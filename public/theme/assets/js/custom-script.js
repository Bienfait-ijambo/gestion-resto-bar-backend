(function($){ 
	'use strict';

	/**=========================
        LOADER
    =========================**/
    $(window).on('load', function() {
        $('.loader-fix').fadeOut('slow',function(){$(this).remove();});
    });

    /**=========================
        HEADER FIXED SCROLL
    =========================**/
    $(window).on('scroll', function () {
        if($(window).scrollTop() > 200){
            $("#header").addClass('header-fixed');
        }else{
            $("#header").removeClass('header-fixed');
        }
    });

    /**=========================
        NAVBAR
    =========================**/
    $(function(){
        if($(window).width() > 768){
            $(".dropdown").hover(
            function(){
                $(this).find('.dropdown-menu').first().stop(true, true).slideDown(400);
                $(this).toggleClass('open');
                $(this).find('.dropdown-menu').parent('.nav-item.dropdown').addClass("dropdown-active");
            },
            function(){
                $(this).find('.dropdown-menu').first().stop(true, true).slideUp(100);
                $(this).toggleClass('open');
                $(this).find('.dropdown-menu').parent('.nav-item.dropdown').removeClass("dropdown-active");
            });
        };
    });

    /**=========================
        SLICK CAROUSEL
    =========================**/
    // Slider
    $(".carousel").carousel({
        pause: false,
    });
    // Swipe
    $(".carousel .carousel-inner").swipe({
        swipeLeft: function (event, direction, distance, duration, fingerCount) {
            this.parent().carousel("next");
        },
        swipeRight: function () {
            this.parent().carousel("prev");
        },
        threshold: 0,
        tap: function (event, target) {
            window.location = $(this).find(".carousel-item.active a").attr("href");
        },
        excludedElements: "label, button, input, select, textarea, .noSwipe",
    });

    $(".carousel .carousel-inner").on("dragstart", "a", function () {
        return false;
    });

    /**=========================
        CAROUSEL
    =========================**/
    // clients carousel
    $(".clients-carousel").not('.slick-initialized').slick({
        slidesToShow: 4,
        dots: false,
        autoplay: true,
        responsive:[
            {
                breakpoint: 900,
                settings:{
                    slidesToShow: 2,
                    slidesToScroll: 1,
                    infinite: true,
                }
            }
        ]
    });

    // client says
    $(".client-says-carousel").not('.slick-initialized').slick({
        slidesToShow: 2,
        dots: false,
        autoplay: true,
        responsive:[
            {
                breakpoint: 900,
                settings:{
                    slidesToShow: 1,
                    slidesToScroll: 1,
                    infinite: true,
                }
            }
        ]
    });

    /**=========================
        MAGANIFIC POPUP
    =========================**/
    $('a.mfpclick').click(function(m) {
        m.preventDefault();
        var gallery = $(this).attr('href');
        $(gallery).magnificPopup({
            delegate: 'a',
            type:'image',
            mainClass: 'mfp-fade',
            gallery: {
                enabled: true
            }
        }).magnificPopup('open');
    });

    /**=========================
        EASING
    =========================**/
    // Smooth scrolling using jQuery easing
    $(".easing-click").on('click', function(e) {
    var target = $(this.hash);
    target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
        if (target.length) {
        $('html, body').animate({
            scrollTop: (target.offset().top - 72)
        }, 1000, "easeInOutExpo");
            return false;
        }
    });

    /**=========================
        BACK TO TOP
    =========================**/
    $(window).on('scroll', function() {
        if ($(this).scrollTop() > 300) {
            $('#backtotop').fadeIn(2000);
        } else {
            $('#backtotop').fadeOut(2000);
        }
    });

})(jQuery);