import 'package:flutter/material.dart';
import 'package:componentes_padrao/components/list_tiles/list_containers.dart';
import 'package:componentes_padrao/components/style_constants/tipography.dart';
import 'package:componentes_padrao/components/style_constants/colors.dart';
import 'package:reabilita_ombro/src/models/exercise_model.dart';

class PhaseDetailView extends StatelessWidget {
  final int phase;

  const PhaseDetailView({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    // Mock exercise logic for testing
    final exerciseList = ExerciseModel.mockExercises.where((e) => e.phase == phase).toList();
    return Scaffold(
      backgroundColor: MY_WHITE,
      appBar: AppBar(
        title: Text("Fase $phase", style: APP_BAR()),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Escolha o exercicio",
                style: H2(textColor: MY_BLACK),
              ),
              const SizedBox(height: 24.0),
              Expanded(
                child: exerciseList.isEmpty
                    ? Center(
                        child: Text(
                          'Nenhum exercício disponível.',
                          style: BODY(textColor: MY_DARK_GREY),
                        ),
                      )
                    : ListView.separated(
                  itemCount: exerciseList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                  itemBuilder: (context, index) {
                    return SimpleListContainerTile(
                      title: exerciseList[index].title,
                      topInfo: ["Fase $phase", exerciseList[index].duration],
                      imagePath: "assets/dummy.png",
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/exercise',
                          arguments: exerciseList[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
