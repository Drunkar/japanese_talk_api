import logging
import tornado.template
import os
from tornado.options import define, options

import environment

# Make filepaths relative to settings.
path = lambda root,*a: os.path.join(root, *a)
ROOT = os.path.dirname(os.path.abspath(__file__))

define("port", default=8888, help="run on the given port", type=int)
define("config", default=None, help="tornado config file")
define("debug", default=False, help="debug mode")
tornado.options.parse_command_line()

MEDIA_ROOT = path(ROOT, 'static')
TEMPLATE_ROOT = path(ROOT, 'templates')


settings = {}
settings['debug'] = options.debug
settings['static_path'] = MEDIA_ROOT
settings['template_loader'] = tornado.template.Loader(TEMPLATE_ROOT)
settings['cookie_secret'] = "your-cookie-secret"
settings['xsrf_cookies'] = True


if settings['debug']:
    LOG_LEVEL = logging.DEBUG
else:
    LOG_LEVEL = logging.INFO

# logger
logger = logging.getLogger("")
logger.setLevel(LOG_LEVEL)

app_log = logging.getLogger("tornado")
app_log_handler = logging.handlers.RotatingFileHandler(
                    path(os.path.abspath(os.path.dirname(os.path.dirname(__file__))), "logs", "app.log"),
                    maxBytes=50000000, backupCount=5)
app_log_handler.setLevel(LOG_LEVEL)
app_log_handler.setFormatter(logging.Formatter('%(asctime)s %(levelname)s %(message)s'))
app_log.addHandler(app_log_handler)


if options.config:
    tornado.options.parse_config_file(options.config)