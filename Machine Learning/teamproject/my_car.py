# 모듈 로딩 ---------------------------------------------------
import cgi, sys, codecs, os
import joblib

# WEB 인코딩 설정 ---------------------------------------------
sys.stdout=codecs.getwriter('utf-8')(sys.stdout.detach())

def displayWEB(detect_msg):
  print("Content-Type: text/html; charset=utf-8")
  print("")
  html="""
  <!DOCTYPE html>
  <html>
    <head>
      <title>Car Price Predictor</title>
    </head>
    <body>
      <h1>Car Price Predictor</h1>
      <form>
        <label for="year">Year:</label>
        <input type="text" id="year" name="year"><br><br>
        <label for="brand">Brand:</label>
        <input type="text" id="brand" name="brand"><br><br>
        <label for="model">Model:</label>
        <input type="text" id="model" name="model"><br><br>
        <label for="transmission">Transmission:</label>
        <input type="text" id="transmission" name="transmission"><br><br>
        <label for="mileage">Mileage:</label>
        <input type="text" id="mileage" name="mileage"><br><br>
        <label for="engine">Engine:</label>
        <input type="text" id="engine" name="engine"><br><br>
        <input type="button" value="Predict" onclick="predict()">
      </form>
      <br><br>
      <p id="result"></p>
      <script>
        function predict() {
          var year = document.getElementById("year").value;
          var brand = document.getElementById("brand").value;
          var model = document.getElementById("model").value;
          var transmission = document.getElementById("transmission").value;
          var mileage = document.getElementById("mileage").value;
          var engine = document.getElementById("engine").value;
          var url = "http://your-ml-model-url.com/predict?year=" + year + "&brand=" + brand + "&model=" + model + "&transmission=" + transmission + "&mileage=" + mileage + "&engine=" + engine;
          fetch(url)
            .then(response => response.json())
            .then(data => {
              var result = document.getElementById("result");
              result.innerHTML = "Predicted price: " + data.price;
            });
        }
      </script>
    </body>
  </html>"""
print(html)