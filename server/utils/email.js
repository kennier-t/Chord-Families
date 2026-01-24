const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  // For development, we'll use a test SMTP service.
  // In a production environment, you would use a real SMTP service.
  host: 'smtp.ethereal.email',
  port: 587,
  auth: {
    user: 'your_ethereal_user',
    pass: 'your_ethereal_password'
  }
});

async function sendVerificationEmail(user, token) {
  const verificationLink = `http://localhost:3000/api/auth/verify?token=${token}`;
  const mailOptions = {
    from: '"ChordSmith" <noreply@chordsmith.com>',
    to: user.email,
    subject: 'Verify your ChordSmith account',
    html: `
      <h1>Welcome to ChordSmith!</h1>
      <p>Please click the following link to verify your account:</p>
      <a href="${verificationLink}">${verificationLink}</a>
    `
  };
  // In a real app, you would use a proper email sending service.
  // For this implementation, we will log the email to the console.
  console.log('Verification email sent:');
  console.log(mailOptions);
  // await transporter.sendMail(mailOptions);
}

async function sendPasswordResetEmail(user, token) {
    const resetLink = `http://localhost:3000/reset-password?token=${token}`;
    const mailOptions = {
        from: '"ChordSmith" <noreply@chordsmith.com>',
        to: user.email,
        subject: 'Reset your ChordSmith password',
        html: `
        <h1>Password Reset</h1>
        <p>Please click the following link to reset your password:</p>
        <a href="${resetLink}">${resetLink}</a>
        `
    };
    // In a real app, you would use a proper email sending service.
    // For this implementation, we will log the email to the console.
    console.log('Password reset email sent:');
    console.log(mailOptions);
    // await transporter.sendMail(mailOptions);
}

module.exports = {
  sendVerificationEmail,
  sendPasswordResetEmail
};