import UIKit

public class PagingOptions {
  public var menuItemSize: PagingMenuItemSize
  public var menuItemSource: PagingMenuItemSource
  public var menuItemSpacing: CGFloat
  public var menuInsets: UIEdgeInsets
  public var menuHorizontalAlignment: PagingMenuHorizontalAlignment
  public var menuTransition: PagingMenuTransition
  public var menuInteraction: PagingMenuInteraction
  public var contentInteraction: PagingContentInteraction
  public var selectedScrollPosition: PagingSelectedScrollPosition
  public var indicatorOptions: PagingIndicatorOptions
  public var indicatorClass: PagingIndicatorView.Type
  public var borderOptions: PagingBorderOptions
  public var borderClass: PagingBorderView.Type
  public var includeSafeAreaInsets: Bool
  public var font: UIFont
  public var selectedFont: UIFont
  public var textColor: UIColor
  public var selectedTextColor: UIColor
  public var backgroundColor: UIColor
  public var selectedBackgroundColor: UIColor
  public var menuBackgroundColor: UIColor
  public var borderColor: UIColor
  public var indicatorColor: UIColor
  
  #if swift(>=4.2)
  public var scrollPosition: UICollectionView.ScrollPosition {
    switch selectedScrollPosition {
    case .left:
      return UICollectionView.ScrollPosition.left
    case .right:
      return UICollectionView.ScrollPosition.right
    case .preferCentered, .center:
      return UICollectionView.ScrollPosition.centeredHorizontally
    }
  }
  #else
  public var scrollPosition: UICollectionViewScrollPosition {
    switch selectedScrollPosition {
    case .left:
      return UICollectionViewScrollPosition.left
    case .right:
      return UICollectionViewScrollPosition.right
    case .preferCentered, .center:
      return UICollectionViewScrollPosition.centeredHorizontally
    }
  }
  #endif
  
  public var menuHeight: CGFloat {
    return menuItemSize.height + menuInsets.top + menuInsets.bottom
  }
  
  public var estimatedItemWidth: CGFloat {
    switch menuItemSize {
    case let .fixed(width, _):
      return width
    case let .sizeToFit(minWidth, _):
      return minWidth
    }
  }
  
  public init() {
    selectedScrollPosition = .preferCentered
    menuItemSize = .sizeToFit(minWidth: 80, height: 40)
    menuTransition = .scrollAlongside
    menuInteraction = .scrolling
    menuItemSource = .class(type: PagingTitleCell.self)
    menuInsets = UIEdgeInsets.zero
    menuItemSpacing = 0
    menuHorizontalAlignment = .left
    includeSafeAreaInsets = true
    indicatorClass = PagingIndicatorView.self
    borderClass = PagingBorderView.self
    contentInteraction = .scrolling
    
    indicatorOptions = .visible(
        height: 1,
        zIndex: Int.max,
        spacing: UIEdgeInsets.zero,
        insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
  
    borderOptions = .visible(
        height: 0,
        zIndex: Int.max - 1,
        insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

    #if swift(>=4.0)
    font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
    selectedFont = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.medium)
    #else
    font = UIFont.systemFont(ofSize: 11, weight: UIFontWeightMedium)
    selectedFont = UIFont.systemFont(ofSize: 11, weight: UIFontWeightMedium)
    #endif
    
    textColor = UIColor.white
    selectedTextColor = UIColor.init(named: "theme_color")!
    backgroundColor = UIColor.init(named: "gray")!
    selectedBackgroundColor = UIColor.init(named: "gray")!
    menuBackgroundColor = UIColor.init(named: "gray")!
    borderColor = GlobalConstant.hexStringToUIColor(BLACK_COLOR)
    indicatorColor = UIColor.white
  }
}
