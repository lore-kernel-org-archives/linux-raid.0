From: Michael Biebl <biebl@debian.org>
Subject: Bug#725284: Bug#779412: block devices loosing state after resume: trigger udev rules to re-apply settings
Date: Sat, 28 Feb 2015 09:38:27 +0100
Message-ID: <54F17E83.5070400@debian.org>
References: <20150228093023.14e30d9a@smtp.arcor.de>
Reply-To: Michael Biebl <biebl@debian.org>, 725284@bugs.debian.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="n3MISEgJ9UAw2N5EMmAU5qcgAooS64l5N"
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.725284.B725284.142511271222489@bugs.debian.org>
In-Reply-To: <20150228093023.14e30d9a@smtp.arcor.de>
List-URL: <http://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
To: Chris <email.bug@arcor.de>, 779412@bugs.debian.org
Cc: 725284@bugs.debian.org, linux-raid@vger.kernel.org, smartmontools-support@lists.sourceforge.net
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--n3MISEgJ9UAw2N5EMmAU5qcgAooS64l5N
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Am 28.02.2015 um 09:30 schrieb Chris:
> (http://bugs.debian.org/779412 explanation)
>=20
> There is a general problem with non-permanent block devices settings
> (hard disks, optical disks, usb storage, ...), that are not restored=20
> when resuming from suspend (instead using factory defaults and=20
> loosing all pre-suspend settings).
>=20
> And as long as the ata/scsi command set drivers can not save and
> restore every state register a device may have (impossible?),
> systemd may ship a viable workaround for this:
>=20
> A systemd unit file could trigger an udev change action upon resume for=

> block devices. This way the same udev rules that set up the devices whe=
n
> they are first plugged, will re-apply their settings after resume.
>=20
> Providing this centrally with the systemd package could avoid that=20
> multiple packages ship their own files, resulting in multiple change=20
> events triggerd on each resume.
>=20
> Examples for very important (non-permanent) settings are with
> hdparm (i.e. the important -B hard disk wear settings)
> https://bugs.debian.org/725284
> smartctl/mdadm/lvm/btrfs/zfs/... (i.e. set error recovery timeouts to
> prevent controller resets and data loss)
> http://sourceforge.net/p/smartmontools/mailman/message/33501936/
>=20

I don't think working around this in udev/systemd is a good idea.
After all, most of those custom settings aren't applied via udev rules
anyway. This should be fixed in the kernel properly (or the individual
services) and not be papered over in systemd.

Marco, what do you think?

--=20
Why is it that all of the instruments seeking intelligent life in the
universe are pointed away from Earth?


--n3MISEgJ9UAw2N5EMmAU5qcgAooS64l5N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJU8X6DAAoJEGrh3w1gjyLcWqQP/3wNj6WPHlRaCS+skY5fdZBv
2/ToQbPFqha5wol7qu+g8gbnJ7yPMXYpdb8dKGbZYE4S7n+hTN2VueI4cqcHvZnV
AbMmdDZk95U4ac6yD2B3j24fb0ZK2U+N7PqmXDQFxuQMqtvccSn0pqe/s9eGwcVi
/Bjy52EYk1A0NkLYO85vokWcTiHkOuKsuSAwiVkOE/PmSkYG8rlMC1U9qL8xskIo
xCqFc7P2rU9LecgUZxET3AirJDKgwwXheQled+NscbEzcMgt7Hgyi9W7VQivXHUv
QTfAz3oODnObukQ7623VfSfKPAAtgu+jnbilYb/i55KvMsU1wf3tIJh86EKW2HCg
bAm7CvNhS0DB8nS+nz0FHFLsozf39DnVTBzV4dRyLel3JYLAGpvtV7/vFOXbmgCF
JNkYTU59bhzF70BiVTQxlPRfrz3KIaBjKRiqkal4rLJiXkJJz+i12UJWws0DjpGR
Ex5xSZFg27OdRdWIwutJ1DdhdBIp7YUQOCDi6klI4awtsOv6TOir9zb1N3Ysbfof
9q/ujQM09jjG6Wqg7cw4VNAjRY2761oKXR830ot7H6sPnNqHaRp9uYg9SP3rLaju
Uj8bUFjo9jICaNNo+fuMoy8DFOnQkxVHWCksY1iou42FMnTySwTFGARI1hr6gQAs
h5irqC1/V/33HWoV3Xg0
=SS7l
-----END PGP SIGNATURE-----

--n3MISEgJ9UAw2N5EMmAU5qcgAooS64l5N--
