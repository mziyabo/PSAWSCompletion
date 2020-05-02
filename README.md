# PowerShell auto-completion for awscli
[![powershellgallery](https://img.shields.io/powershellgallery/v/AWSCompleter.svg)](https://www.powershellgallery.com/packages/AWSCompleter)
[![downloads](https://img.shields.io/powershellgallery/dt/AWSCompleter.svg?label=downloads)](https://www.powershellgallery.com/packages/AWSCompleter)

`awscli` tab-completion for PowerShell
> **Minimum PowerShell version:** PowerShell 5.1

## Installation from PowerShell Gallery:
`Install-Module -Name AWSCompleter`

## Features and Usage:
Import module and register completions as shown below.

After registering tab-completion, use Tab to complete awscli commands.

``` powershell
Import-Module AWSCompleter
Register-AWSCompleter
```

## Licence:
Apache-2.0

## Release Notes:
Largely stable but PRs and Issues are welcome.

## Known Issues:
- If you run this on PowerShell Core in Linux you may need to upgrade `PSReadline` to version [2.0.1](https://www.powershellgallery.com/packages/PSReadline/2.0.1).