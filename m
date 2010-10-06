From: Peter Zieba <pzieba@networkmayhem.com>
Subject: Raid 6 - TLER/CCTL/ERC
Date: Wed, 6 Oct 2010 00:51:36 -0500 (CDT)
Message-ID: <556404795.674.1286344296358.JavaMail.root@mail.networkmayhem.com>
References: <904330941.660.1286340548064.JavaMail.root@mail.networkmayhem.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <904330941.660.1286340548064.JavaMail.root@mail.networkmayhem.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey all,

I have a question regarding Linux raid and degraded arrays.

My configuration involves:
 - 8x Samsung HD103UJ 1TB drives (terrible consumer-grade)
 - AOC-USAS-L8i Controller
 - CentOS 5.5 2.6.18-194.11.1.el5xen (64-bit)
 - Each drive has one maximum-sized partition.
 - 8-drives are configured in a raid 6.

My understanding is that with a raid 6, if a disk cannot return a given sector, it should still be possible to get what should have been returned from the first disk, from two other disks. My understanding is also that if this is successful, this should be written back to the disk that originally failed to read the given sector. I'm assuming that's what a message such as this indicates:
Sep 17 04:01:12 doorstop kernel: raid5:md0: read error corrected (8 sectors at 1647989048 on sde1)

I was hoping to confirm my suspicion on the meaning of that message.

On occasion, I'll also see this:
Oct  1 01:50:53 doorstop kernel: raid5:md0: read error not correctable (sector 1647369400 on sdh1).

This seems to involved the drive being kicked from the array, even though the drive is still readable for the most part (save for a few sectors).

What exactly is the criteria for a disk being kicked out of an array?

Furthermore, if an 8-disk raid 6 is running on the bare-minimum 6-disks, why on earth would it kick any more disks out? At this point, doesn't it makes sense to simply return an error to whatever tried to read from that part of the array instead of killing the array?

In other words, I would rather be able to read from a degraded raid-6 using something like dd with "conv=sync,noerror" (as I would be able to expect with a single disk with some bad sectors),
than have it kick out the last drive that it can possibly run on, and die completely. Is there a good reason for this behavior?

Finally, why do the kernel messages that all say "raid5:" when it is clearly a raid 6?:
<snip>
[root@doorstop log]# cat /proc/mdstat
Personalities : [raid0] [raid6] [raid5] [raid4]

md0 : active raid6 sdc1[8](F) sdf1[7] sde1[6] sdd1[5] sda1[3] sdb1[1]
      5860559616 blocks level 6, 64k chunk, algorithm 2 [8/5] [_U_U_UUU]

unused devices: <none>
</snip>

As for intimate details about the behavior of the drives themselves, I've noticed the following:
 - Over time, each disk develops a slowly increasing number of "Current_Pending_Sector" (ID 197).
 - The pending sector count returns to zero if a disk is removed from an array and filled with /dev/zero, or random data.
   - Interestingly, on some occasions, the pending sector count did not return to zero after wiping the partition i.e. /dev/sda1.
   - It did, however, return to zero when wiping the entire disk (/dev/sda)
   - I had a feeling that this was the result of the drive "reading ahead", into the small area of unusable space after the first partition, and before the end of the disk, and then making note of this in SMART, but not necessarily causing a noticeable problem, as the sector was never actually requested by the kernel.
   - I dd'd just that part of the drive, and the pending sectors went away in those cases
 - I have on rare occasion had these drives go completely bad before (i.e., there were non-zero values for either "Reallocated_Event_Count", "Reallocated_Sector_Ct", or "Offline_Uncorrectable" (#196, #5, #198, respectively), and the drive seemed unwilling to read any sectors. These were RMA'd.
 - As for the other drives, again, pending sectors do crop up, and always disappear when written to. I do not consider these drives bad. Flaky, sure. Slow to respond on error? Almost undoubtedly.

Finally, I should mention that I have tried the smartctl erc commands:
http://www.csc.liv.ac.uk/~greg/projects/erc/

I could not pass them through the controller I was using, but was able to connect the drives to the controller on the motherboard, set the erc values, and still have drives dropping out.

As a terrible band-aid, if I make sure to remove a drive when I see pending sectors, nuke it with random data (or /dev/zero), and resync the array, I get the drive pending sector count to return to zero and the array is happy. Once I have too many drives with pending sectors, however, a resync is almost guaranteed to fail, and I end up having to copy my data off and rebuild the array.

Instead of scripting the above (which sadly, I have done), is there any hope of saving the investment in disks? I have a feeling that this is simply something hitting a timeout, and likely causing problems for many more than just myself.

I greatly appreciate the time taken to read this, and any feedback provided.

Thank you,
Peter Zieba
312-285-3794
