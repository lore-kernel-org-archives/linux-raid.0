From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Can't figure out how to use mdadm in initrd
Date: Sat, 29 Jun 2002 00:58:13 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15644.31109.281940.446666@notabene.cse.unsw.edu.au>
References: <1025275522.600.10.camel@temp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ken Causey on  June 28
To: Ken Causey <ken@ineffable.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  June 28, ken@ineffable.com wrote:
> I don't get it.  I cannot seem to get mdadm to handle a degraded array
> no matter what I do.  I'm setting up a system with all filesystems
> including boot and root on software RAID.  I initially tried to use
> raidstart in my initrd but ran into a bug that prevents reinstating
> missing array members in some circumstances, so I was directed to use
> mdadm instead.  Here's my current setup:
> 
> root is on /dev/md2 (RAID5)
> 
> The /etc/mdadm/mdadm.conf file in the initrd contains:
> 
> DEVICE /dev/sd*
> ARRAY /dev/md2 devices="/dev/sda3,/dev/sdb3,/dev/sdc3"

the "devices=" is not the best way to say what devices to use.
It works OK for IDE which has stable names but not so good for
SCSI which doesn't.

What you are saying is "Please assemble an array from precisely
 /dev/sda3, /dev/sdb3, and /dev/sdc3", and mdadm is saying,
"Sorry, those three devices do not make an array".

You should use either "uuid=" (preferred) or "super-minor=" 
(easier to manage in some ways).

> 
> The modules loaded are
> 
> modprobe -k aic7xxx
> modprobe -k raid1
> modprobe -k raid5
> modprobe -k ext3
> modprobe -k ext2
> 
> mdadm is run as
> 
> set "/dev/md2"
> [ -b "$1" ] || set "/dev/md/2"
> mdadm --assemble --run --scan "$1"

This bit of code is silly.  If it chooses "/dev/md/2", then it
won't find a match in /etc/mdadm/mdadm.conf and wont do anything
useful. 
Why not just:
   mdadm --assemble --scan

It will then start everything listed in mdadm.conf.

NeilBrown
