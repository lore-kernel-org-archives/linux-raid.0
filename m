From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm RAID5 Grow
Date: Thu, 5 Oct 2006 23:00:40 +1000
Message-ID: <17701.504.201046.256698@cse.unsw.edu.au>
References: <6652499.post@talk.nabble.com>
	<17700.35743.152233.689956@cse.unsw.edu.au>
	<4524FD70.6070609@mickg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from mickg on Thursday October 5
Sender: linux-raid-owner@vger.kernel.org
To: mickg <mickg@mickg.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 5, mickg@mickg.net wrote:
> Neil Brown wrote:
> > On Wednesday October 4, mickg@mickg.net wrote:
> >> I have been trying to run: 
> >> mdadm --grow /dev/md0 --raid-devices=6 --backup-file /backup_raid_grow
> >> I get:
> >> mdadm: Need to backup 1280K of critical section..
> >> mdadm: /dev/md0: Cannot get array details from sysfs
> > 
> > It shouldn't do that.... 
> > Can you 
> >   strace -o /tmp/trace -s 300 mdadm --grow .....
...
> open("/sys/block/md0/md/component_size", O_RDONLY) = -1 ENOENT (No such file or directory)

So it couldn't open .../component_size.  That was added prior to the
release of 2.6.16, and you are running 2.6.17.13 so the kernel
certainly supports it.  
Most likely explanation is that /sys isn't mounted.
Do you have a "/sys"?
Is it mounted?
Can you "ls -l /sys/block/md0/md" ??

Maybe you need to
  mkdir /sys
  mount -t sysfs sysfs /sys

and try again.

NeilBrown
