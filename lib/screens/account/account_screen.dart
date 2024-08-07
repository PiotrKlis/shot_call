import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shot_call/common/extensions/context_extensions.dart';
import 'package:shot_call/common/providers/nickname_provider.dart';
import 'package:shot_call/common/providers/notification_permission_provider.dart';
import 'package:shot_call/common/providers/party_name_provider.dart';
import 'package:shot_call/common/providers/version_provider.dart';
import 'package:shot_call/styleguide/dimens.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(Dimens.xmMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.strings.nickname,
              style: const TextStyle(
                fontSize: Dimens.xmMargin,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: Dimens.sMargin,
            ),
            Text(ref.read(nicknameProvider)),
            const SizedBox(
              height: Dimens.mMargin,
            ),
            Text(
              context.strings.party,
              style: const TextStyle(
                fontSize: Dimens.xmMargin,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: Dimens.sMargin,
            ),
            Text(ref.watch(partyNameProvider)),
            const SizedBox(
              height: Dimens.mMargin,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.strings.notifications,
                  style: const TextStyle(
                    fontSize: Dimens.xmMargin,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ref.watch(notificationPermissionStatusProvider).when(
                  data: (notificationStatus) {
                    final switchValue =
                        notificationStatus == PermissionStatus.granted;
                    return Switch(
                      value: switchValue,
                      onChanged: (value) {
                        if (notificationStatus ==
                                PermissionStatus.permanentlyDenied ||
                            notificationStatus == PermissionStatus.granted) {
                          openAppSettings();
                        } else {
                          Permission.notification.request();
                        }
                      },
                    );
                  },
                  loading: () {
                    return Container();
                  },
                  error: (error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.mMargin,
            ),
            Text(
              context.strings.version,
              style: const TextStyle(
                fontSize: Dimens.xmMargin,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: Dimens.sMargin,
            ),
            Text(
              ref.watch(fetchVersionProvider).whenOrNull(
                        data: (data) => data,
                      ) ??
                  '',
            ),
          ],
        ),
      ),
    );
  }
}
