import 'package:darango/darango.dart';
import 'dart:io'; 
import 'dart:convert';

import 'package:http/io_client.dart';

String url = "http://127.0.0.1/:8529";
String database_name = "";
String username = "root";
String password = "";

main(List<String> args) async{
  Base64Codec BASE64 = const Base64Codec();
  const encodedCA = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMrVENDQWVHZ0F3SUJBZ0lRSjBaOVBvMW5zd0lVaWlkVVJ5R0ZCREFOQmdrcWhraUc5dzBCQVFzRkFEQW0KTVJFd0R3WURWUVFLRXdoQmNtRnVaMjlFUWpFUk1BOEdBMVVFQXhNSVFYSmhibWR2UkVJd0hoY05NVGt4TVRFeApNakEwTVRVM1doY05NakF4TVRFd01qQTBNVFUzV2pBbU1SRXdEd1lEVlFRS0V3aEJjbUZ1WjI5RVFqRVJNQThHCkExVUVBeE1JUVhKaGJtZHZSRUl3Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRRE0KN1lEa3BGWGpvTi9kcWNjM2FQdGNlSUF4RG9vaitGVUxvUXVMRjcycUp6MW4xM2JLZUpwQ0hiQTFabzBCMGpEKwpOR2hpQk13Vk02RzhFZkxubDMvQzVIZ1F4QjNpNWtMSk82V1pERUFkRk5IWGJHS3lyektlZzVwUVVmUVJlNFJHCklTMjllOXlkRThYK1REM2RUVTBkMC9FeWovemt0bXNBNm9EZFF3WmJLVnlYOW1MRDNDS0c1K3ZRbkZFZ0FtaWEKNEhGMDl1NFRHUHhoWVRQcUwzNnVnUUxzdUE5bnB5V3c4ajBwV2lmbDJoUEY1WEk4eVpodkFDZEhUQ29MN3lhTQpLOVpqL1hRZEVVVHNFUmI0cERYcERUWjN4eno1ZXovL2g1bndBRnJ5eEZTdDJkMlhkWGVUWjFWMVRDak5GTE9WClhHbDdxOGhHRXQ4R0N1dExCYmZ6QWdNQkFBR2pJekFoTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQQmdOVkhSTUIKQWY4RUJUQURBUUgvTUEwR0NTcUdTSWIzRFFFQkN3VUFBNElCQVFDV3VJZEdWaFFVdzQrUUVqUFVaSTVxcHV6cApIWkNtYm94SXUrZ0lOMVQ0aTJvMnVYSUpvTmkzU21TYUw1elhkMURMeGJVdkVpS09PdEZEd3dobHRmZEtqYkNnClZRZzA3SmtMWWVCZjFoem9sVmgyRFAyZnZ3dFlzUnlqZlppSXpNZmpwMkRXNVFaZUUvWnJ3SmV4OE13NDRkVFoKdmdhOUxORWZ3VkJzakdGMGNDcVB5cUhnR1dleGNpSUNBeXJQaWVYQ0JTdnJjUnRQUVJaR25BQUR5YXhtY3hwZgpoOGdwNlE4bFBBZXdZU253ZjY1NklFb09vWEFuRFdaL2pIQ2lFOXhQRnJhaEI4WmQ1MTdFNFVlNGxBL3FJUER3CmtncnlzWjRaak5Kc3ZsUzFvb0NvTndTenBFdWZBT09DUG1kR1hvR2xrd2VmTjBHR1NUSi9pT0NJTDNCRwotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==";
  SecurityContext clientContext = new SecurityContext()
    ..useCertificateChainBytes(BASE64.decode(encodedCA));
  var inner = new HttpClient(context: clientContext);
  inner.addCredentials(Uri.parse("$url"), "realm", new HttpClientBasicCredentials(username, password));
  inner.getUrl(Uri.parse("$url/_db/$database_name/_api/database/current")).then((res){print(res);});
  // IOClient client = new IOClient(inner);
  // client.get(
  //     Uri.parse("$url/_db/$database_name/_api/database/current")
  //     ).then((response) {
  //       print(response.bodyBytes);
  //       });
}