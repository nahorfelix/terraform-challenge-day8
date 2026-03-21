# Contributing to Terraform Challenge Day 8

Thank you for your interest in contributing to this Terraform modules project! This repository demonstrates professional infrastructure-as-code practices and welcomes improvements and extensions.

## How to Contribute

### 🐛 Bug Reports
If you find a bug or issue:
1. Check existing issues to avoid duplicates
2. Create a new issue with:
   - Clear description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Terraform version and provider versions
   - Relevant error messages or logs

### 💡 Feature Requests
For new features or enhancements:
1. Open an issue describing:
   - The problem you're trying to solve
   - Your proposed solution
   - Any alternative approaches considered
   - Impact on existing functionality

### 🔧 Code Contributions

#### Development Setup
1. Fork the repository
2. Clone your fork locally
3. Install required tools:
   - Terraform >= 1.0
   - AWS CLI configured
   - Pre-commit hooks (optional but recommended)

#### Making Changes
1. Create a feature branch: `git checkout -b feature/your-feature-name`
2. Make your changes following the coding standards below
3. Test your changes thoroughly
4. Commit with clear, descriptive messages
5. Push to your fork and create a Pull Request

#### Coding Standards

**Terraform Code Style:**
- Use `terraform fmt` to format all `.tf` files
- Follow HashiCorp's Terraform style guide
- Use descriptive variable and resource names
- Include comprehensive variable descriptions
- Add appropriate tags to all resources

**Documentation:**
- Update README files for any module changes
- Include usage examples for new features
- Document any breaking changes
- Use clear, professional language

**Testing:**
- Test modules in isolated environments
- Verify `terraform plan` produces expected results
- Ensure `terraform apply` completes successfully
- Test `terraform destroy` cleans up all resources

#### Module Development Guidelines

**Variable Design:**
- Required variables should have clear validation rules
- Optional variables should have sensible defaults
- Use appropriate variable types (string, number, bool, list, map)
- Group related variables logically in the file

**Resource Naming:**
- Use consistent naming conventions across all resources
- Include the cluster_name variable in resource names
- Avoid hardcoded values that limit reusability

**Outputs:**
- Expose all values that calling modules might need
- Include helpful descriptions for each output
- Consider future use cases when designing outputs

### 🧪 Testing Checklist

Before submitting a PR, ensure:
- [ ] Code follows Terraform formatting standards (`terraform fmt`)
- [ ] All variables have descriptions and appropriate types
- [ ] Module can be deployed successfully
- [ ] Module can be destroyed cleanly
- [ ] Documentation is updated and accurate
- [ ] Examples work as described
- [ ] No sensitive data is committed

### 📝 Pull Request Process

1. **Title**: Use clear, descriptive titles (e.g., "feat: Add RDS integration to web cluster module")
2. **Description**: Include:
   - What changes were made and why
   - Any breaking changes
   - Testing performed
   - Screenshots if UI-related
3. **Review**: Be responsive to feedback and make requested changes
4. **Merge**: Maintainers will merge after approval

## Code of Conduct

### Our Standards
- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior
- Harassment, discrimination, or offensive comments
- Personal attacks or trolling
- Publishing private information without permission
- Any conduct that would be inappropriate in a professional setting

## Recognition

Contributors will be recognized in the project documentation. Significant contributions may result in collaborator access to the repository.

## Questions?

Feel free to open an issue for any questions about contributing. We're here to help make your contribution experience as smooth as possible!

---

*This project is part of the 30-Day Terraform Challenge and welcomes contributions from the DevOps and Infrastructure-as-Code community.*