import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scl_mgmt/src/modules/attendance/views/standard_list.dart';
import 'package:scl_mgmt/src/modules/student/views/screens/stundents_list.dart';

import 'curved_header_clipper.dart';

class DynamicCurvedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;

  DynamicCurvedHeaderDelegate({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final bool isExpanded = shrinkOffset == 0;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (isExpanded)
          ClipPath(
            clipper: CurvedHeaderClipper(),
            child: _buildBackground(),
          )
        else
          _buildBackground(),
        Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Dashboard',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.black),
                    onPressed: () {
                      Get.to(() => StudentsListPage());
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.how_to_reg, color: Colors.black),
                    onPressed: () {
                      Get.to(() => StandardsList());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 178, 219, 253),
            Color.fromARGB(255, 178, 219, 253),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 20;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
