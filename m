From: "William L. Thomson Jr." <wltjr@gentoo.org>
Subject: Re: mdadm file system type check
Date: Sat, 17 Mar 2007 14:50:10 -0400
Message-ID: <1174157410.17181.7.camel@wlt.obsidian-studios.com>
References: <1174089424.22511.26.camel@wlt.obsidian-studios.com>
	 <17915.17571.333717.668140@notabene.brown>
	 <1174099334.13073.46.camel@wlt.obsidian-studios.com>
	 <45FC2F2B.7070506@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7STi5aXkTRBYynTtnY6n"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45FC2F2B.7070506@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-7STi5aXkTRBYynTtnY6n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-03-17 at 13:10 -0500, Bill Davidsen wrote:
>
> First, please learn the difference between file system type (user data=20
> ON the device), and partition type (a byte in the partition table).

Which it's technical name would be a partition system ID. However older
versions of fdisk did refer to the t option as file system type.
http://www.redhat.com/docs/manuals/linux/RHL-7.3-Manual/ref-guide/s1-filesy=
stem-ext3-create.html

Given it's quite old and all newer docs refer to it mainly as partition
system id. At least that's what's shown in current fdisks

t   change a partition's system id

Sorry for the miss-clarification. For the record, simply changing the
partitions system id from 83 -> fd allowed the commands that previously
failed to succeed and create the array.

> Second, mdadm cares not a bit about the partition type,

That would be my understanding of it so far, and experience with it.

>  although some=20
> init scripts might.

FYI, this was a new install running on a livecd. So no init scripts were
involved.

>  The reason it didn't work was because the partition=20
> was zero size or missing, and would not work regardless of the partition=20
> type.

Negative, it's one of the things I suggested for them to take a look at.
Even provided the snippet of the IRC log that I left out containing that
information in another post. To save you from having to dig it out. Here
it is again :)

wltjr: kingtaco|work: likely something else, partition off, wrong fs type, =
or etc
kingtaco|work: /dev/sda1 1 17 136521 83 Linux
kingtaco|work: /dev/sdb1 1 17 136521 83 Linux

Also I really would not be reporting this, or wasting any one's time if
it was not something abnormal. Thus reporting it, and my
miss-clarification of stuff surely did not help explain the situation :)

--=20
William L. Thomson Jr.
Gentoo/Java

--=-7STi5aXkTRBYynTtnY6n
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBF/DhiPrChP8zZLyYRAvGTAJ0aJfnralMdY+ldrM8mMaWKGL0QggCg1SFQ
XsLSEnrY1HdR1vtMc1h+45Y=
=SVTC
-----END PGP SIGNATURE-----

--=-7STi5aXkTRBYynTtnY6n--

