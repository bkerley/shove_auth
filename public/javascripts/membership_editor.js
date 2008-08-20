function id_for_user_and_group(prefix, user_id, group_id) {
	return prefix+user_id+"_"+group_id;
}

function locate_memberships() {
	var membership_blocks = $$('.memberships');
	var user_memberships = $H();
	membership_blocks.each(function(m) {
		var user_id = m.id.gsub(/^.+_/, '');
		var groups = m.select('span');
		
		user_memberships[user_id] = m;
		groups.each(function(g) {
			var group_id = g.id.gsub(/^membership_\d+_/, '');
			var button = Builder.node(
				'a', {
					className:'delete_group',
					href:'#',
					id: id_for_user_and_group('remove_', user_id, group_id)
				},
				'X');
			g.appendChild(button);
			button.observe('click', function(f) {remove_group(user_id, group_id)});
		});
		
		Effect.Pulsate(m);
	});
}

function remove_group(user_id, group_id) {
	alert("Removing user "+user_id+" from group "+group_id);
}