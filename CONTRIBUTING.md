# Contributing to iOS Testing Tools

We love your input! We want to make contributing to iOS Testing Tools as easy and transparent as possible, whether it's:

- Reporting a bug
- Discussing the current state of the code
- Submitting a fix
- Proposing new features
- Becoming a maintainer

## We Develop with Github

We use GitHub to host code, to track issues and feature requests, as well as accept pull requests.

## We Use [Github Flow](https://guides.github.com/introduction/flow/)

Pull requests are the best way to propose changes to the codebase. We actively welcome your pull requests:

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## We Use [Conventional Commits](https://www.conventionalcommits.org/)

We use conventional commits for commit messages. This helps with automated changelog generation and semantic versioning.

### Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools and libraries such as documentation generation

### Examples

```
feat(testing): add new assertion helper for async operations

fix(mocks): resolve memory leak in mock generation

docs(readme): update installation instructions

style: format code according to style guide
```

## Any contributions you make will be under the MIT Software License

In short, when you submit code changes, your submissions are understood to be under the same [MIT License](http://choosealicense.com/licenses/mit/) that covers the project. Feel free to contact the maintainers if that's a concern.

## Report bugs using Github's [issue tracker](https://github.com/muhittincamdali/iOSTestingTools/issues)

We use GitHub issues to track public bugs. Report a bug by [opening a new issue](https://github.com/muhittincamdali/iOSTestingTools/issues/new).

## Write bug reports with detail, background, and sample code

**Great Bug Reports** tend to have:

- A quick summary and/or background
- Steps to reproduce
  - Be specific!
  - Give sample code if you can.
- What you expected would happen
- What actually happens
- Notes (possibly including why you think this might be happening, or stuff you tried that didn't work)

## Use a Consistent Coding Style

* Use Swift API Design Guidelines
* 2 spaces for indentation
* Use meaningful variable and function names
* Add comments for complex logic
* Write comprehensive tests
* Follow SOLID principles
* Use Clean Architecture patterns

## License

By contributing, you agree that your contributions will be licensed under its MIT License.

## References

This document was adapted from the open-source contribution guidelines for [Facebook's Draft](https://github.com/facebook/draft-js/blob/a9316a723f9e918afde44dea68b5f9f39b7d9b00/CONTRIBUTING.md).

## Development Setup

### Prerequisites

- Xcode 15.0+
- Swift 5.9+
- iOS 15.0+ SDK
- macOS 12.0+

### Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/iOSTestingTools.git
   cd iOSTestingTools
   ```
3. Create a feature branch:
   ```bash
   git checkout -b feature/amazing-feature
   ```
4. Make your changes
5. Run tests:
   ```bash
   swift test
   ```
6. Commit your changes:
   ```bash
   git commit -m "feat: add amazing feature"
   ```
7. Push to your fork:
   ```bash
   git push origin feature/amazing-feature
   ```
8. Create a Pull Request

### Testing Guidelines

- Write unit tests for all new functionality
- Ensure 100% test coverage for new code
- Include integration tests for complex features
- Add performance tests for critical paths
- Test edge cases and error conditions

### Code Review Process

1. All code changes require review
2. At least one maintainer must approve
3. All tests must pass
4. Code must follow style guidelines
5. Documentation must be updated

### Release Process

1. Update version in Package.swift
2. Update CHANGELOG.md
3. Create release tag
4. Publish to GitHub releases
5. Update documentation

## Community

- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/iOSTestingTools/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/iOSTestingTools/discussions)
- **Documentation**: [Documentation](Documentation/)
- **Examples**: [Examples](Examples/)

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- GitHub contributors page
- Project documentation

Thank you for contributing to iOS Testing Tools! 🚀 