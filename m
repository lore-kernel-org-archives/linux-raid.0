From: "John Stoffel" <john@stoffel.org>
Subject: Re: Adding Latency To Disk Access
Date: Sat, 11 Feb 2006 23:20:37 -0500
Message-ID: <17390.46997.701250.780736@smtp.charter.net>
References: <dd43dcfb0602061349l437a69b8w365dc38dc5809682@mail.gmail.com>
	<43E7DF87.6060000@s5r6.in-berlin.de>
	<dd43dcfb0602070312r1349d555r5217a4e246b7be6@mail.gmail.com>
	<43E8A9B6.7040902@s5r6.in-berlin.de>
	<dd43dcfb0602110150t2a1b6018va55323e5801fdbae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dd43dcfb0602110150t2a1b6018va55323e5801fdbae@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Paul M." <paul@gpmidi.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Paul>   I am currently trying to build a RAID5 array across 12
Paul> disks. The problem is there is a bug in the linux firewire
Paul> drivers that is causes problems when multiple disks are accessed
Paul> randomly at the same time. 

With that number of disks, and that transport, why aren't you looking
at using RAID6 as well?  The rebuild time on RAID5 leaves a window
where a second failure could really mess you up.

Paul> As you can imagine the soft RAID5 drivers try to do exactly
Paul> that - access all 12 disks at once.  Can the software raid
Paul> drivers be made to only access one disk at a time and to wait
Paul> for a requested to be fulfilled before submitting another?

Kiss your system performance down the drain.  But you might be able to
make this work.  Have you tried:

1. the serialize_io=1 option to the SBP driver?

2. moving to USB2 instead?  I've never gotten my firewire enclosure to
   work with Linux.  Prolific Chipset.

3. Maybe tweak /sys/block/sd*/queue/nr_requests to be 1 for each
   device, so that you don't queue up too many commands to each disk.
   That way you can still run commands across all 12 disks, but only one
   per disk.

4. Do you have multiple firewire controllers as well?  That will help
   performance.  

Good luck, and let us know how it works out.  

Oh yeah, more details on your kernel version, MD setup, etc would be
helpful as well.

John
