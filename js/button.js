// This file defines the functionality of the buttons

function toggleTab(evt, toggleOn) {
    // removed pressed indicator for tab button
    const tabButtons = document.getElementsByClassName("tabButton");
    for (let i = 0; i < tabButtons.length; i++) {
        tabButtons[i].classList.remove("active");
    }
    
    // make pressed tab button light up
    evt.currentTarget.classList.add("active");

    // hide tab content for all tabs
    const tabContent = document.getElementsByClassName("tabContent");
    for (let i = 0; i < tabContent.length; i++) {
        tabContent[i].classList.add("d-none");
    }

    // make pressed tab content visable
    const toggleOnTab = document.getElementById(toggleOn);
    toggleOnTab.classList.remove("d-none");
}