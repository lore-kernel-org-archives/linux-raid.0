From: David Greaves <david@dgreaves.com>
Subject: Re: Two Drive Failure on RAID-5
Date: Tue, 20 May 2008 10:14:18 +0100
Message-ID: <4832966A.3010707@dgreaves.com>
References: <loom.20080519T224713-779@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20080519T224713-779@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cry wrote:
> Folks,
> 
> I had a drive fail on my 6 drive raid-5 array.  while syncing in the replacement
> drive (11 percent complete) a second drive went bad.
> 
> Any suggestions to recover as much data as possible from the array?

Let us know if any step fails...

How valuable is your data - if it is very valuable and you have no backups then
you may want to seek professional help.

The replacement drive *may* help to rebuild up to 11% of your data in the event
that the bad drive fails completely. You can keep it to one side to try this if
you get really desperate.

Assuming a real drive hardware failure (smartctl shows errors and dmesg showed
media errors or similar).

I would first suggest using ddrescue to duplicate the 2nd failed drive onto a
spare drive (the replacement is fine if you want to risk that <11% of
potentially saved data - a new drive would be better - you're going to need a
new one anyway!)

SOURCE is the 2nd failed drive
TARGET is it's replacement

blockdev --getra /dev/SOURCE <note the readahead value>
blockdev --setro /dev/SOURCE
blockdev --setra  0 /dev/SOURCE
ddrescue /dev/SOURCE /dev/TARGET /somewhere_safe/logfile

Note, Janos Haar recently (18/may) posted a more conservative approach that you
may want to use. Additionally you may want to use a logfile

ddrescue lets you know how much data it failed to recover. If this is a lot then
you may want to read up on the ddrescue info page (includes a tutorial and lots
of explanation) and consider drive data recovery tricks such as drive cooling
(which some sources suggest may cause more damage than they solve but has worked
for me in the past).

I have also left ddrescue running overnight against a system that repeatedly
timed-out and in the morning I've had a *lot* more recovered data.

Having *successfully* done that you can re-assemble the array using the 4 good
disks and the newly duplicated one.

unless you've rebooted:
blockdev --setrw /dev/SOURCE
blockdev --setra  <saved readahead value> /dev/SOURCE

mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1

cat /proc/mdstat will show the drive status
mdadm --detail /dev/md0
mdadm --examine /dev/sd[abcdef]1 [components]

Should all show a reasonably healthy but degraded array.

This should now be amenable to a read-only fsck/xfs_repair/whatever.

If that looks reasonable then you may want to do a proper fsck, perform a backup
and add a new drive.

HTH - let me know if any steps don't make sense; I think its about time I put
something on the wiki about data-recovery...

David

