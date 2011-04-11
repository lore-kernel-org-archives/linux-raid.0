From: NeilBrown <neilb@suse.de>
Subject: Re: iostat with raid device...
Date: Mon, 11 Apr 2011 20:18:08 +1000
Message-ID: <20110411201808.47cd19d5@notabene.brown>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
	<20110409094629.2eae2d5b@notabene.brown>
	<BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
	<20110409085044.GB417@cthulhu.home.robinhill.me.uk>
	<BANLkTim4fenro-GQchqJ0JzrcDAcJXG0UQ@mail.gmail.com>
	<20110411092559.GA20532@cthulhu.home.robinhill.me.uk>
	<BANLkTikYTECzE-2dCnC+jDT0wHNtgkNQ8Q@mail.gmail.com>
	<20110411095355.GB20532@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/3KcswC8T0vbj/pW1isbjl0z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110411095355.GB20532@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: Linux Raid Study <linuxraid.study@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/3KcswC8T0vbj/pW1isbjl0z
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Apr 2011 10:53:55 +0100 Robin Hill <robin@robinhill.me.uk> wrote:

> On Mon Apr 11, 2011 at 02:36:50AM -0700, Linux Raid Study wrote:
> > On Mon, Apr 11, 2011 at 2:25 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> > > On Mon Apr 11, 2011 at 01:32:34 -0700, Linux Raid Study wrote:
> > >> On Sat, Apr 9, 2011 at 1:50 AM, Robin Hill <robin@robinhill.me.uk> w=
rote:
> > >> > On Fri Apr 08, 2011 at 05:40:46PM -0700, Linux Raid Study wrote:
> > >> >
> > >> >> What I'm not sure of is if the device is newly formatted, would r=
aid
> > >> >> recovery happen? What else could explain difference in the first =
run
> > >> >> of IO benchmark?
> > >> >>
> > >> > When an array is first created, it's created in a degraded state -=
 this
> > >> > is the simplest way to make it available to the user instantly. The
> > >> > final drive(s) are then automatically rebuilt, calculating the
> > >> > parity/data information as normal for recovering a drive.
> > >> >
> > >> Thanks. So, the uneven (unequal) distribution of Wrtie/Sec numbers in
> > >> the iostat output are ok...is that correct?
> > >>
> > > If it hadn't completed the initial recovery, yes. =A0If it _had_ comp=
leted
> > > the initial recovery then I'd expect writes to be balanced (barring
> > > any differences in hardware).
> > >
> > The initial recovery should normally be done during first few minutes
> > .... this is a newly formatted disk so there isn't any user data
> > there. So, if I run the IO benchmark after say 3-4 min of doing, I
> > should be ok?
> >=20
> > mdam --create /dev/md0 --raid5....
> > mount /dev/md0 /mnt/raid
> > mkfs.ext4 /mnt/raid
> >=20
> > ...wait 3-4 min
> >=20
> > run IO benchmark...
> >=20
> > Am I correct?
> >=20
> No, depending on the size of the drives, the initial recovery can take
> hours or even days. For RAID5 with N drives, it needs to read the
> entirity of (N-1) drives, and write the entirity of the remaining drive
> (whether there's any data or not, the initial state of the drives is
> unknown so parity data has to be calculated for the entire array).
>=20
> Check /proc/mdstat and wait until the array has completed resync before
> running any benchmarks.

or run
  mdadm --wait /dev/md0

or create the array with --assume-clean.  But if the array is raid5, don't
trust the data if a device fails:  use this only for testing.

NeilBrown


>=20
> Cheers,
>     Robin


--Sig_/3KcswC8T0vbj/pW1isbjl0z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iD8DBQFNotVgG5fc6gV+Wb0RAhAgAJ48Sj+3DgG72ahJDpix4qzhPxOz9gCffgEg
mKqqOtjnJGpGqG2QSUdYSeA=
=uGHB
-----END PGP SIGNATURE-----

--Sig_/3KcswC8T0vbj/pW1isbjl0z--
