function locate_memberships() {
	var membership_blocks = $$('.memberships');
	var user_memberships = $H();
	membership_blocks.each(function(m) {
		var user_id = m.id.gsub(/^.+_/, '');
		var groups = m.select('span');
		
		user_memberships[user_id] = m;
		groups.each(function(g) {
			var group_id = g.id.gsub(/^membership_\d+_/, '');
			var delete_button = Builder.node(
				'a', {
					className:'delete_group',
					href:'#',
					id: id_for_user_and_group('remove', user_id, group_id)
				},
				'X');
			g.appendChild(delete_button);
			delete_button.observe('click', function(f) {remove_group(user_id, group_id)});
		});
		
		var add_button = Builder.node(
			'a', {
				className:'add_group',
				href:'#',
				id: id_for_user('add', user_id)
			},
			'+');
		m.appendChild(add_button);
		add_button.observe('click', function(f) {show_add_ui(user_id)});
	});
}

function show_add_ui(user_id) {
	alert("Add a group to "+user_id);
}

function remove_group(user_id, group_id) {
	alert("Removing user "+user_id+" from group "+group_id);
}

function id_for_user_and_group(prefix, user_id, group_id) {
	return id_for_user(prefix, user_id)+"_"+group_id;
}

function id_for_user(prefix, user_id) {
	return prefix+'_'+user_id;
}