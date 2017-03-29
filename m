From: jes.sorensen@gmail.com
Subject: Grow set size issue
Date: Wed, 29 Mar 2017 13:50:08 -0400
Message-ID: <wrfjlgrodlbj.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

In the below patch you changed the error handling, to make the kernel
not setting the size of the device being an error. However we still have
the code in place to handle the error, except it never triggers.

Question is do you remember the reason for this change? Old kernels not
allowing it, are there any legitimate reasons for the kernel to refuse
the size change?

Cheers,
Jes

commit b0a658ffbcd2104594e8a7a185fa0fe05127723e
Author: NeilBrown <neilb@suse.de>
Date:   Thu May 3 16:18:22 2012 +1000

    Grow: failing the set the per-device size is not an error.
    
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Grow.c b/Grow.c
index 0b0d718..330e719 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1668,7 +1668,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
                rv = 0;
                for (mdi = sra->devs; mdi; mdi = mdi->next) {
                        if (sysfs_set_num(sra, mdi, "size", size) < 0) {
-                               rv = 1;
+                               /* Probably kernel refusing to let us
+                                * reduce the size - not an error.
+                                */
                                break;
                        }
                        if (array.not_persistent == 0 &&
