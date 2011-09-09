From: CoolCold <coolthecold@gmail.com>
Subject: Re: Bootable Raid-1
Date: Fri, 9 Sep 2011 12:59:01 +0400
Message-ID: <976829848.20110909125901@gmail.com>
References: <AANLkTikBM=BQ7Q3W7zX5o59i9DzDgqHMQvnxQoeXip6M@mail.gmail.com> <60.01.07087.808994D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <60.01.07087.808994D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 2, 2011 at 9:44 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:

Resending because 1st letter was not delivered.

<snip>
>>
>> grub2 work with raid1 boot partition and rootfs over mdadm raid1
>> i tested today (03:00 AM) on my ubuntu desktop
>
> =A0 =A0 =A0 =A0There wasn't really any question about that. =A0I've b=
een running
> RAID1 boots under GRUB2 for months. =A0Prior to that, it was RAID1 un=
der GRUB
> legacy. =A0RAID1 under GRUB legacy takes some finagling. =A0Under GRU=
B2 it
> should be straightforward as long as the partitioning is correct and =
one
> employs a 0.90 superblock for the /boot array.
>
Guys, basing on your experience, can you tell us, how does Grub2 react
on degraded raid? Does it respect md's point of view which disk is bad
and which is not? Does it cooperate well with mdadm in general?

Grub legacy was way easy, just setup on disk & read that disk, no raid
knowledge, no problems. I guess grub2 can be configured in that manner
too, but as it has raid/lvm/whatever support, may be give it a try...

I've got Debian Squeeze servers with grub2, without any mirroing, so
converting them into RAID1 system, wanna make it right.

--=20
Best regards,
[COOLCOLD-RIPN]

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
