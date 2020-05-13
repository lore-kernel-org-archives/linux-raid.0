From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH] Use more secure HTTPS URLs
Date: Wed, 13 May 2020 15:27:07 +0200
Message-ID: <20200513132707.16744-1-pmenzel@molgen.mpg.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@gmail.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All URLs in the source are available over HTTPS, so convert all URLs to
HTTPS with the command below.

    git grep -l 'http://' | xargs sed -i 's,http://,https://,g'

Cc: linux-raid@vger.kernel.org
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 ANNOUNCE-3.0                     | 4 ++--
 ANNOUNCE-3.0.1                   | 4 ++--
 ANNOUNCE-3.0.2                   | 4 ++--
 ANNOUNCE-3.0.3                   | 4 ++--
 ANNOUNCE-3.1                     | 4 ++--
 ANNOUNCE-3.1.1                   | 4 ++--
 ANNOUNCE-3.1.2                   | 4 ++--
 ANNOUNCE-3.1.3                   | 4 ++--
 ANNOUNCE-3.1.4                   | 4 ++--
 ANNOUNCE-3.1.5                   | 4 ++--
 ANNOUNCE-3.2                     | 4 ++--
 ANNOUNCE-3.2.1                   | 4 ++--
 ANNOUNCE-3.2.2                   | 4 ++--
 ANNOUNCE-3.2.3                   | 4 ++--
 ANNOUNCE-3.2.4                   | 4 ++--
 ANNOUNCE-3.2.5                   | 4 ++--
 ANNOUNCE-3.2.6                   | 4 ++--
 ANNOUNCE-3.3                     | 4 ++--
 ANNOUNCE-3.3.1                   | 4 ++--
 ANNOUNCE-3.3.2                   | 4 ++--
 ANNOUNCE-3.3.3                   | 4 ++--
 ANNOUNCE-3.3.4                   | 4 ++--
 ANNOUNCE-3.4                     | 4 ++--
 ANNOUNCE-4.0                     | 4 ++--
 ANNOUNCE-4.1                     | 4 ++--
 external-reshape-design.txt      | 2 +-
 mdadm.8.in                       | 6 +++---
 mdadm.spec                       | 4 ++--
 raid6check.8                     | 2 +-
 restripe.c                       | 2 +-
 udev-md-raid-safe-timeouts.rules | 2 +-
 31 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/ANNOUNCE-3.0 b/ANNOUNCE-3.0
index f2d4f84..05da863 100644
--- a/ANNOUNCE-3.0
+++ b/ANNOUNCE-3.0
@@ -5,10 +5,10 @@ I am pleased to (finally) announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 
 This is a major new version and as such should be treated with some
diff --git a/ANNOUNCE-3.0.1 b/ANNOUNCE-3.0.1
index 91b4428..9f0f39c 100644
--- a/ANNOUNCE-3.0.1
+++ b/ANNOUNCE-3.0.1
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 
 This contains only minor bug fixes over 3.0.  If you are using
diff --git a/ANNOUNCE-3.0.2 b/ANNOUNCE-3.0.2
index 93643d1..5a4198c 100644
--- a/ANNOUNCE-3.0.2
+++ b/ANNOUNCE-3.0.2
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 
 This just contains one bugfix over 3.0.1 - I was obviously a bit hasty
diff --git a/ANNOUNCE-3.0.3 b/ANNOUNCE-3.0.3
index d6117a1..1906f4b 100644
--- a/ANNOUNCE-3.0.3
+++ b/ANNOUNCE-3.0.3
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 
 This contains a collection of bug fixes and minor enhancements over
diff --git a/ANNOUNCE-3.1 b/ANNOUNCE-3.1
index 343b85d..af9c53c 100644
--- a/ANNOUNCE-3.1
+++ b/ANNOUNCE-3.1
@@ -5,10 +5,10 @@ Hot on the heals of 3.0.3 I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 
 It contains significant feature enhancements over 3.0.x
diff --git a/ANNOUNCE-3.1.1 b/ANNOUNCE-3.1.1
index 9e480dc..cea345e 100644
--- a/ANNOUNCE-3.1.1
+++ b/ANNOUNCE-3.1.1
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 This is a bugfix release over 3.1, which was withdrawn due to serious
 bugs.  So it might be best to ignore 3.1 and say that this is a significant
diff --git a/ANNOUNCE-3.1.2 b/ANNOUNCE-3.1.2
index 321b8be..a46c4de 100644
--- a/ANNOUNCE-3.1.2
+++ b/ANNOUNCE-3.1.2
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 This is a bugfix/stability release over 3.1.1.
 
