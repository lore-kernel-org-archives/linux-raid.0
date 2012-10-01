From: Aaron Greenspan <aarong@thinkcomputer.com>
Subject: Re: mdadm --grow Hard Drive Size Puzzle
Date: Sun, 30 Sep 2012 22:12:03 -0700
Message-ID: <0E52B34E-36DF-4F1C-90DA-EB793A209B95@thinkcomputer.com>
References: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com> <20121001125510.6cc0c2be@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121001125510.6cc0c2be@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

To reply to Chris's question (I'm not on the mailing list and didn't get the e-mail directly):

I copied the drives by using the RAID resync process, not by using dd. This has happened over a period of years with different drives most likely, which might explain discrepancies in metadata versions.

Generally (as I alluded to in my last e-mail) I find the output of these utilities to be incredibly confusing. I'm a pretty technical person and I've worked with Linux for many years, but I honestly have no idea what "super 1.1" really means. Is there a reason everything has to be so concise and opaque? It doesn't seem like we're running out of screen space... In some parts of mdadm, a dot (period) means that part of an array is inactive (versus "A" representing active). Here, I guess it means that it's actually part of a version number for something I didn't realize was versioned. That's my own ignorance, but it's hardly clear, and most users will not start out as experts.

In the distant past I remember that there were two (or three?) different types of drive/array UDIDs depending on which utility you were working with. That's confusing as well.

Also, if you try running --grow /dev/mdX --size=max on a partition that is already at its maximum, the error message...

mdadm: Cannot set size on array members.
mdadm: Cannot set device size for /dev/md2: Invalid argument

...is totally useless and isn't even correct as far as I can tell. The argument --size=max IS valid, actually. The error doesn't say which array members it's having trouble with or why (some of them? all of them?). It doesn't suggest that you use mdadm --examine to determine if there's actually more space available, or just tell you the same figures that --examine would tell you anyway. From a usability perspective, it just seems like there's a lot that could be improved.

That all being said, I do appreciate everyone's help.

Aaron

---

[root@kermit dcd]# fdisk -l

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0xa320cea3

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1          13      104391   fd  Linux raid autodetect
Partition 1 does not start on physical sector boundary.
/dev/sda2              14       27551   221198985   fd  Linux raid autodetect
Partition 2 does not start on physical sector boundary.
/dev/sda3           27552       27678     1020127+  fd  Linux raid autodetect
Partition 3 does not start on physical sector boundary.
/dev/sda4           27679      243201  1731188497+   5  Extended
Partition 4 does not start on physical sector boundary.
/dev/sda5           27679      243201  1731188466   fd  Linux raid autodetect
Partition 5 does not start on physical sector boundary.

Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1          13      104391   fd  Linux raid autodetect
Partition 1 does not start on physical sector boundary.
/dev/sdb2              14       27551   221198985   fd  Linux raid autodetect
Partition 2 does not start on physical sector boundary.
/dev/sdb3           27552       27678     1020127+  fd  Linux raid autodetect
Partition 3 does not start on physical sector boundary.
/dev/sdb4           27679      243201  1731188497+   5  Extended
Partition 4 does not start on physical sector boundary.
/dev/sdb5           27679      243201  1731188466   fd  Linux raid autodetect
Partition 5 does not start on physical sector boundary.

Disk /dev/md0: 104 MB, 104845312 bytes
2 heads, 4 sectors/track, 25597 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Alignment offset: 512 bytes
Disk identifier: 0x00000000


Disk /dev/md1: 226.5 GB, 226491232256 bytes
2 heads, 4 sectors/track, 55295711 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Alignment offset: 1536 bytes
Disk identifier: 0x00000000


Disk /dev/md3: 886.4 GB, 886367970304 bytes
2 heads, 4 sectors/track, 216398430 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Alignment offset: 1536 bytes
Disk identifier: 0x00000000


Disk /dev/md2: 1044 MB, 1044597760 bytes
2 heads, 4 sectors/track, 255028 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Alignment offset: 512 bytes
Disk identifier: 0x00000000