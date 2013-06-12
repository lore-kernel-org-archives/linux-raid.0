From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 12 Jun 2013 07:45:16 -0700
Message-ID: <51B8897C.8000801@zytor.com>
References: <51AC1440.7020505@zytor.com> <51ACBAA0.40604@zytor.com> <CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com> <51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net> <CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com> <yq1d2s1rcb7.fsf@sermon.lab.mkp.net> <51AE2A8C.4080508@zytor.com> <yq18v2prbum.fsf@sermon.lab.mkp.net> <CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com> <51AE3441.3000208@zytor.com> <CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com> <51AEA4FE.3060900@zytor.com> <yq1mwr4pd9f.fsf@sermon.lab.mkp.net> <20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com> <yq1bo7ioe6e.fsf@sermon.lab.mkp.net> <20130610101505.33b32d07@jlaw-desktop.mno.stratus.com> <20130612131543.1c79e077@notabene.brown> <51B
 7F41F.9000605@zytor.com> <yq17ghzjti4.fsf@sermon.lab.mkp.net> <51B885B8.9040600@zytor.com> <yq1txl3iejr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020601050000050409020302"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1txl3iejr.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: NeilBrown <neilb@suse.de>, Joe Lawrence <joe.lawrence@stratus.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020601050000050409020302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 06/12/2013 07:34 AM, Martin K. Petersen wrote:
>>>>>> "hpa" == H Peter Anvin <hpa@zytor.com> writes:
> 
> hpa> The second question is if we should disable WRITE SAME for raid1/10
> hpa> (what about raid0?) for 3.10/stable or if your patch really is
> hpa> sufficient... "just adds another heuristic" makes me nervous.
> 
> I think we should disable 1+10 in stable until we get the recovery
> scenario sorted out.
> 
> I don't believe there are any problems with raid0.
> 

How does this look?

	-hpa


--------------020601050000050409020302
Content-Type: text/x-patch;
 name="0001-raid1-10-Disable-WRITE-SAME-until-a-recovery-strateg.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-raid1-10-Disable-WRITE-SAME-until-a-recovery-strateg.pa";
 filename*1="tch"

From ac28be1574a6187f4f26bd75217059bf17b13560 Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 12 Jun 2013 07:37:43 -0700
Subject: [PATCH] raid1,10: Disable WRITE SAME until a recovery strategy is in
 place

There are cases where the kernel will believe that the WRITE SAME
command is supported by a block device which does not, in fact,
support WRITE SAME.  This currently happens for SATA drivers behind a
SAS controller, but there are probably a hundred other ways that can
happen, including drive firmware bugs.

After receiving an error for WRITE SAME the block layer will retry the
request as a plain write of zeroes, but mdraid will consider the
failure as fatal and consider the drive failed.  This has the effect
that all the mirrors containing a specific set of data are each
offlined in very rapid succession resulting in data loss.

However, just bouncing the request back up to the block layer isn't
ideal either, because the whole initial request-retry sequence should
be inside the write bitmap fence, which probably means that md needs
to do its own conversion of WRITE SAME to write zero.

Until the failure scenario has been sorted out, disable WRITE SAME for
raid1 and raid10.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/md/raid1.c  | 4 ++--
 drivers/md/raid10.c | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 5595118..914ca0a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2780,8 +2780,8 @@ static int run(struct mddev *mddev)
 		return PTR_ERR(conf);
 
 	if (mddev->queue)
-		blk_queue_max_write_same_sectors(mddev->queue,
-						 mddev->chunk_sectors);
+		blk_queue_max_write_same_sectors(mddev->queue, 0);
+
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
 			continue;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 59d4daa..807ace8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3609,8 +3609,7 @@ static int run(struct mddev *mddev)
 	if (mddev->queue) {
 		blk_queue_max_discard_sectors(mddev->queue,
 					      mddev->chunk_sectors);
-		blk_queue_max_write_same_sectors(mddev->queue,
-						 mddev->chunk_sectors);
+		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, chunk_size);
 		if (conf->geo.raid_disks % conf->geo.near_copies)
 			blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
-- 
1.7.11.7


--------------020601050000050409020302--