diff --git a/ANNOUNCE-3.1.3 b/ANNOUNCE-3.1.3
index 95b2b6c..b4ea4d4 100644
--- a/ANNOUNCE-3.1.3
+++ b/ANNOUNCE-3.1.3
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 This is a bugfix/stability release over 3.1.2
 
diff --git a/ANNOUNCE-3.1.4 b/ANNOUNCE-3.1.4
index c157a36..6d4811b 100644
--- a/ANNOUNCE-3.1.4
+++ b/ANNOUNCE-3.1.4
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 This is a bugfix/stability release over 3.1.3.
 3.1.3 had a couple of embarrasing regressions and a couple of other
diff --git a/ANNOUNCE-3.1.5 b/ANNOUNCE-3.1.5
index baa1f92..3e1aac0 100644
--- a/ANNOUNCE-3.1.5
+++ b/ANNOUNCE-3.1.5
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 This is a bugfix/stability release over 3.1.4.  It contains all the
 important bugfixes found while working on 3.2 and 3.2.1.  It will be
diff --git a/ANNOUNCE-3.2 b/ANNOUNCE-3.2
index 9e282bc..27187d1 100644
--- a/ANNOUNCE-3.2
+++ b/ANNOUNCE-3.2
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm devel-3.2
-   http://neil.brown.name/git?p=mdadm
+   https://neil.brown.name/git?p=mdadm
 
 This is a "Developers only" release.  Please don't consider using it
 or making it available to others without reading the following.
diff --git a/ANNOUNCE-3.2.1 b/ANNOUNCE-3.2.1
index 0e7826c..3b5f2a3 100644
--- a/ANNOUNCE-3.2.1
+++ b/ANNOUNCE-3.2.1
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
+   https://neil.brown.name/git/mdadm
 
 Many of the changes in this release are of internal interest only,
 restructuring and refactoring code and so forth.
diff --git a/ANNOUNCE-3.2.2 b/ANNOUNCE-3.2.2
index b70d18b..4d44dd2 100644
--- a/ANNOUNCE-3.2.2
+++ b/ANNOUNCE-3.2.2
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
+   https://neil.brown.name/git/mdadm
 
 This release is largely a stablising release for the 3.2 series.
 Many of the changes just fix bugs introduces in 3.2 or 3.2.1.
diff --git a/ANNOUNCE-3.2.3 b/ANNOUNCE-3.2.3
index 8a8dba4..6549a5f 100644
--- a/ANNOUNCE-3.2.3
+++ b/ANNOUNCE-3.2.3
@@ -5,10 +5,10 @@ I am pleased to announce the availability of
 
 It is available at the usual places:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
+   https://neil.brown.name/git/mdadm
 
 This release is largely a bugfix release for the 3.2 series with many
 minor fixes with little or no impact.
diff --git a/ANNOUNCE-3.2.4 b/ANNOUNCE-3.2.4
index e321678..cf964c6 100644
--- a/ANNOUNCE-3.2.4
+++ b/ANNOUNCE-3.2.4
@@ -5,11 +5,11 @@ I am pleased to announce the availability of
 
 It is available at the usual places, now including github:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://github.com/neilbrown/mdadm
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
+   https://neil.brown.name/git/mdadm
 
 This release is largely a bugfix release for the 3.2 series with many
 minor fixes with little or no impact.
diff --git a/ANNOUNCE-3.2.5 b/ANNOUNCE-3.2.5
index 396da12..9b86bbf 100644
--- a/ANNOUNCE-3.2.5
+++ b/ANNOUNCE-3.2.5
@@ -5,11 +5,11 @@ I am somewhat disappointed to have to announce the availability of
 
 It is available at the usual places, now including github:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://github.com/neilbrown/mdadm
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
+   https://neil.brown.name/git/mdadm
 
 This release primarily fixes a serious regression in 3.2.4.
 This regression does *not* cause any risk to data.  It simply
diff --git a/ANNOUNCE-3.2.6 b/ANNOUNCE-3.2.6
index f5cfd49..dffe22e 100644
--- a/ANNOUNCE-3.2.6
+++ b/ANNOUNCE-3.2.6
@@ -5,11 +5,11 @@ I am pleased to announce the availability of
 
 It is available at the usual places, now including github:
    countrycode=xx.
-   http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://github.com/neilbrown/mdadm
    git://neil.brown.name/mdadm
