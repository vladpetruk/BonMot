//
//  DemoStrings.swift
//  BonMot
//
//  Created by Brian King on 8/26/16.
//  Copyright © 2016 Raizlabs. All rights reserved.
//

import UIKit
import BonMot

enum DemoStrings {

    // A Simple Example
    static let simpleExample = "MY PRECIOUS"
        .styled(
            with:
            .tracking(.point(6)),
            .font(UIFont(name: "AvenirNextCondensed-Bold", size: 16)!),
            .alignment(.center),
            .color(BONColor(hex: 0x2769dd)),
            .adapt(.control)
    )

    /// Style a string, with both global and range-based overrides, from an XML
    /// source. This is the most common use case for styling substrings of
    /// localized strings, where searching for and replacing substrings on a
    /// per-language basis is cumbersome.
    static let xmlExample: NSAttributedString = {

        // This would typically come from NSLocalizedString
        let localizedString = "I want to be different. If everyone is wearing <black><BON:noBreakSpace/>black,<BON:noBreakSpace/></black> I want to be wearing <red><BON:noBreakSpace/>red.<BON:noBreakSpace/></red>\n<signed><BON:emDash/>Maria Sharapova</signed> <racket/>"

        // Define a colored image that's slightly shifted to account for the line height
        let racket = UIImage(named: "Tennis Racket")!.styled(with:
            .color(.raizlabsRed), .baselineOffset(-4.0))

        // Define styles
        let accent = StringStyle(.font(BONFont(name: "SuperClarendon-Black", size: 18)!))
        let black = accent.byAdding(.color(.white), .backgroundColor(.black))
        let red = accent.byAdding(.color(.white), .backgroundColor(.raizlabsRed))
        let signed = accent.byAdding(.color(.raizlabsRed))

        // Define the base style with xml rules for all tags
        let baseStyle = StringStyle(
            .font(BONFont(name: "GillSans-Light", size: 18)!),
            .lineHeightMultiple(1.8),
            .color(.darkGray),
            .adapt(.control),
            .xmlRules([
                .style("black", black),
                .style("red", red),
                .style("signed", signed),
                .enter(element: "racket", insert: racket)
                ]
            )
        )
        return localizedString.styled(with: baseStyle)
    }()

    /// Compose a string piecewise from different components. If you are using
    /// localized strings, you may not want to use this approach, since it does
    /// not work well in cases where different languages have different
    /// sentence structure. Instead, use XML as in the previous example. Use
    /// composition only if you absolutely need to build the string from pieces.
    static let compositionExample: NSAttributedString = {
        // Define a colored image that's slightly shifted to account for the line height
        let boat = UIImage(named: "boat")!.styled(with:
            .color(.raizlabsRed))

        let baseStyle = StringStyle(
            .alignment(.center),
            .color(.black)
        )

        let preamble = baseStyle.byAdding(
            .font(BONFont(name: "AvenirNext-Bold", size: 14)!),
            .adapt(.body)
        )

        let bigger = baseStyle.byAdding(
            .font(BONFont(name: "AvenirNext-Heavy", size: 64)!),
            .adapt(.control)
        )

        return NSAttributedString.composed(of: [
            "You’re going to need a\n".styled(with: preamble),
            "Bigger\n".localizedUppercase.styled(with: bigger),
            boat,
            ], baseStyle: baseStyle)
    }()

    static let imagesExample = NSAttributedString.composed(of: [
        "2".styled(with: .baselineOffset(8)),
        UIImage(named: "bee")!,
        UIImage(named: "oar")!,
        UIImage(named: "knot")!,
        "2".styled(with: .baselineOffset(8)),
        UIImage(named: "bee")!
        ], baseStyle: StringStyle(
            .font(UIFont(name: "HelveticaNeue-Bold", size: 24)!),
            .adapt(.control)
        ))

    static let noBreakSpaceExample: NSAttributedString = {
        let noSpaceTextStyle = StringStyle(
            .font(.systemFont(ofSize: 17)),
            .adapt(.control),
            .color(.darkGray),
            .baselineOffset(10)
        )

        return NSAttributedString.composed(of: [
            ("barn", "This"),
            ("bee", "string"),
            ("bug", "is"),
            ("circuit", "separated"),
            ("cut", "by"),
            ("discount", "images"),
            ("gift", "and"),
            ("pin", "no-break"),
            ("robot", "spaces"),
            ].map() {
                return NSAttributedString.composed(of: [
                    UIImage(named: $0)!,
                    Special.noBreakSpace,
                    $1.styled(with: noSpaceTextStyle)
                    ])
            }, separator: " ")
    }()

