function locate_memberships() {
	var membership_blocks = $$('.memberships');
	var user_memberships = $H();
	membership_blocks.each(function(m) {
		var user_id = m.id.gsub(/^.+_/, '');
		var groups = m.select('span');
		
		user_memberships[user_id] = m;
		groups.each(group_connector(user_id));
		
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
	var memberships = $(id_for_user('memberships', user_id));
	var group_name = Builder.node('input', {type:'text'});
	var go_button = Builder.node('input', {type:'button', name:'add', value:'Join to group'});
	var no_button = Builder.node('input', {type:'button', name:'cancel', value:'Don\'t join group'})
	var autocompleted_names = Builder.node('div');
	var group_form = Builder.node('form', {className: 'add_form', style:'display: none'},
		[group_name, autocompleted_names, go_button, no_button]);
	memberships.insert({top: group_form});
	
	new Ajax.Request('/memberships/groups.json', {
		method: 'get',
		evalJSON: true,
		onSuccess: function(transport) {
			new Autocompleter.Local(group_name, autocompleted_names, transport.responseJSON);
		}
	});
	Effect.Appear(group_form, {duration: 0.5});
	
	no_button.observe('click', function(f) {
		Effect.Fade(group_form, {duration: 0.5, afterFinish: function(f){group_form.remove();}});
	});
	go_button.observe('click', function(f) {
		var name = group_name.value;
		ajax_addition(user_id, name, function(group_id) {
			Effect.Fade(group_form, {duration: 0.5, afterFinish: function(f){group_form.remove();}});
			var new_span = 
				Builder.node('span', {id: id_for_user_and_group('membership', user_id, group_id)}, '%'+name);
			
			memberships.select('.add_group')[0].insert({before: new_span});
			connect_group(new_span);
		});
	})
}

function remove_group(user_id, group_id) {
	var group_element = $(id_for_user_and_group('membership', user_id, group_id));
	ajax_removal(user_id, group_id, function() {
		Effect.Fade(group_element, {
			afterFinish: function(f){ group_element.remove(); }
		});
	});
}

function ajax_removal(user_id, group_id, callback) {
	new Ajax.Request('/memberships/'+group_id+'.json', {
		parameters: {
			authenticity_token:($('csrf_token').value)
		},
		method: 'delete',
		evalJSON: true,
		onSuccess: callback
	});
}

function ajax_addition(user_id, group_name, callback) {
	new Ajax.Request('/memberships.json', {
		method: 'post',
		evalJSON: true,
		parameters: {
			'membership[account_id]': user_id, 
			'membership[group]': group_name,
			authenticity_token:($('csrf_token').value)
		},
		onSuccess: function(transport) {		
			var response = transport.responseJSON.membership;
			callback(response.id);
		}
	});
}

function group_connector(user_id) {
	return function(g) {connect_group(g, user_id)};
}

function connect_group(g, user_id) {
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
}

function id_for_user_and_group(prefix, user_id, group_id) {
	return id_for_user(prefix, user_id)+"_"+group_id;
}

function id_for_user(prefix, user_id) {
	return prefix+'_'+user_id;
}