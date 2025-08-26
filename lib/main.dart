import 'package:flutter/material.dart';

void main() => runApp(const TutorialApp());

class TutorialApp extends StatelessWidget {
  const TutorialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planejador (TO-DO) — Tutorial',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: false,
      ),
      home: const TutorialHome(),
    );
  }
}

class TutorialHome extends StatelessWidget {
  const TutorialHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planejador (TO-DO) — Tutorial no App')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: '0) Antes de começar',
            bullets: const [
              'Vamos construir um app simples chamado “Planejador (TO-DO)”.',
              'Flutter organiza tudo em CLASSES; cada parte visual é um WIDGET.',
              'StatelessWidget (não muda) vs StatefulWidget (muda com interações).',
              'A tela é uma ÁRVORE de widgets, remontada quando o estado muda.',
              'Usaremos orientação a objetos criando a classe Task.',
              'Dica: no Flutter, TUDO é widget (texto, botão, app, etc.).',
            ],
            extra: const SelectableText(
              'Link útil: https://docs.flutter.dev/resources/architectural-overview',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),

          SectionCard(
            title: '1) Estrutura básica do app',
            description:
                'Esse é o mínimo para um app Flutter rodar: main → runApp → MaterialApp → Scaffold.',
            code: r'''
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO-DO!',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planejador!')),
      body: const Center(child: Text('Conteúdo da tela')),
    );
  }
}
''',
            demo: const BasicScaffoldDemo(),
            demoHeight: 120,
          ),

          SectionCard(
            title: 'Extras do Scaffold (slots comuns)',
            description:
                'Alguns slots úteis: Drawer, FloatingActionButton, BottomNavigationBar, BottomSheet, SnackBar etc.',
            demo: const ScaffoldSlotsDemo(),
            demoHeight: 150,
          ),

          SectionCard(
            title: '2) Criando widgets fixos (Stateless)',
            description:
                'Adicionamos um Progress fixo e uma TaskList com itens fixos (sem estado).',
            code: r'''
class Progress extends StatelessWidget {
  const Progress({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Percentual concluído:'),
        LinearProgressIndicator(value: 0.0),
      ],
    );
  }
}

class TaskListFixed extends StatelessWidget {
  const TaskListFixed({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TaskRow(label: 'Lavar as roupas'),
        _TaskRow(label: 'Levar o cachorro para passear'),
        _TaskRow(label: 'Chegar antes das 19:20'),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String label;
  const _TaskRow({required this.label});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_box_outline_blank),
      title: Text(label),
    );
  }
}
''',
            demo: const _Step2Demo(),
            demoHeight: 200,
          ),

          SectionCard(
            title: '3) Criando um item com estado (Stateful)',
            description:
                'Agora cada item tem uma Checkbox com estado próprio. Use setState para notificar mudanças.',
            code: r'''
class TaskItemStateful extends StatefulWidget {
  final String label;
  const TaskItemStateful({super.key, required this.label});
  @override
  State<TaskItemStateful> createState() => _TaskItemStatefulState();
}

class _TaskItemStatefulState extends State<TaskItemStateful> {
  bool? _value = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: _value, onChanged: (v) => setState(() => _value = v)),
        Text(widget.label),
      ],
    );
  }
}
''',
            demo: const _Step3Demo(),
            demoHeight: 140,
          ),

          SectionCard(
            title: '4) Passando uma lista dinâmica (List<String>)',
            description:
                'O pai cria a lista e passa para o filho via construtor. Filhos apenas renderizam.',
            code: r'''
class TaskListFromStrings extends StatelessWidget {
  final List<String> tasks;
  const TaskListFromStrings({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks.map((label) => ListTile(title: Text(label))).toList(),
    );
  }
}
''',
            demo: const _Step4Demo(),
            demoHeight: 160,
          ),

          SectionCard(
            title: '5) Criando um objeto Task (OO)',
            description:
                'Evoluímos de List<String> para List<Task>. Isso organiza melhor dados e comportamentos.',
            code: r'''
class Task {
  final String label;
  bool isDone;
  Task({required this.label, this.isDone = false});
}

class TaskListFromModel extends StatelessWidget {
  final List<Task> tasks;
  const TaskListFromModel({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks
          .map((t) => ListTile(
                leading: Icon(
                    t.isDone ? Icons.check_box : Icons.check_box_outline_blank),
                title: Text(t.label),
              ))
          .toList(),
    );
  }
}
''',
            demo: const _Step5Demo(),
            demoHeight: 180,
          ),

          SectionCard(
            title: '6) Adicionando Task (estado no pai + input)',
            description:
                'O estado (lista + controller) sobe para o pai. Filhos recebem props e chamam callbacks.',
            code: r'''
class ToDoAddDemo extends StatefulWidget {
  const ToDoAddDemo({super.key});
  @override
  State<ToDoAddDemo> createState() => _ToDoAddDemoState();
}

class _ToDoAddDemoState extends State<ToDoAddDemo> {
  final List<Task> tasks = [
    Task(label: 'Teste item objeto'),
    Task(label: 'Coisas'),
  ];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      tasks.add(Task(label: text));
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(Task t, bool? v) => setState(() => t.isDone = v ?? false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Nova tarefa',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addTask(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _addTask, child: const Text('Adicionar')),
            ],
          ),
        ),
        // Lista
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, i) {
              final t = tasks[i];
              return ListTile(
                leading: Checkbox(value: t.isDone, onChanged: (v) => _toggle(t, v)),
                title: Text(t.label),
                onTap: () => _toggle(t, !t.isDone),
              );
            },
          ),
        ),
      ],
    );
  }
}
''',
            demo: const _Step6Demo(),
            demoHeight: 360,
          ),

          SectionCard(
            title: '7) Estado no pai + Progresso + FAB “Ver marcadas”',
            description:
                'Fluxo de dados unidirecional: pai mantém o estado (fonte da verdade), filhos exibem e disparam eventos.',
            code: r'''
class Progress extends StatelessWidget {
  final double value;
  const Progress({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).clamp(0, 100).toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Percentual concluído:'),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: value.clamp(0.0, 1.0)),
          const SizedBox(height: 4),
          Text('$pct% concluído'),
        ],
      ),
    );
  }
}

class ToDoFullDemo extends StatefulWidget {
  const ToDoFullDemo({super.key});
  @override
  State<ToDoFullDemo> createState() => _ToDoFullDemoState();
}

class _ToDoFullDemoState extends State<ToDoFullDemo> {
  final List<Task> tasks = [
    Task(label: 'Explorar Flutter'),
    Task(label: 'Estudar Widgets'),
  ];
  final TextEditingController _controller = TextEditingController();

  double get progress {
    if (tasks.isEmpty) return 0.0;
    final done = tasks.where((t) => t.isDone).length;
    return done / tasks.length;
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      tasks.add(Task(label: text));
      _controller.clear();
    });
  }

  void _toggle(Task t, bool? v) => setState(() => t.isDone = v ?? false);

  void _showChecked() {
    final checked = tasks.where((t) => t.isDone).map((t) => '• ${t.label}').toList();
    final content = checked.isEmpty ? 'Nenhuma tarefa marcada.' : checked.join('\n');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tarefas marcadas'),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usamos um Scaffold próprio para suportar FAB dentro da área demonstrativa
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showChecked,
        icon: const Icon(Icons.list),
        label: const Text('Ver marcadas'),
      ),
      body: Column(
        children: [
          Progress(value: progress),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addTask, child: const Text('Adicionar')),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                final t = tasks[i];
                return ListTile(
                  leading: Checkbox(value: t.isDone, onChanged: (v) => _toggle(t, v)),
                  title: Text(t.label),
                  onTap: () => _toggle(t, !t.isDone),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
''',
            demo: const _Step7Demo(),
            demoHeight: 420,
          ),

          SectionCard(
            title: '8) Finalizando + Desafio',
            bullets: const [
              'Tudo é widget. Stateless = fixo. Stateful = muda com setState.',
              'Subimos o estado para o pai (fonte única da verdade).',
              'Fluxo: Pai (dados) → Filhos (props) → eventos → Pai atualiza → rebuild.',
              'Base pronta para Provider/Riverpod/BLoC sem mudar o conceito.',
            ],
            extra: const Text(
              'Desafio extra: Adicione um campo "priority" em Task.\n'
              'Mostre 🔴 para alta e 🟢 para baixa ao lado do texto.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------
 * COMPONENTES DE SUPORTE (SectionCard, CodeBlock etc.)
 * -----------------------------------------------------*/

class SectionCard extends StatelessWidget {
  final String title;
  final String? description;
  final List<String>? bullets;
  final String? code;
  final Widget? demo;
  final double? demoHeight;
  final Widget? extra;

  const SectionCard({
    super.key,
    required this.title,
    this.description,
    this.bullets,
    this.code,
    this.demo,
    this.demoHeight,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    )),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(description!),
            ],
            if (bullets != null) ...[
              const SizedBox(height: 8),
              ...bullets!.map((b) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('•  '),
                      Expanded(child: Text(b)),
                    ],
                  )),
            ],
            if (code != null) ...[
              const SizedBox(height: 12),
              CodeBlock(code: code!),
            ],
            if (extra != null) ...[
              const SizedBox(height: 12),
              extra!,
            ],
            if (demo != null) ...[
              const SizedBox(height: 12),
              Container(
                height: demoHeight ?? 220,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: demo,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CodeBlock extends StatelessWidget {
  final String code;
  const CodeBlock({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // slate-900
        borderRadius: BorderRadius.circular(8),
      ),
      child: SelectableText(
        code.trim(),
        style: const TextStyle(
          fontFamily: 'monospace',
          color: Color(0xFFE2E8F0), // slate-200
          fontSize: 12.5,
          height: 1.35,
        ),
      ),
    );
  }
}

/* -------------------------------------------------------
 * DEMOS DOS PASSOS
 * -----------------------------------------------------*/

class BasicScaffoldDemo extends StatelessWidget {
  const BasicScaffoldDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('App rodando • AppBar, Body, etc.')),
    );
  }
}

