class VisitsController < ApplicationController
  respond_to :js, :json

  def import
    respond_to do |format|
      format.html { raise "not supported" }
      # format.json { render json: { hello: "world" } }
      format.json do

        job = PassportImportJob.perform_later()
        job_id = job.job_id
        Rails.cache.write(job_id, :pending, expires_in: 30.seconds) unless Rails.cache.read(job_id).present?
        render status: :accepted, json: { job_id: job_id }

      end
    end
  end


  def import_result

    job_id = params[:job_id]
    status = Rails.cache.read(job_id)

    case status
    when nil
      head :gone
    when :pending || :working
      response.headers["Retry-After:"] = 15
      head :accepted
    when :success
      Rails.cache.delete(job_id)
      @visits = Rails.cache.read("result #{job_id}")
      Rails.cache.delete("result #{job_id}")
      Rails.logger.warn @visits
      render 'import_result'
    else
      head :internal_server_error
    end

  end

  def new
    #new.js.erb
  end

  private

  def passport_params
    params.require(:passport).permit(:lastname, :firstname, :birthdate, :passport_no, :passport_country)
  end

end
