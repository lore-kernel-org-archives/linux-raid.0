From: dean gaudet <dean@arctic.org>
Subject: Re: Ubuntu - RAID Array not "assembling" on boot.
Date: Tue, 21 Nov 2006 23:43:19 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0611212339001.8068@twinlark.arctic.org>
References: <1164139592.12278.276853539@webmail.messagingengine.com>  
 <45635DCC.3010500@idgmail.se> <1164147995.26591.276873647@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1164147995.26591.276873647@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Reeves <john.reeves@mailc.net>
Cc: Henrik Holst <henrik.holst@idgmail.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 21 Nov 2006, John Reeves wrote:

> On Tue, 21 Nov 2006 21:13:00 +0100, "Henrik Holst"
> <henrik.holst@idgmail.se> said:
> > > Having a great deal of difficulty getting my 3 disk RAID 5 array to
> > > reappear on restart, Ubuntu 6.10.  
> ... < snip > ...
> > > the only way I can get
> > > the RAID Array to assemble is to issue the following:
> > > 
> > > mknod -m 0660 /dev/md0 b 9 0
> > > mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1
> 
> > Try "dpkg-reconfigure mdadm" as root. Under Debian this will give you
> > the chance to configure the startup configuration for all software raids
> > in the system. Under any cirtumstances you should not have to use mknod.
> > Instead try adding the --auto=yes switch to mdadm. Then mdadm will
> > create the node itself.
> 
> That's the one!  Blowing away my current mdadm.conf and issuing a
> dpkg-reconfigure mdadm bought my raid online with the subsequent reboot
> - I am very greatful!  Now I guess I would like to know where I go wrong
> :)
> 
> I created the raid in the first place by issuing a:
> 
> # sudo mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 \
> /dev/sda1 /dev/sdb1 /dev/sdc1
> 
> After this, no mdadm.conf file was created for me, so I made by own by
> issuing:
> 
> # mdadm --detail --scan >> /etc/mdadm/mdadm.conf
> 
> And thats when the whole "assemble" on boot problem came from.  I
> presume that the above command (--detail --scan)  is not the correct way
> to make the mdadm.conf file - how should it be made?

that's fine, but you need a "DEVICE partitions" line as well... that's 
what i suspect your problem was.  dpkg-reconfigure probably created it for 
you.  you should look -- because if it put in a "DEVICE /dev/sda1 
/dev/sdb1 /dev/sdc1" line then you really want to change it to 
"partitions"... so that it can handle device renames properly.


> Finally, on a side note, I have formatted this array (/dev/md0) with
> ext3, I planned to exapand the array in the future by adding extra disks
> - I presume I can do this with 'mdadm --grow' (and some extra research!
> :)  Am I correct on this assumption?

yep.

-dean