class ScaffoldSlotsDemo extends StatelessWidget {
  const ScaffoldSlotsDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(child: Center(child: Text('Menu (Drawer)'))),
      endDrawer: const Drawer(child: Center(child: Text('Configurações'))),
      body: Center(
        child: ElevatedButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Olá! Eu sou um SnackBar.')),
          ),
          child: const Text('Mostrar SnackBar'),
        ),
      ),
      bottomSheet: Container(
        height: 36,
        alignment: Alignment.center,
        child: const Text('BottomSheet persistente'),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
      floatingActionButton: Builder(
        builder: (ctx) => FloatingActionButton(
          onPressed: () => Scaffold.of(ctx).openDrawer(),
          child: const Icon(Icons.menu),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class _Step2Demo extends StatelessWidget {
  const _Step2Demo();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            // Progress fixo (0%)
            _ProgressFixed(),
            SizedBox(height: 12),
            // Lista fixa
            TaskListFixed(),
          ],
        ),
      ),
    );
  }
}

class _ProgressFixed extends StatelessWidget {
  const _ProgressFixed();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Percentual concluído:'),
        SizedBox(height: 6),
        LinearProgressIndicator(value: 0.0),
      ],
    );
  }
}

class TaskListFixed extends StatelessWidget {
  const TaskListFixed({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TaskRow(label: 'Lavar as roupas'),
        _TaskRow(label: 'Levar o cachorro para passear'),
        _TaskRow(label: 'Chegar antes das 19:20'),
      ],
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String label;
  const _TaskRow({required this.label});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.check_box_outline_blank),
      title: Text(label),
    );
  }
}

