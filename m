From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: which raid level gives maximum overall speed? (raid-10,f2 vs.
 raid-0)
Date: Thu, 31 Jan 2008 15:01:58 +0100
Message-ID: <20080131150158.5b70aaf2@szpak>
References: <20080130192133.17b254bf@szpak>
	<20080130220007.GG20173@rap.rap.dk>
	<20080130233639.5d46b044@szpak>
	<20080131015506.GB6617@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080131015506.GB6617@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=C3=B8rn Simonsen said:     (by the date of Thu, 31 Jan 2008 02:5=
5:07 +0100)

> Given that you want maximum thruput for both reading and writing, I
> think there is only one way to go, that is raid0.
>=20
> All the raid10's will have double time for writing, and raid5 and rai=
d6
> will also have double or triple writing times, given that you can do
> striped writes on the raid0.=20
>=20
> For random and sequential writing in the normal case (no faulty disks=
) I would
> guess that all of the raid10's, the raid1 and raid5 are about equally=
 fast, given the
> same amount of hardware.  (raid5, raid6 a little slower given the
> unactive parity chunks).
>=20
> For random reading, raid0, raid1, raid10 should be equally fast, with
> raid5 a little slower, due to one of the disks virtually out of
> operation, as it is used for the XOR parity chunks. raid6 should be=20
> somewhat slower due to 2 non-operationable disks. raid10,f2 may have =
a
> slight edge due to virtually only using half the disk giving better
> average seek time, and using the faster outer disk halves.
>=20
> For sequential reading, raid0 and raid10,f2 should be equally fast.
> Possibly raid10,o2 comes quite close. My guess is that raid5 then is
> next, achieving striping rates, but with the loss of one parity drive=
,
> and then raid1 and raid10,n2 with equal performance.
>=20
> In degraded mode, I guess for random read/writes the difference is no=
t
> big between any of the raid1, raid5 and raid10 layouts, while sequent=
ial
> reads will be especially bad for raid10,f2 approaching the random rea=
d
> rate, and others will enjoy the normal speed of the above filesystem
> (ext3, reiserfs, xfs etc).


Wow! Thanks for detailed explanations.=20

I was thinking that maybe raid10 on 4 drives could be faster than
raid0. But now it's all logical for me. With 4 drives and raid10,f2
I could get an "extra" reading speed, but not the writing speed. Makes
a lot of sense.

Perhaps it should be added to linux-raid wiki? (and perhaps a
=46AQ there - isn't a question about speed a frequent one?)

  http://linux-raid.osdl.org/index.php/Main_Page =20


> Theory, theory theory. Show me some real figures.

yes... that would be great if someone could spend some time
benchmarking all possible configurations :-)

thanks for your help!
--=20
Janek Kozicki
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
