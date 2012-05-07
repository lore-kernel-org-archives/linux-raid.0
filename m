From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: Reason for md raid1 max_sectors_kb limited to 127?
Date: Mon, 07 May 2012 16:04:40 +0200
Message-ID: <4FA7D678.4080106@itwm.fraunhofer.de>
References: <4FA798D7.4070506@profitbricks.com> <20120507211846.789d5808@notabene.brown> <4FA7B337.7040408@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FA7B337.7040408@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/07/2012 01:34 PM, Sebastian Riemer wrote:
> On 07/05/12 13:18, NeilBrown wrote:
>> You didn't say which kernel you are running.
>>
>> However md/raid1 bases all those settings on the minimum or maximum (as
>> appropriate) of the setting of the underlying devices, using blk_stack_limits
>> (in block/blk-settings.c).
>>
>> So the likely answer is that one of your HDDs has a smaller max_sectors_kb?
>>
>> NeilBrown
> 
> Thanks for your answer! Kernel version is vanilla 3.2, but I've also
> tested 2.6.32. There is no difference. Distribution: Debian Squeeze.
> 
> I can even reproduce this behaviour with RAM disks:
> 
> # modprobe brd rd_nr=2 rd_size=1048576
> # cat /sys/block/ram0/queue/max_sectors_kb
> 512
> # cat /sys/block/ram1/queue/max_sectors_kb
> 512
> # mdadm -C /dev/md200 --force --assume-clean -n 2 -l raid1 -a md
> /dev/ram0 /dev/ram1
> # cat /sys/block/md200/queue/max_sectors_kb
> 127
> 
> I'll have a look at that blk_stack_limits() function.
> 

I think you need something like this. I thought there already went 
something in in recent kernel, will check it later on today.



Index: 2.6.32.13/drivers/md/raid0.c
===================================================================
--- 2.6.32.13.orig/drivers/md/raid0.c
+++ 2.6.32.13/drivers/md/raid0.c
@@ -96,6 +96,7 @@ static int create_strip_zones(mddev_t *m
 	int cnt;
 	char b[BDEVNAME_SIZE];
 	raid0_conf_t *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	unsigned int opt_io_size;
 
 	if (!conf)
 		return -ENOMEM;
@@ -256,9 +257,16 @@ static int create_strip_zones(mddev_t *m
 		goto abort;
 	}
 
+	/*
+	 * To send large IOs to the drives we need sufficient segments
+	 * for our own queue first.
+	 */
+	opt_io_size = (mddev->chunk_sectors << 9) * mddev->raid_disks;
+	blk_queue_max_phys_segments(mddev->queue, opt_io_size >> PAGE_SHIFT);
+	blk_queue_max_hw_segments(mddev->queue, opt_io_size >> PAGE_SHIFT);
+
 	blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
-	blk_queue_io_opt(mddev->queue,
-			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
+	blk_queue_io_opt(mddev->queue, opt_io_size);
 
 	printk(KERN_INFO "raid0: done.\n");
 	mddev->private = conf;


Cheers,
Bernd
