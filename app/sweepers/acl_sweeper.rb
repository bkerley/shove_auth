class AclSweeper < ActionController::Caching::Sweeper
	observe Aclpart
	
	def after_create(part)
		reload_acls
	end
	
	def after_save(part)
	  reload_acls
	end
	
	def after_destroy(part)
	  reload_acls
	end
	
	private
	def reload_acls
		CACKLE.reload
	end
end
