From: kbuild test robot <fengguang.wu@intel.com>
Subject: [md:for-linus 7/8] drivers/md/md.c:5297:6: sparse: symbol
 '__md_stop' was not declared. Should it be static?
Date: Tue, 20 Nov 2012 16:25:21 +0800
Message-ID: <50ab3e71.l5WJWEVMFL2rb1jK%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_50ab3e71.9V1whCiage2HvyF7DNRaUVMjAU7QRJI60fGuqiHZAyYLIoFB"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

--=_50ab3e71.9V1whCiage2HvyF7DNRaUVMjAU7QRJI60fGuqiHZAyYLIoFB
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

tree:   git://neil.brown.name/md for-linus
head:   879d63a5d4cc36ff804a9cf0de2c092dd538fa45
commit: fceef26b94e8507f33e28741f755c010de052042 [7/8] md: make sure everything is freed when dm-raid stops an array.


sparse warnings:

drivers/md/md.c:1553:34: sparse: cast to restricted __le64
drivers/md/md.c:1823:40: sparse: incorrect type in assignment (different base types)
drivers/md/md.c:1823:40:    expected unsigned long long [unsigned] [long] [long long] [usertype] <noident>
drivers/md/md.c:1823:40:    got restricted __le64 [usertype] <noident>
drivers/md/md.c:1898:26: sparse: incorrect type in assignment (different base types)
drivers/md/md.c:1898:26:    expected restricted __le64 [usertype] super_offset
drivers/md/md.c:1898:26:    got unsigned long long [unsigned] [usertype] sb_start
+ drivers/md/md.c:5297:6: sparse: symbol '__md_stop' was not declared. Should it be static?

Please consider folding the attached diff :-)

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation

--=_50ab3e71.9V1whCiage2HvyF7DNRaUVMjAU7QRJI60fGuqiHZAyYLIoFB
Content-Type: text/x-diff;
 charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="make-it-static-fceef26.diff"

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a8cf4be..6120071 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5294,7 +5294,7 @@ void md_stop_writes(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_stop_writes);
 
-void __md_stop(struct mddev *mddev)
+static void __md_stop(struct mddev *mddev)
 {
 	mddev->ready = 0;
 	mddev->pers->stop(mddev);

--=_50ab3e71.9V1whCiage2HvyF7DNRaUVMjAU7QRJI60fGuqiHZAyYLIoFB--
