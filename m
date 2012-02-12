From: Jeff W <jeff.welling@gmail.com>
Subject: RAID6 ext3 problems
Date: Sun, 12 Feb 2012 12:16:04 -0500
Message-ID: <CAKXovctARfGAkug=ZA0EYm1uB=V0_5BXWyNisVZYip0VBpJxtA@mail.gmail.com>
References: <CAKXovctDQdiMWEdzh6Jg8OkEjXX5OHZ+hubFV-GRsc8S2QHohQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKXovctDQdiMWEdzh6Jg8OkEjXX5OHZ+hubFV-GRsc8S2QHohQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello to all!
I've had a problem with my system that involves a RAID array with
mdadm on Debian linux and the ext3 filesystem. My partition on the
RAID array won't let me mount it anymore.

I have/had a RAID6 array of 7 500GB drives, formatted as one large
ext3 partition.=A0 This array resided in a system that booted from a
separate 320GB hard drive, but recently that system drive bit the dust
and so was replaced. Upon reinstalling Debian on the system drive,
`mdadm --assemble --scan` didn't assemble the RAID array as it had in
times past, so I used 'fdisk -l' to find all the drives marked with
'fd' (Linux RAID) and manually did `mdadm --assemble /dev/md0
/dev/sdc1...` with the names of all the fd-marked drives (a command
I've also used to successfully assemble the array before). That
attempt didn't work because it said one of the drives was busy, and
I've determined after the fact that it was because I misread of
misunderstood the output of the first time I ran `mdadm --assemble
--scan` because it seems that it had in fact created two arrays, one
of the arrays (md0) containing one of the drives and the other array
(md1) containing the rest of the drives.=A0 This confusing situation ha=
d
me concerned, I now know rightfully so, about data loss so I read the
man page for mdadm and googled looking for a hint at how to
troubleshoot or solve this, and I came across the `--examine` option
which I used to look at each of the drives marked with Linux RAID. All
of them except one, (sda1) had the same UID and what appeared to be
the correct metadata for the RAID array I was trying to recover, so I
tried assembling with the UID option which gave me an array with 5 out
of 7 of the component drives. So, it had missed a drive -- sda1. If
your wondering about the 7th drive, it didn't survive the move I went
through just before this, but RAID6 documentation says it can sustain
2 drive failures and continue operating, and I have only sustained two
drive failures right now. So unless one more drive dies, I should
still be able to access that array -- correct me if I'm wrong?
Anyway, after I got the 5 out of 7 drives in the array, I manually
added the 6th drive, sda1 to the array and it began repairing itself.
Phew, I thought, so I tried to mount the array, which I have done in
the past and was successful, but not this time. This time it threw the
same error as before, mount couldn't detect the filesystem type
because of some kind of superblock error.

Now, it's probably self-evident at this point that I'm not an expert,
but I'm hoping that you are and that you'll at least be able to tell
me what I did wrong so as to avoid doing it again, and at best be able
to tell me how I could recover my data.=A0 At this point I'm confused
about what happened and how I could have possibly gotten myself in
this situation.=A0 The RAID array wasn't assembled when I was
reinstalling Debian so that shouldn't have been able to wipe the
partition on the array, though it could have wiped sda1, but then, how
did the partition/superblock on the RAID disappear...
At present I've installed Ubuntu to the system drive, which in
hindsight was not an intelligent move because now I don't know what
version of mdadm I was using on Debian, though I was using 'stable'
with no apt pinning. I'm running testdisk to analyze the drives, I was
hoping it would be able to find a backup of the superblock but so far
all it's finding is HFS partitions which doesn't seem promising.

If anyone can shed any light on what I did wrong, if I encountered
some kind of known bug or unintentionally did this myself through
improper use of mdadm, any help at all would be hugely appreciated.

Thanks in advance,
Jeff.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
