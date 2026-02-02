// The MIT License (MIT)
//
// Copyright © 2022 Ivan Izyumkin
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

/// Delegate for handling touch gesture.
protocol MCEmojiCategoryViewDelegate: AnyObject {
    /**
     Processes an event by category selection.
     
     - Parameter index: index of the selected category.
     */
    func didChoiceCategory(at index: Int)
}

/// The class store the category icon and processes handling touches.
final class MCTouchableEmojiCategoryView: UIView {
    
    // MARK: - Private Properties
    
    private let categoryIconView: MCEmojiCategoryIconView
    /// Target category index.
    private let categoryIndex: Int
    
    private weak var delegate: MCEmojiCategoryViewDelegate?
    
    /// Fixed icon size to keep icons at a normal width regardless of popover width.
    private let iconSize: CGFloat
    
    // MARK: - Initializers
    
    init(
        delegate: MCEmojiCategoryViewDelegate,
        categoryIndex: Int,
        categoryType: MCEmojiCategoryType,
        selectedEmojiCategoryTintColor: UIColor,
        iconSize: CGFloat = 14 // sensible default that looks close to system segmented icons
    ) {
        self.delegate = delegate
        self.categoryIndex = categoryIndex
        self.iconSize = iconSize
        self.categoryIconView = MCEmojiCategoryIconView(
            type: categoryType,
            selectedIconTintColor: selectedEmojiCategoryTintColor
        )
        super.init(frame: .zero)
        setupCategoryIconViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Nothing dynamic to do on each layout pass.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        categoryIconView.updateIconTintColor(for: .highlighted)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        categoryIconView.updateIconTintColor(for: .selected)
        delegate?.didChoiceCategory(at: categoryIndex)
    }
    
    // MARK: - Public Methods
    
    /**
     Updates the icon state to the selected one if the indexes match and the standard one if not.
     
     - Parameter selectedCategoryIndex: Selected category index.
     */
    public func updateCategoryViewState(selectedCategoryIndex: Int) {
        categoryIconView.updateIconTintColor(
            for: categoryIndex == selectedCategoryIndex ? .selected : .standard
        )
    }
    
    // MARK: - Private Methods
    
    private func setupCategoryIconViewLayout() {
        addSubview(categoryIconView)
        
        // Make sure Auto Layout is used and no autoresizing masks leak in.
        translatesAutoresizingMaskIntoConstraints = false
        categoryIconView.translatesAutoresizingMaskIntoConstraints = false
        
        // Center the icon and keep a fixed size so it doesn't stretch with popover width
        NSLayoutConstraint.activate([
            categoryIconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            categoryIconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryIconView.widthAnchor.constraint(equalToConstant: iconSize),
            categoryIconView.heightAnchor.constraint(equalToConstant: iconSize)
        ])
    }
}

