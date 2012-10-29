From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: 3TB drives failure rate
Date: Mon, 29 Oct 2012 10:29:19 +0600
Message-ID: <20121029102919.1134a797@natsu>
References: <11510711257.20121028131527@oudeis.org>
	<508D61A1.7020106@wildgooses.com>
	<508D65CF.1080904@gmail.com>
	<508DADC3.4080104@shiftmail.org>
	<508DB08D.20002@meetinghouse.net>
	<508DC6E9.8070001@shiftmail.org>
	<508DC922.7040400@meetinghouse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SO0VcOtt1EsXe002DgJpNH7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508DC922.7040400@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SO0VcOtt1EsXe002DgJpNH7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 28 Oct 2012 20:09:06 -0400
Miles Fidelman <mfidelman@meetinghouse.net> wrote:

> Two separate issues.

> The comments about "dropping out of raid" had to do with drives that are=
=20
> slow to come out of sleep mode - causing hiccups when the RAID=20
> hardware/software simply doesn't see the drive, and drops it.

There are no drives in good working order that would come out of sleep mode=
 SO
slowly, that the Linux kernel ATA subsystem would even give up trying and
return an I/O error from it (and it's only after that point, when this begi=
ns
to become mdraid's concern).

I have yet to see even any first sign of "SATA frozen" due to drive sleep
mode, let alone to imagine this last through all the port resets and speed
step-downs the SATA driver will attempt.

So the "sleep" issue is not relevant with Linux software RAID, and if you're
still concerned that it might be, you can just reconfigure your drives so t=
hey
don't enter that sleep mode.=20

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/SO0VcOtt1EsXe002DgJpNH7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCOBh8ACgkQTLKSvz+PZwgKDgCfVyH1hohyjvwTDi+LRX+wJhcB
U7EAoIdgUQiBfZPeEVqxh9uLXcxe0kiF
=eR1E
-----END PGP SIGNATURE-----

--Sig_/SO0VcOtt1EsXe002DgJpNH7--
