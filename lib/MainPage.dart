import 'package:LoginTesting/Login.dart';
import 'package:flutter/material.dart';




class MainPage extends StatefulWidget
{
  String username,Year,Month;
  MainPage({Key key,@required this.username,this.Year,this.Month}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState(username,Year,Month);
}

class _MainPageState extends State<MainPage> {




  String username,Year,Month;
  _MainPageState(this.username,this.Year,this.Month);
  @override
  Widget build(BuildContext context)
  {
    debugShowCheckedModeBanner:false;

    return Drawer(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 30,
                        bottom: 30,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage('https://allworldpm.com/wp-content/uploads/2016/10/230x230-avatar-dummy-profile-pic.jpg'
                            ),
                            fit: BoxFit.fill

                        ),
                      ),
                    ),
                    Text(username,style: TextStyle(fontSize: 22,color: Colors.white
                    ),
                    ),
                    Text('Selected Year :'+Year,style: TextStyle(fontSize: 15,color: Colors.white
                    ),
                    ),
                    Text('Selected Month :'+Month,style: TextStyle(fontSize: 15,color: Colors.white
                    ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.arrow_back),

              title: Text('LogOut',style: TextStyle(fontSize: 18,
              ),
              ),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>Login(),
                    ));
              },
            ),







          ],
        )
    );




  }
}
