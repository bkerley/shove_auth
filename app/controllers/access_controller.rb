class AccessController < ApplicationController
  def index
    sid = params[:sid]
    resource_selector = params[:resource_selector]
    
    return fail_403 unless nonce = Nonce.find_by_sid(sid)
    return fail_403 unless a = nonce.account 
    
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
