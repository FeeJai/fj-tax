class PassportImportJob < ApplicationJob
  queue_as :default

  def perform(*args)

    return nil if Rails.cache.read(job_id).present? && Rails.cache.read(job_id) != :pending # job expired in the meanwhile
    Rails.cache.write(job_id, :working, expires_in: 60.seconds)

    # i94 = I94.new
    # i94.init_connection
    # i94.load_travel_dates
    # dates = i94.parse_dates

    dates = [
      {
        :entry => Date.parse("Fri, 12 Dec 2014"),
        :exit => Date.parse("Tue, 16 Dec 2014")
      },{
        :entry => Date.parse("Wed, 11 Mar 2015"),
        :exit => Date.parse("Tue, 22 Sep 2015")
      }, {
        :entry => Date.parse("Thu, 31 Mar 2016"),
        :exit => Date.parse("Sat, 31 Dec 2016")
      }]

    Rails.cache.write("result #{job_id}", dates, expires_in: 60.seconds)
    Rails.cache.write(job_id, :success, expires_in: 60.seconds)

  end

end



class I94

  include HTTParty
  base_uri 'https://i94.cbp.dhs.gov'
  # debug_output

  def init_connection

    init_cookie

    # Get the session ID
    get_response = self.class.get('/I94/consent.html')
    add_cookie(get_response)

    # Consent to rules and regulations
    post_response = self.class.post(
      '/I94/consent.html',
      body: {
        mode: "consent",
        consent: "yes",
        Submit: "Submit"
      },
      headers: {'Cookie' => @cookie_hash.to_cookie_string }
    )
    add_cookie(post_response)
  end


  def load_travel_dates
    @travel_html = self.class.post(
      '/I94/request.html',
      body: {
        mode: "request",
        familyName: "Jankowski",
        givenName: "Felix",
        birthYear: 1989,
        birthMonth: "%02d" % 03,
        birthDay: "%02d" % 26,
        passportNumber: "CH1HYGWZ2",
        passportCountry: "DEU",
        requestType: "history"
      },
      headers: {'Cookie' => @cookie_hash.to_cookie_string}
    )
    nil
  end


  def parse_dates
    parse_page = Nokogiri::HTML(@travel_html)
    table = parse_page.css('#leftcontent1')[1].css('table').css('tr').reverse
    rows = table.length

    visits = Array.new

    # apparently this is the only way to proceed one or two iterations in a loop depending on content
    i = 0
    begin
      row = table[i]
      next_row = table[i+1]

      if row.children[1].content == "Arrival" && next_row&.children[1]&.content  == "Departure"

        entry_date = Date.parse(row.children[3].content)
        exit_date  = Date.parse(next_row.children[3].content)
        i += 2 # 2 rows imported, skip

      elsif row.children[1].content == "Arrival" # we have no departure record

        entry_date = Date.parse(row.children[3].content)
        exit_date  = entry_date.end_of_year
        i += 1

      elsif row.children[1].content == "Departure" # we have no arrival record

        exit_date = Date.parse(row.children[3].content)
        entry_date = exit_date.beginning_of_year
        i += 1

      else # something strange or table header

        i += 1
        next # do not add to array

      end

      visits.push({ entry: entry_date, exit: exit_date })

    end while i < rows

    visits
  end


  private

  def init_cookie
    @cookie_hash = CookieHash.new
  end

  def add_cookie(resp)
    resp.get_fields('Set-Cookie')&.each { |c| @cookie_hash.add_cookies(c) }
  end

end
