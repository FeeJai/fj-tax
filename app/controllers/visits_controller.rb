class VisitsController < ApplicationController

  def import

  end


  def results

  end



  private

  def passport_params
    params.require(:passport).permit(:lastname, :firstname, :birthdate, :passport_no, :passport_country)
  end

end
