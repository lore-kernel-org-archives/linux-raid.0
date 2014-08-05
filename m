From: Xiao Ni <xni@redhat.com>
Subject: One patch just review the code
Date: Tue, 5 Aug 2014 03:12:07 -0400 (EDT)
Message-ID: <1122994629.17915693.1407222727992.JavaMail.zimbra@redhat.com>
References: <705044700.17914512.1407222497904.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <705044700.17914512.1407222497904.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes Sorensen <jes.sorensen@redhat.com>
List-Id: linux-raid.ids

Hi all

   I'm reading the code of md. I find there is a problem. I know now there are arrays mark[SYNC_MARKS] mark_cnt[SYNC_MARKS] 
store the information about how many sectors finish recovery and the moment.


7825       currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
7826          /((jiffies-mddev->resync_mark)/HZ +1) +1;
  
   But when calculate the speed of recovery, the sectors used to calculate contains
the sectors which are not finished recovery.

   When assign value to mark_cnt[next], it subtract the sectors which don't finish recovery.
So I think when calculate the recovery speed we should subtract the sectors not finishing
recovery too.

7638          mark_cnt[next] = io_sectors - atomic_read(&mddev->recovery_active);

   So I try to modify and the patch is:

--- linux-stable/drivers/md/md.c 2014-07-30 14:36:37.327535805 +0800
+++ fix/md.c   2014-07-31 16:40:57.151493177 +0800
@@ -7652,7 +7652,7 @@
       */  
      cond_resched();
 
-     currspeed = ((unsigned long)(io_sectors-mddev->resync_mark_cnt))/2
+     currspeed = ((unsigned long)(io_sectors-atomic_read(&mddev->recovery_active)-mddev->resync_mark_cnt))/2
         /((jiffies-mddev->resync_mark)/HZ +1) +1;
 
      if (currspeed > speed_min(mddev)) {

   Am I right?

Best Regards
Xiao
