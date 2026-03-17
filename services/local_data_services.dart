import 'dart:math';

class LocalDataService {
  // Math questions
  static final Map<String, List<Map<String, String>>> mathQA = {
    'algebra': [
      {
        'question': 'what is algebra',
        'answer': 'Algebra is a branch of mathematics dealing with symbols and rules for manipulating them. It uses letters (like x, y) to represent unknown numbers. For example, in 2x + 3 = 7, we solve for x = 2.',
        'category': 'algebra'
      },
      {
        'question': 'solve for x 2x+5=15',
        'answer': 'To solve 2x + 5 = 15:\n1. Subtract 5 from both sides: 2x = 10\n2. Divide both sides by 2: x = 5',
        'category': 'algebra'
      },
      {
        'question': 'what is quadratic formula',
        'answer': 'The quadratic formula is x = [-b ± √(b² - 4ac)] / 2a. It solves equations like ax² + bx + c = 0.',
        'category': 'algebra'
      },
      {
        'question': 'what is pythagoras theorem',
        'answer': 'Pythagoras theorem: In a right triangle, a² + b² = c², where c is the hypotenuse. Example: If a=3, b=4, then c=5 because 9+16=25, √25=5.',
        'category': 'geometry'
      },
      {
        'question': '2+2',
        'answer': '2 + 2 = 4',
        'category': 'arithmetic'
      },
      {
        'question': '5+3',
        'answer': '5 + 3 = 8',
        'category': 'arithmetic'
      },
      {
        'question': '10-4',
        'answer': '10 - 4 = 6',
        'category': 'arithmetic'
      },
      {
        'question': '6×7',
        'answer': '6 × 7 = 42',
        'category': 'arithmetic'
      },
      {
        'question': '15÷3',
        'answer': '15 ÷ 3 = 5',
        'category': 'arithmetic'
      },
      {
        'question': 'what is calculus',
        'answer': 'Calculus is the mathematical study of continuous change. It has two main branches: differential calculus (rates of change) and integral calculus (accumulation).',
        'category': 'calculus'
      },
    ],
    
    'geometry': [
      {
        'question': 'what is geometry',
        'answer': 'Geometry is the branch of mathematics concerned with shapes, sizes, positions of figures, and properties of space.',
        'category': 'geometry'
      },
      {
        'question': 'area of rectangle',
        'answer': 'Area of a rectangle = length × width. For length 5 cm and width 3 cm, area = 15 cm².',
        'category': 'geometry'
      },
    ],
  };

  // Science questions
  static final Map<String, List<Map<String, String>>> scienceQA = {
    'physics': [
      {
        'question': 'what is gravity',
        'answer': 'Gravity is the force that attracts objects toward each other. On Earth, it gives us weight (9.8 m/s²). It keeps planets in orbit around the sun.',
        'category': 'physics'
      },
      {
        'question': 'newton laws',
        'answer': 'Newton\'s Laws:\n1st: Objects at rest stay at rest, in motion stay in motion\n2nd: F = ma (Force = mass × acceleration)\n3rd: Every action has equal opposite reaction',
        'category': 'physics'
      },
    ],
    'biology': [
      {
        'question': 'what is photosynthesis',
        'answer': 'Photosynthesis: 6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂. Plants use sunlight, water and CO₂ to make glucose and oxygen.',
        'category': 'biology'
      },
      {
        'question': 'what is cell',
        'answer': 'Cells are the basic building blocks of life. They contain nucleus (control center), mitochondria (powerhouse), and cell membrane (boundary).',
        'category': 'biology'
      },
    ],
  };

