From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Thu, 24 Apr 2014 16:31:08 -0400
Message-ID: <CAK_KU4ZDi7qUNKft7+GH8mLcKG0yq1KBg6hn1DV9jgc=BN02tw@mail.gmail.com>
References: <20140424070548.445497dd@netstation>
	<20140424194832.2d0a867f@netstation>
	<CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com>
	<20140424203506.5fdee0d3@netstation>
	<CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail.com>
	<CAK_KU4aDDaUSGgcGBwCeO+yE0Qa_pUmMdAHMu7pqO7dqEEC71g@mail.gmail.com>
	<20140424215654.0447d300@netstation>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424215654.0447d300@netstation>
Sender: linux-raid-owner@vger.kernel.org
To: "L.M.J" <linuxmasterjedi@free.fr>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have been replying directly to you, not to the mailing list, since
your case seems to be a case of user-screwed-up-his-own-data, and not
a problem with mdadm/linux raid, nor a problem that will necessarily
help someone else (since it is not likely someone will create a mess
in exactly the same manner you have). Also, it is easier to click
reply than reply-all and have to worry about the top-posting police
getting on my case.

To summarize:
1) You lost a disk. Even down a disk, you should have been able to
run/start the array (in degraded mode) with only 2 disks, mounted the
filesystem, backed up data, etc.
2) You then should have simply partitioned and then --add 'ed the new
disk.   mdadm would have written a superblock to the new disk, and
resynced the data

Would have-- Could have-- Should have---

Hindsight is 20/20, a mistake was made, it happens to all of us at
some point or another, (I've lost arrays and filesystems with careless
use of 'dd' once upon a time; Once, I was giving a raid demo to a
friend with loop devices, mistyped something, and blew something else
away)



Unfortunately, you might have clobbered your drives by recreating the
array. I assume your original disks were in the order sdb, sdc, sdd.
If so, you certainly clobbered your superblocks and changed the order
when you did this:
> ~# mdadm -Cv /dev/md0 --assume-clean --level=5 --raid-devices=3 /dev/sdc1 /dev/sdd1 /dev/sdb1

You changed the order, but because of the assume-clean, it shouldn't
have started a resync of the data. Your file system probably had a fit
though, since your data was put effectively through a 3-piece
strip-type paper-shredder. You should be able to reorder things
though..

IMPORTANT: At any point did your drives do a resync?

Assuming no, and assuming you haven't done any other writing to your
disks(besides rewriting the superblocks), you can probably correct the
order of your drives by reissuing the --create command with the two
original drives, in the proper order, and the missing drive as the
placeholder. (This will rewrite the superblocks again, but hopefully
in the right order).
mdadm -Cv /dev/md0 --level=5 --raid-devices=3 missing /dev/sdc1 /dev/sdd1
Note, you need the 'missing' drive, so the raid calculates the missing
data, instead of reading chunks from a blank drive.

If you can start that array with 2 devices (it will be degraded with
only 2/3 drives) you should be able to mount and recover your data.
You may need to run a full fsck again since your last fsck probably
made a mess.

Assuming you can mount and copy your data, you can then --add your
'new' drive to the array with the --add argument. (Note, you'll have
to clear it's superblock or mdadm will object)
