From: Thomas Andrews <tandrews@grok.co.za>
Subject: Re: One partition degraded after every reboot
Date: Fri, 9 Apr 2004 15:09:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040409130944.GA10445@gaspode.nextlink.co.za>
References: <406C00E3.4030205@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <406C00E3.4030205@chello.at>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 01, 2004 at 01:45:39PM +0200, Philipp Gortan wrote:

> > I've set up RAID-1 on a pair of disks recently. When I reboot I get this
> > in syslog, even though the partition was perfect & not degraded before:
> >
> > kernel: md1: former device ide/host2/bus0/target0/lun0/part5 is unavailable, removing from array!
> >
> > More specifically, of the 4 RAID-1 partitions, md1 (my root partition)
> > is in degraded mode.

[snip]
> I solved the problem by creating a new initrd and fiddling with the lilo 
> configuration:
> for me,
> after re-adding the always-failing drive to the raid
> # mdadm -a /dev/md0 /dev/hda1
> i updated my lilo.conf to:
> 
> ...
> boot=/dev/md0
> raid-extra-boot=/dev/hda,/dev/hdc
> root=/dev/md0
> ...
> 
> and created a new initrd
> # mkinitrd -k -r /dev/md0 -o /boot/initrd.img-2.6.3-1-k7
> 
> and ran lilo again
> # lilo
[snip]

Unfortunately, installing lilo in place of grub hasn't solved the
problem, so I'm still without a solution.

-Thomas
