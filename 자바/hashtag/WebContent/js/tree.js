am4core.useTheme(am4themes_animated);

var chart = am4core.create("hstree_tree", am4plugins_forceDirected.ForceDirectedTree);
chart.legend = new am4charts.Legend();

var networkSeries = chart.series.push(new am4plugins_forceDirected.ForceDirectedSeries())

networkSeries.data = [{
  name: root,                      //가운데에 오는 태그(root)
  fixed: true,
  x: am4core.percent(50),
  y: am4core.percent(50),
  children: []
}];

for (var i = 0; i < child.length; i++) {
  networkSeries.data[0].children.push({
    name: child[i],
    value: 10,
    children: [{
      name: grandchild[i].split(",")[0].replace("[","")
    },{
      name: grandchild[i].split(",")[1]
    },{
      name: grandchild[i].split(",")[2]
    }, {
      name: grandchild[i].split(",")[3]
    }, {
      name: grandchild[i].split(",")[4].replace("]","")
    }]
  });
}

networkSeries.dataFields.linkWith = "linkWith";
networkSeries.dataFields.name = "name";
networkSeries.dataFields.id = "name";
networkSeries.dataFields.value = "value";
networkSeries.dataFields.children = "children";
networkSeries.dataFields.fixed = "fixed";

//원의 최소 크기
networkSeries.minRadius = 35;

networkSeries.nodes.template.propertyFields.x = "x";
networkSeries.nodes.template.propertyFields.y = "y";

networkSeries.nodes.template.tooltipText = "{name}";
networkSeries.nodes.template.fillOpacity = 1;

networkSeries.nodes.template.label.text = "{name}"
networkSeries.fontSize = 15;
networkSeries.maxLevels = 3;
//텍스트가 원보다 큰경우 표시 안함
networkSeries.nodes.template.label.hideOversized = false;
//텍스트가 원보다 큰경우 줄임말표시
networkSeries.nodes.template.label.truncate = false;