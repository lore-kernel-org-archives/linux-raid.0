From: David Greaves <david@dgreaves.com>
Subject: Re: Manually hacking superblocks
Date: Fri, 13 Apr 2007 11:23:28 +0100
Message-ID: <461F5A20.4010203@dgreaves.com>
References: <461F3B2B.4030006@trn.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <461F3B2B.4030006@trn.iki.fi>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TGFzc2UgS8Okcmtrw6RpbmVu?= <tronic+owm8@trn.iki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lasse K=C3=A4rkk=C3=A4inen wrote:
> I managed to mess up a RAID-5 array by mdadm -adding a few failed dis=
ks
> back, trying to get the array running again. Unfortunately, -add didn=
't
> do what I expected, but instead made spares out of the failed disks. =
The
> disks failed due to loose SATA cabling and the data inside should be
> fairly consistent. sdh failed a bit earlier than sdd and sde, so I
> expect to be able to revocer by building a degraded array without sdh
> and then syncing.
>=20
> The current situation looks like this:
>       Number   Major   Minor   RaidDevice State
>    0     0       8       33        0      active sync   /dev/sdc1
>    1     1       0        0        1      faulty removed
>    2     2       8       97        2      active sync   /dev/sdg1
>    3     3       8      129        3      active sync   /dev/sdi1
>    4     4       0        0        4      faulty removed
>    5     5       8       81        5      active sync   /dev/sdf1
>    6     6       0        0        6      faulty removed
>    7     7       8      177        7      spare
>    8     8       8      161        8      spare
>    9     9       8      145        9      spare
>=20
> ... and before any of this happened, the configuration was:
>=20
> disk 0, o:1, dev:sdc1
> disk 1, o:1, dev:sde1
> disk 2, o:1, dev:sdg1
> disk 3, o:1, dev:sdi1
> disk 4, o:1, dev:sdh1
> disk 5, o:1, dev:sdf1
> disk 6, o:1, dev:sdd1
>=20
> I gather that I need a way to alter the superblocks of sde and sdd so
> that they seem to be clean up-to-date disks, with their original disk
> numbers 1 and 6. A hex editor comes to mind, but are there any better
> tools for that?

You don't need a tool.
mdadm --force will do what you want.

Read the archives and the man page.

You are correct to assemble the array with a missing disk (or 2 missing=
 disks
for RAID6) - this prevents the kernel from trying to sync. Not syncing =
is good
because if you do make a slight error in the order, you can end up sync=
ing bad
data over good.

I *THINK* you should try something like (untested):
mdadm --assemble /dev/md0 --force /dev/sdc1 /dev/sde1 /dev/sdg1 /dev/sd=
i1
missing /dev/sdf1 /dev/sdf1

The order is important and should match the original order.
There's more you could do by looking at device event counts (--examine)

Also you must do a READ-ONLY mount the first time you mount the array -=
 this
will check the consistency and avoid corruption if you get the order wr=
ong.

I really must get around to setting up a test environment so I can chec=
k this
out and update the wiki...

I have to go out or a couple of hours. Let me know how it goes if you c=
an't wait
for me to get back.

David
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
