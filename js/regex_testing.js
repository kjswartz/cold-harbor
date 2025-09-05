export function testFunction(functionName, testCases) {
  console.log(`\n${"=".repeat(60)}`);
  console.log(`TESTING: ${functionName}`);
  console.log(`${"=".repeat(60)}`);
  
  testCases.forEach((testCase, index) => {
    console.log(`\n--- Test ${index + 1}: ${testCase.description} ---`);
    try {
      const result = testCase.test();
      console.log(`✅ PASSED: ${JSON.stringify(result)}`);
    } catch (error) {
      console.log(`❌ FAILED: ${error.message}`);
    }
  });
}

export function testRegexFunction(regex, testCases) {
  testCases.forEach((testCase, index) => {
    console.log(`\n--- Test ${index + 1}: ${testCase.description} ---`);
    console.log(`Input: "${testCase.text}"`);

    const matches = regex.test(testCase.text);
    const result = matches === testCase.shouldMatch ? "✅ PASSED" : "❌ FAILED";

    console.log(`Expected: ${testCase.shouldMatch ? "should match" : "should NOT match"}`);
    console.log(`Actual: ${matches ? "matches" : "does NOT match"}`);
    console.log(`Result: ${result}`);
    
    if (matches) {
      const match = testCase.text.match(regex);
      console.log(`Match details: "${match[0]}"`);
    }
  });
}

// Regex to match the docs line with two groups:
// Group 1: Matches the text pattern containing the book emoji (📘), the word "Docs", "help", "docs-content", and ending with "**".
// Group 2: Captures everything after the matched text, typically the issue number.
// Flags:
// - 'i': Makes the regex case-insensitive, allowing it to match "Docs", "docs", etc.
// - 'm': Enables multiline mode, allowing the regex to match patterns across multiple lines.
const bookEmojiLineGroupRegex = /^(.*📘.*Docs.*help.*docs-content.*\*\*)\s*(.*)$/im;

const testBookEmojiLineGroupRegex = () => {
  const testCases = [
    {
      description: "Match with book emoji and no content",
      text: "- 📘 **Docs ([help][docs-content]):**",
      shouldMatch: true,
    },
    {
      description: "Match with book emoji and content",
      text: "- 📘 **Docs ([help][docs-content]):** some content",
      shouldMatch: true,
    },
    {
      description: "Match with book emoji and issue number",
      text: "- 📘 **Docs ([help][docs-content]):** issues/12345",
      shouldMatch: true,
    },
    {
      description: "No match without book emoji",
      text: "- **Docs ([help][docs-content]):** some content",
      shouldMatch: false,
    },
    {
      description: "Match with multiple lines",
      text: `Some content
- 📘 **Docs ([help][docs-content]):** issues/67890
More content`,
      shouldMatch: true,
    }
  ];

  testRegexFunction(bookEmojiLineGroupRegex, testCases);
};

console.log('\ntestBookEmojiLineGroupRegex');
console.log(`${"=".repeat(60)}`);
testBookEmojiLineGroupRegex();

const bookEmojiLineGroupRegexTestCases = [
  {
    description: "Match with book emoji and content",
    test: () => {
      const line = "- 📘 **Docs ([help][docs-content]):** some content";
      const expected = "- 📘 **Docs ([help][docs-content]):** issues/12345";
      const result = line.replace(bookEmojiLineGroupRegex, `$1 issues/12345`);
    if (result !== expected) {
        throw new Error(`Expected: "${expected}", Got: "${result}"`);
      }
      return result;
    },
  },
  {
    description: "Match with book emoji and no content",
    test: () => {
      const line = "- 📘 **Docs ([help][docs-content]):**";
      const expected = "- 📘 **Docs ([help][docs-content]):** issues/12345";
      const result = line.replace(bookEmojiLineGroupRegex, `$1 issues/12345`);
    if (result !== expected) {
        throw new Error(`Expected: "${expected}", Got: "${result}"`);
      }
      return result;
    },
  },
  {
    description: "Match with book emoji with checkbox",
    test: () => {
      const line = "- [ ] 📘 **Docs ([help][docs-content]):**";
      const expected = "- [ ] 📘 **Docs ([help][docs-content]):** issues/12345";
      const result = line.replace(bookEmojiLineGroupRegex, `$1 issues/12345`);
    if (result !== expected) {
        throw new Error(`Expected: "${expected}", Got: "${result}"`);
      }
      return result;
    },
  },
];

console.log('\nbookEmojiLineGroupRegex Replace Test');
console.log(`${"=".repeat(60)}`);
testFunction('bookEmojiLineGroupRegex', bookEmojiLineGroupRegexTestCases);

// Final message
console.log(`\n${"=".repeat(60)}`);
console.log(`ALL TESTS COMPLETED`);
console.log(`${"=".repeat(60)}`);
