From: linux@horizon.com
Subject: Re: Software RAID 0+1 with mdadm.
Date: 8 Feb 2005 14:32:45 -0000
Message-ID: <20050208143245.13933.qmail@science.horizon.com>
Sender: linux-raid-owner@vger.kernel.org
To: brad@seatab.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The only issue is that the md code only auto-scans non-MD partitions when
assembling a RAID array.  You can use mdadm at boot time to put them
together as other people have shown, or you can add an option to the kernel
command line (LILO append="..." option; other boot loaders have something
similar) to help it out.

Since I have my root partition on RAID1+0, I have "md=4,/dev/md2,/dev/md3"
on the kernel command line.  This gets /dev/md4 (which is a RAID-0
made of two RAID-1s) going.

Oh, regarding data placement: I also have the RAID-1 split across
controllers.  Also, I have half the mirror in removable drive trays
for emergency insta-backup (fire or other natural disaster) uses.

There are uses for such things.
