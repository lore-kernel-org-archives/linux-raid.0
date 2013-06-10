From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID-10 keeps aborting
Date: Mon, 10 Jun 2013 10:15:05 -0400
Message-ID: <20130610101505.33b32d07@jlaw-desktop.mno.stratus.com>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com>
	<yq1y5art543.fsf@sermon.lab.mkp.net>
	<CAA9_cmcoOYcFsJuuuJfC4aOUQxJ+6B_Z350HL70TXwYHF4_qGQ@mail.gmail.com>
	<yq1d2s1rcb7.fsf@sermon.lab.mkp.net>
	<51AE2A8C.4080508@zytor.com>
	<yq18v2prbum.fsf@sermon.lab.mkp.net>
	<CAA9_cmcBt3Mqt+iwrZFANoCef4YfopEPFbvYfEJgqFg8p7WtLQ@mail.gmail.com>
	<51AE3441.3000208@zytor.com>
	<CAA9_cmdSvThf_TRjtTSh3r6KOgF9RgzZ6GZPEeYoC2f_n_qz8A@mail.gmail.com>
	<51AEA4FE.3060900@zytor.com>
	<yq1mwr4pd9f.fsf@sermon.lab.mkp.net>
	<20130606142747.1fc17b7f@jlaw-desktop.mno.stratus.com>
	<yq1bo7ioe6e.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1bo7ioe6e.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

[Cc: Neil -- a few questions if you want to skip to the bottom ]

I looked a little more into the RAID1 case and tried a few things.
First, to enable WRITE SAME on RAID1, I had to apply the patch at the
bottom of this mail. With the patch in place, the component disk limits
propogate up to their MD:

  [2:0:4:0]    disk    SANBLAZE VLUN0001         0001  /dev/sds 
  [3:0:2:0]    disk    SEAGATE  ST9146853SS      0004  /dev/sdv

  /sys/class/scsi_disk/2:0:4:0/max_write_same_blocks: 65535
  /sys/class/scsi_disk/3:0:2:0/max_write_same_blocks: 65535
  /sys/block/md125/queue/write_same_max_bytes: 33553920

I was interested in observing how a failed WRITE SAME would interact
with MD, the intent bitmap, and resyncing. 

In my setup, I created a RAID1 out of a 4G partition from a SAS disk
(supporting WRITE SAME) and a SanBlaze VirtualLUN (claiming WRITE SAME
support, but returing [sense_key,asc,ascq]: [0x05,0x20,0x00] on the
first such command.)  I also added an external write intent bitmap file
chunk size of 4KB to create a large, granular bitmap:

  mdadm --create /dev/md125 --raid-devices=2 --level=1 \
        --bitmap=/mnt/bitmap/file --bitmap-chunk=4K /dev/sds1 /dev/sdv1

After creating the RAID and letting the initial synchronization finish,
I filled the entire MD with random data.  I would use this to verify
resync using the write intent bitmap later.

From previous tests, I knew that the first failed WRITE SAME to the
VirtualLUN would bounce that disk from the MD.  Current and subsequent
WRITE SAME cmds would process just fine to the member disk that actually
supported the command. 

To kick off WRITE SAME commands, I added a new ext4 filesystem to the
disk.  When mounting (no special options) this executes the following
call chain:

  ext4_lazyinit_thread
    ext4_init_inode_table
      sb_issue_zeroout
        blkdev_issue_zeroout
          blkdev_issue_write_same

When the first WRITE SAME hits the VirtualLUN, MD kicks it from the RAID
and degrades the array:

  EXT4-fs (md125): mounted filesystem with ordered data mode. Opts: (null)
  sd 2:0:6:0: [sds] CDB: 
  Write same(16): 93 00 00 00 00 00 00 00 21 10 00 00 0f f8 00 00
  mpt2sas0:        sas_address(0x500605b0006c0ae0), phy(3)
  mpt2sas0:        handle(0x000b), ioc_status(scsi data underrun)(0x0045), smid(59)
  mpt2sas0:        scsi_status(check condition)(0x02), scsi_state(autosense valid )(0x01)
  mpt2sas0:        [sense_key,asc,ascq]: [0x05,0x20,0x00], count(96)
  md/raid1:md125: Disk failure on sds1, disabling device.
  md/raid1:md125: Operation continuing on 1 devices.

