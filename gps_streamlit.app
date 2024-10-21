import streamlit as st
from streamlit_folium import st_folium
import folium

# 스트림릿 페이지 제목
st.title("현재 위치 표시 지도")

# 기본 위치 (서울)로 지도 초기화
map_center = [37.5665, 126.9780]
mymap = folium.Map(location=map_center, zoom_start=12)

# 폴리움 맵을 스트림릿에 표시
st_data = st_folium(mymap, width=700, height=500)

# HTML + JavaScript로 현재 위치 표시
html_code = """
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Map</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        #map {
            height: 500px;
            width: 100%;
        }
    </style>
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
</head>
<body>
    <div id="map"></div>

    <script>
        var map = L.map('map').setView([37.5665, 126.9780], 12);

        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: 'Map data © <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);

        function onLocationFound(e) {
            var radius = e.accuracy / 2;

            L.marker(e.latlng).addTo(map)
                .bindPopup("You are within " + radius + " meters from this point").openPopup();

            L.circle(e.latlng, radius).addTo(map);
        }

        function onLocationError(e) {
            alert(e.message);
        }

        map.on('locationfound', onLocationFound);
        map.on('locationerror', onLocationError);

        map.locate({setView: true, maxZoom: 16});
    </script>
</body>
</html>
"""

# HTML 삽입 (iframe을 사용하여 JavaScript 실행)
st.components.v1.html(html_code, height=600)
