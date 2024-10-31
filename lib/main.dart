import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CustomIconTray(),
        ),
      ),
    );
  }
}

class CustomIconTray extends StatefulWidget {
  const CustomIconTray({super.key});

  @override
  _CustomIconTrayState createState() => _CustomIconTrayState();
}

class _CustomIconTrayState extends State<CustomIconTray> {
  List<String> trayIcons = [
    "assets/calculator.png",
    "assets/chrome.png",
    "assets/intelli.png",
    "assets/photos.png",
    "assets/safari.png",
    "assets/spotify.png",
  ];

  String? draggedIcon;
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < trayIcons.length; i++)
              _buildDraggableIcon(trayIcons[i], i),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableIcon(String icon, int index) {
    bool isDragging = draggedIcon == icon;

    return LongPressDraggable<String>(
      data: icon,
      onDragStarted: () {
        setState(() {
          draggedIcon = icon; // Start dragging
        });
      },
      onDragCompleted: () {
        if (hoveredIndex != null) {
          setState(() {
            trayIcons.remove(draggedIcon); // Remove the icon from its old position
            trayIcons.insert(hoveredIndex!, draggedIcon!); // Insert it in the new position
          });
        }
        resetDragState();
      },
      onDraggableCanceled: (_, __) {
        resetDragState();
      },
      feedback: Material(
        color: Colors.transparent,
        child: Image.asset(icon, height: 58), // Larger icon for feedback
      ),
      childWhenDragging: Container(), // Remove the icon while dragging
      child: DragTarget<String>(
        onWillAcceptWithDetails: (data) {
          setState(() {
            hoveredIndex = index; // Set hover position
          });
          return true;
        },
        onAcceptWithDetails: (data) {},
        onLeave: (data) {
          setState(() {
            hoveredIndex = null; // Clear hover index
          });
        },
        builder: (context, candidateData, rejectedData) {
          return _buildIcon(icon, index, isDragging);
        },
      ),
    );
  }

  Widget _buildIcon(String icon, int index, bool isDragging) {
    bool isHovered = hoveredIndex == index;
    bool isLeftNeighborHovered = hoveredIndex == index + 1;
    bool isRightNeighborHovered = hoveredIndex == index - 1;

    // Conditional padding based on hover position
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 7);
    if (isHovered) {
      padding = const EdgeInsets.only(left: 20, right: 7); // Extra space on the left
    } else if (isLeftNeighborHovered) {
      padding = const EdgeInsets.only(left: 7, right: 20); // Space on the right
    } else if (isRightNeighborHovered) {
      padding = const EdgeInsets.only(left: 20, right: 7); // Space on the left
    }

    return AnimatedPadding(
      duration: const Duration(milliseconds: 300),
      padding: padding,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Smooth transition
        curve: Curves.easeInOut,
        width: 40,
        child: Opacity(
          opacity: isDragging ? 0 : 1, // Hide the icon if dragging
          child: Image.asset(icon, height: 40),
        ),
      ),
    );
  }

  void resetDragState() {
    setState(() {
      draggedIcon = null; // Reset after drag completion
      hoveredIndex = null; // Clear hover position
    });
  }
}
