class Dashing.ResqueList extends Dashing.Widget
	@accessor 'total', ->
		total = 0
		total += parseInt(item.value) for item in @get('items')
		total

	onData: (data) ->
		parent = this;
		$(".resque_queues_stats .meter").each(
			(i) ->
				$(this).css("width", Batman.Filters.percentage(data.items[i].value, parent.get("total")) + "%")
		)

Batman.mixin Batman.Filters,
	percentage: (n, total) ->
		Math.round(n * 100 / total)