From: "Phantazm" <phantazm@phantazm.nu>
Subject: Re: Bug in MDADM or just crappy computer?
Date: Sun, 20 Feb 2005 10:41:26 +0100
Message-ID: <cv9lk2$hf3$1@sea.gmane.org>
References: <cv9gbc$84g$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

haha now thi sis even more wierd.

Rebuild rate is at 1700K/s when my box is not loaded.
When i change make flags to -j5 and compile something. The load ofcourse 
rises but strange thing is that rebuild rate also rises.

Seems like reverse fnction of what it should :)

Did 4 compiles at the same time and got the resync rate up to 6000K/s

wierd. I better go buy a playstation instead ;)


"Phantazm" <phantazm@phantazm.nu> skrev i meddelandet 
news:cv9gbc$84g$1@sea.gmane.org...
> My resync problem still goes on :-(
>
> When the resync is done on my raid5 with 8 disks just goes into a loop and 
> marks 2 disks as failed.
>
> Then i need to reboot and assemble them again with the force. (the 2 disks 
> thats failing isnt on same controller card)
>
> And the kernel log is filled up with this.
>
> Feb 20 08:43:13 [kernel] md: md0: sync done.
> Feb 20 08:43:13 [kernel] md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] md: md0: sync done.
> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] md: using maximum available idle IO bandwith (but 
> not more than 15000 KB/sec) for reconstruction.
> Feb 20 08:43:13 [kernel] md: using 128k window, over a total of 199141632 
> blocks.
> Feb 20 08:43:13 [kernel] md: md0: sync done.
> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] .<6>md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] md: using maximum available idle IO bandwith (but 
> not more than 15000 KB/sec) for reconstruction.
> Feb 20 08:43:13 [kernel] md: using 128k window, over a total of 199141632 
> blocks.
> Feb 20 08:43:13 [kernel] md: md0: sync done.
> Feb 20 08:43:13 [kernel] md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] md: using maximum available idle IO bandwith (but 
> not more than 15000 KB/sec) for reconstruction.
> Feb 20 08:43:13 [kernel] md: using 128k window, over a total of 199141632 
> blocks.
> Feb 20 08:43:13 [kernel] md: md0: sync done.
> Feb 20 08:43:13 [kernel] md: syncing RAID array md0
> Feb 20 08:43:13 [kernel] md: minimum _guaranteed_ reconstruction speed: 
> 5000 KB/sec/disc.
> Feb 20 08:43:13 [kernel] md: using maximum available idle IO bandwith (but 
> not more than 15000 KB/sec) for reconstruction.
> Feb 20 08:43:13 [kernel] md: using 128k window, over a total of 199141632 
> blocks.
>
>
> aint got a single clue what it could be.
>
> I have tried this patch too..
>
> (The disks are not broken, that i know for sure)
>
> --------------------------------------------
>
> Fix endless loop when syncing an array that doesn't need any resync.
>
> If the resync checkpoint for an array is at the end of the array, It 
> doesn't get set to MAX_SECTOR, so resyncing will be retried.
>
> By updating curr_resync early, this problem is fixed.
>
> Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>
>
> ### Diffstat output
>
> ./drivers/md/md.c | 6 ++++--
>
> 1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff ./drivers/md/md.c~current~ ./drivers/md/md.c
>
> --- ./drivers/md/md.c~current~ 2005-02-02 12:08:42.000000000 +1100
>
> +++ ./drivers/md/md.c 2005-02-02 12:08:53.000000000 +1100
>
> @@ -3472,10 +3472,12 @@ static void md_do_sync(mddev_t *mddev)
>
> init_waitqueue_head(&mddev->recovery_wait);
>
> last_check = 0;
>
>
> - if (j)
>
> + if (j>2) {
>
> printk(KERN_INFO
>
> "md: resuming recovery of %s from checkpoint.\n",
>
> mdname(mddev));
>
> + mddev->curr_resync = j;
>
> + }
>
>
> while (j < max_sectors) {
>
> int sectors;
>
> @@ -3562,7 +3564,7 @@ static void md_do_sync(mddev_t *mddev)
>
>
> if (!test_bit(MD_RECOVERY_ERR, &mddev->recovery) &&
>
> mddev->curr_resync > 2 &&
>
> - mddev->curr_resync > mddev->recovery_cp) {
>
> + mddev->curr_resync >= mddev->recovery_cp) {
>
> if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>
> printk(KERN_INFO
>
> "md: checkpointing recovery of %s.\n",
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



