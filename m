From: "Sandu Mihai" <mihai.sandu@kpnqwest.ro>
Subject: Re: Raid Persistent Superblock Question..
Date: Mon, 20 Jan 2003 03:57:06 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <008e01c2c027$3c9042e0$c7e60c0a@mihaisandu2>
References: <Pine.LNX.3.96.1030119130208.20317A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok. I am carefull. But, I want to be able to mangle with the superblock, in
order to have my kernel 'autodetect' a disk as being a member of a specific
md device.
If for example you install Redhat on a box, with all the things on software
raid (including /), Redhat will autogenerate a raidtab, with every disk
having a permanent superblock. That will glue forever your disks to md0,
md1, etc (sadly, Redhat install will not allow you to specify which mdNNN
you will use for what, except if you are doing kickstart install).
If you will move the disks in another box (also Redhat), the other box will
go bezerk, since by the 'magic' of array membership autodetection it will
autodetect your new disks as part of a md device
and then it will refuse to create the correct md device with the existing
disks. (that is, if the box has md devices overlapping with those on the
other box, eg. md0 used for / on both, etc)
The new disks (in my case) got a correct SCSI assignment (newdisk 1 = sdc,
new disk 2 = sdd, which is correct).
So far, I have seen a lot of tools that either query the superblock, add a
disk in the array, etc. I did not seen one that can let one edit the
superblock of a raid device.

/Mike
----- Original Message -----
From: "Alvin Oga" <aoga@Maggie.Linux-Consulting.com>
To: "Sandu Mihai" <mihai.sandu@kpnqwest.ro>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, January 19, 2003 11:04 PM
Subject: Re: Raid Persistent Superblock Question..


>
> hi ya
>
> when you add a new scsi disk...  you have to be careful
> about its unit number
>
> make sure your dirves are properly configured...
> - sda is in fact the lowest scsi-ID
> - sdb is in fact lowest scsi-ID +1
> - add your new disks w/ higher scsi-IDs
>
> all should work fine
>
> sda, sdb, sdc is (re-)assigned in the sequence of scsi-IDs
>
> c ya
> alvin
>
> On Sun, 19 Jan 2003, Sandu Mihai wrote:
>
> >
> > Is there any tool that can help someone edit the persistent superblock
of a
> > partition/device that is a member of an RAID array?
> >
> > Problem:
> >     I have md0 - raid1 - /dev/sda1 + /dev/sdb1 + persistent-superblock 1
> > md0 happens to be my / partition.
> >     If I will insert another two disks in that box (/dev/sdd, /dev/sdc
with
> > /dev/sdc1, /dev/sdd1 being members of md0 RAID1 array, the disks are
from
> > another box..) the kernel will mess-up the things, by 'autodetecting'
the
> > newly added disks as md0, and not _my_ disks.
> >     If I could alter the superblock info on the newly added disks, well,
> > that will be good.
> > So far, no HOWTO, and no docs mention the existence of a tool like this
(you
> > can only query the superblock, and that is all..)
> >
>
>
>
>

