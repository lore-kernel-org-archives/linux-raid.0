From: Xiao Ni <xni@redhat.com>
Subject: [PATCH] Recovery speed is wrong
Date: Thu, 7 Aug 2014 09:37:41 -0400 (EDT)
Message-ID: <1135772294.19428712.1407418661354.JavaMail.zimbra@redhat.com>
References: <1888683818.19423710.1407418230213.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1888683818.19423710.1407418230213.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

   When we calculate the speed of recovery, the numerator that contains the recovery done sectors.
It's need to subtract the sectors which don't finish recovery.


Signed-off-by: Xiao Ni <xni@redhat.com>

diff -urN linux-stable/drivers/md/md.c fix/md.c
--- linux-stable/drivers/md/md.c 2014-07-30 14:36:37.327535805 +0800
+++ fix/md.c   2014-08-07 16:07:12.559503942 +0800
@@ -7376,7 +7376,7 @@
   struct mddev *mddev2;
   unsigned int currspeed = 0,
       window;
-  sector_t max_sectors,j, io_sectors;
+  sector_t max_sectors,j, io_sectors, recovery_done;
   unsigned long mark[SYNC_MARKS];
   unsigned long update_time;
   sector_t mark_cnt[SYNC_MARKS];
@@ -7652,7 +7652,8 @@
       */  
      cond_resched();
 
-     currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
+     recovery_done = io_sectors - atomic_read(&mddev->recovery_active);
+     currspeed = ((unsigned long)recovery_done - mddev->resync_mark_cnt)/2
         /((jiffies-mddev->resync_mark)/HZ +1) +1;
 
      if (currspeed > speed_min(mddev)) {
