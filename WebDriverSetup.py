import os

from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager

def get_chrome_driver_path():
    return os.path.normpath(ChromeDriverManager().install())

def create_service(chrome_driver_path: str) -> Service:
    return Service(executable_path=chrome_driver_path)
