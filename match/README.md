<h3 align="center">
  <a href="https://github.com/fastlane/fastlane/tree/master/fastlane">
    <img src="../fastlane/assets/fastlane.png" width="150" />
    <br />
    fastlane
  </a>
</h3>
<p align="center">
  <a href="https://github.com/fastlane/fastlane/tree/master/deliver">deliver</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/snapshot">snapshot</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/frameit">frameit</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/pem">pem</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/sigh">sigh</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/produce">produce</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/cert">cert</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/spaceship">spaceship</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/pilot">pilot</a> &bull;
  <a href="https://github.com/fastlane/boarding">boarding</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/gym">gym</a> &bull;
  <a href="https://github.com/fastlane/fastlane/tree/master/scan">scan</a> &bull;
  <b>match</b>
</p>
-------

<p align="center">
  <img src="assets/match.png" height="110">
</p>

match
============

[![Twitter: @FastlaneTools](https://img.shields.io/badge/contact-@FastlaneTools-blue.svg?style=flat)](https://twitter.com/FastlaneTools)
[![License](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/fastlane/fastlane/blob/master/match/LICENSE)
[![Gem](https://img.shields.io/gem/v/match.svg?style=flat)](http://rubygems.org/gems/match)
[![Build Status](https://img.shields.io/circleci/project/fastlane/fastlane/master.svg?style=flat)](https://circleci.com/gh/fastlane/fastlane)

###### 使用Git简便的在团队成员直接同步你的证书和配置

A new approach to iOS code signing: Share one code signing identity across your development team to simplify your codesigning setup and prevent code signing issues.

-------
<p align="center">
    <a href="#why-match">Why?</a> &bull;
    <a href="#installation">Installation</a> &bull;
    <a href="#usage">Usage</a> &bull;
    <a href="#is-this-secure">Is this secure?</a> &bull;
    <a href="#need-help">Need help?</a>
</p>

-------

<h5 align="center"><code>match</code> is part of <a href="https://fastlane.tools">fastlane</a>: connect all deployment tools into one streamlined workflow.</h5>

## Why match?

Before starting to use `match`, make sure to read the [codesigning.guide](https://codesigning.guide)

> When deploying an app to the App Store, beta testing service or even installing it on a device, most development teams have separate code signing identities for every member. This results in dozens of profiles including a lot of duplicates.

> You have to manually renew and download the latest set of provisioning profiles every time you add a new device or a certificate expires. Additionally this requires spending a lot of time when setting up a new machine that will build your app.

**A new approach**

> Share one code signing identity across your development team to simplify your setup and prevent code signing issues. What if there was a central place where your code signing identity and profiles are kept, so anyone in the team can access them during the build process?

### Why not let Xcode handle all this?

- You have full control over what happens
- You have access to all the certificates and profiles, which are all securely stored in git
- You share one code signing identity across the team to have fewer certificates and profiles
- Xcode sometimes revokes certificates which breaks your setup causing failed builds
- More predictable builds by settings profiles in an explicit way instead of using the `Automatic` setting
- It just works™

### What does `match` do for you?

              |  match
--------------------------|------------------------------------------------------------
:arrows_counterclockwise:  | 使用Git自动在团队所有成员之间同步证书和配置文件
:package:  | Handle all the heavy lifting of creating and storing your certificates and profiles
:computer:  | Setup codesigning on a new machine in under a minute
:dart:  | Designed to work with apps with multiple targets and bundle identifiers
:lock: | You have full control over your files and Git repo, no third party service involved
:sparkles: | Provisioning profile will always match the correct certificate
:boom:  | Easily reset your existing profiles and certificates if your current account has expired or invalid profiles
:recycle:  | Automatically renew your provisioning profiles to include all your devices using the `--force` option
:busts_in_silhouette:  | Support for multiple Apple accounts and multiple teams
:sparkles: | Tightly integrated with [fastlane](https://fastlane.tools) to work seamlessly with [gym](https://github.com/fastlane/fastlane/tree/master/gym) and other build tools

For more information about the concept, visit [codesigning.guide](https://codesigning.guide).

## 安装

```
sudo gem install match
```

Make sure you have the latest version of the Xcode command line tools installed:

    xcode-select --install

## 使用

### 启动

1. 创建一个**新的、private的Git repo** (e.g. on [GitHub](https://github.com/new) or [BitBucket](https://bitbucket.org/repo/create)) 并命名为类似 `certificates`的名字。 **Important:** 确保这个仓库是*私有*的.

2. Optional: Create a **new, shared Apple Developer Portal account**, something like `office@company.com` that will be shared across your team from now on (for more information visit [codesigning.guide](https://codesigning.guide))

3. 运行一下命令来开始使用 `match`:

```
match init
```

<img src="assets/match_init.gif" width="550" />

程序会让你输入git仓库的地址. 可以是`https://` 或者`git` URL. `match init` 不会读取或者更改这个仓库里的内容.

然后一个`Matchfile`将会在当前目录里被创建 (或者是在`./fastlane/`文件夹).

该文件的内容示例： (要查看更高级的设置，请查看[fastlane section](#fastlane)):

```ruby
git_url "https://github.com/fastlane/fastlane/tree/master/certificates"

app_identifier "tools.fastlane.app"
username "user@fastlane.tools"
```

#### Important: 一个团队使用一个git repo

`match` 设计的是每个Apple ID一个git repo. 如果你为多个团队工作，请为每个团队创建各自的repo。 More information on [codesigning.guide](https://codesigning.guide)

### 运行

> 第一次运行 `match` 命令之前，请考虑是否需要使用[match nuke command](#nuke)命令清除已经有的证书和pp文件。

在运行了 `match init` 你就可以运行如下命令生成新的证书和pp文件profiles:

```
match appstore
```
```
match development
```

<img src="assets/match_appstore_small.gif" width="550" />

这将会创建新的证书和pp文件（如有需要）并存储到git repo里。如果你之前运行过`match`命令，它会自动下载已有的。

pp文件安装在`~/Library/MobileDevice/Provisioning Profiles`下，而证书和私钥存储在Keychain里。

To get a more detailed output of what `match` is doing use

```
match --verbose
```

For a list of all available options run

```
match --help
```

#### 处理多个target

如果你有多个target，各有不同的Bundle Identifier， 可以单独为某一个target运行`match`:

```
match appstore -a tools.fastlane.app
match appstore -a tools.fastlane.app.watchkitapp
```

You can make this even easier using [fastlane](https://github.com/fastlane/fastlane/tree/master/fastlane) by creating a match lane like this:

```
lane :match do
  match(app_identifier: "com.krausefx.app1", readonly: true)
  match(app_identifier: "com.krausefx.app2", readonly: true)
  match(app_identifier: "com.krausefx.app3", readonly: true)
end
```

Then all your team has to do is `fastlane match` and keys, certs and profiles for all targets will be synced.

#### Passphrase

在一台新电脑上第一次运行`match`时，它会让你输入git repo的密码，这是一层安全措施：所有文件都是使用`openssl`加密过的，因此在新电脑上安装的时候你需要这个密码来解密。

要用环境变量设置密码的话，用`MATCH_PASSWORD`.

#### 新电脑

要在新电脑上设置证书和pp文件，你只需要运行：

```
match development
```

可以在`readonly` 模式下运行`match`以防止产生新的证书。

```
match development --readonly
```

#### 访问限制

使用`match`的一个好处是可以不用让每个人都去访问developer portal就能让他们拿到CS证书:

1. 运行`match`以把证书存储到Git repo
2. 给团队成员密码，让他们能访问这个repo
3. 团队成员可以运行`match`来自动下载和安装证书签名文件，这样他们就不用访问developer portal了。
4. 每次你运行`match`来更新pp文件时，(e.g. 添加新设备), 所有的成员在运行`match`之后都会得到更新后的文件

如果你不需要`match`访问developer portal，请加上`--readonly`，这样它就不会向你要developer portal的密码了.

这么做的好处是没有人会因为误操作而revoke证书了. 此外建议安装[FixCode Xcode Plugin](https://github.com/neonichu/FixCode)来禁用`Fix Issue`按钮.

#### Git Repo

在第一次运行`match`后，你的git repo将会包含两个文件夹:

- `certs`包含了所有的证书和私钥
- `profiles`包含了所有的pp文件

此外`match`还贴心的为你创建了`README.md`让新成员更容易上手:

<p align="center">
  <img src="assets/github_repo.png" width="700" />
</p>

#### fastlane

使用[fastlane](https://fastlane.tools)，把`match`添加到你的`Fastfile`来自动获取最新的code signing certificates.

```ruby
match(type: "appstore")

match(git_url: "https://github.com/fastlane/fastlane/tree/master/certificates",
      type: "development")

match(git_url: "https://github.com/fastlane/fastlane/tree/master/certificates",
      type: "adhoc",
      app_identifier: "tools.fastlane.app")

# `match` 应该在你使用 `gym`build项目之前运行
gym
...
```

##### 多个Targets

如果你的项目有多个target (e.g. Widget or WatchOS Extension)

```ruby
match(app_identifier: "tools.fastlane.app", type: "appstore")
match(app_identifier: "tools.fastlane.app.today_widget", type: "appstore")
```

`match` 可以为所有的bundle identifier使用同一个repo.

### Setup Xcode project

为了保证Xcode为每个target使用正确的pp文件, 不要使用 `Automatic` 功能 for the profile selection.

此外建议使用[FixCode Xcode Plugin](https://github.com/neonichu/FixCode)禁用`Fix Issue`按钮. 这个`Fix Issue`可能会revoke已有的证书，从而导致pp文件失效。

#### To build from the command line using [fastlane](https://fastlane.tools)

`match` automatically pre-fills environment variables with the UUIDs of the correct provisioning profiles, ready to be used in your Xcode project.

<img src="assets/UDIDPrint.png" width="700" />

Open your target settings, open the dropdown for `Provisioning Profile` and select `Other`:

<img src="assets/XcodeProjectSettings.png" width="700" />

Profile environment variables are named after `$(sigh_<bundle_identifier>_<profile_type>)`

e.g. `$(sigh_tools.fastlane.app_development)`

#### To build from Xcode manually

This is useful when installing your application on your device using the Development profile.

You can statically select the right provisioning profile in your Xcode project (the name will be `match Development tools.fastlane.app`).

### 连续集成

#### Repo访问

在让一个连续集成CI系统使用`match`时，会出现一种很古怪的问题：要让CI能访问到git repo，通常的做法是吧CI的公共ssh key添加到`match`的repo里，但是由于你的CI要用这个key来访问你的代码所在的repo，[你不能这么做(把key添加到`match`的repo里)，否则会出现error:`key already in use`](https://help.github.com/articles/error-key-already-in-use/)

有的repo管理网站允许你把同一个deploy key添加给多个不同的repo，但是github不允许。如果你使用的管理网站允许，你就不用担心这个问题了，把CI的key添加到`match`的repo里，翻到[这儿](####Encryption password)开始看吧。

处理方法:

1. Create a new account on your repo host with read-only access to your `match` repo. Bitrise have a good description of this [here](http://devcenter.bitrise.io/docs/adding-projects-with-submodules).
2. Some CIs allow you to upload your signing credientials manually, but obviously this means that you'll have to re-upload the profiles/keys/certs each time they change.

Neither solution is pretty. It's one of those _trade-off_ things. Do you care more about **not** having an extra account sitting around, or do you care more about having the :sparkles: of auto-syncing of credentials.

#### Encryption password
Once you've decided which approach to take, all that's left to do is to set your encryption password as secret environment variable named `MATCH_PASSWORD`. Match will pick this up when it's run.

### Nuke

If you never really cared about code signing and have a messy Apple Developer account with a lot of invalid, expired or Xcode managed profiles/certificates, you can use the `match nuke` command to revoke your certificates and provisioning profiles. Don't worry, apps that are already available in the App Store will still work. Builds distributed via TestFlight might be disabled after nuking your account, so you'll have to re-upload a new build. After clearing your account you'll start from a clean state, and you can run `match` to generate your certificates and profiles again.

To revoke all certificates and provisioning profiles for a specific environment:

```sh
match nuke development
match nuke distribution
```

<img src="assets/match_nuke.gif" width="550" />

You'll have to confirm a list of profiles / certificates that will be deleted.

### Change Password

To change the password of your repo and therefore decrypting and encrypting all files run

```
match change_password
```

You'll be asked for the new password on all your machines on the next run.

### 手动解密

If you want to manually decrypt a file you can.

```
openssl aes-256-cbc -k "<password>" -in "<fileYouWantToDecryptPath>" -out "<decryptedFilePath>" -a -d
```


## Is this secure?

Both your keys and provisioning profiles are encrypted using OpenSSL using a passphrase.

Storing your private keys in a Git repo may sound off-putting at first. We did an in-depth analysis of potential security issues and came to the following conclusions:

#### What could happen if someone stole a private key?

If attackers would have your certificate and provisioning profile, they could codesign an application with the same bundle identifier.

What's the worst that could happen for each of the profile types?

##### App Store Profiles

An App Store profile can't be used for anything as long as it's not re-signed by Apple. The only way to get an app resigned is to submit an app for review (which takes around 7 days). Attackers could only submit an app for review, if they also got access to your iTunes Connect credentials (which are not stored in git, but in your local keychain). Additionally you get an email notification every time a build gets uploaded to cancel the submission even before your app gets into the review stage.

##### Development and Ad Hoc Profiles

In general those profiles are harmless as they can only be used to install a signed application on a small subset of devices. To add new devices, the attacker would also need your Apple Developer Portal credentials (which are not stored in git, but in your local keychain).

##### Enterprise Profiles

Attackers could use an In-House profile to distribute signed application to a potentially unlimited number of devices. All this would run under your company name and it could eventually lead to Apple revoking your In-House account. However it is very easy to revoke a certificate to remotely break the app on all devices.

Because of the potentially dangerous nature of In-House profiles we decided to not allow the use of `match` with enterprise accounts.

##### To sum up

- 你对你的repo有完全的控制权，没有第三方介入
- 即使证书泄露，没有iTunes Connect密码的人也不能对你造成损害
- `match`目前不支持Enterprise版的Apple开发者账户（就是那种做了app只能公司内部使用，不能发布到App Store，我们的fastspider2017@gmail.com就是这种）
- 如果你使用GitHub或Bitbucket，我们建议开启所有有权限访问证书仓库的账号的两步验证
- `match`完全开源，所有的代码都在[GitHub](https://github.com/fastlane/fastlane/tree/master/match)

## [`fastlane`](https://fastlane.tools) Toolchain

- [`fastlane`](https://fastlane.tools): Connect all deployment tools into one streamlined workflow
- [`deliver`](https://github.com/fastlane/fastlane/tree/master/deliver): Upload screenshots, metadata and your app to the App Store
- [`snapshot`](https://github.com/fastlane/fastlane/tree/master/snapshot): Automate taking localized screenshots of your iOS app on every device
- [`frameit`](https://github.com/fastlane/fastlane/tree/master/frameit): Quickly put your screenshots into the right device frames
- [`pem`](https://github.com/fastlane/fastlane/tree/master/pem): Automatically generate and renew your push notification profiles
- [`produce`](https://github.com/fastlane/fastlane/tree/master/produce): Create new iOS apps on iTunes Connect and Dev Portal using the command line
- [`cert`](https://github.com/fastlane/fastlane/tree/master/cert): Automatically create and maintain iOS code signing certificates
- [`spaceship`](https://github.com/fastlane/fastlane/tree/master/spaceship): Ruby library to access the Apple Dev Center and iTunes Connect
- [`pilot`](https://github.com/fastlane/fastlane/tree/master/pilot): The best way to manage your TestFlight testers and builds from your terminal
- [`boarding`](https://github.com/fastlane/boarding): The easiest way to invite your TestFlight beta testers
- [`gym`](https://github.com/fastlane/fastlane/tree/master/gym): Building your iOS apps has never been easier
- [`scan`](https://github.com/fastlane/fastlane/tree/master/scan): The easiest way to run tests of your iOS and Mac app

# Need help?
Please submit an issue on GitHub and provide information about your setup

# Code of Conduct
Help us keep `match` open and inclusive. Please read and follow our [Code of Conduct](https://github.com/fastlane/fastlane/blob/master/CODE_OF_CONDUCT.md).

# License
This project is licensed under the terms of the MIT license. See the LICENSE file.

> This project and all fastlane tools are in no way affiliated with Apple Inc. This project is open source under the MIT license, which means you have full access to the source code and can modify it to fit your own needs. All fastlane tools run on your own computer or server, so your credentials or other sensitive information will never leave your own computer. You are responsible for how you use fastlane tools.