class _Step3Demo extends StatelessWidget {
  const _Step3Demo();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            TaskItemStateful(label: 'Item com estado (checkbox)'),
          ],
        ),
      ),
    );
  }
}

class TaskItemStateful extends StatefulWidget {
  final String label;
  const TaskItemStateful({super.key, required this.label});
  @override
  State<TaskItemStateful> createState() => _TaskItemStatefulState();
}

class _TaskItemStatefulState extends State<TaskItemStateful> {
  bool? _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: _value, onChanged: (v) => setState(() => _value = v)),
        Text(widget.label),
      ],
    );
  }
}

class _Step4Demo extends StatelessWidget {
  const _Step4Demo();

  @override
  Widget build(BuildContext context) {
    final tasks = <String>['Printar piadas', 'Enviar memes'];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: TaskListFromStrings(tasks: tasks),
      ),
    );
  }
}

class TaskListFromStrings extends StatelessWidget {
  final List<String> tasks;
  const TaskListFromStrings({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks.map((label) => ListTile(title: Text(label))).toList(),
    );
  }
}

class Task {
  final String label;
  bool isDone;
  Task({required this.label, this.isDone = false});
}

class _Step5Demo extends StatelessWidget {
  const _Step5Demo();

  @override
  Widget build(BuildContext context) {
    final tasks = <Task>[
      Task(label: 'Printar piadocas'),
      Task(label: 'Enviar memes'),
      Task(label: 'Adicionar'),
    ];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: TaskListFromModel(tasks: tasks),
      ),
    );
  }
}

