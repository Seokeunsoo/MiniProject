from selenium import webdriver

driver=webdriver.Chrome('C:/workspace/chromedriver_win32/chromedriver.exe')
driver.get('https://google.com')

driver.implicitly_wait(3)

search_box=driver.find_element_by_name('q')
search_box.send_keys('빅데이터')
search_box.submit() # 검색어 전달


