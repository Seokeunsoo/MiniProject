from bs4 import BeautifulSoup
from selenium import webdriver

driver=webdriver.Chrome('C:/workspace/chromedriver_win32/chromedriver.exe')
driver.get('https://www.coffeebeankorea.com/store/store.asp')

# storePop2(1)호출
driver.execute_script('storePop2(1)')

html=driver.page_source
soup=BeautifulSoup(html,'html.parser')

print(soup.prettify())





