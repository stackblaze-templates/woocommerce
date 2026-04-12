<?php
/**
 * Plugin Name: Starter WooCommerce Plugin
 * Description: A starter scaffold for custom WooCommerce plugin development.
 * Version: 1.0.0
 * Author: StackBlaze
 * Requires Plugins: woocommerce
 */

if (!defined('ABSPATH')) exit;

add_action('woocommerce_loaded', function () {
    // WooCommerce is loaded, add your customizations here
});

// Example: Add a custom product tab
add_filter('woocommerce_product_tabs', function ($tabs) {
    $tabs['starter_tab'] = [
        'title'    => 'Custom Tab',
        'priority' => 50,
        'callback' => function () {
            echo '<h2>Custom Tab Content</h2><p>Add your custom product info here.</p>';
        },
    ];
    return $tabs;
});
