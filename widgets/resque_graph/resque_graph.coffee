class Dashing.ResqueGraph extends Dashing.Widget
	ready: ->
		# Number of minutes to display on the graph
		graphWidth = 1

		container = $(@node).parent()

		width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
		height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
		marginTop = 10

		@data = []
		@data.push({x: i, y: 0}) for i in [0..(graphWidth*29)]

		@graph = new Rickshaw.Graph({
			element: @node,
			width: width,
			height: height - marginTop,
			series: [{color: "#000", data: @data}]
		});

		@graph.render();

	onData: (data) ->
		if @last
			@graph.series[0].data = @shiftData(data.current - @last)
			@graph.render()

		@last = data.current

	shiftData: (newVal) ->
		data.x -= 1 for data in @data

		@data.shift()
		@data.push({x: @data.length+1, y: newVal})

		@data