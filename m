From: "Kenn" <kenn@kenn.us>
Subject: Recovering from a Bad Resilver?
Date: Sun, 25 Sep 2011 22:40:49 -0700
Message-ID: <cad701ba2d655d91986b73b84b65e1f5.squirrel@www.maxstr.com>
Reply-To: kenn@kenn.us
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I managed to get mdadm to resilver the wrong drive of a 5-drive RAID5
array.  I stopped the resilver at less than 1% complete but the damage is
done, the drive won't mount and fsck -n spits out a zillion errors.  I'm
in the process of purchasing two 2T drives to dd a copy of the array to
attempt to recover the files.  Here's what I plan to do:

(1) fsck a copy of the drive.  Who knows.
(2) Run photorec on the entire drive, and use the md5sum checksums of the
files to recover their filenames (I had a cron process run md5sum against
the raid5 and I have a 2010 copy of the drive's output)

Both options seem sucky.  Only 1% of the drive should be corrupt.  Any
other ideas?

Thanks,
Kenn

P.S.  Details:

/dev/md3 is a 5 x WD 750G in a raid5 array - /dev/hde1 /dev/hdi1 /dev/sde1
/dev/hdk1 /dev/hdg1

/dev/sde dropped out.  From a loose sata cable was my guess, since it
wasn't seated fully.  And I ran a full smartctl -t offline /dev/sde and it
found and marked 37 unreadable sectors, and I decided to try out the drive
again before replacing it.

I added /dev/sde1 back into the array and it resilvered over the next day.
 Everything was fine for a couple days.

Then I decided to fsck my array just for good measure.  It wouldn't
unmount.  I thought sde was the issue so I tried to remove it from the
array via remove and then fail, but /proc/mdstat wouldn't show it out of
the array.  So I removed my array from fstab and rebooted, and then sde
was out of the array and the array was unmounted.

I wanted to force another resilver on sde, so I used fdisk to delete sde's
raid partition and create two small partitions, used newfs to format them
as ext3, then deleted them, and re-created an empty partition for sde's
raid partition.  Then I used --zero-superblock to get rid of sde's raid
info.  The resilver on this new sde was supposed to test if the drive was
fully working or needed replacement.

Then I added sde back into the array. I stopped the array, and recreated
it and this is probably where I went wrong.  First I tried:

# mdadm --create /dev/md3 --level=5 --raid-devices=5  /dev/hde1 /dev/hdi1
missing /dev/hdk1 /dev/hdg1

and this worked fine.  Note the sde1 is marked as missing still.  This
mounted and unmounted fine.  So I stopped the array and added sde1 back
in:

mdadm --create /dev/md3 --level=5 --raid-devices=5  /dev/hde1 /dev/hdi1
/dev/sde1 /dev/hdk1 /dev/hdg1

This started up the array .. but /proc/mdstat showed a non-sde1 drive as
out of the array and a resilvering process running.  OH NO!  So I stopped
the array, and tried to recreate it with sde1 as missing:

# mdadm --create /dev/md3 --level=5 --raid-devices=5  /dev/hde1 /dev/hdi1
missing /dev/hdk1 /dev/hdg1

It created, but the array wont mount and fsck -n says lots of nasty things.

I don't have a 3 Terrabyte drive handy, and my motherboard won't support
drives over 2T, so I'm gonna purchase two 2T's, raid0 them, and then see
what I can recover out of my failed /dev/md3.