  // CYBER SECURITY TOPICS
  static final Map<String, List<Map<String, String>>> cyberQA = {
    'trojans': [
      {
        'question': 'what is trojan horse',
        'answer': 'A Trojan Horse is malicious software that disguises itself as legitimate software. Unlike viruses, Trojans don\'t replicate themselves but can create backdoors, steal data, or install other malware.',
        'category': 'trojans'
      },
      {
        'question': 'trojan types',
        'answer': 'Common Trojan types:\n• Backdoor Trojans - create remote access\n• Downloader Trojans - download more malware\n• Infostealer Trojans - steal passwords\n• Ransom Trojans - encrypt files for ransom',
        'category': 'trojans'
      },
    ],
    
    'viruses': [
      {
        'question': 'what is computer virus',
        'answer': 'A computer virus is malicious code that replicates by inserting itself into other programs. It can corrupt files, steal data, or damage systems.',
        'category': 'viruses'
      },
      {
        'question': 'virus types',
        'answer': 'Common virus types:\n• Boot Sector Virus - infects boot records\n• File Infector Virus - attaches to executable files\n• Macro Virus - infects documents\n• Polymorphic Virus - changes code to avoid detection',
        'category': 'viruses'
      },
    ],
    
    'worms': [
      {
        'question': 'what is computer worm',
        'answer': 'A worm is self-replicating malware that spreads automatically across networks without human action. Unlike viruses, worms don\'t need to attach to programs.',
        'category': 'worms'
      },
    ],
    
    'ransomware': [
      {
        'question': 'what is ransomware',
        'answer': 'Ransomware encrypts your files and demands payment (ransom) for decryption. Examples: WannaCry, Petya, Ryuk. Prevention: Regular backups, updated software.',
        'category': 'ransomware'
      },
    ],
    
    'phishing': [
      {
        'question': 'what is phishing',
        'answer': 'Phishing is cybercrime where attackers pose as legitimate entities to steal sensitive data (passwords, credit cards). Usually via fake emails or websites.',
        'category': 'phishing'
      },
      {
        'question': 'phishing types',
        'answer': 'Phishing types:\n• Email Phishing - mass fake emails\n• Spear Phishing - targeted attacks\n• Whaling - targeting executives\n• Smishing - SMS phishing\n• Vishing - voice calls',
        'category': 'phishing'
      },
    ],
    
    'ddos': [
      {
        'question': 'what is ddos attack',
        'answer': 'DDoS (Distributed Denial of Service) floods a target with traffic from multiple sources, overwhelming it and causing service disruption.',
        'category': 'ddos'
      },
    ],
    
    'malware': [
      {
        'question': 'what is malware',
        'answer': 'Malware (Malicious Software) is any program designed to harm computers or networks. Types include: viruses, worms, Trojans, ransomware, spyware, rootkits.',
        'category': 'malware'
      },
    ],
    
    'spyware': [
      {
        'question': 'what is spyware',
        'answer': 'Spyware secretly monitors user activity, collecting information without consent. It can capture keystrokes, browsing history, and passwords.',
        'category': 'spyware'
      },
    ],
    
    'keylogger': [
      {
        'question': 'what is keylogger',
        'answer': 'A keylogger records every keystroke made on a computer. Used to steal passwords, credit card numbers, and sensitive information.',
        'category': 'keylogger'
      },
    ],
    
    'firewall': [
      {
        'question': 'what is firewall',
        'answer': 'A firewall monitors and controls network traffic based on security rules. It acts as a barrier between trusted networks and untrusted networks.',
        'category': 'firewall'
      },
    ],
    
    'encryption': [
      {
        'question': 'what is encryption',
        'answer': 'Encryption converts data into secret code to prevent unauthorized access. It uses algorithms and keys to scramble information.',
        'category': 'encryption'
      },
    ],
    
    'hacker': [
      {
        'question': 'what is hacker',
        'answer': 'Hackers are skilled computer users who exploit system vulnerabilities. Types:\n• White Hat - ethical hackers\n• Black Hat - malicious hackers\n• Grey Hat - in-between',
        'category': 'hacker'
      },
    ],
    
    'cybersecurity': [
      {
        'question': 'what is cybersecurity',
        'answer': 'Cybersecurity protects systems, networks, and data from digital attacks. Key elements: Confidentiality, Integrity, Availability.',
        'category': 'cybersecurity'
      },
      {
        'question': 'cyber threats',
        'answer': 'Major cyber threats:\n1. Malware\n2. Phishing\n3. Ransomware\n4. DDoS attacks\n5. Man-in-the-Middle\n6. SQL Injection\n7. Zero-day exploits',
        'category': 'cybersecurity'
      },
    ],
    
    'botnet': [
      {
        'question': 'what is botnet',
        'answer': 'A botnet is a network of infected computers (bots) controlled remotely by attackers. Used for DDoS attacks, spam, and credential theft.',
        'category': 'botnet'
      },
    ],
    
    'social engineering': [
      {
        'question': 'what is social engineering',
        'answer': 'Social engineering manipulates people into revealing confidential information. It exploits human psychology, not technical flaws.',
        'category': 'social_engineering'
      },
    ],
  };

