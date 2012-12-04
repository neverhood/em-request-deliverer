module IlogosEM
  module Views
    require 'json'

    extend self # Since we don't want to mix it in but rather call methods explicitly for clarity

    def ok
      Hash[[
        [ :content_type, 'text/plain' ],
        [ :data, 'OK' ]
      ]]
    end

    def stats(params)
      Hash[[
        [ :content_type, 'text/html' ],
        [ :data, layout(
                   head: %q(
                     <script src="http://code.jquery.com/jquery-1.8.3.min.js"></script>
                     <script src="http://code.highcharts.com/highcharts.js"></script>
                     <script src="http://code.highcharts.com/modules/exporting.js"></script>
                   ),
                   body: %Q(
                       <div id="container" style="min-width: 400px; height: 400px; margin: 0 auto"></div>

                       <script>
                           $(function () {
                              var chart;

                              var xAxis = [];
                              for ( var i = 1; i < 60; i++ ) { xAxis.push(i) };

                              receivedRequests = $.parseJSON( '#{JSON.dump params[:received].values}' );
                              successfullRequests = $.parseJSON( '#{JSON.dump params[:successfull].values}' );
                              failedRequests = $.parseJSON( '#{JSON.dump params[:failed].values}' );

                              $(document).ready(function() {
                                  chart = new Highcharts.Chart({
                                      chart: {
                                          renderTo: 'container',
                                          type: 'line',
                                          marginRight: 130,
                                          marginBottom: 25
                                      },
                                      title: {
                                          text: 'Requests chart',
                                          x: -20 //center
                                      },
                                      subtitle: {
                                          text: null
                                      },
                                      xAxis: {
                                          categories: xAxis
                                      },
                                      yAxis: {
                                          title: {
                                              text: 'Request stats'
                                          },
                                          plotLines: [{
                                              value: 0,
                                              width: 1,
                                              color: '#808080'
                                          }]
                                      },
                                      tooltip: {
                                          formatter: function() {
                                                  return '<b>'+ this.series.name +'</b><br/>'+
                                                  'Sec. ' + this.x +': '+ this.y +' requests';
                                          }
                                      },
                                      legend: {
                                          layout: 'vertical',
                                          align: 'right',
                                          verticalAlign: 'top',
                                          x: -10,
                                          y: 100,
                                          borderWidth: 0
                                      },
                                      series: [{
                                          name: 'Received',
                                          data: receivedRequests
                                      }, {
                                          name: 'Succesfull',
                                          data: successfullRequests
                                      }, {
                                          name: 'Failed',
                                          data: failedRequests
                                      }]
                                  });
                              });
                          });
                       </script>
                   )
                 )
        ]
      ]]
    end

    def welcome
      Hash[[
        [ :content_type, 'text/plain' ],
        [ :data,         'Welcome!'   ]
      ]]
    end

    private

    def layout opts = {}
      %Q(
         <!DOCTYPE html>
          <html>
          <head>
            #{ opts[:head] }
          </head>

          <body>
            #{ opts[:body] }
          </body>
          </html>
      )
    end

  end
end
