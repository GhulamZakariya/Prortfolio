import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/core/analytics/analytics_service.dart';
import 'package:my_portfolio/injection/injector.dart';
import 'package:my_portfolio/presentation/features/json_to_dart/bloc/json_to_dart_cubit.dart';
import 'package:my_portfolio/presentation/features/json_to_dart/bloc/json_to_dart_state.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/widgets/header.dart';

class JsonToDartScreen extends StatelessWidget {
  const JsonToDartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<JsonToDartCubit>(
      create: (_) => injector<JsonToDartCubit>(),
      child: const _JsonToDartView(),
    );
  }
}

class _JsonToDartView extends StatefulWidget {
  const _JsonToDartView();

  @override
  State<_JsonToDartView> createState() => _JsonToDartViewState();
}

class _JsonToDartViewState extends State<_JsonToDartView> {
  final TextEditingController _jsonController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();

  static const _subtitle =
      'Paste your JSON below and get a generated, strongly-typed Dart class.';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final analytics = injector<AnalyticsService>();
      await analytics.logStartupEvent();
      await analytics.logScreen('json_to_dart');
    });
  }

  @override
  void dispose() {
    _jsonController.dispose();
    _classNameController.dispose();
    super.dispose();
  }

  void _convert() {
    final error = context.read<JsonToDartCubit>().generate(
          jsonText: _jsonController.text,
          className: _classNameController.text,
        );
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: context.colors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isNarrow = MediaQuery.of(context).size.width < 900;

    final input = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _jsonController,
          maxLines: isNarrow ? 8 : 16,
          style: AppTextStyles.mono(13).copyWith(color: colors.textPrimary),
          decoration: _decoration(context, 'Enter JSON'),
        ),
        16.vertical,
        TextField(
          controller: _classNameController,
          style: context.textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
          decoration: _decoration(context, 'Enter class name'),
        ),
        16.vertical,
        SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(colors.primary),
              foregroundColor: WidgetStatePropertyAll(colors.onPrimary),
            ),
            onPressed: _convert,
            icon: const Icon(Icons.auto_awesome_rounded),
            label: Text('Generate Code',
                style: AppTextStyles.body(13, weight: FontWeight.w700)),
          ),
        ),
      ],
    );

    final output = BlocBuilder<JsonToDartCubit, JsonToDartState>(
      builder: (context, state) {
        if (state.output.isEmpty) {
          return Center(
            child: Text('Your generated Dart class will appear here.',
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: colors.textMuted)),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                tooltip: 'Copy to clipboard',
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: state.output));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Copied to clipboard'),
                        backgroundColor: colors.success,
                      ),
                    );
                  }
                },
                icon: Icon(Icons.copy_rounded, color: colors.accent),
              ),
            ),
            Container(
              padding: 16.all,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: AppDimensions.radiusMd.radius,
                border: Border.all(color: colors.border),
              ),
              child: SelectableText(state.output,
                  style: AppTextStyles.mono(12.5)
                      .copyWith(color: colors.textPrimary)),
            ),
          ],
        );
      },
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CommonHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: 24.all,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('JSON → Dart',
                        style: AppTextStyles.heading(32)
                            .copyWith(color: colors.textPrimary)),
                    8.vertical,
                    Text(_subtitle,
                        style: context.textTheme.bodyLarge
                            ?.copyWith(color: colors.textSecondary)),
                    32.vertical,
                    if (isNarrow) ...[
                      input,
                      32.vertical,
                      output,
                    ] else
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: input),
                            32.horizontal,
                            Expanded(child: output),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _decoration(BuildContext context, String label) {
    final colors = context.colors;
    OutlineInputBorder border(Color c) => OutlineInputBorder(
          borderRadius: AppDimensions.radiusMd.radius,
          borderSide: BorderSide(color: c),
        );
    return InputDecoration(
      labelText: label,
      alignLabelWithHint: true,
      labelStyle: TextStyle(color: colors.textSecondary),
      filled: true,
      fillColor: colors.surface,
      enabledBorder: border(colors.border),
      focusedBorder: border(colors.accent),
    );
  }
}
