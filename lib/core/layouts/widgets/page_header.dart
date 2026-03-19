import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../models/breadcrumb.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subTitle,
    this.breadcrumbs,
  });

  final String title;
  final String? subTitle;
  final List<BreadcrumbModel>? breadcrumbs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title).h3,
        const SizedBox(height: 6),
        if (subTitle != null)
          Text(subTitle!, style: Theme.of(context).typography.medium),
        const Gap(10),
        if (breadcrumbs != null) const Gap(10),
        Breadcrumb(
          // Use a built-in arrow separator for a conventional look.
          separator: Breadcrumb.arrowSeparator,
          children: [
            TextButton(
              onPressed: () {},
              density: ButtonDensity.dense,
              child: const Text('Home'),
            ),
            TextButton(
              onPressed: () {},
              density: ButtonDensity.dense,
              child: const Text('Components'),
            ),
            // Final segment as a non-interactive label.
            const Text('Breadcrumb'),
          ],
        ),
      ],
    );
  }
}
