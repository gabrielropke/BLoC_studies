import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lista_de_compras/pages/resumes/resume/bloc/resume_bloc.dart';
import 'package:lista_de_compras/pages/resumes/resume/bloc/resume_state.dart';
import 'package:lista_de_compras/pages/resumes/resume/widgets/resumes_widget.dart';
import 'package:lista_de_compras/utils/loading.dart';

class ResumePage extends StatefulWidget {
  const ResumePage({super.key});

  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  late ResumeBloc resumeBloc;

  @override
  void initState() {
    resumeBloc = ResumeBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => resumeBloc,
      child: BlocBuilder<ResumeBloc, ResumeState>(
        builder: (context, state) {

          if (state is ResumeInitial) {
            return LoadingWidget.progressIndication();
          }

          if (state is ResumeLoaded) {
            return ResumesWidget(resumeBloc: resumeBloc);
          }

          return LoadingWidget.progressIndication();

        },
      ),
    ));
  }
}
