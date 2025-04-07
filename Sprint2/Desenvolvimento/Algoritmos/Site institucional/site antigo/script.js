 const btnMobile = document.getElementById('btnMobile');
 const menu = document.getElementById('navM');
 

btnMobile.addEventListener('click', () => {
    menu.classList.toggle('active');
    
});

    
window.efeito = ScrollReveal({reset: true});
efeito.reveal('.home',{duration:1000});



efeito.reveal('.mainSobre',{ easing: 'ease-in' });




