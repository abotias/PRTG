from selenium import webdriver
import os
os.system("taskkill /f /im firefox.exe")
options = webdriver.FirefoxOptions()
options.add_argument('-headless')
driver = webdriver.Firefox(executable_path=r'C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\python\geckodriver\geckodriver.exe',options=options)
web = driver.get("https://web.com/")
input_a = driver.find_element_by_id("username").send_keys("<username>")
input_b = driver.find_element_by_id("password").send_keys("<password>")
input_c = driver.find_element_by_id("submit").click()
element = driver.find_element_by_id("search")
element = element.get_attribute('innerHTML')
result = "<chain to search>" in element
prtgvalue=1
if result is True:
      prtgvalue=0
print("<prtg>")
print("  <result>")
print("    <channel>CHECK WEB.COM</channel>")
print('    <value>',prtgvalue,'</value>')
print("    <LimitMaxError>0</LimitMaxError>")
print("  </result>")
print("</prtg>")
driver.quit()