  // Combined QA
  static final Map<String, List<Map<String, String>>> allQA = {
    ...mathQA,
    ...scienceQA,
    ...cyberQA,
  };

  // Get response based on question
  static String getResponse(String question, {String subject = 'general'}) {
    String q = question.toLowerCase().trim();
    print('🔍 Searching for: "$q"');
    
    // Cyber Security checks
    if (q.contains('trojan')) return cyberQA['trojans']![0]['answer']!;
    if (q.contains('virus')) return cyberQA['viruses']![0]['answer']!;
    if (q.contains('worm')) return cyberQA['worms']![0]['answer']!;
    if (q.contains('ransomware')) return cyberQA['ransomware']![0]['answer']!;
    if (q.contains('phish')) return cyberQA['phishing']![0]['answer']!;
    if (q.contains('ddos')) return cyberQA['ddos']![0]['answer']!;
    if (q.contains('malware')) return cyberQA['malware']![0]['answer']!;
    if (q.contains('spyware')) return cyberQA['spyware']![0]['answer']!;
    if (q.contains('keylogger')) return cyberQA['keylogger']![0]['answer']!;
    if (q.contains('firewall')) return cyberQA['firewall']![0]['answer']!;
    if (q.contains('encrypt')) return cyberQA['encryption']![0]['answer']!;
    if (q.contains('hacker')) return cyberQA['hacker']![0]['answer']!;
    if (q.contains('cyber') || q.contains('security')) return cyberQA['cybersecurity']![0]['answer']!;
    if (q.contains('botnet')) return cyberQA['botnet']![0]['answer']!;
    if (q.contains('social engineering')) return cyberQA['social engineering']![0]['answer']!;
    
    // Math checks
    if (q.contains('algebra')) return mathQA['algebra']![0]['answer']!;
    if (q.contains('pythagoras') || q.contains('pythagorean')) return mathQA['algebra']![3]['answer']!;
    if (q.contains('2+2') || q == '2+2?') return mathQA['algebra']![4]['answer']!;
    if (q.contains('solve for x') || q.contains('2x+5=15')) return mathQA['algebra']![1]['answer']!;
    if (q.contains('calculus')) return mathQA['algebra']![8]['answer']!;
    if (q.contains('geometry')) return mathQA['geometry']![0]['answer']!;
    
    // Science checks
    if (q.contains('gravity')) return scienceQA['physics']![0]['answer']!;
    if (q.contains('newton')) return scienceQA['physics']![1]['answer']!;
    if (q.contains('photosynthesis')) return scienceQA['biology']![0]['answer']!;
    if (q.contains('cell')) return scienceQA['biology']![1]['answer']!;
    
    return "I can help with:\n\n"
           "📐 Math: Algebra, geometry, calculus, arithmetic\n"
           "🔬 Science: Physics, biology\n"
           "🛡️ Cyber Security: Trojans, viruses, ransomware, phishing, DDoS, malware, encryption, hackers, firewalls\n\n"
           "What would you like to learn about?";
  }

  // FIXED: getRandomQuestion method - this was missing!
  static Map<String, String> getRandomQuestion({String? subject}) {
    Random random = Random();
    List<Map<String, String>> allQuestions = [];
    
    // Collect all questions from all categories
    for (var category in allQA.values) {
      allQuestions.addAll(category);
    }
    
    // If no questions found, return default
    if (allQuestions.isEmpty) {
      return {
        'question': 'What is 2+2?',
        'answer': '4',
        'category': 'math'
      };
    }
    
    // Return random question
    int index = random.nextInt(allQuestions.length);
    return allQuestions[index];
  }
  
  static int min(int a, int b) => a < b ? a : b;
}