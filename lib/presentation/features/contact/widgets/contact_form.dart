import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_portfolio/domain/entities/contact_message.dart';
import 'package:my_portfolio/presentation/common/base_status.dart';
import 'package:my_portfolio/presentation/features/contact/bloc/contact_cubit.dart';
import 'package:my_portfolio/presentation/features/contact/bloc/contact_state.dart';
import 'package:my_portfolio/presentation/resources/resources.dart';
import 'package:my_portfolio/presentation/widgets/app_button.dart';
import 'package:my_portfolio/presentation/widgets/glass_card.dart';

/// The contact form. Validates locally, then hands a [ContactMessage] to the
/// [ContactCubit] which delivers it via FormSubmit. Shows loading, success and
/// error states.
class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    context.read<ContactCubit>().submit(
          ContactMessage(
            name: _name.text.trim(),
            email: _email.text.trim(),
            subject: _subject.text.trim(),
            message: _message.text.trim(),
          ),
        );
  }

  void _reset() {
    _formKey.currentState?.reset();
    _name.clear();
    _email.clear();
    _subject.clear();
    _message.clear();
    context.read<ContactCubit>().reset();
  }

  String? _required(String? v, String field) =>
      (v == null || v.trim().isEmpty) ? 'Please enter your $field' : null;

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Please enter your email';
    final ok = RegExp(r'^[\w.\-+]+@[\w\-]+\.[\w\-.]+$').hasMatch(v.trim());
    return ok ? null : 'Please enter a valid email';
  }

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(AppDimensions.spaceXl),
      child: BlocBuilder<ContactCubit, ContactState>(
        builder: (context, state) {
          final status = state.submitStatus;

          // On success, swap the whole form for a clean confirmation — avoids
          // showing empty fields with stray validation errors.
          if (status.isSuccess) {
            return _SuccessState(onSendAnother: _reset);
          }

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _AppTextField(
                        controller: _name,
                        label: 'Name',
                        hint: 'Your name',
                        validator: (v) => _required(v, 'name'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spaceMd),
                    Expanded(
                      child: _AppTextField(
                        controller: _email,
                        label: 'Email',
                        hint: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                _AppTextField(
                  controller: _subject,
                  label: 'Subject',
                  hint: "What's this about?",
                  validator: (v) => _required(v, 'subject'),
                ),
                const SizedBox(height: AppDimensions.spaceMd),
                _AppTextField(
                  controller: _message,
                  label: 'Message',
                  hint: 'Tell me about your project…',
                  maxLines: 5,
                  validator: (v) => _required(v, 'message'),
                ),
                if (status.isFailure) ...[
                  const SizedBox(height: AppDimensions.spaceLg),
                  _Banner(
                    icon: Icons.error_outline_rounded,
                    color: context.colors.danger,
                    message: (status as Failure).error.message,
                  ),
                ],
                const SizedBox(height: AppDimensions.spaceLg),
                AppButton(
                  label: 'Send message',
                  icon: Icons.send_rounded,
                  expand: true,
                  loading: status.isLoading,
                  onPressed: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Shown in place of the form after a successful submission.
class _SuccessState extends StatelessWidget {
  const _SuccessState({required this.onSendAnother});
  final VoidCallback onSendAnother;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.success.withValues(alpha: 0.12),
              border: Border.all(color: colors.success.withValues(alpha: 0.35)),
            ),
            child: Icon(Icons.check_circle_rounded,
                color: colors.success, size: 40),
          ),
        ),
        AppDimensions.spaceLg.vertical,
        Center(
          child: Text('Message sent!',
              style:
                  AppTextStyles.heading(24).copyWith(color: colors.textPrimary)),
        ),
        AppDimensions.spaceXs.vertical,
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Text(
              "Thanks for reaching out — your message is on its way and I'll get "
              'back to you soon.',
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium
                  ?.copyWith(color: colors.textSecondary),
            ),
          ),
        ),
        AppDimensions.spaceLg.vertical,
        AppButton(
          label: 'Send another message',
          icon: Icons.refresh_rounded,
          variant: AppButtonVariant.outline,
          expand: true,
          onPressed: onSendAnother,
        ),
      ],
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          borderSide: BorderSide(color: color),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.body(13, weight: FontWeight.w600)
                .copyWith(color: colors.textPrimary)),
        6.vertical,
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: context.textTheme.bodyMedium
              ?.copyWith(color: colors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: context.textTheme.bodyMedium
                ?.copyWith(color: colors.textMuted),
            filled: true,
            fillColor: colors.surfaceElevated,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMd, vertical: 14),
            enabledBorder: border(colors.border),
            focusedBorder: border(colors.accent),
            errorBorder: border(context.colors.danger),
            focusedErrorBorder: border(context.colors.danger),
          ),
        ),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.color,
    required this.message,
  });
  final IconData icon;
  final Color color;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: AppDimensions.spaceSm),
          Expanded(
            child: Text(message,
                style: context.textTheme.bodyMedium
                    ?.copyWith(color: context.colors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