the bitmap file starts recording dirty chunks:

  Sync Size : 4192192 (4.00 GiB 4.29 GB)
     Bitmap : 1048048 bits (chunks), 16409 dirty (1.6%)

The MD write_same_max_bytes are left at 33553920 until the VirtualLUN is
failed/remove/re-added.  After the WRITE SAME failure, the VirtualLUN's
max_write_same_blocks have been set to 0.  When re-added to the MD, this
value is reconsidered in the MD's write_same_max_bytes, which also gets
set to zero.  This behavior seems okay as the remaining good disk fully
supported WRITE SAME when the RAID was degraded.  Once the
non-supporting component disk was added to the RAID1, WRITE SAME was
disabled for the MD:

  /sys/class/scsi_disk/2:0:4:0/max_write_same_blocks: 0
  /sys/class/scsi_disk/3:0:2:0/max_write_same_blocks: 65535
  /sys/block/md125/queue/write_same_max_bytes: 0

When the VirtualLUN was re-added to the RAID1, resync initiated.  Recall
that earlier I had dumped random bits on the entire MD device, so the
state of the disks should have looked like this:

  SAS  = init RAID sync + random bits + ext4 WRITE SAME 0's + ext4 misc
  VLUN = init RAID sync + random bits

and resync would need to consult the bitmap to repair the VLUN chunks
that WRITE SAME and whatever else ext4_lazyinit_thread layed down.

By setting the bitmap chunksize so small, the idea was to spread the
failed WRITE SAME across tracking bits.  CDB WRITE SAME num blocks was
0x0FF8 (4088) and 4088 x 512 (block size) ~= 2MB (much greater than
4KB).  With a systemtap probe, I saw 32 WRITE SAME commands (all about
4KB blocks) emitted from the block layer via ext4_lazyinit_thread.  So
the estimated dirty bits for all 32 should be somewhere around:

  32 * (2MB disk dirty / 4K disk per bit) = 16384 dirty bits

pretty close to the observed 16409 (the rest I assume were other ext4
housekeeping).

At this point we know:

  - Failed WRITE SAME will kick disk from MD RAID1
  - WRITE SAME is disabled if unsupported disk added to MD
  - Failed WRITE SAME is properly handled by bitmap, even when
    spanning bitmap bits.

A few outstanding questions that I have, maybe Neil or someone more
familiar with the code could answer.

Q1 - Is mddev->chunk_sectors is always zero for RAID1?

Q2 - I noticed handle_write_finished calls narrow_write_error to try and
     potentially avoid failing an entire device.  In my tests,
     narrow_write_error never succeeded as rdev->badblocks.shift = -1.

     I think this part of the bad block list code Neil has been working
     on.  I don't suppose this is the proper place for MD to reset
     write_same_max_bytes to disable future WRITE SAME and handling the
     individual writes here instead of the block layer?

Regards,

-- Joe


From b12c24ee0fce802f35263da65d236694b01c99cf Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Fri, 7 Jun 2013 15:25:54 -0400
Subject: [PATCH] raid1: properly set blk_queue_max_write_same_sectors

MD RAID1 chunk_sectors will always be zero, unlike RAID0, so RAID1 does
not need to worry about limiting the write same sectors in that regard.
Let disk_stack_limits choose the minimum of the RAID1 components write
same values.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
---
 drivers/md/raid1.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fd86b37..3dc9ad6 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2821,9 +2821,6 @@ static int run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	if (mddev->queue)
-		blk_queue_max_write_same_sectors(mddev->queue,
-						 mddev->chunk_sectors);
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
 			continue;
-- 
1.8.1.4

