#ILogos Continious requests delivery

## ( test task implementation )


### Notes:
    * `ruby start.rb` to start the server ( default port is 9000 )
    * require lib/ilogos_em.rb and test it in irb: `em = ILogos::EMInstance.new`
    * the `test` dir includes httperf ruby script by Ilia Grigorik and
      an appropriate config file, `ruby autoperf.rb -c autoperf.conf`


### Side info

* I've been somewhat hasting with this so it might look somewhat crude (
especially things like `RequestParser` and `Views` ) *

