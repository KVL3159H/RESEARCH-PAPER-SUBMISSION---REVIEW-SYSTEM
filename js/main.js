/**
 * Shared JS utilities for Research Paper Submission System
 */

document.addEventListener('DOMContentLoaded', () => {
    // Handle File Upload Display
    const fileInput = document.querySelector('input[type="file"]');
    if (fileInput) {
        fileInput.addEventListener('change', (e) => {
            const fileName = e.target.files[0] ? e.target.files[0].name : 'No file selected';
            const displayElement = document.getElementById('file-name-display');
            if (displayElement) {
                displayElement.textContent = fileName;
            }
        });
    }

    // Role-based dynamics
    const roleRadios = document.querySelectorAll('input[name="role"]');
    const expertiseGroup = document.getElementById('expertise-group');
    if (roleRadios.length > 0 && expertiseGroup) {
        roleRadios.forEach(radio => {
            radio.addEventListener('change', (e) => {
                if (e.target.value === 'reviewer') {
                    expertiseGroup.style.display = 'block';
                } else {
                    expertiseGroup.style.display = 'none';
                }
            });
        });
    }

    // Dashboard navigation helper
    const userDropdown = document.getElementById('user-dropdown');
    if (userDropdown) {
        userDropdown.addEventListener('click', () => {
            const menu = document.getElementById('dropdown-menu');
            if (menu) {
                menu.classList.toggle('active');
            }
        });
    }
});
