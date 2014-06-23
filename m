From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Fwd: Adding a new drive to an array
Date: Mon, 23 Jun 2014 16:40:23 +0100
Message-ID: <20140623154023.GA7171@cthulhu.home.robinhill.me.uk>
References: <CAG__1a6i-UsOJpy+5GdwV_a-cVDCi_F_5KztwkFbNUEONDhH5w@mail.gmail.com>
 <alpine.DEB.2.02.1406221931230.18361@uplift.swm.pp.se>
 <CAG__1a4EG1PNpy_3Zt23OuEaEn1jTsF3-0-o21EQJBRCTPVORg@mail.gmail.com>
 <CAG__1a5M8RKfk1en3j8Cz9hBsPtB+g=znbzOE3hYOZZ2ZgU++g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAG__1a5M8RKfk1en3j8Cz9hBsPtB+g=znbzOE3hYOZZ2ZgU++g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Duffield <forumscollective@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Jun 23, 2014 at 04:47:07pm +0200, George Duffield wrote:

> > Consider adding two drives and go to RAID6.
> >
> > http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162
>=20
> Isn't what you're really saying then is that it's best to abandon RAID
> altogether when dealing with large storage requirements utilising high
> capacity drives?  Filling each drive individually and backing it up to
> another drive presumably involves a lot less iro r/w operations and if
> one fails you simply replace it with another of the same or larger
> size and be done with it.  Just make sure you have current backups
> (which you need to have even if using RAID).  The only real downside
> then is the inability to deal with the storage as a consolidated whole
> (I'm guessing LVM would be just as problematic as RAID if a drive in a
> volume fails)?
>=20
Any parity RAID certainly starts to run into issues in this area. RAID-6
is significantly safer than RAID-5 but will also reach a point where
it's no longer statistically viable. Higher parity options could be used
then - they're not currently supported by md, but there's been some ideas
floated over the last year or so. Non-parity RAID options (e.g. RAID-10)
are far safer in this respect but have a higher storage overhead.

Manual duplication is unlikely to offer any practical advantages over
RAID-10 though (or layered RAID-1/RAID-0 if you prefer more control over
the layout).

> >> Looking at https://raid.wiki.kernel.org/index.php/Growing it seems the
> >> approach (after partitioning the drive) is to:
> >>
> >> 1) add the drive to the pool: # mdadm --add /dev/md127 /dev/sdX1
> >> 2) grow the array: # mdadm --grow --raid-devices=3D5
> >> --backup-file=3D~/grow_md127.backup  /dev/md127
> >
> >
> > Make sure the backup file is NOT on a filesystem that is on the md being
> > resized. Put it on /root or something instead.
> >
> >
> >> 3) edit mdadm.conf to include the 5th drive i.e. num-devices=3D5
> >> 4) determine raid stride size calculated with chunk / block
> >> 4) ensure the array is unmounted and resize ext4: # resize2fs -S
> >> ascertained_stride_size -p /dev/md127
> >
> >
> > Yeah, that looks about right. Don't know if you really need step 4, just
> > enmount and resize, I would imagine that if you have a reasonable resent
> > version of the tools it'll figure out the stride size automatically.
> >
> > You cannot avoid the resync, so stop looking into weird options. The
> > resizing will take days.
> >
>=20
> What are weird options for if not to be used ;-)
>=20
> What is the purpose of --assume-clean then when man states:
> When  an  array  is resized to a larger size with --grow --size=3D the
> new space is normally resynced in that  same  way  that  the whole
> array  is  resynced at creation.  From Linux version 3.0,
> --assume-clean can be used with that command to avoid the  automatic
> resync.
>=20
Well, --grow --size=3D is usually for growing to larger disks (but the same
number). In this case, if the added data is all zeroes on all disks (as
it might be at the end of a disk burn-in test, for example) then there's
no need to recalculate the parity (or mirror the data), and
--assume-clean allows you to shortcut that step.

In your case, you're adding a new disk so the data needs to be restriped
anyway. I doubt that the --assume-clean option would even work in this
case (I can't see any rational case where it would be useful anyway).

> ^^^ What is the automatic resync being referred to in man?
>
It's what it describes in the previous line:
    "the new space is normally resynced in that same way that the whole
     array is resynced at creation"

That's done automatically when you grow an array.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlOoSmYACgkQShxCyD40xBJ7AACcDrFJwJJ9Lt0vdhovh++RtZlI
8p4AnREvLIs5hrQa0gt9/Dp7+fMjOMdQ
=lduX
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
