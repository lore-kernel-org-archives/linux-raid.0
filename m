From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: RAID5 with 2 drive failure at the same time
Date: Fri, 1 Feb 2013 13:34:55 +0000
Message-ID: <20130201133455.GA24375@cthulhu.home.robinhill.me.uk>
References: <510A4AAE.6000009@evilazrael.de>
 <20130131113820.GA20536@cthulhu.home.robinhill.me.uk>
 <510A6E54.5050001@evilazrael.de>
 <CAF3D534-D907-4A88-AFAF-EA9B97C1D8BF@colorremedies.com>
 <20130131221007.GA1447@cthulhu.home.robinhill.me.uk>
 <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <88758108-9333-4224-9006-8E44E717AB29@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Robin Hill <robin@robinhill.me.uk>, Christoph Nelles <evilazrael@evilazrael.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Jan 31, 2013 at 03:40:00PM -0700, Chris Murphy wrote:

>=20
> On Jan 31, 2013, at 3:10 PM, Robin Hill <robin@robinhill.me.uk> wrote:
>=20
> > If there is a read error
> > further back then I'd blame it on timeout issues, with the drive still
> > trying to complete the read operation while the kernel's timed out and
> > trying to send a write.
>=20
> I think we need the whole log for the time before the start of the
> error1.txt file provided previously. And also I'd like to know which
> /dev/ device was the first to have a problem, that instigated the
> rebuild. And if during the rebuild if the file system was mounted rw,
> and if any writes were done at all. If so, that probably nixes
> --assume-clean. If it was rebuilding and not written to from the file
> system, the disk being rebuilt shouldn't actually be out of sync with
> the array state.
>=20
The timestamps on the logs show that sdg was the first to have a
problem. It'd also be useful to know whether sdg has been rewritten at
all since then (i.e. whether the testing was destructive or not), and
whether or not the array was written to at all since the failure of sdg.

> The disk that needs spot sector repairs is the one with UREs, I think
> that's sdj1. If that disk is dd'd to another disk, the new disk won't
> produce UREs for sectors missing data, and the chunks comprised of
> those sectors won't get rebuilt by md.
>=20
> So the disk to possibly dd to another is the one with the write error,
> sdg1. But only if the idea is to not use --assume-clean. That way a
> reassemble can rebuild, and not encounter another write error on that
> drive.
>=20
Yes, if sdg still contains valid array data (and the array wasn't
written since then) then it would definitely make more sense to recreate
the array using it, leaving sdj out for now. That'll require more work
checking mdadm versions and data offset values though. That'll avoid the
issues with the unreadable blocks on sdj.

> > Not a chance I'd use it if it's actually failing to remap bad sectors,
> > no. Only had that with one drive so far though (out of several hundred),
> > most get failed out after getting more than a handful of remapped
> > sectors.
>=20
> I think I see a use case for badblocks destructive writes if the disk
> doesn't support enhanced secure erase (which writes a pattern not just
> zeros). Of on laptops where it's not possible to get a disk to reset
> on sleep, allowing it to be unfrozen for the purposes of using secure
> erase. But if available, secure erase is faster and wipes all sectors
> even those without LBAs. For sure with SSDs it's what should be used.
>=20
I prefer badblocks myself - I can see exactly what it's doing and what
errors are seen. With secure erase you're dependent on the firmware
internals to tell you what's actually going on (and, depending on the
nature of the errors you're getting, this may already be suspect).

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlELxH8ACgkQShxCyD40xBIDtgCeNxFUhJK3DzfTY250VHYRwk9h
v0kAoOAtmXfBl/fRt3BHLSImRhU5lzAa
=pO3Y
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
