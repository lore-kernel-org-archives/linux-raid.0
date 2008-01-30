From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: Re: Help, big error, dd first GB of a raid:-/
Date: Wed, 30 Jan 2008 13:36:16 +0100
Message-ID: <47A06F40.9010705@cgv.tugraz.at>
References: <47A054D4.9030308@cgv.tugraz.at> <47A0696B.4030301@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A0696B.4030301@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Peter Rabbitson wrote:
> Lars Schimmer wrote:
>>
>> Hi!
>>
>> Due to a very bad idea/error, I zeroed my first GB of /dev/md0.
>> Now fdisk doesn't find any disk on /dev/md0.
>> Any idea on how to recover?
>>
>=20
> It largely depends on what is /dev/md0, and what was on /dev/md0.
> Provide very detailed info:
>=20
> * Was the MD device partitioned?
> * What filesystem(s) were residing on the array, what sizes, what ord=
er
> * What was each filesystem used for (mounted as what)

One large parttiton on /dev/md0 with ext3.

> Someone might be able to help at this point, however if you do not ha=
ve
> a backup - you are in very very deep trouble already.

I activate the backup right now - was OpenAFS with some RW volumes -
fairly easy to backup, but...
If it's hard to recover raid data, I recreate the raid and forget the
old data on it.

MfG,
Lars Schimmer
- --
- -------------------------------------------------------------
TU Graz, Institut f=C3=BCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHoG9AmWhuE0qbFyMRAnjOAJ4rMZR8eCjYkMinlQ8vxZTIiLuxWwCfe3zj
VihVxdjRnE8oc9BRq6hcaVQ=3D
=3Duzyt
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
