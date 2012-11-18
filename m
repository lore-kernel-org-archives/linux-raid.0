From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: Smartmontools on software RAID
Date: Sun, 18 Nov 2012 23:25:38 +0100
Message-ID: <20121118222538.GB2715@vault.local>
References: <CANSbrrotWforxJj-nQ_KJ4Y=jGGFaCubCdUjqv8bLJ6Tn5CUgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANSbrrotWforxJj-nQ_KJ4Y=jGGFaCubCdUjqv8bLJ6Tn5CUgA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anuj Goel <anuj.goel@stonybrook.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 18, 2012 at 05:15:47PM -0500, Anuj Goel wrote:
> Hi,
>=20
> Can smartmontools be used with software RAID ?

Yes of course, as long as the member-devices/disks that your md-RAID array
consists of support SMART themselves. The resulting block device(s) that
implement RAID on top of these devices don't report any SMART
attributes/values, however.

> I see that it has support for RAID, but that is based on the Hardware
> controller.

That kind of support in smartmontools for a given controller model and/or
controller driver is only relevant if the "hardware"-RAID controller abstra=
cts
away the physical disks (by providing the arrays its user or administrator
defined - in the controller BIOS or a special setup utility - as ordinary
Linux block devices), and does not export these individual drives as standa=
rd
ATA or SCSI devices (which can support SMART) to the kernel. I've also seen
controllers with drivers that do both - you get your array(s) as defined in
the controllers setup tool, and also a set of SCSI generic devices (/dev/sg=
*)
that you can use to run smartctl against.

--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www:   http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp:  johannes@truschnigg.info

Please do not bother me with HTML-email or attachments. Thank you.

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlCpYGEACgkQnnUApj8OcoLQcACfTydh5esZmiT/pw5j29Hhz5X/
H2cAnRmD9V+qGw85eIouRmdhtoxhSVoQ
=uIHM
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
