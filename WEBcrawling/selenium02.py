from selenium import webdriver

driver=webdriver.Chrome('C:/workspace/chromedriver_win32/chromedriver.exe')
# 최신버전은 이걸 써야함
# options=Options()
# options.add_experimental_option('detach',True)
driver.get('https://nid.naver.com/nidlogin.login')

driver.implicitly_wait(3)

driver.find_element_by_class_name('id').send_keys('tjrdmstn7720_')
driver.find_element_by_name('pw').send_keys('@aplus5350971')

driver.find_element_by_xpath('//*[@id="log.login"]').click()
