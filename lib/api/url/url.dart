
class BaseUrl{

  static String address="holomboko.000webhostapp.com";

  //authetication
  static String reg= "https://$address/api/login/register.php";


  //products
  static String addPro= "https://$address/api/products/addPro.php";
  static String getPro= "https://$address/api/products/getPro.php";
  static String editPro= "https://$address/api/products/editPro.php";
  static String deletePro= "https://$address/api/products/delPro.php";


  //cart
  static String addCart= "https://$address/api/cart/addCart.php";
  static String getCart= "https://$address/api/cart/getCart.php";
  static String cartCount= "https://$address/api/cart/getCount.php";
  static String totalCart= "https://$address/api/cart/getTotalCart.php";
  static String upDateCart= "https://$address/api/cart/upDate.php";
  static String delCart= "https://$address/api/cart/delCart.php";
  static String confirm= "https://$address/api/cart/confirm.php";



  //orders
  static String getCreditOrder= "https://$address/api/orders/getOrder.php";
  static String getPartOrder= "https://$address/api/orders/getPartOrder.php";
  static String getFullOrder= "https://$address/api/orders/getFullOrder.php";


  static String getOrderDe= "https://$address/api/orders/oderDetails.php";
  static String getCreditCount= "https://$address/api/orders/allCount.php";
  static String getFullCount= "https://$address/api/orders/fullCount.php";
  static String getPartCount= "https://$address/api/orders/partCount.php";

}