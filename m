From: bfowler@ewitness.co.uk (ewitness - Ben Fowler)
Subject: RAID 5 disk format for Promise SuperTrak Sx6000 (Linux)
Date: Sun, 26 May 2002 03:35:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <f04330107b915ec475e78@[192.168.254.56]>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
Cc: ewitness - David Pearce <dp@ewitness.co.uk>
List-Id: linux-raid.ids

Just as a standard disk has a standard format with MBR, partition
table, superblock, root directory et cetera; I assume that the disks
making up a RAID 5 array have a defined format covering the 'superblock',
striping, parity and so forth.

Is this standard for all RAID compliant/certified systems? Is it
defined by each vendor? Is the format/system used by Promise
published anywhere?

Owing to the the sequential ocurrence of a number of circumstances
each of which was distinctly unlikely. I have the job of trying to 
read 120 GB of data from a 240 GB RAID 5 Array attached to
a Supertrak Sx6000 controller card. The software that handles
the raid is on the card's BIOS and so far as I know is proprietary.

I know that I need help because of the five disks making up the array
no fewer than three are recognised as 'free', that is, not part
of the array. I suspect that the data on these disks is fine, and
that the problem was a transient failure on one of the disks, followed
by a catastrophe. If I knew how, I would 'force' the controller to
use and resync those disks.

I suspect my job would be measurably easier and greatly eased if I could
use the standard Linux tools such as mkraid. See 
<URL: http://www.mail-archive.com/linux-raid@vger.rutgers.edu/msg07932.html >
which contains the highly optimistic suggestion:

	The problem was how to read using the Linux RAID 5 software, 
	the data written by Mylex controller. I wrote a few test 
	programs, and found that the Mylex AcceleRaid controller is 
	using what Linux software RAID calls right-asymmetric parity 
	algorithm (you will find the part of /etc/raidtab file I use, 
	at the end of this mail), so I could read the data using Linux 
	software RAID (mkraid --force --dangerous-no-resync /dev/md2). 

Is there something similar for the Sx6000? How can I find out?

Ben.
