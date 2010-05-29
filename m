From: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Subject: recovering from a controller failure
Date: Sat, 29 May 2010 14:07:51 -0500
Message-ID: <20100529190751.GM2167@flews.lairds.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Recently a drive failed on one of our file servers.  The machine has
three RAID6 arrays (15 1TB each plus spares).  I let the spare rebuild
and then started the process of replacing the drive.

Unfortunately I'd misplaced the list of drive IDs so I generated a new
list in order to identify the failed drive.  I used "smartctl" and made
a quick script to scan all 48 drives and generate pretty output.  That
was a mistake.  After running it a couple times one of the controllers
failed and several disks in the first array were failed.

I worked on the machine for awhile.  (It has an NFS root.)  I got some
information from it before it rebooted (via watchdog).  I've dumped all
of the information here.
	http://lairds.us/temp/ucmeng_md/

In mdstat_0 you can see the status of the arrays right after the
controller failure.  mdstat_1 shows the status after reboot.

sys_block shows a listing of the block devices so you can see that the
problem drives are on controller 1.

The examine_sd?1 files show -E output from each drive in md0.  Note that
the Events count is different for the drives on the problem controller.

I'd like to know if this is something I can recover.  I do have backups
but it's a huge pain to recover this much data.

Thank you.

--kyler
