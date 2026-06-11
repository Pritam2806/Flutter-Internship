import 'package:flutter/material.dart';
import 'package:tinder_cards/profile.dart';
import 'package:tinder_cards/match_screen.dart';

class TinderHomePage extends StatefulWidget {
  const TinderHomePage({super.key});

  @override
  State<TinderHomePage> createState() {
    return _TinderHomePageState();
  }   
}

class _TinderHomePageState extends State<TinderHomePage> with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin required for animations

  final List<Profile> _likedProfiles = [];
  final List<Profile> _unlikedProfiles = [];
  int _currentIndex = 0;                                   // Tells which card is currently visible
  Offset _cardOffset = Offset.zero;                        // Stores the card position
  double _rotation = 0;                                    // Stores card tilt angle
  late AnimationController _animationController;           // Controls swipe animations.
  late Animation<Offset> _animation;                       // Stores movement animation.
  bool _isSwipingOut = false;                              // When card leaves the screen
  bool _swipeRight = false;

  Profile get _currentProfile {                            // Returns the current Profile.
    return profiles[_currentIndex];
  } 

  @override
  void initState() {                                       // Runs for the first time.
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )
      ..addListener(() {
        setState(() {
          _cardOffset = _animation.value;                  // Updates the card position
          _rotation = _cardOffset.dx / 280;                // Updates rotation based on horizontal movement.
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _handleAnimationComplete();                      // Function call
        }
      }
    );
  }

  @override
  void dispose() {                                         // Release animation sources to free memory.
    _animationController.dispose();
    super.dispose();
  }

  void _nextCard() {
    _currentIndex = (_currentIndex + 1) % profiles.length; // Moves to next profile [ 10 -> 0 ][ Cycling order ]
  }

  Future<void> _navigateToMatchScreen(Profile profile) async {                 // Navigating to Match Screen.
    await Navigator.of(context).push(                      
      MaterialPageRoute(
        builder: (context) {
          return MatchScreen(profile: profile);
        }
      ),
    );
  }

  void _handleAnimationComplete() {                        // Runs when swipe animation completes.
    if (_isSwipingOut) {                                   // When we like the profile  
      final profile = _currentProfile;
      if (_swipeRight) {
        _likedProfiles.add(profile);                       // Added to liked profiles list
        _nextCard();                                       // Move to next card
        _navigateToMatchScreen(profile);                   // Opens the Match Screen
      } 
      else {
        _unlikedProfiles.add(profile);                     // Added to unlike profiles list
        _nextCard();                                       // Move to next card
      }
    }

    setState(() {
      _cardOffset = Offset.zero;                           // Back to Center
      _rotation = 0;                                       // Removes the tilt  
      _isSwipingOut = false;
    });
  }

  void _startSwipeAnimation(Offset targetOffset, bool rightSwipe) {
    _swipeRight = rightSwipe;                              // Stores the direction
    _isSwipingOut = true;                                  // Card leaving the screen
    _animation = Tween<Offset>(begin: _cardOffset, end: targetOffset).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward(from: 0);                 // Starts the animation
  }

  void _resetCardPosition() {                              // Used when the swipe is not strong enough.
    _isSwipingOut = false;
    _animation = Tween<Offset>(begin: _cardOffset, end: Offset.zero).animate(  // Move card back to center
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward(from: 0);
  }

  void _onPanUpdate(DragUpdateDetails details) {           // Runs continuously while the finger moves (While Dragging)
    setState(() {
      _cardOffset += details.delta;                        // Move the card with finger
      _rotation = _cardOffset.dx / 280;                    // Tilt card
    });
  }

  void _onPanEnd(DragEndDetails details) {                 // Runs when the finger lifted
    const threshold = 120;
    if (_cardOffset.dx > threshold) {                      // Card accepted
      _startSwipeAnimation(
        Offset(MediaQuery.of(context).size.width * 1.5, _cardOffset.dy),
        true,                                              // Move right side
      );
    } 
    else if (_cardOffset.dx < -threshold) {
      _startSwipeAnimation(
        Offset(-MediaQuery.of(context).size.width * 1.5, _cardOffset.dy),
        false,                                             // Move left side
      );
    } 
    else {
      _resetCardPosition();                                // Move the card back to center
    }
  }

  List<Profile> _visibleProfiles() {                       // Total 3 cards are visible on the main screen
    return List.generate(3, (i) {                          // Generating the list of 3 cards.
      final nextIndex = (_currentIndex + i) % profiles.length;
      return profiles[nextIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleProfiles = _visibleProfiles();
    return Scaffold(
      backgroundColor: Colors.grey[95],
      appBar: AppBar(
        title: const Text('Tinder Card Swipe'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(                                      // Avoid merging with notification area and bottom 3 buttons
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatusBar(),
              const SizedBox(height: 16),
              Expanded(
                child: Stack(                              // Cards placed on top of each other
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    for (int i = visibleProfiles.length - 1; i >= 0; i--)
                      _buildProfileCard(
                        profile: visibleProfiles[i],
                        index: i,
                        isTopCard: (i == 0),                 // Card on the top of the stack (i == 0)
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,   // Take the space between the children
      children: [
        Text(
          'Card ${_currentIndex + 1} / ${profiles.length}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            const Icon(Icons.favorite, color: Colors.green, size: 18),
            const SizedBox(width: 4),
            Text('${_likedProfiles.length} liked'),
            const SizedBox(width: 16),
            const Icon(Icons.close, color: Colors.red, size: 18),
            const SizedBox(width: 4),
            Text('${_unlikedProfiles.length} skipped'),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileCard({required Profile profile, required int index, required bool isTopCard}) {
    final baseCard = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      clipBehavior: Clip.hardEdge,                         // Be strict to the shape (No overflowing outside the shape)
      elevation: 12,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(                        // Providing the Gradient color
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: profile.gradientColors,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(                               // Fills the entire card
              child: Container(                            // ********* Shadow container ***********
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(31),
                      blurRadius: 24,
                      offset: const Offset(0, 10),         // Moves the shadow down
                    ),
                  ],
                ),
              ),
            ),
            Padding(  
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Hero(                                    // Hero animation 
                    tag: profile.name,                     // Identification of the card
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white.withAlpha(72),
                      child: Icon(profile.avatarIcon, size: 42, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    profile.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${profile.age} years old',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBottomActionIcon(icon: Icons.close,label: 'Dislike',color: Colors.redAccent),
                      _buildBottomActionIcon(icon: Icons.favorite,label: 'Like',color: Colors.greenAccent),
                    ],
                  ),
                ],
              ),
            ),
            if (isTopCard)
              Center(
                child: Opacity(
                  opacity: _cardOffset.dx != 0
                    ? (_cardOffset.dx.abs().clamp(0, 120) / 120)               // Between 0 to 1
                    : 0,                                   // When the card is not moving
                  child: Transform.scale(                  // Scaling means changing the size
                    scale: 1 + (_cardOffset.dx.abs().clamp(0, 120) / 120) * 0.3,                   // Size increase with x corrdinate
                    child: buildIndicator(
                      _cardOffset.dx > 0 ? 'LIKE' : 'DISLIKE',
                      _cardOffset.dx > 0
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (!isTopCard) {                                      // Giving the Deck of cards like effect
      final scale = 1 - (index * 0.04);                    // Making the card slightly smaller
      final offsetY = index * 18.0;                        // Move the cards downward
      return Positioned(
        top: offsetY,                                      // Position little below the topcard (Deck like effect)
        child: Transform.scale(                            // Scaling means playing with size
          scale: scale,
          child: SizedBox(
            // Getting the screen width and height
            width: MediaQuery.of(context).size.width - 32,
            height: MediaQuery.of(context).size.height * 0.75,
            child: baseCard,
          ),
        ),
      );
    }

    return Positioned(
      top: 0,                                              // Place the card at the top of the stack
      child: GestureDetector(                              // enables swiping
        onPanUpdate: _onPanUpdate,                         // Runs while dragging
        onPanEnd: _onPanEnd,                               // Runs when fingers released
        child: Transform.translate(                        // Move the widget without changing the actual layout
          offset: _cardOffset,                             // Very similar to Translation
          child: Transform.rotate(                         // Brings the rotation effect
            angle: _rotation,                              // Very similar to Rotation
            child: SizedBox(
              // Getting the screen width and height
              width: MediaQuery.of(context).size.width - 32,         // MediaQuery gets the screen information
              height: MediaQuery.of(context).size.height * 0.75,
              child: baseCard,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActionIcon({required IconData icon, required String label, required Color color}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(62),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget buildIndicator(String text, Color color) {          // Creates a Like/Dislike Indicator
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}