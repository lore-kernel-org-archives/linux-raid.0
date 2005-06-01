From: "Harry M. Aasterud" <harry@aasterudweb.com>
Subject: mdamin on Fedora Core 3 - recovery procedures
Date: Wed, 1 Jun 2005 15:08:40 +0200
Message-ID: <001c01c566ab$07bd1480$d01301c3@aasterudweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I found this email adress on the website of Neil Brown at
http://cgi.cse.unsw.edu/~neilb/Contact. I hope this email will find its
way to the right person, within reasonable time.

I installed FC3 with server installation. I'm using to identical disks
40 Gb each, no RAID controller. Disc 1 on IDE controler 1, 2 on 2.
During partitioning, I did this:

- deleted all partitions
- created new partition on hda, file system type software RAID, 100 Mb.
This will be boot partition on hda. Did the same on hdc
- created new partition on hda, file system type software RAID, 512 Mb.
This will be swap partition on hda. Did the same on hdc
- created new partition on hda, file system type software RAID, fill to
max size . This will be / partition on hda. Did the same on hdc

Created RAID devices

selected hda1 and hdc1 -> md1
selected hda2 and hdc2 -> md2
selected hda3 and hdc3 -> md3

copied MBR via grub

When doing so, al works fine. Shutting down the system, disconnecting
disc 2, and reboot. Doing cat /proc/mdstat shows only hda1/2/3, which i=
s
correct. just one minor problem: Smartd failed to load during reboot,
though the smard.conf points to both hda and hdc. But the system is
working OK.

Shutting down again, reconnect disc 2, and reboot. Starting the server
again with 2 discs. Now cat /proc/mdstat only sees this:

md3-hda1 size 100000 (/boot)
md2-hda3 size 38000000 (/)
md1-hdc2 - hda2 size 500000 (swap)

This is what bothers me. I am not familiar with the RAID1 disc recoverr=
y
procedures, and can't tell if this how it it supposed to work.When I
after reboot do mdadm /dev/md3 --add /dev/hdc1, then the disk is loaded
into the array. The same with mdadm /dev/md2 --add /dev/hdc3.

After that, all works fine. I also tested it by removing disk 1 (primar=
y
disk), and replacing it with a brand new unformatted disk. At reboot th=
e
error showed, not bootable. so I swapped the discs, and then it worked.

Another strange thing is that I configured the partitions at
installation after the logical sequence, that md1 should contain hda1
and hdc1, md2 has hda2 and hdc2 etc. After installation you see that md=
3
has hdx1, md2 has hdx3 and md1 has hdx2...

Anyway, after putting the discs back, and mdadm --add them again, thing=
s
appear to be working again.

BUT: What I can't find in the documentation (and I've been searching no=
w
for 3 whole days) is what to do when I replace a disk. I replaced one o=
f
the discs with a blanc unformated disk. The system boots up from the on=
e
working harddisk. Where is it written what command to execute to create
an exact bootable copy on the new unformated drive.

Looking forward to hear from you soon.

Best regards,

Live support? http://www.aasterudweb.com/live

Aasterud WebCom     URL: aasterudweb.com
Harry M. Aasterud      Tel.: +47 / 48 046 256
H.K. Foosn=E6s veg 5    Faks: +47 / 92 179 882
NO-7730 Beitstad
Norge - Norway

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
