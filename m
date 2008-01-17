From: Jiri Slaby <jirislaby@gmail.com>
Subject: do_md_run returned -22 [Was: 2.6.24-rc8-mm1]
Date: Thu, 17 Jan 2008 16:23:30 +0100
Message-ID: <478F72F2.6000707@gmail.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Torsten Kaiser <just.for.lkml@googlemail.com>, NeilBrown <neilb@suse.de>, mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/17/2008 11:35 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/

still the same md issue (do_md_run returns -22=EINVAL) as in -rc6-mm1 reported 
by Thorsten here:
http://lkml.org/lkml/2007/12/27/45

Is there around any fix for this?

Having 0.90 raid 0 and 1, commenting this out helps:
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8633bd4..9b8ecc8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3292,8 +3292,8 @@ static int do_md_run(mddev_t * mddev)
          * Analyze all RAID superblock(s)
          */
         if (!mddev->raid_disks) {
-               if (!mddev->persistent)
-                       return -EINVAL;
+/*             if (!mddev->persistent)
+                       return -EINVAL;*/
                 analyze_sbs(mddev);
         }

The persistency is marked even in analyze_sbs->validate_super, I guess?
