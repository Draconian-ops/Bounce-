// Ball properties
float ballX, ballY;
float ballRadius = 5;
float ballSpeedX = 3;
float ballSpeedY = -3;

// Paddle properties
float paddleX;
float paddleY = 480;
float paddleWidth = 80;  // Doubled paddle width
float paddleHeight = 10;
float paddleSpeed = 6;

// Brick properties
int brickRows = 5;
int brickCols = 10;
float brickWidth;
float brickHeight = 20;
int[][] brickHealth;  // Each brick needs to be hit twice

// Game properties
int lives = 4;  // Maximum 4 lives
boolean gameOver = false;

void setup() {
  size(800, 500);
  
  // Initialize ball position
  ballX = width / 2;
  ballY = height / 2;
  
  // Initialize paddle position
  paddleX = width / 2 - paddleWidth / 2;
  
  // Initialize bricks
  brickWidth = width / brickCols;
  brickHealth = new int[brickRows][brickCols];
  for (int i = 0; i < brickRows; i++) {
    for (int j = 0; j < brickCols; j++) {
      brickHealth[i][j] = 2;  // Each brick starts with 2 health points
    }
  }
}

void draw() {
  background(200);
  
  // If game is over, display "Game Over" message and stop
  if (gameOver) {
    textSize(32);
    fill(255, 0, 0);
    text("Game Over!", width / 2 - 100, height / 2);
    return;
  }
  
  // Draw and update ball
  updateBall();
  
  // Draw and update paddle
  updatePaddle();
  
  // Draw bricks
  drawBricks();
  
  // Check for collisions with bricks
  checkBrickCollisions();
  
  // Display remaining lives
  textSize(16);
  fill(0);
  text("Lives: " + lives, 10, 20);
}

void updateBall() {
  // Move the ball
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  
  // Ball-wall collision detection (left, right, top)
  if (ballX - ballRadius < 0 || ballX + ballRadius > width) {
    ballSpeedX *= -1;
  }
  if (ballY - ballRadius < 0) {
    ballSpeedY *= -1;
  }
  
  // Ball-paddle collision detection (considering animation)
  if (ballY + ballRadius >= paddleY && ballY + ballRadius <= paddleY + paddleHeight &&
      ballX > paddleX && ballX < paddleX + paddleWidth) {
    ballSpeedY *= -1;  // Reverse the Y direction
    ballY = paddleY - ballRadius;  // Adjust ball position to just above the paddle to avoid passing through
  }
  
  // Ball out of bounds (bottom)
  if (ballY - ballRadius > height) {
    lives--;  // Decrease life
    if (lives == 0) {
      gameOver = true;  // End game when lives reach 0
    } else {
      // Reset ball position and speed after losing a life
      ballX = width / 2;
      ballY = height / 2;
      ballSpeedY = -3;
    }
  }
  
  // Draw ball
  ellipse(ballX, ballY, ballRadius * 2, ballRadius * 2);
}

void updatePaddle() {
  // Move paddle based on arrow keys
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == LEFT && paddleX > 0) {
        paddleX -= paddleSpeed;
      }
      if (keyCode == RIGHT && paddleX + paddleWidth < width) {
        paddleX += paddleSpeed;
      }
    }
  }
  
  // Draw paddle
  rect(paddleX, paddleY, paddleWidth, paddleHeight);
}

void drawBricks() {
  for (int i = 0; i < brickRows; i++) {
    for (int j = 0; j < brickCols; j++) {
      if (brickHealth[i][j] > 0) {
        // Brick color based on health
        if (brickHealth[i][j] == 2) {
          fill(255, 0, 0);  // Full health (red)
        } else if (brickHealth[i][j] == 1) {
          fill(255, 165, 0);  // Half health (orange)
        }
        rect(j * brickWidth, i * brickHeight, brickWidth, brickHeight);
      }
    }
  }
}

void checkBrickCollisions() {
  // Ball-brick collision detection
  for (int i = 0; i < brickRows; i++) {
    for (int j = 0; j < brickCols; j++) {
      if (brickHealth[i][j] > 0) {
        float brickX = j * brickWidth;
        float brickY = i * brickHeight;
        
        // Check if ball is colliding with this brick
        if (ballX + ballRadius > brickX && ballX - ballRadius < brickX + brickWidth &&
            ballY + ballRadius > brickY && ballY - ballRadius < brickY + brickHeight) {
          
          // Reverse ball's Y direction and reduce brick health
          ballSpeedY *= -1;
          brickHealth[i][j]--;
        }
      }
    }
  }
}