-   http://neil.brown.name/git/mdadm
+   https://neil.brown.name/git/mdadm
 
 This is a stablity release which adds a number of bugfixs to 3.2.5.
 There are no real stand-out fixes, just lots of little bits and pieces.
diff --git a/ANNOUNCE-3.3 b/ANNOUNCE-3.3
index f770aa1..c533453 100644
--- a/ANNOUNCE-3.3
+++ b/ANNOUNCE-3.3
@@ -4,11 +4,11 @@ I am pleased to announce the availability of
    mdadm version 3.3
 
 It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://github.com/neilbrown/mdadm
    git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm
+   https://git.neil.brown.name/git/mdadm
 
 This is a major new release so don't be too surprised if there are a
 few issues.  If I hear about them they will be fixed in 3.3.1.
diff --git a/ANNOUNCE-3.3.1 b/ANNOUNCE-3.3.1
index 7d5e666..fadcd74 100644
--- a/ANNOUNCE-3.3.1
+++ b/ANNOUNCE-3.3.1
@@ -4,11 +4,11 @@ I am pleased to announce the availability of
    mdadm version 3.3.1
 
 It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://github.com/neilbrown/mdadm
    git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm.git
+   https://git.neil.brown.name/git/mdadm.git
 
 The main changes are:
  - lots of work on "DDF" support.  Hopefully it will be more stable
diff --git a/ANNOUNCE-3.3.2 b/ANNOUNCE-3.3.2
index 6b54961..6fe96f4 100644
--- a/ANNOUNCE-3.3.2
+++ b/ANNOUNCE-3.3.2
@@ -4,11 +4,11 @@ I am pleased to announce the availability of
    mdadm version 3.3.2
 
 It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://github.com/neilbrown/mdadm
    git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm.git
+   https://git.neil.brown.name/git/mdadm.git
 
 Changes since 3.3.1 are mostly little bugfixes and some man-page
 updates.
diff --git a/ANNOUNCE-3.3.3 b/ANNOUNCE-3.3.3
index ac1b217..135be29 100644
--- a/ANNOUNCE-3.3.3
+++ b/ANNOUNCE-3.3.3
@@ -4,11 +4,11 @@ I am pleased to announce the availability of
    mdadm version 3.3.3
 
 It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://github.com/neilbrown/mdadm
    git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm.git
+   https://git.neil.brown.name/git/mdadm.git
 
 The 100 changes since 3.3.3 are mostly little bugfixes and some improvements
 to the selftests.
diff --git a/ANNOUNCE-3.3.4 b/ANNOUNCE-3.3.4
index 52b9456..910d2a8 100644
--- a/ANNOUNCE-3.3.4
+++ b/ANNOUNCE-3.3.4
@@ -4,11 +4,11 @@ I am somewhat disappointed to have to announce the availability of
    mdadm version 3.3.4
 
 It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://github.com/neilbrown/mdadm
    git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm.git
+   https://git.neil.brown.name/git/mdadm.git
 
 In mdadm-3.3 a change was made to how IMSM (Intel Matrix Storage
 Manager) metadata was handled.  Previously an IMSM array would only
diff --git a/ANNOUNCE-3.4 b/ANNOUNCE-3.4
index 2689732..f707fa1 100644
--- a/ANNOUNCE-3.4
+++ b/ANNOUNCE-3.4
@@ -4,11 +4,11 @@ I am pleased to announce the availability of
    mdadm version 3.4
 
 It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://github.com/neilbrown/mdadm
    git://neil.brown.name/mdadm
-   http://git.neil.brown.name/git/mdadm
+   https://git.neil.brown.name/git/mdadm
 
 The new second-level version number reflects significant new
 functionality, particular support for journalled RAID5/6 and clustered
diff --git a/ANNOUNCE-4.0 b/ANNOUNCE-4.0
index f79c540..91aaad9 100644
--- a/ANNOUNCE-4.0
+++ b/ANNOUNCE-4.0
@@ -4,10 +4,10 @@ I am pleased to announce the availability of
    mdadm version 4.0
 
 It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
-   http://git.kernel.org/cgit/utils/mdadm/
+   https://git.kernel.org/cgit/utils/mdadm/
 
 The update in major version number primarily indicates this is a
 release by it's new maintainer. In addition it contains a large number
diff --git a/ANNOUNCE-4.1 b/ANNOUNCE-4.1
index a273b9a..2961e43 100644
--- a/ANNOUNCE-4.1
+++ b/ANNOUNCE-4.1
@@ -4,10 +4,10 @@ I am pleased to announce the availability of
    mdadm version 4.1
 
 It is available at the usual places:
