From: mru@kth.se (=?iso-8859-1?q?M=E5ns_Rullg=E5rd?=)
Subject: Re: Hot adding active disk to RAID1?
Date: Sat, 07 Feb 2004 19:01:56 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1xekt67oq3.fsf@kth.se>
References: <20040207152948.GA17368@fscked.org> <20040207173716.GA10996@fscked.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Perry <mikepery@fscked.org> writes:

> Thus spake Mike Perry (mikepery@fscked.org):
>
>> Well, this is probably a FAQ, but I've really looked around..
>> Does anyone have any experience with using raidreconf for RAID1, or =
have
>> a way to hotadd a disk and have it become active, instead of being a
>> spare?
>
> Ok, in my impatience I grew some balls.. As it turns out, the RAID1
> superblock is (seemingly?) independent of the contents of the volume.=
 So
> I was able to simply mkraid --force /dev/md0, this time WITH a
> failed-disk directive. Once this was done, I was able to mount /dev/m=
d0
> right away, no reformatting or anything needed.

Yes, the superblock is written at the end of the disk.  Writing a
superblock doesn't touch the data.

> Then I hot-added the failed-disk, and it seems to be synching properl=
y.
>
> And also this time the failed-disk wasn't mirrored to immediately eit=
her
> (ie without the explicit hotadd).. I wonder why that happened the las=
t
> time I did this.. Maybe I just miswrote the raidtab on that occasion.=
=2E
> Or possibly the partition type was raid autodetect and after the rebo=
ot
> the md driver saw this and decided to start mirroring, regardless of
> raidtab?

I use mdadm for managing my RAID.  When creating a new array it lets
you specify "missing" instead of a device to create an array with
failed disks.  No risk of overwriting anything there.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
