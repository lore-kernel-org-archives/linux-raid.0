From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Reason for md raid1 max_sectors_kb limited to 127?
Date: Mon, 07 May 2012 13:34:15 +0200
Message-ID: <4FA7B337.7040408@profitbricks.com>
References: <4FA798D7.4070506@profitbricks.com> <20120507211846.789d5808@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120507211846.789d5808@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/05/12 13:18, NeilBrown wrote:
> You didn't say which kernel you are running.
> 
> However md/raid1 bases all those settings on the minimum or maximum (as
> appropriate) of the setting of the underlying devices, using blk_stack_limits
> (in block/blk-settings.c).
> 
> So the likely answer is that one of your HDDs has a smaller max_sectors_kb?
> 
> NeilBrown

Thanks for your answer! Kernel version is vanilla 3.2, but I've also
tested 2.6.32. There is no difference. Distribution: Debian Squeeze.

I can even reproduce this behaviour with RAM disks:

# modprobe brd rd_nr=2 rd_size=1048576
# cat /sys/block/ram0/queue/max_sectors_kb
512
# cat /sys/block/ram1/queue/max_sectors_kb
512
# mdadm -C /dev/md200 --force --assume-clean -n 2 -l raid1 -a md
/dev/ram0 /dev/ram1
# cat /sys/block/md200/queue/max_sectors_kb
127

I'll have a look at that blk_stack_limits() function.

Cheers,
Sebastian