-   http://www.kernel.org/pub/linux/utils/raid/mdadm/
+   https://www.kernel.org/pub/linux/utils/raid/mdadm/
 and via git at
    git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
-   http://git.kernel.org/cgit/utils/mdadm/
+   https://git.kernel.org/cgit/utils/mdadm/
 
 The update constitutes more than one year of enhancements and bug fixes
 including for IMSM RAID, Partial Parity Log, clustered RAID support,
diff --git a/external-reshape-design.txt b/external-reshape-design.txt
index 10c57cc..e4cf4e1 100644
--- a/external-reshape-design.txt
+++ b/external-reshape-design.txt
@@ -277,4 +277,4 @@ sync_action
 
 ...
 
-[1]: Linux kernel design patterns - part 3, Neil Brown http://lwn.net/Articles/336262/
+[1]: Linux kernel design patterns - part 3, Neil Brown https://lwn.net/Articles/336262/
diff --git a/mdadm.8.in b/mdadm.8.in
index a3494a1..10c9e32 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -367,7 +367,7 @@ Use the Intel(R) Matrix Storage Manager metadata format.  This creates a
 which is managed in a similar manner to DDF, and is supported by an
 option-rom on some platforms:
 .IP
-.B http://www.intel.com/design/chipsets/matrixstorage_sb.htm
+.B https://www.intel.com/design/chipsets/matrixstorage_sb.htm
 .PP
 .RE
 
@@ -3407,7 +3407,7 @@ was previously known as
 For further information on mdadm usage, MD and the various levels of
 RAID, see:
 .IP
-.B http://raid.wiki.kernel.org/
+.B https://raid.wiki.kernel.org/
 .PP
 (based upon Jakob \(/Ostergaard's Software\-RAID.HOWTO)
 .PP
@@ -3415,7 +3415,7 @@ The latest version of
 .I mdadm
 should always be available from
 .IP
-.B http://www.kernel.org/pub/linux/utils/raid/mdadm/
+.B https://www.kernel.org/pub/linux/utils/raid/mdadm/
 .PP
 Related man pages:
 .PP
diff --git a/mdadm.spec b/mdadm.spec
index 1c66894..506ea33 100644
--- a/mdadm.spec
+++ b/mdadm.spec
@@ -2,8 +2,8 @@ Summary:     mdadm is used for controlling Linux md devices (aka RAID arrays)
 Name:        mdadm
 Version:     4.1
 Release:     1
-Source:      http://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-%{version}.tar.gz
-URL:         http://neil.brown.name/blog/mdadm
+Source:      https://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-%{version}.tar.gz
+URL:         https://neil.brown.name/blog/mdadm
 License:     GPL
 Group:       Utilities/System
 BuildRoot:   %{_tmppath}/%{name}-root
diff --git a/raid6check.8 b/raid6check.8
index 5003343..8999ca8 100644
--- a/raid6check.8
+++ b/raid6check.8
@@ -86,7 +86,7 @@ The latest version of
 .I raid6check
 should always be available from
 .IP
-.B http://www.kernel.org/pub/linux/utils/raid/mdadm/
+.B https://www.kernel.org/pub/linux/utils/raid/mdadm/
 .PP
 Related man pages:
 .PP
diff --git a/restripe.c b/restripe.c
index 31b07e8..2aecdb8 100644
--- a/restripe.c
+++ b/restripe.c
@@ -333,7 +333,7 @@ void make_tables(void)
 
 	/* Compute log and inverse log */
 	/* Modified code from:
-	 *    http://web.eecs.utk.edu/~plank/plank/papers/CS-96-332.html
+	 *    https://web.eecs.utk.edu/~plank/plank/papers/CS-96-332.html
 	 */
 	b = 1;
 	raid6_gflog[0] = 0;
diff --git a/udev-md-raid-safe-timeouts.rules b/udev-md-raid-safe-timeouts.rules
index 13c23d8..12bdcaa 100644
--- a/udev-md-raid-safe-timeouts.rules
+++ b/udev-md-raid-safe-timeouts.rules
@@ -13,7 +13,7 @@
 #
 # You should have received a copy of the GNU General Public License
 # along with mdraid-safe-timeouts.  If not, see
-# <http://www.gnu.org/licenses/>.
+# <https://www.gnu.org/licenses/>.
 
 # This file causes block devices with Linux RAID (mdadm) signatures to
 # attempt to set safe timeouts for the drives involved
-- 
2.26.2
