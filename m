From: Mike Tran <mhtran@us.ibm.com>
Subject: [PATCH] 2.4.25 raid1 : correct nr of spares after I/O errors
Date: 17 Mar 2004 16:44:04 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1079563444.9564.4.camel@star2.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>, evms-devel <evms-devel@lists.sourceforge.net>
Cc: Neil Brown <neilb@cse.unsw.edu.au>, Marcelo Tosatti <marcelo.tosatti@cyclades.com>
List-Id: linux-raid.ids

If the spare failed during a resync, the number of spares should be
decremented.

Regards,
Mike T.


--- a/drivers/md/raid1.c        2004-03-17 14:26:51.000000000 -0600
+++ b/drivers/md/raid1.c        2004-03-17 14:28:11.000000000 -0600
@@ -762,6 +762,10 @@
                sb->active_disks--;
        sb->working_disks--;
        sb->failed_disks++;
+       if (mirror->spare) {
+               sb->spare_disks--;
+               mirror->spare = 0;
+       }
        mddev->sb_dirty = 1;
        md_wakeup_thread(conf->thread);
        if (!mirror->write_only)


