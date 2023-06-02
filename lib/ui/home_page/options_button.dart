// import 'package:flutter/material.dart';
//
// class OptionsButton extends StatefulWidget {
//   const OptionsButton({Key? key}) : super(key: key);
//
//   @override
//   State<OptionsButton> createState() => _OptionsButtonState();
// }
//
// class _OptionsButtonState extends State<OptionsButton> {
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//         style: ButtonStyle(
//           overlayColor: MaterialStateProperty.all(Colors.transparent),
//           backgroundColor:
//               getColor(Colors.orange, Colors.orange.shade800, true),
//           side: getBorder(Colors.white, Colors.white, true),
//         ),
//         child: const Icon(
//           Icons.more_vert,
//           color: Colors.white,
//           size: 46,
//         ),
//         onPressed: () {});
//   }
// }
//
// MaterialStateProperty<Color> getColor(
//     Color color, Color colorPressed, bool force) {
//   getColor(Set<MaterialState> states) {
//     if (force || states.contains(MaterialState.pressed)) {
//       return colorPressed;
//     } else {
//       return color;
//     }
//   }
//
//   return MaterialStateProperty.resolveWith(getColor);
// }
//
// MaterialStateProperty<BorderSide> getBorder(
//     Color color, Color colorPressed, bool force) {
//   getBorder(Set<MaterialState> states) {
//     if (force || states.contains(MaterialState.pressed)) {
//       return BorderSide(color: colorPressed, width: 4);
//     } else {
//       return BorderSide(color: color, width: 2);
//     }
//   }
//
//   return MaterialStateProperty.resolveWith(getBorder);
// }
import 'package:flutter/material.dart';

class OptionsButton extends StatefulWidget {
  const OptionsButton({Key? key}) : super(key: key);

  @override
  State<OptionsButton> createState() => _OptionsButtonState();
}

class _OptionsButtonState extends State<OptionsButton> {
  bool isFollowing = false; // Example variable to store follow status

  @override
  Widget build(BuildContext context) {
    return
    // ElevatedButton(
    //   style: ButtonStyle(
    //     overlayColor: MaterialStateProperty.all(Colors.transparent),
    //     backgroundColor: getColor(Colors.orange, Colors.orange.shade800, true),
    //     side: getBorder(Colors.white, Colors.white, true),
    //   ),
    //   child: const Icon(
    //     Icons.more_vert,
    //     color: Colors.white,
    //     size: 46,
    //   ),
    //   onPressed: () {
        PopupMenuButton(
          color: Colors.white,
            
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: ListTile(
                      leading: Icon(
                          isFollowing ? Icons.person_remove : Icons.person_add),
                      title: Text(isFollowing ? 'Unfollow' : 'Follow'),
                      onTap: () {
                        setState(() {
                          isFollowing = !isFollowing;
                        });
                      },
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.report),
                      title: Text('Report Post'),
                      // onTap: () {
                      // // Handle report post action
                      // },
                    ),
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.volume_off),
                      title: Text('Mute User'),
                      // onTap: () {
                      // // Handle mute user action
                      // },
                    ),
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.block),
                      title: Text('Block User'),
                      // onTap: () {
                      // // Handle block user action
                      // },
                    ),
                  ),
                ]);

  }
}

MaterialStateProperty<Color> getColor(
    Color color, Color colorPressed, bool force) {
  getColor(Set<MaterialState> states) {
    if (force || states.contains(MaterialState.pressed)) {
      return colorPressed;
    } else {
      return color;
    }
  }

  return MaterialStateProperty.resolveWith(getColor);
}

MaterialStateProperty<BorderSide> getBorder(
    Color color, Color colorPressed, bool force) {
  getBorder(Set<MaterialState> states) {
    if (force || states.contains(MaterialState.pressed)) {
      return BorderSide(color: colorPressed, width: 4);
    } else {
      return BorderSide(color: color, width: 2);
    }
  }

  return MaterialStateProperty.resolveWith(getBorder);
}
