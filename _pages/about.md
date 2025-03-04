---
layout: page
title: About
permalink: /about/
---

<style>
.page-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    padding: 20px;
}

.about-container {
    display: flex;
    gap: 50px;
    padding: 40px;
    background-color: #e5d6cc;
    border-radius: 10px;
    max-width: 1200px;
    margin: 0 auto;
}

.left-column {
    flex: 1;
    text-align: center;
    padding: 20px;
    padding-top: 60px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-start;
}

.right-column {
    flex: 1;
    padding: 20px;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
}

.profile-img {
    width: 250px;
    height: 250px;
    border-radius: 50%;
    object-fit: cover;
    margin-bottom: 30px;
}

.name {
    font-size: 2.8em;
    margin: 20px 0;
    color: #4a3427;
    font-family: "Trajan Pro", serif;
    text-align: center;
    width: 100%;
}

.pronouns {
    font-size: 1.4em;
    margin-bottom: 0;
    color: #4a3427;
}

.title {
    font-size: 1.8em;
    color: #4a3427;
    margin-top: 0;
    margin-bottom: 20px;
}

.about-heading {
    font-size: 3.2em;
    color: #4a3427;
    font-family: "Trajan Pro", serif;
    margin-bottom: 30px;
    margin-top: 0;
    text-align: center;
}

.about-text {
    color: #4a3427;
    font-size: 1.1em;
    line-height: 1.8;
    margin-bottom: 20px;
    text-align: justify;
    font-family: "Trajan Pro", serif;
}

.about-text:last-of-type {
    margin-bottom: 30px;
}

.email-button {
    display: inline-block;
    background-color: #4a3427;
    color: white;
    padding: 15px 40px;
    text-decoration: none;
    border-radius: 5px;
    margin-top: 20px;
    text-transform: uppercase;
    letter-spacing: 2px;
    font-size: 1.1em;
    width: 100%;
    text-align: center;
    box-sizing: border-box;
}

.social-section {
    margin-top: 40px;
    width: 100%;
    text-align: center;
}

.social-section p {
    color: #4a3427;
    margin-bottom: 25px;
    font-size: 1.2em;
    font-family: "Trajan Pro", serif;
}

.social-links {
    display: flex;
    flex-direction: column;
    gap: 20px;
    align-items: center;
}

.social-link {
    display: flex;
    align-items: center;
    gap: 15px;
    color: #4a3427;
    text-decoration: none;
    font-size: 1.1em;
    font-family: "Trajan Pro", serif;
    white-space: nowrap;
}

.social-link img {
    width: 30px;
    height: 30px;
}
</style>

<div class="page-wrapper">
    <div class="about-container">
        <div class="left-column">
            <img src="/assets/images/profile.jpg" alt="Adriana Lopez" class="profile-img">
            <h1 class="name">ADRIANA LOPEZ</h1>
            <p class="pronouns">(SHE/HER)</p>
            <p class="title">PHD STUDENT</p>
        </div>
        
        <div class="right-column">
            <h1 class="about-heading">ABOUT ME</h1>
            <p class="about-text">Originally from Mexico, I'm currently in the second year of my PhD in Aerospace Engineering at Queen Mary University of London. As an early-career researcher, I'm exploring the development of soft inflatable manipulators for space applications.</p>
            <p class="about-text">With a background in Bionic Engineering (UPIITA-IPN), I also enjoy topics like biomimetics, robotics, and creative problem-solving. I'm always looking to learn something new and happy to chat about exciting ideas in space technologies and beyond.</p>
            <p class="about-text">Feel free to reach out if you'd like to collaborate or share insights.</p>
            
            <a href="mailto:a.lopezlopez@qmul.ac.uk" class="email-button">EMAIL ME</a>

            <div class="social-section">
                <p>Find me online:</p>
                <div class="social-links">
                    <a href="https://www.linkedin.com/in/adriana-lopez-lopez/" target="_blank" class="social-link">
                        <img src="/assets/images/linkedin-icon.png" alt="LinkedIn">
                        LinkedIn: linkedin.com/in/adriana-lopez-lopez
                    </a>
                    <a href="https://github.com/adrulpz" target="_blank" class="social-link">
                        <img src="/assets/images/github-icon.png" alt="GitHub">
                        GitHub: github.com/adrulpz
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
