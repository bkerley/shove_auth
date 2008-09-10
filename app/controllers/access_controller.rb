class AccessController < ApplicationController
  def index
    sid = params[:sid]
    resource_selector = params[:resource_selector]
    
    a = Nonce.find_by_sid(sid).account
    result = CACKLE.test(a, resource_selector)
    
    return(render :text=>'200 OK', :status=>200) if result
    
    return fail_403
  end
  
  private
  def fail_403
    render :text=>'403 Forbidden', :status=>403
    return false
  end
end
