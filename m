From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Software RAID 0+1 with mdadm.
Date: Tue, 25 Jan 2005 18:04:07 -0500
Message-ID: <200501252302.j0PN2A904022@www.watkins-home.com>
References: <1106692101.15355.16.camel@serpent>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1106692101.15355.16.camel@serpent>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brad Dameron' <brad@seatab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

For a more stable array, build a RAID0 out of 2 RAID1 arrays.

Like this:

mdadm --create /dev/md1 --level=1 --chunk=4 --raid-devices=2 /dev/sdb1
/dev/sdc1
mdadm --create /dev/md2 --level=1 --chunk=4 --raid-devices=2 /dev/sdd1
/dev/sde1
mdadm --create /dev/md0 --level=0 --chunk=4 --raid-devices=2 /dev/md1
/dev/md2

You can put a file system directly on /dev/md0

Are all of the disks on the same cable?

Not sure about your booting issue.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Dameron
Sent: Tuesday, January 25, 2005 5:28 PM
To: linux-raid@vger.kernel.org
Subject: Software RAID 0+1 with mdadm.

Been trying for days to get a software RAID 0+1 setup. This is on SuSe
9.2 with kernel 2.6.8-24.11-smp x86_64.

I am trying to setup a RAID 0+1 with 4 250gb SATA drives. I do the
following:

mdadm --create /dev/md1 --level=0 --chunk=4 --raid-devices=2 /dev/sdb1
/dev/sdc1
mdadm --create /dev/md2 --level=0 --chunk=4 --raid-devices=2 /dev/sdd1
/dev/sde1
mdadm --create /dev/md0 --level=1 --chunk=4 --raid-devices=2 /dev/md1
/dev/md2

This all works fine and I can mkreiserfs /dev/md0 and mount it. If I am
then to reboot /dev/md1 and /dev/md2 will show up in the /proc/mdstat
but not /dev/md0. So I create a /etc/mdadm.conf like so to see if this
will work:

DEVICE partitions
DEVICE /dev/md*
ARRAY /dev/md2 level=raid0 num-devices=2
UUID=5e6efe7d:6f5de80b:82ef7843:148cd518
   devices=/dev/sdd1,/dev/sde1
ARRAY /dev/md1 level=raid0 num-devices=2
UUID=e81e74f9:1cf84f87:7747c1c9:b3f08a81
   devices=/dev/sdb1,/dev/sdc1
ARRAY /dev/md0 level=raid1 num-devices=2  devices=/dev/md2,/dev/md1


Everything seems ok after boot. But again no /dev/md0 in /proc/mdstat.
But then if I do a mdadm --assemble --scan it will then load /dev/md0. 

Also do I need to create partitions? Or can I setup the whole drives as
the array?

I have since upgraded to mdadm 1.8 and setup a RAID10. However I need
something that is production worthy. Is a RAID10 something I could rely
on as well? Also under a RAID10 how do you tell it which drives you want
mirrored?

Any help appreciated. 

Thank you,
Brad Dameron
SeaTab Software
www.seatab.com

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

