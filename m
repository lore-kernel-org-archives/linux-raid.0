From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: iostat with raid device...
Date: Mon, 11 Apr 2011 10:53:55 +0100
Message-ID: <20110411095355.GB20532@cthulhu.home.robinhill.me.uk>
References: <BANLkTi=6uvCsQTpCi4xLUWzx5X7o99_=5g@mail.gmail.com>
 <20110409094629.2eae2d5b@notabene.brown>
 <BANLkTin2KP-_vy8jbmV3JB-LHHJNOEVCKw@mail.gmail.com>
 <20110409085044.GB417@cthulhu.home.robinhill.me.uk>
 <BANLkTim4fenro-GQchqJ0JzrcDAcJXG0UQ@mail.gmail.com>
 <20110411092559.GA20532@cthulhu.home.robinhill.me.uk>
 <BANLkTikYTECzE-2dCnC+jDT0wHNtgkNQ8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/WwmFnJnmDyWGHa4"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BANLkTikYTECzE-2dCnC+jDT0wHNtgkNQ8Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--/WwmFnJnmDyWGHa4
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Apr 11, 2011 at 02:36:50AM -0700, Linux Raid Study wrote:
> On Mon, Apr 11, 2011 at 2:25 AM, Robin Hill <robin@robinhill.me.uk> wrote:
> > On Mon Apr 11, 2011 at 01:32:34 -0700, Linux Raid Study wrote:
> >> On Sat, Apr 9, 2011 at 1:50 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> >> > On Fri Apr 08, 2011 at 05:40:46PM -0700, Linux Raid Study wrote:
> >> >
> >> >> What I'm not sure of is if the device is newly formatted, would raid
> >> >> recovery happen? What else could explain difference in the first run
> >> >> of IO benchmark?
> >> >>
> >> > When an array is first created, it's created in a degraded state - t=
his
> >> > is the simplest way to make it available to the user instantly. The
> >> > final drive(s) are then automatically rebuilt, calculating the
> >> > parity/data information as normal for recovering a drive.
> >> >
> >> Thanks. So, the uneven (unequal) distribution of Wrtie/Sec numbers in
> >> the iostat output are ok...is that correct?
> >>
> > If it hadn't completed the initial recovery, yes. =A0If it _had_ comple=
ted
> > the initial recovery then I'd expect writes to be balanced (barring
> > any differences in hardware).
> >
> The initial recovery should normally be done during first few minutes
> .... this is a newly formatted disk so there isn't any user data
> there. So, if I run the IO benchmark after say 3-4 min of doing, I
> should be ok?
>=20
> mdam --create /dev/md0 --raid5....
> mount /dev/md0 /mnt/raid
> mkfs.ext4 /mnt/raid
>=20
> ...wait 3-4 min
>=20
> run IO benchmark...
>=20
> Am I correct?
>=20
No, depending on the size of the drives, the initial recovery can take
hours or even days. For RAID5 with N drives, it needs to read the
entirity of (N-1) drives, and write the entirity of the remaining drive
(whether there's any data or not, the initial state of the drives is
unknown so parity data has to be calculated for the entire array).

Check /proc/mdstat and wait until the array has completed resync before
running any benchmarks.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--/WwmFnJnmDyWGHa4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2iz7EACgkQShxCyD40xBI//gCfWvQv/y6eZLDXyNrvbtu+uPN6
eMoAoJ4w4pS6BD4Tn9wjDhLjM2p05V2n
=bTgg
-----END PGP SIGNATURE-----

--/WwmFnJnmDyWGHa4--
