from selenium import webdriver
# 구글 켰다 키키 =============================================================
# driver = webdriver.Chrome('C:/workspace/chromedriver_win32/chromedriver.exe')
# driver.get('https://www.google.com')
# print(driver.current_url)
# print(driver.title)
# print(driver.page_source)

# driver.implicitly_wait(time_to_wait=5)
# driver.close() # 하나의 탭만 종료

# ===================================================
# element 접근 예제
driver = webdriver.Chrome('C:/workspace/chromedriver_win32/chromedriver.exe')
driver.get('http://www.pythonscraping.com/pages/warandpeace.html')
driver.implicitly_wait(5)
# driver.quit() # webdriver 전체 종료

name=driver.find_element_by_class_name('green')
print(name.text)

name_List=driver.find_elements_by_class_name('green')
# name=driver.find_elements(By.Class_NAME, 'green') # 뷰티풀 숲에서 검색하는것과 같음
for name in name_List:
    print(name.text)

driver.quit()
















