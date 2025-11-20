import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';


class Menu extends StatelessWidget {
  final User user;
  const Menu({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user.displayName ?? ''),
            accountEmail: Text(user.email!),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://scontent.fpoa11-1.fna.fbcdn.net/v/t39.30808-6/435904331_1293843198239930_3493681493461454436_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeFGlbq5OBNxCt-2z6JJPzs6xpoDdpnci3vGmgN2mdyLe9-UsMy8Zi2XJwN3FY3wA3EAjWJJYKTu3vAQi3BzE_6P&_nc_ohc=NgliyyVPkXAQ7kNvwFs67n3&_nc_oc=AdkYWGKQADmIuIjMS30YnnS7sj-513dpeLklRKUtHPi98hoLb3ZlK3lfz0G5Zm7NQjU9RNUi8Z3bgl6ESv0z_PFf&_nc_zt=23&_nc_ht=scontent.fpoa11-1.fna&_nc_gid=XTpCqRWeHNzcbyfRso57dw&oh=00_AfiUqepUWJm1OLtMBlcutI9ft82Frvunoj7EJT-Rur9NKA&oe=69255318'
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              AuthService().logoutUser();
            }
          ),
        ],
      ),
    );
  }
}
