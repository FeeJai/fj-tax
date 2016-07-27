class PassportImportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    i94 = I94.new
    i94.init_connection
    i94.load_travel_dates
    i94.parse_dates
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

    i = 0
    begin
      if table[i].children[1].content == "Arrival"
        puts "Entry: #{table[i].children[3].content} - Exit: #{table[i+1].children[3].content}"
        i +=2
      else
        i +=1
      end
    end while i < rows
  end


  private

  def init_cookie
    @cookie_hash = CookieHash.new
  end

  def add_cookie(resp)
    resp.get_fields('Set-Cookie')&.each { |c| @cookie_hash.add_cookies(c) }
  end

end
