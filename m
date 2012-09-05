From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Safe disk replace
Date: Wed, 5 Sep 2012 21:32:03 +0100
Message-ID: <20120905203203.GA4391@cthulhu.home.robinhill.me.uk>
References: <20120904041447.GB14445@onthe.net.au>
 <5045D7D9.9000108@hesbynett.no>
 <alpine.DEB.2.00.1209041423250.13902@uplift.swm.pp.se>
 <20120904153342.GA26999@cthulhu.home.robinhill.me.uk>
 <CAEhu1-6oNLaPuoh-aXtrFsnmPZ2fMGVaQSbtQp7Wkx-sf8MfDg@mail.gmail.com>
 <CAEhu1-6+PQr_UG6NLTgXcWgYJYfpp5j7EHt5BnfMmWJr=s-i_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAEhu1-6+PQr_UG6NLTgXcWgYJYfpp5j7EHt5BnfMmWJr=s-i_g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Sep 05, 2012 at 03:35:29PM -0400, John Drescher wrote:

> On Wed, Sep 5, 2012 at 10:25 AM, John Drescher <drescherjm@gmail.com> wro=
te:
> >> I'm currently upgrading my RAID-6 arrays via hot-replacement. The
> >> process I followed (to replace device YYY in array mdXX) is:
> >>     - add the new disk to the array as a spare
> >>     - echo want_replacement > /sys/block/mdXX/md/dev-YYY/state
> >>
> >> That kicks off the recovery (a straight disk-to-disk copy from YYY to
> >> the new disk). After the rebuild is complete, YYY gets failed in the
> >> array, so can be safely removed:
> >>     - mdadm -r /dev/mdXX /dev/mdYYY
> >>
> >
> > Thanks for the info. I wanted this feature for years at work..
> >
> > I am testing this now on my test box. Here I have 13 x 250GB SATA 1
> > drives. Yes these are 8+ years old..
> >
> > md1 : active raid6 sda2[13](R) sdk2[17] sdj2[18] sdf2[16] sdm2[19]
> > sdl2[14] sdi2[12] sdg2[15] sde2[5] sdd2[4] sdh2[21] sdb2[20] sdc2[1]
> >       2431477760 blocks super 1.2 level 6, 512k chunk, algorithm 2
> > [12/12] [UUUUUUUUUUUU]
> >       [>....................]  recovery =3D  3.4% (8401408/243147776)
> > finish=3D75.9min speed=3D51540K/sec
> >
> >
> > Speeds are faster than failing a drive but I would do this more for
> > the lower chance of failure more than the improved performance:
> >
> > md1 : active raid6 sdk2[17] sdj2[18] sdf2[16] sdm2[19] sdl2[14]
> > sdi2[12] sdg2[15] sde2[5] sdd2[4] sdh2[21] sdb2[20] sdc2[1]
> >       2431477760 blocks super 1.2 level 6, 512k chunk, algorithm 2
> > [12/11] [_UUUUUUUUUUU]
> >       [>....................]  recovery =3D  1.2% (3134952/243147776)
> > finish=3D100.1min speed=3D39954K/sec
> >
>=20
> I found something interesting. I issued want_replacement without spares.
>=20
> localhost md # echo want_replacement > dev-sdd2/state
> localhost md # cat /proc/mdstat
> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4] [raid0]
> [linear] [multipath]
> md0 : active raid1 sda1[10](S) sdj1[0] sdk1[2] sdf1[11](S) sdb1[12](S)
> sdg1[9] sdh1[8] sdl1[7] sdm1[6] sde1[5] sdd1[4] sdi1[3] sdc1[1]
>       1048512 blocks [10/10] [UUUUUUUUUU]
>=20
> md1 : active raid6 sdb2[20] sdk2[17] sda2[13] sdj2[18] sdf2[16]
> sdm2[19] sdl2[14] sdi2[12] sdg2[15] sde2[5] sdd2[4] sdh2[21]
> sdc2[1](F)
>       2431477760 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [12/11] [UUUUUUUUUUUU]
>
> Then I added the failed disk from a previous round as a spare.
>=20
> localhost md # mdadm --manage /dev/md1 --remove /dev/sdc2
> mdadm: hot removed /dev/sdc2 from /dev/md1
> localhost md # mdadm --zero-superblock /dev/sdc2
> localhost md # mdadm --manage /dev/md1 --add /dev/sdc2
> mdadm: added /dev/sdc2
>=20
> localhost md # cat /proc/mdstat
> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4] [raid0]
> [linear] [multipath]
> md0 : active raid1 sda1[10](S) sdj1[0] sdk1[2] sdf1[11](S) sdb1[12](S)
> sdg1[9] sdh1[8] sdl1[7] sdm1[6] sde1[5] sdd1[4] sdi1[3] sdc1[1]
>       1048512 blocks [10/10] [UUUUUUUUUU]
>=20
> md1 : active raid6 sdc2[22](R) sdb2[20] sdk2[17] sda2[13] sdj2[18]
> sdf2[16] sdm2[19] sdl2[14] sdi2[12] sdg2[15] sde2[5] sdd2[4] sdh2[21]
>       2431477760 blocks super 1.2 level 6, 512k chunk, algorithm 2
> [12/11] [UUUUUUUUUUUU]
>       [>....................]  recovery =3D  0.6% (1592256/243147776)
> finish=3D119.2min speed=3D33746K/sec
>=20
>=20
> Now its taking much longer and it says 12/11 instead of 12/12.
>=20
The problem's actually at the point it finishes the recovery. When it
fails the replaced disk, it treats it as a failure of an in-array disk.
You get the failure email and the array shows as degraded, even though
it has the full number of working devices. Your 12/11 would have shown
even before you started doing the second replacement. It doesn't seem to
cause any problems in use though, and it gets corrected after a reboot.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBHtsIACgkQShxCyD40xBIVyQCg3EdJDkEMvMkQSItbjv9vCU4v
uc0Aniai8jZfmA8YxUmaFCBUaJq/GBDc
=DB78
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
