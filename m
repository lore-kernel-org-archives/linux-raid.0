From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 with 2 disks not working correctly. Need help!
Date: Mon, 5 Jan 2009 21:27:51 +1100
Message-ID: <18785.57511.258898.368282@notabene.brown>
References: <995ea3b00812160536x55d140caned9952c99dd5e2be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Roy Lim on Tuesday December 16
Sender: linux-raid-owner@vger.kernel.org
To: Roy Lim <cableroy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 16, cableroy@gmail.com wrote:
> Hi
> I have ran into a serious problem with my raid5 array and need expert
> help on this one.
> 
> My array is with 5x500GB disks none spare, I've accidentally did a
> unclean shutdown of the server. When it came up it gave me this error:
> 
> Dec 15 09:07:11 ares kernel: md: kicking non-fresh hdk1 from array!
> Dec 15 09:07:11 ares kernel: md: unbind<hdk1>
> Dec 15 09:07:11 ares kernel: md: export_rdev(hdk1)
> Dec 15 09:07:11 ares kernel: md: md0: raid array is not clean --
> starting background reconstruction
> Dec 15 09:07:11 ares kernel: raid5: device hde1 operational as raid disk 0
> Dec 15 09:07:11 ares kernel: raid5: device sda1 operational as raid disk 4
> Dec 15 09:07:11 ares kernel: raid5: device hdi1 operational as raid disk 2
> Dec 15 09:07:11 ares kernel: raid5: device hdg1 operational as raid disk 1
> Dec 15 09:07:11 ares kernel: raid5: cannot start dirty degraded array for md0
> 
> However i managed to get this back up with remove and add, the system
> was rebuilding the array. around 70-80% in the process i was going to
> prepare to decrypt it (luks crypted) so I'm going to mount the usb
> stick witch has the encryption key however when i was going to mount
> it i tried to mount wrong device, resulting trying to mount a device
> in the array (sda1) i hit repeatedly crtl+c, now taking a look at the
> details on the array it looks like this:

Trying to mount sda1 should have simply failed as the device was in
use.  I wonder what really happened....

> 
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Mon Feb  4 18:25:28 2008
>      Raid Level : raid5
>      Array Size : 1953535744 (1863.04 GiB 2000.42 GB)
>     Device Size : 488383936 (465.76 GiB 500.11 GB)
>    Raid Devices : 5
>   Total Devices : 5
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Dec 15 16:02:54 2008
>           State : clean, degraded
>  Active Devices : 3
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 1
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            UUID : 856a6e4e:a1663e98:9efbd2b1:7507133b
>          Events : 0.74
> 
>     Number   Major   Minor   RaidDevice State
>        0      33        1        0      active sync   /dev/hde1
>        1      34        1        1      active sync   /dev/hdg1
>        2      56        1        2      active sync   /dev/hdi1
>        3       0        0        3      removed
>        4       0        0        4      removed
> 
>        5      57        1        -      spare   /dev/hdk1
>        6       8        1        -      faulty spare   /dev/sda1
> 
> a quick summary: hdk1 was the one failing in the first place, witch
> was about to get rebuild, sda1 was the device i tried to mount while
> reconstruction the data. As you can see, hdk1 is now marked as spare
> and sda1 a faulty spare.  I have not touch the array after this. Can
> anyone help me out? How can i force mdadm to set the sda1 to active
> sync so i can mount the array and start a backup? Can i use dd_rescue
> to file of all of the disks and play with it?
> 
> All help is appreciated!

Your only option at this stage is to re-create the array with the best
devices.  Create it will one device missing so that it won't try a
resync.
e.g.

  mdadm -C /dev/md0 -l5 -n5 /dev/hde1 /dev/hdg1 /dev/hdi1 missing /dev/sda1

then try to access the data to see if it looks right.
This will not modify the data on any devices (until you try writing to
md0), only the RAID metadata.
If you are happy that md0 looks OK, you can then
  mdadm /dev/md0 --add /dev/hdk1
and it will recover data to hdk1 and you will have redundancy back
again.

Good luck,
NeilBrown
