From: Jake Thomas <thomasj10@georgefox.edu>
Subject: Device Unusable At Startup
Date: Sun, 5 Aug 2012 03:13:43 -0400
Message-ID: <CACO8viptp4hS91apO=FM8S65w2sOYwjQs5w3=uQ_nd76xNpTAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First of all, I have no idea if this e-mail address is a part of a
mailing list, so please CC me individually, or somehow reply to me
personally.

My goal: create a RAID 1 array between a partition on the hard drive
and a ramdisk and mount this md array at /usr. Once poplulated, the
vast majority of my programs will run out of RAM, and be very fast! I
have 8 GB of RAM, so why not?


On startup, the partition, which is a linux_raid_member, is detected
as such, and /dev/md127 is automatically created.

The problem: /dev/md127 is not usable. "sudo blkid /dev/md127" yeilds
nothing. mdadm can't even query anything about it.

Since this is RAID _one_ it should be able to function just fine with
only one member, but it doesn't.

In fact, to get it going again, I have to do:

sudo mdadm --stop /dev/md127
sudo mdadm -A /dev/md127 -f /dev/sda2

#works at this point, now to add in the ramdisk:
sudo mdadm /dev/md127 -a /dev/ram0


Then "sudo blkid /dev/md127" says that it's ext4 formatted, that it
has a UUID, etc., and it is usable. After mounting it after fixing it,
all my data is there.

Problem restated: /usr needs to be mounted so early in startup that
there is no script that I can have automate the fixing of my /usr RAID
device in time for it to be mounted when it needs to be. I shouldn't
even have to do that. It should just be functional from the get-go.

I have a thread going on about this here:
http://bbs.archbang.org/viewtopic.php?id=3179 .

I have even tried renaming /sbin/mdadm to /sbin/mdadm.moved and doing
"sudo /sbin/mdadm.moved --stop --scan" before shutdown, as mentioned
here: http://neil.brown.name/blog/20120615073245#6 . After restart,
the automatically generated md device for the found linux_raid_member
partition is still unusable.

I have tried both kernel 3.3.4-1-ARCH with mdadm 3.2.3-2 and kernel
3.4.7-1 with mdadm 3.2.5-2.

The original idea for this came from here:
https://bbs.archlinux.org/viewtopic.php?pid=493773#p493773 . I, of
course, can't afford enough RAM to put the entirety of my installation
in RAM, but I can afford to put /usr entirely in RAM.

Can any of you folks help me out on this?

Cheers,
Jake
