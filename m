From: NeilBrown <neilb@suse.de>
Subject: Re: Some md/mdadm bugs
Date: Tue, 7 Feb 2012 09:31:56 +1100
Message-ID: <20120207093156.290bd52b@notabene.brown>
References: <4F2ADF45.4040103@shiftmail.org>
	<20120203081717.195bfec8@notabene.brown>
	<4F2B1519.5010500@shiftmail.org>
	<4F3008DA.8060402@shiftmail.org>
	<4F30204A.1060206@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IQ/s_nrUCmUsVvEWEqp2Jjc"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F30204A.1060206@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/IQ/s_nrUCmUsVvEWEqp2Jjc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Feb 2012 19:47:38 +0100 Asdo <asdo@shiftmail.org> wrote:

> One or two more bug(s) in 3.2.2
> (note: my latest mail I am replying to is still valid)
>=20
> AUTO line in mdadm.conf does not appear to work any longer in 3.2.2=20
> compared to mdadm 3.1.4
> Now this line
>=20
> "AUTO -all"
>=20
> still autoassembles every array.
> There are many arrays not declared in my mdadm.conf, and which are not=20
> for this host (hostname is different)
> but mdadm still autoassembles everything, e.g.:
>=20
> # mdadm -I /dev/sdr8
> mdadm: /dev/sdr8 attached to /dev/md/perftest:r0d24, not enough to start=
=20
> (1).
>=20
> (note: "perftest" is even not the hostname)

Odd.. it works for me:

# cat /etc/mdadm.conf=20
AUTO -all
# mdadm -Iv /dev/sda
mdadm: /dev/sda has metadata type 1.x for which auto-assembly is disabled
# mdadm -V
mdadm - v3.2.2 - 17th June 2011
#=20

Can you show the complete output of the same commands (with sdr8 in place o=
f sda of course :-)


>=20
> I have just regressed to mdadm 3.1.4 to confirm that it worked back=20
> then, and yes, I confirm that 3.1.4 was not doing any action upon:
> # mdadm -I /dev/sdr8
> --> nothing done
> when the line in config was:
> "AUTO -all"
> or even
> "AUTO +homehost -all"
> which is the line I am normally using.
>=20
>=20
> This is a problem in our fairly large system with 80+ HDDs and many=20
> partitions which I am testing now which is full of every kind of arrays..=
..
> I am normally using : "AUTO +homehost -all"  to prevent assembling a=20
> bagzillion of arrays at boot, also because doing that gives race=20
> conditions at boot and drops me to initramfs shell (see below next bug).
>=20
>=20
>=20
>=20
>=20
> Another problem with 3.2.2:
>=20
> At boot, this is from a serial dump:
>=20
> udevd[218]: symlink '../../sdx13'=20
> '/dev/disk/by-partlabel/Linux\x20RAID.udev-tmp' failed: File exists
> udevd[189]: symlink '../../sdb1'=20
> '/dev/disk/by-partlabel/Linux\x20RAID.udev-tmp' failed: File exists
>=20
> And sdb1 is not correctly inserted into array /dev/md0 which hence=20
> starts degraded and so I am dropped into an initramfs shell.
> This looks like a race condition... I don't know if this is fault of=20
> udev, udev rules or mdadm...
> This is with mdadm 3.2.2 and kernel 3.0.13 (called 3.0.0-15-server by=20
> Ubuntu) on Ubuntu oneiric 11.10
> Having also the above bug of nonworking AUTO line, this problem happens=20
> a lot with 80+ disks and lots of partitions. If the auto line worked, I=20
> would have postponed most of the assembly's at a very late stage in the=20
> boot process, maybe after a significant "sleep".
>=20
>=20
> Actually this race condition could be an ubuntu udev script bug :
>=20
> Here are the ubuntu udev rules files I could find, related to mdadm or=20
> containing "by-partlabel":

It does look like a udev thing more than an mdadm thing.

What do
   /dev/blkid -o udev -p /dev/sdb1
and
   /dev/blkid -o udev -p /dev/sdx12

report?

NeilBrown



--Sig_/IQ/s_nrUCmUsVvEWEqp2Jjc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzBU3Dnsnt1WYoG5AQLTeQ//UPn2zpOEbm/yuLa9htMjLFW2f/YKuBBx
DHgMqsJkRh8IPMAhssHVAtlWE0sd0wtEQ0m1MaHU6lLtO9IWXqAkEZjFi4N8+gqF
2Yw7tJ0EKvvNxKG4cUFEdRZoiEjmDOLKjvDGXiqo+fCi7pQJYVaomE1L9PTpLEz1
UJHEP3hMIaV7VxMfp6mqQKM+3M0twcQKcAXL5sHH30qNrHqWkNSXQrN+As10lVFU
btH+8DlciijDGTTDFjlkc7fVIDCvi7uKAgVJvnw+2nR74c9c2wrbaKarOWp/vG61
GlttKvoQswHWR6SMk/LiLS/J6gbCtei+UBY1Nb6BXUhjlA6RHPDQJMvnfC0b/XI4
Kh5PuiU7NtN56IPmMQa8SIu8MOK0AyjmplVZcX5UU6PG687V9h/2bQ70YuGK55XR
FGjBmuOQdW/GsxFPy0H1s3qhRiR4y4jhIef8ewOMbZAX91Ju3OEWFinukgCzaMEw
6Bt71mZj/CDDTzS09EYTbG/013nSXjcx8S6gvJY46LkLkHogTDacEBpxUBFDPL7c
di/NtnuabQIxuG/eR4JgsIpgolQKfM+UrwSkp0pwI++/L0ZYO1mCSMQNyvbnt6C/
QfzbHUEnsR9PZDncavnDT1ThKGE7GxDsKLiEA3U9/FvigPjtcbQjvPjVlXWS1Y5C
QzeFBl1H/vE=
=d+Ba
-----END PGP SIGNATURE-----

--Sig_/IQ/s_nrUCmUsVvEWEqp2Jjc--
