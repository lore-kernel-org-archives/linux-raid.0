From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: which raid level gives maximum overall speed? (raid-10,f2 vs. raid-0)
Date: Thu, 31 Jan 2008 02:55:07 +0100
Message-ID: <20080131015506.GB6617@rap.rap.dk>
References: <20080130192133.17b254bf@szpak> <20080130220007.GG20173@rap.rap.dk> <20080130233639.5d46b044@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080130233639.5d46b044@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 30, 2008 at 11:36:39PM +0100, Janek Kozicki wrote:
> Keld J=F8rn Simonsen said:     (by the date of Wed, 30 Jan 2008 23:00=
:07 +0100)
>=20
> > Teoretically, raid0 and raid10,f2 should be the same for reading, g=
iven the
> > same size of the md partition, etc. For writing, raid10,f2 should b=
e half the speed of
> > raid0. This should go both for sequential and random read/writes.
> > But I would like to have real test numbers.=20
>=20
> Me too. Thanks. Are there any other raid levels that may count here?
> Raid-10 with some other options?

Given that you want maximum thruput for both reading and writing, I
think there is only one way to go, that is raid0.

All the raid10's will have double time for writing, and raid5 and raid6
will also have double or triple writing times, given that you can do
striped writes on the raid0.=20

=46or random and sequential writing in the normal case (no faulty disks=
) I would
guess that all of the raid10's, the raid1 and raid5 are about equally f=
ast, given the
same amount of hardware.  (raid5, raid6 a little slower given the
unactive parity chunks).

=46or random reading, raid0, raid1, raid10 should be equally fast, with
raid5 a little slower, due to one of the disks virtually out of
operation, as it is used for the XOR parity chunks. raid6 should be=20
somewhat slower due to 2 non-operationable disks. raid10,f2 may have a
slight edge due to virtually only using half the disk giving better
average seek time, and using the faster outer disk halves.

=46or sequential reading, raid0 and raid10,f2 should be equally fast.
Possibly raid10,o2 comes quite close. My guess is that raid5 then is
next, achieving striping rates, but with the loss of one parity drive,
and then raid1 and raid10,n2 with equal performance.

In degraded mode, I guess for random read/writes the difference is not
big between any of the raid1, raid5 and raid10 layouts, while sequentia=
l
reads will be especially bad for raid10,f2 approaching the random read
rate, and others will enjoy the normal speed of the above filesystem
(ext3, reiserfs, xfs etc).

Theory, theory theory. Show me some real figures.

Best regards
Keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