    /// A whimsical example using baseline offset and some math.
    static let heartsExample = NSAttributedString.composed(of: (0..<20).map() { i in
        let offset: CGFloat = 15 * sin((CGFloat(i) / 20.0) * 7.0 * CGFloat(M_PI))
        return "❤️".styled(with: .baselineOffset(offset))
        })

    static let indentationExamples: [NSAttributedString] = {

        /// Using an image as a bullet.
        let imageIndentation = NSAttributedString.composed(
            of: [
                UIImage(named: "robot")!,
                Tab.headIndent(4.0),
                "“It’s OK to ask for help. When doing a final exam, all the work must be yours, but in engineering, the point is to get the job done, and people are happy to help. Corollaries: You should be generous with credit, and you should be happy to help others.”",
                Special.lineSeparator,
                Special.emDash,
                "Radia Perlman",
            ],
            baseStyle: StringStyle(
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .adapt(.control)
            ))

        /// Using text as a bullet.
        let stringIndentation = NSAttributedString.composed(
            of: [
                "🍑 →",
                Tab.headIndent(4.0),
                "You can also use strings (including emoji) for bullets, and they will still properly indent the appended text by the right amount.",
            ],
            baseStyle: StringStyle(
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .color(.darkGray),
                .adapt(.control)
            ))

        /// Parse a bulleted list out of HTML which uses <li> tags. Note the use
        /// of `enter` and `exit` style rules to insert bullet characters. and
        /// line breaks. As a bonus, <code> tags are formatted using a different
        /// font and background color.
        let xmlIndentation: NSAttributedString = {
            let listItemStyle = StringStyle(
                .font(UIFont(name: "AvenirNextCondensed-Medium", size: 18.0)!),
                .adapt(.control),
                .paragraphSpacingAfter(10.0)
            )

            let codeStyle = StringStyle(
                .font(UIFont(name: "Menlo-Regular", size: 16.0)!),
                .backgroundColor(BONColor.blue.withAlphaComponent(0.1)),
                .adapt(.control)
            )

            let bulletString = NSAttributedString.composed(of: ["🍑 →", Tab.headIndent(4.0)])
            let rules: [XMLStyleRule] = [
                .style("li", listItemStyle),
                .style("code", codeStyle),
                .enter(element: "li", insert: bulletString),
                .exit(element: "li", insert: "\n")
            ]

            let xml = "<li>This list is defined with XML and displayed in a single <code>UILabel</code>.</li><li>Each row is represented with an <code>&lt;li&gt;</code> tag.</li><li>Attributed strings define the string to use for bullets.</li><li>The text style is also specified for the <code>&lt;li&gt;</code> and <code>&lt;code&gt;</code> tags.</li>"

            // Use this method of parsing XML if the content is not under your
            // control, since you are less likley to catch edge cases while
            // developing. This way, you can handle parsing errors gracefully.
            guard let string = try? NSAttributedString.composed(ofXML: xml, rules: rules) else {
                fatalError("Unable to load XML \(xml)")
            }
            return string
        }()

        return [
            imageIndentation,
            stringIndentation,
            xmlIndentation,
        ]
    }()

    /// This example uses XML to combine many features, including special
    /// characters and line spacing, and it uses single-character kerning to
    /// move the period at the end of the sentence closer to the preceding
    /// character.
    static let advancedXMLAndKerningExample: NSAttributedString = {

        let fullStyle = StringStyle(
            .alignment(.center),
            .color(.raizlabsRed),
            .font(BONFont(name: "AvenirNext-Medium", size: 16)!),
            .adapt(.body),
            .lineSpacing(20),
            .xmlRules([
                .style("large", StringStyle(
                    .font(BONFont(name: "AvenirNext-Heavy", size: 64)!),
                    .lineSpacing(40),
                    .adapt(.control))),
                .style("kern", StringStyle(
                    .tracking(.adobe(-80))
                    )),
                ])
        )

        // XML makes it hard to read. It says: "GO AHEAD, MAKE MY DAY."
        let phrase = "GO<BON:noBreakSpace/>AHEAD,\n<large>MAKE\nMY\nDA<kern>Y.</kern></large>"

        let attributedString = phrase.styled(with: fullStyle)
        return attributedString
    }()

