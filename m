From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 crashed, need comments on possible repair solution
Date: Tue, 24 Apr 2012 07:00:44 +1000
Message-ID: <20120424070044.707745b8@notabene.brown>
References: <4F955F80.80903@evilazrael.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n3HcVy=VI=JbrhtLJXGOhJV"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F955F80.80903@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/n3HcVy=VI=JbrhtLJXGOhJV
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Apr 2012 15:56:16 +0200 Christoph Nelles
<evilazrael@evilazrael.de> wrote:

> Hi,
>=20
> Linux RAID worked for me fine in the last few years, but yesterday while
> reorganizing the HW in my server the RAID5 crashed. It was a
> Software-RAID Level 5 with 6x 3TB drives and ran XFS on top of it. I
> have no idea why it crashed, but now all superblocks are invalid (one
> dump follows) and sadly i have no information on the raid disk layout
> (in which sequence the drives were). All drives from the raid are
> available and running.
>=20
> As i cannot afford to buy 6x more drives for making a backup prior
> trying to fix the situation, i need a non-destructive approach to fix
> the RAID configuration and the superblocks.
>=20
> >From my understanding of the RAID5 implementation the correct order of
> drives is important.
>=20
> First Question:
> 1) Am i right that the order is important and i have to try to find the
> right sequence of drives?
>=20
> So i would create a loop over all permutations of the drive list and for
> each permutation:
> - Scrub the Superblock mdadm --zero-superblock /dev/sd[bcdefg]1
> - Recreate the RAID5 mdadm --create /dev/md0 -c 64 -l 5 \
> 	-n 6 --assume-clean <drive permutation>
> - Run xfs_check to see if it recognizes the FS xfs_check -s /dev/md0
> - Stop the RAID mdadm --stop /dev/md0
>=20
> 2) Is that a promising approach to repair the RAID5 array?
> 3) According the man page the --assume-cleanthat no data is affected
> unless you write to the array, so this effectively prevents a rebuild?
> This is important for me, as i don't want to trigger a rebuild as this
> will certainly send my data to hell.
> 4) Any other idea for repairing the RAID without loosing user data?
>=20
> Thanks in advance for any answers.
>=20
>=20
> Currently the RAID superblocks on each device look like this:
>=20
> /dev/sdg1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 53a294b5:975244fc:343b0f94:16652fce
>            Name : grml:0
>   Creation Time : Fri Apr 15 20:55:52 2011
>      Raid Level : -unknown-
>    Raid Devices : 0
>=20
>  Avail Dev Size : 5860529039 (2794.52 GiB 3000.59 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 9688dc72:02140045:c16a2123:4f6cc006
>=20
>     Update Time : Sun Apr 22 23:56:14 2012
>        Checksum : 350d8d74 - correct
>          Events : 1
>=20
>=20
>    Device Role : spare
>    Array State :  ('A' =3D=3D active, '.' =3D=3D missing)
>=20
>=20
> Interestingly at the Update Time the system should have been shut down:
> Apr 22 23:55:55 router init: Switching to runlevel: 0
> [...]
> Apr 22 23:56:03 router exiting on signal 15
> Apr 22 23:59:21 router syslogd 1.5.0: restart.
>=20
> I have really no clue what happened.

This is really worrying.  It's about the 3rd or 4th report recently which
contains:

>      Raid Level : -unknown-
>    Raid Devices : 0

and that should not be possible.  There must be some recent bug that causes
the array to be "cleared" *before* writing out the metadata - and that shou=
ld
be impossible.
What kernel are you running?

You are correct that order is important.  Your algorithm looks good.
However I suggest that you first look through your system looks to see if

  RAID conf printout:

appears at all.  That could contain the device order.

NeilBrown


--Sig_/n3HcVy=VI=JbrhtLJXGOhJV
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5XC/Dnsnt1WYoG5AQLiFw/+JTu0dK/JPhOtVj52U8rYkOrdV/whHGn0
z+yzfYFO8idIHOgCC593g4Rare1FC/Y46yZbPT7Ty0ndByMlXP1xXYDT0MOcbyA9
7tvrkZcQ3S8OT6Vh5/ZmUk6wjvxq40ylFhQHxPxJ3IT8qPFOdt+R1Sjnh3T/nODy
c1XcGFd76QoXAaGk/nUH2ypA0c+No5EB4hi1FSdlTwpHmAJSanqLVQY1lEMyWgmZ
aPa6lXDwi5kRRr2RppIxPIhA0s81+L8POcuN5sjiHTf1QvwH/UpXprSNGXKdWKLw
x4YHoojnvsogGVAhEDO/bFc+mNGfqXQi0sGIG1pu6kU47dmbVLSwjU5OqOElA/k2
YtpGKRTwVJobAzQj1rd8MP6rva9e4oMO6KUOy22CPdH4XkjBOOXKdcLSoI22c0bG
LHU7IJV6Y+xsnwOR7w3PReTc2vpN0DXE5W7146+c2dtHPPxAX5AZV9BIXKlaD5QU
vMoWRaTFzKrPsLQ1AYReaZC5jPXiDJ4hpcTloyT2lPdH1M8F9SVAT31YgWo316Sl
cU5cdv2BOOujQZPGEf1QUJeI7oded2vC7PJ7k01cS7/onH3o/7gSvXdK3HpIuTDd
IrOqP19A0WDEodA53OZV76WmXEZR7vr7UNDhwEOsB9Yh0gk2ocOha6aXBUn1RQKo
+b8B16z0Rxs=
=XBDZ
-----END PGP SIGNATURE-----

--Sig_/n3HcVy=VI=JbrhtLJXGOhJV--
