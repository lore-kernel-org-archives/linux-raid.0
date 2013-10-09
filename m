From: Guillaume Betous <guillaume.betous@gmail.com>
Subject: Re: RAID 5 : recovery after failure
Date: Wed, 9 Oct 2013 10:54:09 +0200
Message-ID: <CAPbD+Ret3-2M1ir=0G5YP9VdGBptMAPLzCZRFga0jjv0Y6aEhQ@mail.gmail.com>
References: <CAPbD+Repm2SDpCGsR35QbW9Zq-MiCu1Fsdh4jjP_yESE3E3Exg@mail.gmail.com>
	<20131008210603.GA22876@cthulhu.home.robinhill.me.uk>
	<CAPbD+Re5TogdCTWabxoch77zzSRFfZhzuxAF=+UVn_ND2+R-3w@mail.gmail.com>
	<alpine.DEB.2.02.1310090853060.20065@uplift.swm.pp.se>
	<CAPbD+Rd2Ouvh0crZgujrkqTr2kCNPkQ25D3f7q96eQFDb__ddw@mail.gmail.com>
	<alpine.DEB.2.02.1310091022560.20065@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1310091022560.20065@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Here is the 2nd message I received.
=46or now my RAID has restarted with only sdc, sde and sdf.

I don't know if /dev/sdb is still usable, or if this was only a
desynchro failure.
How to know ?

-----------------------------------------------------------------------=
-------------------

This is an automatically generated mail message from mdadm
running on sam

A FailSpare event had been detected on md device /dev/md127.

It could be related to component device /dev/sdb1.

=46aithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md127 : active raid5 sde1[2] sdb1[5](F) sdc1[0](F) sdd1[6] sdf1[4]
      5860535808 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/2=
] [__UU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>........]  recovery =3D 62.=
0%
(1212358192/1953511936) finish=3D854.7min speed=3D14451K/sec

2013/10/9 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Wed, 9 Oct 2013, Guillaume Betous wrote:
>
>> Now, should I add the other drives ? How ?
>
>
> Depends on what the problem is.
>
> Is the initial drive that failed now totally unusable?
>
> In that case, just do mdadm --manage /dev/md0 --add /dev/sd<whatever>=
 with a
> new drive.
>
> But you said you received a second error, was this a read error on on=
e of
> good working drive (see other threads in archive) and so you don't ha=
ve any
> read errors (the information on those bad sectors will now be lost), =
then
> you can resync properly.
>
> I strongly recommend going to RAID6 to solve this problem in the futu=
re.
>
> I recommend having
>
> for x in /sys/block/sd[a-z] ; do echo 180 > $x/device/timeout ; done
>
> in rc.local (or equivalent) to make sure you can handle timeouts prop=
erly
> even for consumer drives.
>
>
> --
> Mikael Abrahamsson    email: swmike@swm.pp.se



--=20
Pour la sant=E9 de votre ordinateur, pr=E9f=E9rez les logiciels libres.
Lire son mail : http://www.mozilla-europe.org/fr/products/thunderbird/
Browser le web : http://www.mozilla-europe.org/fr/products/firefox/
Suite bureautique : http://www.libreoffice.org/download/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
