import Foundation

public enum DeeplinkPageType: String {
    case productsList
    case product
    case offlineBrand
    case onlineBrand
    case home
    case shopping
    case brands
    case leBonMarche = "lbm"
    case events
    case loyaltySignup
    case loyaltySignupOneClick
    case loyaltySignin
    case loyaltyPresentation
    case attachLoyaltyCard
    case cartView
    case webview
    case signIn
    case settings
    case iosSettingsApp
    case lovelist
}

public enum DeeplinkKey: String {
    case page              = "24s_page" // required, for all pages
    case productListOrigin = "productListOrigin" //
    case id                = "24s_id" // category
    case code              = "24s_code" // online brand
    case path              = "24s_path" // offline brand
    case url               = "24s_url_path" // webview url path
    
    // New way to use the locale (deeplink doc updated, but need synchro with both dev teams and merch)
    case locale            = "24s_locale" // the locale of the deeplink
    
    // Old way to use the locale for the deeplinks
    case pathFr            = "24s_path_fr"
    case pathEn            = "24s_path_en"
    case pathKo            = "24s_path_ko"
    case pathDe            = "24s_path_de"
    case pathZh            = "24s_path_zh"

    case modelSku          = "24s_model_sku" // product
    case color             = "24s_color" // product
    case categoryFacet     = "24s_category_facet"
    case title
    case slug
    case facetTags
    case categoryPath
}
