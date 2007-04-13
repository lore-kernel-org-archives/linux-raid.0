From: Laurent CARON <lcaron@unix-scripts.info>
Subject: Re: Growing a raid 6 array
Date: Fri, 13 Apr 2007 10:15:05 +0200
Message-ID: <461F3C09.1030909@unix-scripts.info>
References: <45E72549.2080108@unix-scripts.info>	<Pine.LNX.4.64.0703011728270.7560@p34.internal.lan> <17895.34033.867599.954940@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17895.34033.867599.954940@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil Brown a =E9crit :
> On Thursday March 1, jpiszcz@lucidpixels.com wrote:
>> You can only grow a RAID5 array in Linux as of 2.6.20 AFAIK.
>=20
> There are two dimensions for growth.
> You can increase the amount of each device that is used, or you can
> increase the number of devices.
>=20
> You are correct that increasing the number of devices only works for
> RAID5 (and RAID1, but you don't get extra space) in 2.6.20 (RAID6
> coming in 2.6.21).
>=20
> However this question is about growing an array the first way:
> increasing the amount of space used on each devices, and that is
> supported for RAID1/4/5/6.
>=20
> And Laurent:
>   1/ Yes, it is that easy
>   2/ I doubt a nearly-full ext3 array increases the risk
>   3/ The effect of adding a bitmap is that if you suffer a crash whil=
e
>      the array is degraded, it will resync faster so you have less
>      exposure to multiple failure.

I just finished changing disks, growing the array, and then the filesys=
tem.

It worked flawlessy.

Just a little notice: I had to unmount my ext3 filesystem to be able to
resize it. (Took ~8 hours to fsck + resize the 15 disks array from 6 to
9TB on a dual Xeon with 4GB RAM).

Thanks

Laurent
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
