<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hotel Image Upload</title>
</head>
<body>
    <h2>Upload Hotel Image</h2>
    <form action="hotel_br.jsp" method="post" enctype="application/x-www-form-urlencoded">
        <label for="hotel_id">Hotel ID:</label><br>
        <input type="text" id="hotel_id" name="hotel_id" required><br><br>
        
        <label for="image">Image (Base64):</label><br>
        <textarea id="image" name="image" rows="10" cols="50" required></textarea><br><br>

        <input type="submit" value="Upload">
    </form>
</body>
</html>

