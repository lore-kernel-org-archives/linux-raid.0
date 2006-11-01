From: Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 28/61] md: Fix bug where spares dont always get rebuilt properly when they become live.
Date: Tue, 31 Oct 2006 21:34:08 -0800
Message-ID: <20061101054004.729703000@sous-sol.org>
References: <20061101053340.305569000@sous-sol.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-fix-bug-where-spares-don-t-always-get-rebuilt-properly-when-they-become-live.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Andrew Morton <akpm@osdl.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, torvalds@osdl.org, alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
List-Id: linux-raid.ids

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

If save_raid_disk is >= 0, then the device could be a device that is 
already in sync that is being re-added.  So we need to default this
value to -1.


Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/md/md.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.18.1.orig/drivers/md/md.c
+++ linux-2.6.18.1/drivers/md/md.c
@@ -1994,6 +1994,7 @@ static mdk_rdev_t *md_import_device(dev_
 	kobject_init(&rdev->kobj);
 
 	rdev->desc_nr = -1;
+	rdev->saved_raid_disk = -1;
 	rdev->flags = 0;
 	rdev->data_offset = 0;
 	rdev->sb_events = 0;

--
