From: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Subject: Re: (no subject)
Date: Wed, 11 Sep 2002 12:50:13 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.3.96.1020911123839.30810A-100000@Maggie.Linux-Consulting.com>
References: <3D7F8B2E.14D49808@milleraa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D7F8B2E.14D49808@milleraa.com>
To: Eddie Johnson <ejohnson@milleraa.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hiya eddie

i think you want raid5 w/ 3 disks instead of 3 copies of the same
data on 3 disks w/ raid1

watch our for old raid commands (mkraid ) vs new raid commands (raidstart)

More raid commands
       http://www.1U-Raid5.net/HowTo/Commands.uhow2.txt

have fun raiding
alvin

#
#
# sample /etc/raidtab
#
# To start it up
# --------------
#	fdsisk /dev/sda
#	--> use FD raid partion ( 1 partition - the whole disk ?)
#
#	raidstart /dev/md0
#	cat /proc/mdstat	--> see if all 3 disks is listed
#	mke2fs -j /dev/md0
#	mount /dev/md0 /RAID
#
#	dd if=/dev/random of=/RAID/test.big count=1000000
#
#
#
raiddev /dev/md0
raid-level 5
#
nr-raid-disks 3
#  note the above
#
nr-spare-disks 0
persistent superblock 1
parity-algorithm left-symmetric
#
#
# That's a huge chunk .... units are 1024 block * chunk-size 
# chunk-size 2048
chunk-size	8
#
#
# use the "partition" on the disk and define the raiddev device /dev/md0
#
device /dev/sda1
raid-disk 0
#
device /dev/sdb1
raid-disk 1
# 
device /dev/sdc1
raid-disk 2
#
# end of raidtab file


On Wed, 11 Sep 2002, Eddie Johnson wrote:

> I installed Suse Linux Professional 8 on a HP Netserver LC3 PII/450.  An
> AHA-2940 UW Scsi host adapter with a AIC-78XX Scsi Protocol Chip/50 pin
> high density scsi-2 control.  I have a raid (3 drives) off the host
> adapter and a 80 gig scsi drive off the mother board. After launching
> yast2 the first raid has the following device: LD0 raid 5 34730R:
> device_name /dev/sda, vendor megaraid.  Disk two (80 gig drive) has LD1
> raid 0 70006R: device name /dev/sdb vendor the same as above.  There was
> no raidtab file so I created one with the following:
> 
> raiddev /dev/md0
> raid-level 5
> nr-raid-disks 1(little sketchy on this because it is three drives that
> make up the raid)
> nr-spare-disks 0
> persistent superblock 1
> parity-algorithm left-symmetric
> chunk-size 2048
> device /dev/sda
> raid-disk 0 (sketchy here as well)
> 
> #Second drive
> raiddev /dev/md1
> raid-level 5
> nr-raid-disks 1
> nr-spare-disks 0
> persistent-superblock 1
> chunk-size 2048
> device /dev/sdb
> raid-disks 1 (sketchy as well)
> 
> Trying to follow the procedures and I type:
> mkraid /dev/md0 and I get:
> 
> Handling md device /dev/md0
> analyzing super-block
> disk 0: /dev/sda, 35563520kb, raid superblock at 35563456kb
> 
> Second drive I get:
> 
> Handling md deviice /dev/md1
> analyzing super-block
> disk 0: /dev/sdb, 71686144kb, raid superblock at 71686080kb
> 
> I then type cat /proc/mdstat and get the following:
> 
> Personalities [RAID5]
> read_ahead not set
> md1: inactive sdb [0]
>      71684096 blocks
> md0: inactive sda [0]
>      35561472 blocks
> unused devices: <none>
> 
> If I read this correctly both are inactive when it should be stating
> that they are active.  At this point I am baffled any suggestions or
> possible directions would greatly be appreciated.
> 
> 
> Thanks in advance,
> Ed
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

