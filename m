From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID6 ext3 problems
Date: Sun, 12 Feb 2012 09:31:40 -0800
Message-ID: <CAK2H+eerAkwup2UcAu2v=_4+=Bg_FBCqZmjGjmcLQA+2ozmvbg@mail.gmail.com>
References: <CAKXovctDQdiMWEdzh6Jg8OkEjXX5OHZ+hubFV-GRsc8S2QHohQ@mail.gmail.com>
	<CAKXovctARfGAkug=ZA0EYm1uB=V0_5BXWyNisVZYip0VBpJxtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKXovctARfGAkug=ZA0EYm1uB=V0_5BXWyNisVZYip0VBpJxtA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff W <jeff.welling@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 12, 2012 at 9:16 AM, Jeff W <jeff.welling@gmail.com> wrote:
> Hello to all!
> I've had a problem with my system that involves a RAID array with
> mdadm on Debian linux and the ext3 filesystem. My partition on the
> RAID array won't let me mount it anymore.
>
> I have/had a RAID6 array of 7 500GB drives, formatted as one large
> ext3 partition.=C2=A0 This array resided in a system that booted from=
 a
> separate 320GB hard drive, but recently that system drive bit the dus=
t
> and so was replaced. Upon reinstalling Debian on the system drive,
> `mdadm --assemble --scan` didn't assemble the RAID array as it had in
> times past, so I used 'fdisk -l' to find all the drives marked with
> 'fd' (Linux RAID) and manually did `mdadm --assemble /dev/md0
> /dev/sdc1...` with the names of all the fd-marked drives (a command
> I've also used to successfully assemble the array before). That
> attempt didn't work because it said one of the drives was busy, and
> I've determined after the fact that it was because I misread of
> misunderstood the output of the first time I ran `mdadm --assemble
> --scan` because it seems that it had in fact created two arrays, one
> of the arrays (md0) containing one of the drives and the other array
> (md1) containing the rest of the drives.=C2=A0 This confusing situati=
on had
> me concerned, I now know rightfully so, about data loss so I read the
> man page for mdadm and googled looking for a hint at how to
> troubleshoot or solve this, and I came across the `--examine` option
> which I used to look at each of the drives marked with Linux RAID. Al=
l
> of them except one, (sda1) had the same UID and what appeared to be
> the correct metadata for the RAID array I was trying to recover, so I
> tried assembling with the UID option which gave me an array with 5 ou=
t
> of 7 of the component drives. So, it had missed a drive -- sda1. If
> your wondering about the 7th drive, it didn't survive the move I went
> through just before this, but RAID6 documentation says it can sustain
> 2 drive failures and continue operating, and I have only sustained tw=
o
> drive failures right now. So unless one more drive dies, I should
> still be able to access that array -- correct me if I'm wrong?
> Anyway, after I got the 5 out of 7 drives in the array, I manually
> added the 6th drive, sda1 to the array and it began repairing itself.
> Phew, I thought, so I tried to mount the array, which I have done in
> the past and was successful, but not this time. This time it threw th=
e
> same error as before, mount couldn't detect the filesystem type
> because of some kind of superblock error.
>
> Now, it's probably self-evident at this point that I'm not an expert,
> but I'm hoping that you are and that you'll at least be able to tell
> me what I did wrong so as to avoid doing it again, and at best be abl=
e
> to tell me how I could recover my data.=C2=A0 At this point I'm confu=
sed
> about what happened and how I could have possibly gotten myself in
> this situation.=C2=A0 The RAID array wasn't assembled when I was
> reinstalling Debian so that shouldn't have been able to wipe the
> partition on the array, though it could have wiped sda1, but then, ho=
w
> did the partition/superblock on the RAID disappear...
> At present I've installed Ubuntu to the system drive, which in
> hindsight was not an intelligent move because now I don't know what
> version of mdadm I was using on Debian, though I was using 'stable'
> with no apt pinning. I'm running testdisk to analyze the drives, I wa=
s
> hoping it would be able to find a backup of the superblock but so far
> all it's finding is HFS partitions which doesn't seem promising.
>
> If anyone can shed any light on what I did wrong, if I encountered
> some kind of known bug or unintentionally did this myself through
> improper use of mdadm, any help at all would be hugely appreciated.
>
> Thanks in advance,
> Jeff.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml


Jeff,
   I suspect that you'll need to provide more technical info for the
heavy hitters to give good responses.

   If the devices are recognized by mdadm at all, and if you have
devices ala /dev/md3, etc., then minimally provide the response to a
command like

mdadm -D /dev/md3

   I've had devices recognized but not mounted in the past because the
machine name has changed on the reinstall, etc.

   If the md devices aren't even recognized then minimally try

mdadm -E /dev/sda3 (etc...)

to determine which partitions are part of the RAID, etc. and post back
some of that info.

HTH,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
