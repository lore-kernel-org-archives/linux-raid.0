From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Understanding raid array status: Active vs Clean
Date: Wed, 18 Jun 2014 16:03:26 +0100
Message-ID: <20140618150326.GA28569@cthulhu.home.robinhill.me.uk>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
 <20140529151658.3bfc97e5@notabene.brown>
 <1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
 <20140529160623.5b9e37e5@notabene.brown>
 <CAG__1a5j-0O7LOb6opz4MLPCjbxRNDXiaG6W=Xxt3JJ9eXfRRA@mail.gmail.com>
 <CAG__1a5XK1yt70ox_12hLjpBpY=YRcaJ6-MYHiEJ_RTpxFujoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG__1a5XK1yt70ox_12hLjpBpY=YRcaJ6-MYHiEJ_RTpxFujoA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed Jun 18, 2014 at 03:25:27PM +0200, George Duffield wrote:

> A little more information if it helps deciding on the best recovery
> strategy.  As can be seen all drives still in the array have event
> count:
> Events : 11314
>=20
> The drive that fell out of the array has an event count of:
> Events : 11306
>=20
> Unless mdadm writes to the drives when a machine is booted or the
> array partitioned I know for certain that the array has not been
> written to i.e. no files have been added or deleted.
>=20
> Per https://raid.wiki.kernel.org/index.php/RAID_Recovery it would seem
> to me the following guidance applies:
> If the event count closely matches but not exactly, use "mdadm
> --assemble --force /dev/mdX <list of devices>" to force mdadm to
> assemble the array anyway using the devices with the closest possible
> event count. If the event count of a drive is way off, this probably
> means that drive has been out of the array for a long time and
> shouldn't be included in the assembly. Re-add it after the assembly so
> it's sync:ed up using information from the drives with closest event
> counts.
>=20
> However, in my case the array has been auto assebled by mdadm at boot
> time.  How would I best go about adding /dev/sdb1 back into the array?
>=20
That doesn't matter here - a force assemble would have left out the
drive with the lower event count as well. As there's a bitmap on the
array then either a --re-add or a --add (these should be treated the
same for arrays with persistent superblocks) should just synch any
differences since the disk was failed.

> On Tue, Jun 17, 2014 at 4:31 PM, George Duffield
> <forumscollective@gmail.com> wrote:
> > Apologies for the long delay in responding - I had further issues with
> > Microservers trashing the first drive in the backplane, including one
> > of the drives for the array in question (in the case of the array it
> > seems the drive lost power and dropped out the array, albeit it's
> > fully functional now and passes SMART testing).  As a result I've
> > built new machines using a mini-itx motherboards and made a clean
> > install of Arch Linux - finished that last night, so now have the
> > array migrated to the new machine and powered up, albeit in degraded
> > mode.  I'd appreciate some advice re rebuilding this array (by adding
> > back the drive in question).  I've set out below pertinent info
> > relating to the array and hard drives in the system as well as my
> > intended recovery strategy.  As can be seen from lsblk, /dev/sdb1 is
> > the drive that is no longer recognised as being part of the array.  It
> > has not been written to since the incident occurred.  Is there a quick
> > & easy to reintegrate it into the array or is my only option to run:
> > # mdadm /dev/md0 --add /dev/sdb1
> >
> > and let it take its course?
> >
> > The machine has a 3.5Ghz i3 CPU and currently has 8GB ram installed, I
> > can swap out the 4GB chips and replace with 8GB chips if 16GB RAM will
> > significantly increase the rebuild speed.  I'd also like to speed up
> > the rebuild as far as possible, so my plan is to set the following
> > parameters, (but I've no idea what safe numbers would be).
> >
> > dev.raid.speed_limit_min =3D
> > dev.raid.speed_limit_max =3D
> >
> > Current values are:
> > # sysctl dev.raid.speed_limit_min
> > dev.raid.speed_limit_min =3D 1000
> > # sysctl dev.raid.speed_limit_max
> > dev.raid.speed_limit_max =3D 200000
> >
You can set these as high as you like, though it can impact other tasks.
I'd suggest bumping the speed_limit_min up gradually and seeing how it
goes (unless you're hitting speed_limit_max already).

> > Set readahead:
> > # blockdev --setra 65536 /dev/md0
> >
> > Set stripe_cache_size to 32 MiB:
> > # echo 32768 > /sys/block/md0/md/stripe_cache_size
> >
> > Turn on bitmaps:
> > # mdadm --grow --bitmap=3Dinternal /dev/md0
> >
> > Rebuild the array by reintegrating /dev/sdb1:
> > # mdadm /dev/md0 --add /dev/sdb1
> >
> > Turn off bitmaps after rebuild is completed:
> > # mdadm --grow --bitmap=3Dnone /dev/md0
> >
I'm not sure you can modify the bitmaps on degraded arrays anyway, and
adding one before replacing a failed member won't do any good
regardless. The bitmap is only used if the disk used to be an active
member of the array, so will be ignored until the disk is fully synched
anyway. If you were adding a new disk (rather than just re-adding the
existing failed disk) then it might speed things up to drop the bitmap
until the array rebuild is complete (if this is possible).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlOhqj4ACgkQShxCyD40xBL1BgCdGZvicAUidjmJvpNKuFAyBtS7
+XMAoNeZ33gDt0OlQYuoI1olwzxnbMJ6
=dGGB
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
