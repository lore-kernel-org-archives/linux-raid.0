From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  RAID needs more to survive a power hit, different /boot
	layout for example (was Re: draft howto on making raids for
	surviving a disk crash)
Date: Mon, 4 Feb 2008 11:40:26 +0000
Message-ID: <20080204114026.GC30156@cthulhu.home.robinhill.me.uk>
References: <47A612BE.5050707@pobox.com> <20080203200150.GB22004@cthulhu.home.robinhill.me.uk> <47A6283E.1000706@pobox.com> <20080203220158.GC22004@cthulhu.home.robinhill.me.uk> <47A6F1A1.7030407@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KDt/GgjP6HVcx58l"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47A6F1A1.7030407@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--KDt/GgjP6HVcx58l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon Feb 04, 2008 at 05:06:09AM -0600, Moshe Yudkowsky wrote:

> Robin, thanks for the explanation. I have a further question.
>
> Robin Hill wrote:
>
>> Once the file system is mounted then hdX,Y maps according to the
>> device.map file (which may actually bear no resemblance to the drive
>> order at boot - I've had issues with this before).  At boot time it maps
>> to the BIOS boot order though, and (in my experience anyway) hd0 will
>> always map to the drive the BIOS is booting from.
>
> At the time that I use grub to write to the MBR, hd2,1 is /dev/sdc1.=20
> Therefore, I don't quite understand why this would not work:
>
> grub <<EOF
> root(hd2,1)
> setup(hd2)
> EOF
>
> This would seem to be a command to have the MBR on hd2 written to use the=
=20
> boot on hd2,1. It's valid when written. Are you saying that it's a comman=
d=20
> for the MBR on /dev/sdc to find the data on (hd2,1), the location of whic=
h=20
> might change at any time? That's... a  very strange way to write the tool=
=2E=20
> I thought it would be a command for the MBR on hd2 (sdc) to look at hd2,1=
=20
> (sdc1) to find its data, regardless of the boot order that caused sdc to =
be=20
> the boot disk.
>
This is exactly what it does, yes - the hdX,Y are mapped by GRUB into
BIOS disk interfaces (0x80 being the first, 0x81 the second and so on)
and it writes (to hdc in this case) the instructions to look on the
first partition of BIOS drive 0x82 (whichever drive that ends up being)
for the rest of the bootloader.

It is a bit of a strange way to work, but it's really the only way it
_can_ work (and cover all circumstances).  Unfortunately when you start
playing with bootloaders you have to get down to the BIOS level, and
things weren't written to make sense at that level (after all, when
these standards were put in place everyone was booting from a single
floppy disk system).  If EFI becomes more standard then hopefully this
will simplify but we're stuck with things as they are for now.

Cheers,
        Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--KDt/GgjP6HVcx58l
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHpvmpShxCyD40xBIRAh3xAJ9IcXEX/IXjaUK2slYWQnslMR0JUQCeL5Rr
3X41l6fSY4L4ryTD7hXzYJw=
=HO3y
-----END PGP SIGNATURE-----

--KDt/GgjP6HVcx58l--