    /// Demonstrate specifying Dynamic Type sizing behavior and custom styles
    /// via IBDesignable in Interface Builder. To see this example in action,
    /// play with the iOS Text Size slider and see how the UI elements react.
    static let dynamcTypeUIKitExample = DemoStrings.customStoryboard(identifier: "CatalogViewController")
        .attributedString(from: "Dynamic UIKit elements with custom fonts")

    /// Demonstrate how BonMot interacts with sytem preferred text styles.
    static let preferredFontsExample = DemoStrings.customStoryboard(identifier: "PreferredFonts")
        .attributedString(from: "Preferred Fonts")

    // Demonstrate different number styles and spacings.
    static let figureStylesExample: NSAttributedString = {

        let garamondStyle = StringStyle(
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!),
            .lineHeightMultiple(1.2),
            .adapt(.control)
        )

        let digits = "\n0123456789"

        return NSAttributedString.composed(of: [
            "Number Styles".styled(with: garamondStyle, .smallCaps(.fromLowercase), .color(.raizlabsRed)),
            digits.styled(with: garamondStyle, .numberCase(.lower), .numberSpacing(.monospaced)),
            digits.styled(with: garamondStyle, .numberCase(.upper), .numberSpacing(.monospaced)),
            digits.styled(with: garamondStyle, .numberCase(.lower), .numberSpacing(.proportional)),
            digits.styled(with: garamondStyle, .numberCase(.upper), .numberSpacing(.proportional))
        ])
    }()

    // Demonstrate ordinals.
    static let ordinalsExample: NSAttributedString = {

        let garamondStyle = StringStyle(
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!),
            .lineHeightMultiple(1.2),
            .adapt(.control)
        )

        let string = "Today is my <number>111<ordinal>th</ordinal></number> birthday!"
        return string.styled(with: garamondStyle.byAdding(
            .xmlRules([
                .style("number", garamondStyle.byAdding(.color(.raizlabsRed), .numberCase(.upper))),
                .style("ordinal", garamondStyle.byAdding(.ordinals(true)))
                ])
            )
        )
    }()

    // Demonstrate scientific inferiors.
    static let scientificInferiorsExample: NSAttributedString = {

        let garamondStyle = StringStyle(
            .font(UIFont(name: "EBGaramond12-Regular", size: 24)!),
            .lineHeightMultiple(1.2),
            .adapt(.control)
        )

        let string = "<name>Johnny</name> was a little boy, but <name>Johnny</name> is no more, for what he thought was <chemical>H<number>2</number>O</chemical> was really <chemical>H<number>2</number>SO<number>4</number></chemical>."
        return string.styled(with: garamondStyle.byAdding(
            .xmlRules([
                .style("name", garamondStyle.byAdding(.smallCaps(.fromLowercase))),
                .style("chemical", garamondStyle.byAdding(.color(.raizlabsRed))),
                .style("number", garamondStyle.byAdding(.scientificInferiors(true)))
                ])
            )
        )
    }()

    // Demonstrate stylistic alternates.
    static let stylisticAlternatesExample: NSAttributedString = {
        let systemFontStyle = StringStyle(
            .font(.systemFont(ofSize: 18)),
            .adapt(.control)
        )

        let password = "68Il14"
        let string = "My password, <callout>\(password)</callout>, is much easier to read with stylistic alternate set six enabled: <password>\(password)</password>."

        let callout = StringStyle(.color(.raizlabsRed))
        return string.styled(with: systemFontStyle, .xmlRules([
            .style("callout", callout),
            .style("password", callout.byAdding(.stylisticAlternates(.six(on: true)))),
            ])
        )
    }()

}

extension DemoStrings {

    /// Embed an attribute for the storyboard identifier to link to. This is
    /// a good example of embedding custom attributes in an attributed string,
    /// although it might not be the best UIKit design pattern.
    ///
    /// - Parameter theIdentifier: The identifier of the storyboard in question.
    /// - Returns: A string style that contains the extra storyboard attribute.
    static func customStoryboard(identifier theIdentifier: String) -> StringStyle {
        return StringStyle(.extraAttributes(["Storyboard": theIdentifier]))
    }

}
