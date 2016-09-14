From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 22:33:31 -0600
Message-ID: <CAJCQCtRdbWg7HgX=wghd8OBUcauiVfES6NSOKOZj38HMWVg65A@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
 <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com> <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Sep 13, 2016 at 2:04 PM, Daniel Sanabria <sanabria.d@gmail.com> wrote:

> [root@lamachine ~]# gdisk -l /dev/sdc
> GPT fdisk (gdisk) version 1.0.1
>
> Warning! Disk size is smaller than the main header indicates!

This is true...

> Disk /dev/sdc: 5860531055 sectors, 2.7 TiB
> First usable sector is 2048, last usable sector is 5860533134

The last usable sector LBA is bigger than the total number of LBAs. So
either there's a bug in whatever partitioned this or maybe the
partition map was copied from one disk to another somehow? Hard to
say, but it happened twice as sde has the exact same problem.

> [root@lamachine ~]# gdisk -l /dev/sde
> GPT fdisk (gdisk) version 1.0.1
>
> Warning! Disk size is smaller than the main header indicates!

> Disk /dev/sde: 5860531055 sectors, 2.7 TiB
> First usable sector is 2048, last usable sector is 5860533134

Pretty weird.  Any ideas how that happened? My guess is sdd was
partitioned first, and its partition was copied to sdc and sde, and
the tool blindly did not recompute the last usable sector LBA, it used
the value from sdd.

Anyway...

sdd1 is 2TB
sdd2 is 500MB

And it looks like sdc and sde, if we believe the backup GPT, have the
same exact partition scheme.

sdd1 has mdadm v1.2 metadata indicating it's a raid5 with two other
members, logically that means sdc1 and sde1 are the missing members
for md128.
sdd2 has mdadm v1.2 metadata indicating it's a raid0 with two other
members, logically that means sdc2 and sde2 are the missing members
for md129.

This is consistent with the metadata that's been found on sdd1 and
sdd2. So now the question is really how to go about fixing sdc and sde
partition tables, so that their partitions appear?

Weirdly enough the safest way to fix it is to replace the PMBR with a
conventional MBR with two primary partitions with start and end LBAs
just as gdisk shows them for sdc, sdd and sde. Why? Well, by spec,
even if you don't remove the GPT signatures, if an MBR is present and
is not a protective MBR, then it is supposed to be honored over the
GPT. That 'd let you keep the GPT untouched, and only alter the MBR
which right now doesn't contain any valuable information anyway. The
trick though is you need to use an old version of fdisk that won't
check for the GPT first; OR you can use wipefs to wipe the GPT
signatures only, and then use fdisk to create a new MBR (msdos disk
label it's sometimes called).

Hint with wipefs. First, use it with -n to see what it will do. And
then when you're ready to act, replace -n with -b which will create a
backup file for what it's wiping. The signature is a small amount of
data that's easily replaced and not unique to the table being wiped so
it's still possible to use the GPT later should it be necessary. i.e.
everything I'm describing is reversible.

wipefs -a -n /dev/sdc
wipefs -a -n /dev/sde

So what do you get for that?

When you get ready to use fdisk to create the new partitions, since
both use metadata 1.2, use 0xda as the partition type code (although
0x83 is OK also, 0xfd technically only applies to 0.9 metadata for
kernel autodetect).

Chances are you could just use gdisk to verify and fix the primary and
backup GPTs on sdc and sde, it looks like there's nothing in the
vicinity that'll get stepped on by doing this. But the above is one
part being strict about being able to reverse each step, and 1 part
ass covering.

When it's all done and working with the new MBR you can either leave
it alone, or you can run gdisk on it and it will immediately convert
it (in memory) and you can commit it to disk with the w command to go
back to GPT - which I personally prefer just because there are two
copies of everything, and each copy is separately checksummed.



-- 
Chris Murphy
