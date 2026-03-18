{% for (let e in eth_list): %}
	ethernet {{ e }} {
		description "Physical interface - Bridge member"
	}
{% endfor %}

