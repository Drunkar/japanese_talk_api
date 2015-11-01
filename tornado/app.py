# -*- coding: utf-8 -*-
from __future__ import print_function

import tornado.httpserver
import tornado.web
from tornado.ioloop import IOLoop
from tornado.options import options

from settings import settings
from routes import routes

import logging
app_log = logging.getLogger("tornado")


class App(tornado.web.Application):
    def __init__(self):
        app_log.info(routes)
        app_log.info(settings)
        tornado.web.Application.__init__(self, routes, **settings)

def startApp():

    if options.debug == "False":
        app = App()
        server = tornado.httpserver.HTTPServer(app)
        server.bind(options.port)
        server.start(0)  # forks one process per cpu
        IOLoop.current().start()
    else:
        app = App()
        http_server = tornado.httpserver.HTTPServer(app)
        http_server.listen(options.port)
        IOLoop.instance().start()

if __name__ == "__main__":
    startApp()