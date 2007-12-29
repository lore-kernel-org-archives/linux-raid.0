From: "Dan Williams" <dan.j.williams@intel.com>
Subject: mdadm: unable to add a disk to degraded raid1 array
Date: Sat, 29 Dec 2007 02:35:58 -0700
Message-ID: <e9c3a7c20712290135m165be59fo55cf1b728ad1657d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In case someone else happens upon this I have found that mdadm >=
v2.6.2 cannot add a disk to a degraded raid1 array created with mdadm
< 2.6.2.

I bisected the problem down to mdadm git commit
2fb749d1b7588985b1834e43de4ec5685d0b8d26 which appears to make an
incompatible change to the super block's 'data_size' field.

--- sdb1-sb-good.hex    2007-12-12 14:31:42.000000000 +0000
+++ sdb1-sb-bad.hex     2007-12-12 14:31:36.000000000 +0000
@@ -6,12 +6,12 @@
 0000050 60d8 0077 0000 0000 0000 0000 0004 0000
 0000060 0000 0000 0000 0000 0000 0000 0000 0000
 *
-0000080 0000 0000 0000 0000 60d8 0077 0000 0000
+0000080 0000 0000 0000 0000 60d0 0077 0000 0000

Which trips up the "if (rdev->size < le64_to_cpu(sb->data_size)/2)"
check in super_1_load [1], resulting in:

        mdadm: add new device failed for /dev/sdb1 as 4: Invalid argument

--
Dan

[1] http://lxr.linux.no/linux/drivers/md/md.c#L1148
