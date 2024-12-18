var chartDom = document.getElementsByClassName('graph_body')[0];
var myChart = echarts.init(chartDom);
var option;

option = {
  xAxis: {
    type: 'category',
    data: x
  },
  yAxis: {
	name: '언급량',
    type: 'value',
  },
  series: [{
      data: y,
      type: 'line',
      itemstyle: 'red'
  }],
  tooltip: {
	  
  }
};

option && myChart.setOption(option);	