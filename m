From: travis+ml-linux-raid@subspacefield.org
Subject: SOLVED - Re: md raid0 with overwritten superblock on 1/4 disks
Date: Sun, 2 Feb 2014 17:24:05 -0800
Message-ID: <20140203012405.GB7193@subspacefield.org>
References: <20140203004137.GA7193@subspacefield.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140203004137.GA7193@subspacefield.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Funny how the answer is obvious once you ask.

I noticed the "Data Offset" was 2048 sectors.

On the newly-created md, it was 16 sectors, I think because it was a
device mapper overlay and not a real block device.

I found this page:
http://www.thomas-krenn.com/en/wiki/Linux_Software_RAID

Got the mdadm development version that allows setting data offset.

  724  parallel truncate -s4000G overlay-{/} ::: $DEVICES
  725  parallel 'size=3D$(blockdev --getsize {}); loop=3D$(losetup -f --sho=
w -- overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup create {/}'=
 ::: $DEVICES
  726  cat /proc/mdstat=20
  727  mdadm -S /dev/md127
  728  ~/src/mdadm-40c9a66/mdadm --create  /dev/md127  --data-offset=3D1024=
  -v -l 0 -n 4 $OVERLAYS

That fixed it up (data offset is in k, not sectors).

Cheers.
--=20
http://www.subspacefield.org/~travis/
Remediating... LIKE A BOSS



--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (OpenBSD)

iQIcBAEBAgAGBQJS7u+1AAoJEGQVZZEDJt9Hpa0P/2qmRqYoJ2NV9eZ08mMjEAHj
LzDInbZGW1RdiH1AxjdeYhEun9Cc74/kfMkE3QPkKULeg9vUmU8iMv+IuS9DDpif
zp6aSHcbDDqTmCJmO5FL1EHEKpHf0MfOnR3TRdXlVNIBn0Ip0Gn4JM8wAz6B8TlF
/gfDV/MPe8hTpBAkT2dTyRgZg9/i8ybjnPyHFihohm70cu0p70VwMQ1H849KxNL0
vZUzaX6zdMa0wif91s0WDElXxqgv2ga1AGcBFaKWdqJe6Ja83cIARdqo1WzUc9Jl
Xzpy4JHDFuVg/GqEOoTZCYiNsQCblQc628k3Ylrrf3IwsKCONgPPSxNhtEZMNnqf
DbFoaClzdzV12SzdSjdHsuX4Tt4AR9b+BHZdKyblZkfdqkpp8N8buhA+q1rI/hGc
X0l+uNY1Lsq64J2hUIiO1rozZb3iDh2/N5LrjpE4qTHIYMfV6ch2NvDEAOzugQVV
5wk94oFgAg6mOJyZcPkPqisMS5/gc7pr/p371dY1IWH2DfbHssA9QCGYOtMG82oR
hkZArboDhA5YowYrCriIjpNQzV1rdMFw/td+6SwvVR0BsBtXfb7KQ6XGzqkemRAd
xFTQI7fJHmZdkctO8ZPwH3WQUMmpF5axNeLtYFSS09dCQ5dGRzo9rHug/YwvEfGh
KvczuKc8T15IhEXhmy00
=TL6B
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
