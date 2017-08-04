From: NeilBrown <neilb@suse.com>
Subject: [PATCH 2/4] Use correct syntax for passing DEVLINKS to mdadm from
 udev
Date: Fri, 04 Aug 2017 15:30:02 +1000
Message-ID: <150182460221.25561.3743606766426534278.stgit@noble>
References: <150182450644.25561.9683614144764209335.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <150182450644.25561.9683614144764209335.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 ${DEVLINKS}
is not valid udev syntax, and is passed through uninterpreted.
 $env{DEVLINKS}
or
  %e{DEVLINKS}
is correct.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 mdadm.8.in                  |    2 +-
 udev-md-raid-assembly.rules |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index ecfe9da8d474..d8c2dfca6040 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2948,7 +2948,7 @@ This is the only context where the aliases are used.  They are
 usually provided by a
 .I udev
 rules mentioning
-.BR ${DEVLINKS} .
+.BR $env{DEVLINKS} .
 
 .IP +
 Does the device have a valid md superblock?  If a specific metadata
diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
index 8ca232a44b1f..9f055ed022d5 100644
--- a/udev-md-raid-assembly.rules
+++ b/udev-md-raid-assembly.rules
@@ -30,7 +30,7 @@ LABEL="md_inc"
 
 # remember you can limit what gets auto/incrementally assembled by
 # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
-ACTION=="add|change", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot ${DEVLINKS}"
+ACTION=="add|change", IMPORT{program}="BINDIR/mdadm --incremental --export $devnode --offroot $env{DEVLINKS}"
 ACTION=="add|change", ENV{MD_STARTED}=="*unsafe*", ENV{MD_FOREIGN}=="no", ENV{SYSTEMD_WANTS}+="mdadm-last-resort@$env{MD_DEVICE}.timer"
 ACTION=="remove", ENV{ID_PATH}=="?*", RUN+="BINDIR/mdadm -If $name --path $env{ID_PATH}"
 ACTION=="remove", ENV{ID_PATH}!="?*", RUN+="BINDIR/mdadm -If $name"


