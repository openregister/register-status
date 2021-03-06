class AuthorityController < ApplicationController
  def index
    redirect_to registers_path(show_by: "organisation"), status: 301
  end

  def show
    @collection = Authority.collection(params[:slug])
  end
end
