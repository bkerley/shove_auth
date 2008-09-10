class CackleShim
  def initialize
    @parser = Cackle::AccessControlLanguageParser.new
  end
  
  def try_parse(data)
    @parser.parse(data)
  end
  
  def reload
    data = Aclpart.concatenated
    parsetree = try_parse(data)
    throw 'ACL Syntax Error' unless parsetree
    
    @rules = Cackle::RuleList.new(parsetree)
  end
end