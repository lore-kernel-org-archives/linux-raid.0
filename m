From: "John Stoffel" <john@stoffel.org>
Subject: Re: Recovering a RAID6 after all disks were disconnected
Date: Wed, 7 Dec 2016 09:31:26 -0500
Message-ID: <22600.7486.444800.536687@quad.stoffel.home>
References: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAOxFTczhq3Gr4WW=-sMamaYDmAoMFGh7kkanwJzhXe5NBdMHHQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Giuseppe> my situation is the following: I have a small 4-disk JBOD that I use
Giuseppe> to hold a RAID6 software raid setup controlled by mdraid (currently
Giuseppe> Debian version 3.4-4 on Linux kernel 4.7.8-1

Giuseppe> I've had sporadic resets of the JBOD due to a variety of reasons
Giuseppe> (power failures or disk failures —the JBOD has the bad habit of
Giuseppe> resetting when one disk has an I/O error, which causes all of the
Giuseppe> disks to go offline temporarily).

Please toss that JBOD out the window!  *grin*

Giuseppe>  When this happens, all the disks get kicked from the RAID,
Giuseppe> as md fails to find them until the reset of the JBOD is
Giuseppe> complete. When the disks come back online, even if it's just
Giuseppe> a few seconds later, the RAID remains in the failed
Giuseppe> configuration with all 4 disks missing, of course.

Giuseppe> Normally, the way I would proceed in this case is to unmount
Giuseppe> the filesystem sitting on top of the RAID, stop the RAID,
Giuseppe> and then try to start it again, which works reasonably well
Giuseppe> (aside from the obvious filesystem check that is often
Giuseppe> needed).

Giuseppe> The thing happened again a couple of days ago, but this time
Giuseppe> I tried re-adding the disks directly when they came back
Giuseppe> online, using mdadm -a and confident that since they _had_
Giuseppe> been recently part of the array, the array would actually go
Giuseppe> back to work fine —except that this is not the case when ALL
Giuseppe> disks were kicked out of the array! Instead, what happened
Giuseppe> was that all the disks were marked as 'spare' and the RAID
Giuseppe> would not assemble anymore.

Can you please send us the full details of each disk using the
command:

  mdadm -E /dev/sda1

Where of course 'a' and '1' depend on whether or not you are using
whole disk or partitioned disks for your arrays.

You might be able to just for the three spare disks (assumed in this
case to be sda1, sdb1, sdc1; but you need to be sure first!) to
assemble into a full array with:

 mdadm -A /dev/md50 /dev/sda1 /dev/sdb1 /dev/sdc1

And if that works, great.   If not, post the error message(s) you get
back.

Basically provide more details on your setup so we can help you.

John


Giuseppe> At this point I stopped everything and made a full copy of
Giuseppe> the RAID disks (lucky me, I had just bought a new JBOD for
Giuseppe> an upgrade, and a bunch of new disks, even if one of them is
Giuseppe> apparently defective so I have only been able to backup 3 of
Giuseppe> the 4 disks) and I have been toying around with ways to
Giuseppe> recover the array by playing on the copies I've made (I've
Giuseppe> set the original disks to readonly at the kernel level just
Giuseppe> to be sure).

Giuseppe> So now my situation is this, and I would like to know if there is
Giuseppe> something I can try to recover the RAID (I've made a few tests that I
Giuseppe> will describe momentarily). (I would like to know if there is any
Giuseppe> possibility for md to handle these kind of issue —all disks in a RAID
Giuseppe> going temporarily offline— more gracefully, which is likely needed for
Giuseppe> a lot of home setup where SATA is used instead of SAS).

Giuseppe> So one thing that I've done is to hack around the superblock in the
Giuseppe> disks (copies) to put back the device roles as they were (getting the
Giuseppe> information from the pre-failure dmesg output). (By the way, I've been
Giuseppe> using Andy's Binary Editor for the superblock editing, so if anyone is
Giuseppe> interested in a be.ini for mdraid v1 superblocks, including checksum
Giuseppe> verification, I'd be happy to share). Specifically, I've left the
Giuseppe> device number untouched, but I have edited the dev_roles array so that
Giuseppe> the slots corresponding to the dev_number from all the disks map to
Giuseppe> appropriate device roles.

Giuseppe> I can then assemble the array with only 3 of 4 disks (because I do not
Giuseppe> have a copy of the fourth, essentially) and force-run it. However,
Giuseppe> when I do this, I get two things:

Giuseppe> (1) a complaint about the bitmap being out of date (number of events
Giuseppe> too low by 3) and
Giuseppe> (2) I/O errors on logical block 0 (and the RAID data thus completely
Giuseppe> inaccessible)

Giuseppe> I'm now wondering about what I should try next. Prevent a resync by
Giuseppe> matching the event count with that of the bitmap (or conversely)? Try
Giuseppe> a different permutation of the roles? (I have triple-checked but who
Giuseppe> knows)? Try a different subset of disks? Try and recreate the array?

Giuseppe> Thanks in advance for any suggestion you may have,

Giuseppe> -- 
Giuseppe> Giuseppe "Oblomov" Bilotta
Giuseppe> --
Giuseppe> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
Giuseppe> the body of a message to majordomo@vger.kernel.org
Giuseppe> More majordomo info at  http://vger.kernel.org/majordomo-info.html
