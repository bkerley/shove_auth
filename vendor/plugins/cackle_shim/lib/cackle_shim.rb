class CackleShim
  def initialize
    @parser = Cackle::AccessControlLanguageParser.new
  end
  
  def try_parse(data)
    @parser.parse(data)
  end
  
  def reload
    data = Aclpart.concatenated
    parsetree = try_parse(data).selection_array
    throw 'ACL Syntax Error' unless parsetree
    
    @rules = Cackle::RuleList.new(parsetree)
  end
  
  def test(account, resource_selector)
    reload unless @rules
    
    results = account.acl_groups.map do |n|
      @rules.soft_test(resource_selector, n)
    end
    
    return false if results.include? false
    return true if results.include? true
    
    # everything is a soft fail
    return false
  end
end