class TaskListFromModel extends StatelessWidget {
  final List<Task> tasks;
  const TaskListFromModel({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks
          .map((t) => ListTile(
                leading: Icon(
                  t.isDone ? Icons.check_box : Icons.check_box_outline_blank,
                ),
                title: Text(t.label),
              ))
          .toList(),
    );
  }
}

class _Step6Demo extends StatelessWidget {
  const _Step6Demo();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ToDoAddDemo(),
      ),
    );
  }
}

class ToDoAddDemo extends StatefulWidget {
  const ToDoAddDemo({super.key});
  @override
  State<ToDoAddDemo> createState() => _ToDoAddDemoState();
}

class _ToDoAddDemoState extends State<ToDoAddDemo> {
  final List<Task> tasks = [
    Task(label: 'Teste item objeto'),
    Task(label: 'Coisas'),
  ];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      tasks.add(Task(label: text));
      _controller.clear();
    });
  }

  void _toggle(Task t, bool? v) => setState(() => t.isDone = v ?? false);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Nova tarefa',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _addTask(),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _addTask, child: const Text('Adicionar')),
          ],
        ),
        const SizedBox(height: 8),
        // Lista
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, i) {
              final t = tasks[i];
              return ListTile(
                leading: Checkbox(value: t.isDone, onChanged: (v) => _toggle(t, v)),
                title: Text(t.label),
                onTap: () => _toggle(t, !t.isDone),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Step7Demo extends StatelessWidget {
  const _Step7Demo();

  @override
  Widget build(BuildContext context) {
    // Colocamos um Scaffold dentro do container da seção para suportar o FAB
    return const ToDoFullDemo();
  }
}

class Progress extends StatelessWidget {
  final double value;
  const Progress({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final pct = (value * 100).clamp(0, 100).toStringAsFixed(0);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Percentual concluído:'),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: value.clamp(0.0, 1.0)),
          const SizedBox(height: 4),
          Text('$pct% concluído'),
        ],
      ),
    );
  }
}

class ToDoFullDemo extends StatefulWidget {
  const ToDoFullDemo({super.key});
  @override
  State<ToDoFullDemo> createState() => _ToDoFullDemoState();
}

class _ToDoFullDemoState extends State<ToDoFullDemo> {
  final List<Task> tasks = [
    Task(label: 'Explorar Flutter'),
    Task(label: 'Estudar Widgets'),
  ];
  final TextEditingController _controller = TextEditingController();

  double get progress {
    if (tasks.isEmpty) return 0.0;
    return tasks.where((t) => t.isDone).length / tasks.length;
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      tasks.add(Task(label: text));
      _controller.clear();
    });
  }

  void _toggle(Task t, bool? v) => setState(() => t.isDone = v ?? false);

  void _showChecked() {
    final checked = tasks.where((t) => t.isDone).map((t) => '• ${t.label}').toList();
    final content = checked.isEmpty ? 'Nenhuma tarefa marcada.' : checked.join('\n');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tarefas marcadas'),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showChecked,
        icon: const Icon(Icons.list),
        label: const Text('Ver marcadas'),
      ),
      body: Column(
        children: [
          Progress(value: progress),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addTask, child: const Text('Adicionar')),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                final t = tasks[i];
                return ListTile(
                  leading: Checkbox(value: t.isDone, onChanged: (v) => _toggle(t, v)),
                  title: Text(t.label),
                  onTap: () => _toggle(t, !t.isDone),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}