From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 2/2] Revert "Restore force switch of md array to readonly at
	reboot time."
Date: Thu, 08 Jan 2009 00:24:43 -0700
Message-ID: <20090108072443.9577.10920.stgit@dwillia2-linux.ch.intel.com>
References: <20090108072023.9577.3585.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090108072023.9577.3585.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This reverts commit 2b25000bf5157c28d8591f03f0575248a8cbd900.

Justin provided a test case that can reliably trigger the md_write_start
BUG_ON(mddev->ro == 1) at shutdown time.  Kernels prior to 2.6.27 do not fail
this test because the array remains readwrite.  The block layer does not
quiesce in-flight writes after setting the readonly flag so there will need to
be new infrastructure (stop writes at shutdown), or support for barriers
before MD arrays can reliably force readonly while writes may be in flight.

Reported-by: Justin Maggard <jmaggard10@gmail.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/md.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7ac2b56..d3640b8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6281,11 +6281,7 @@ static int md_notify_reboot(struct notifier_block *this,
 
 		for_each_mddev(mddev, tmp)
 			if (mddev_trylock(mddev)) {
-				/* Force a switch to readonly even array
-				 * appears to still be in use.  Hence
-				 * the '100'.
-				 */
-				do_md_stop(mddev, 1, 100);
+				do_md_stop(mddev, 1, 0);
 				mddev_unlock(mddev);
 			}
 		/*

