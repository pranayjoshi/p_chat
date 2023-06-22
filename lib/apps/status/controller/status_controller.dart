import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:p_chat/apps/auth/controller/auth_controller.dart';
import 'package:p_chat/apps/status/repository/status_repository.dart';
import 'package:p_chat/models/status.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(
    statusRepository: statusRepository,
    ref: ref,
  );
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;
  StatusController({
    required this.statusRepository,
    required this.ref,
  });

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
        username: value!.name,
        profilePic: value.profilePic,
        statusImage: file,
        context: context,
      );
    });
  }

  // Future<List<Status>> getStatus(BuildContext context) async {
  //   List<Status> statuses = await statusRepository.getStatus(context);
  //   return statuses;
  // }
}