String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour < 5) return 'Working late?';
  if (hour < 12) return 'Ohayō';
  if (hour < 17) return 'Konnichiwa';
  if (hour < 21) return 'Good Evening';
  return '(ᴗ˳ᴗ)ᶻ𝗓𐰁';
}
