From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Recovering RAID5 array
Date: Tue, 20 Jan 2004 02:22:25 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401200722.i0K7MTi03836@dns1.watkins-home.com>
References: <400CD0BF.2010808@upfrontsystems.co.za>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <400CD0BF.2010808@upfrontsystems.co.za>
To: 'Jean Jordaan' <jean@upfrontsystems.co.za>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Warning!  Don't create, you could lose data!  Use --assemble --force!!!!!!

In the future...  If you need to determine which disk is which.  Just dd
each disk to /dev/null, and note which disk has an access light on solid!
After you have done this to all of the good disks, then the 1 that is left
must be the bad disk.  Or trace the cables, and decode the jumpers!

Using dd to test a disk, seems like a good test for me.  I have been using
dd for years to verify that a disk works.  I am sure it is not a 100% test,
but is will find a read error!  Just dd a disk to /dev/null, any errors, bad
disk.  After the disk has been removed from your array you could determine
if the bad block(s) can be relocated by the drive.  To do this, dd another
disk to the bad disk.  If success, then do another read test of the "bad"
disk.  If success, then the bad blocks(s) have been relocated.  I wish the
OS or md could do something like this before the disk is dropped from the
array.  It would save a lot of problems.  In this case the bad block(s)
would be over-written with re-constructed data using the redundancy logic.

Also, I don't think a file system could cause a bad disk.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Jean Jordaan
Sent: Tuesday, January 20, 2004 1:55 AM
To: linux-raid@vger.kernel.org
Subject: Recovering RAID5 array

Hi all

I'm having a RAID week. It looks like 1 disk out of a
3-disk RAID5 array has failed. The array consists of
/dev/hda3 /dev/hdb3 /dev/hdc3 (all 40Gb)
I'm not sure which one is physically faulty. In an attempt
to find out, I did:
   mdadm --manage --set-faulty /dev/md0 /dev/hda3

The consequence of this was 2 disks marked faulty and no
way to get the array up again in order to use raidhotadd
to put that device back.

I'm scared of recreating superblocks and losing all my data.
So now I'm doing 'dd if=/dev/hdb3 of=/dev/hdc2' of all three
RAID partitions so that I can work on a *copy* of the data.

Then I aim to
mdadm --create /dev/md0 --raid-devices=3 --level=5 \
   --spare-devices=1 --chunk=64 --size=37111 \
   /dev/hda1 /dev/hda2 missing /dev/hdb1 /dev/hdb2

hda2 is a copy of the partition of the drive I'm currently
suspecting of failure. hdb2 is a blank partition.

I've been running Seagate's drive diagnostic software
overnight, and the old disks check out clean. This makes me
afraid that it's reiserfs corruption, not a RAID disk
failure :/

Does anyone here have any comments on what I've done so far,
or if there's anything better I can do next?

-- 
Jean Jordaan
http://www.upfrontsystems.co.za

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


