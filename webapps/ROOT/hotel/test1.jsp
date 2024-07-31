<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Download Hotel Image</title>
</head>
<body>
    <h2>Download Hotel Image</h2>
    <form action="download_image.jsp" method="get">
        <label for="hotel_id">Hotel ID:</label><br>
        <input type="text" id="hotel_id" name="hotel_id" required><br><br>

        <input type="submit" value="Download">
    </form>
</body>
</html>

