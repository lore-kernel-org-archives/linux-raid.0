From: Ben Hutchings <ben@decadent.org.uk>
Subject: fsync() on read-only RAID triggers BUG
Date: Sun, 20 Jan 2013 18:44:52 +0000
Message-ID: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-V9sYi4kXXcQNa6raUP4E"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, 696650@bugs.debian.org
List-Id: linux-raid.ids


--=-V9sYi4kXXcQNa6raUP4E
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We've had a report of the BUG in md_write_start() being triggered while
running the Debian installer: <http://bugs.debian.org/696650>.
Based on the call trace, I came up with the following script that
reproduces this under Linux 3.2.35 and 3.7.3:

--- BEGIN ---
#!/bin/bash -ex

# Set up temporary RAID1 on /dev/md0
dd if=3D/dev/zero of=3D/tmp/disk0 bs=3D1M count=3D1
losetup /dev/loop0 /tmp/disk0
dd if=3D/dev/zero of=3D/tmp/disk1 bs=3D1M count=3D1
losetup /dev/loop1 /tmp/disk1
yes | mdadm -C /dev/md0 -l 1 -n 2 /dev/loop{0,1}

# Make it read-only
while ! mdadm -o /dev/md0; do sleep 1; done

# Call fsync()
python -c "import os; os.fsync(os.open('/dev/md0', os.O_RDWR))"
--- END ---

I assume that the sync request should be filtered out at some point
before this assertion is made, since there can be nothing to sync.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-V9sYi4kXXcQNa6raUP4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPw7JOe/yOyVhhEJAQpaZw//S3/4VXISx6H+lxRTvyqmzhR2dFMjLFCn
COkZLYjvO96WmtQKiWrTlPM8a5DyVEzGot4xcB14fjFkXW+3oorH6Dwn/P94Po8y
6QB6ba80AD+Qv/nl9sKXlcM5ZBmzaZOAN3cIQzl2tHop8ZMFmzxZALVKf1pzZy/r
QSjDRy611vGmh7j7mjpD6OHmIt9ItZWeQEo35AXqy8Xf+19aWlwHuQWvyF9X+uWQ
aeRtELfnB9uf2ruKS+FpolyUTAROEPKk2bZpyqc1hh41v7poJVBdWb0peROSaqkK
3DT9fShxOOp/VPCR39vEwT4wSuAd1Wodr01ozXE0L8rCf7XBLGKnPDr0CQpW8nfc
OcZdRunqwg5H2eFLa2zO1tjsvXOEFHG788bIphZ1IqneDewOjBWd8yECMEHY+xDK
nWRzFE44iPs77vyoUSPXO5TOqr/UjVI+s1wp3BzbFzh1Es918ekDGt26etVyHZxL
7NCEIGOBGiEzKLmAsLbL5W5nUO1EjCyIkIrZBm+UTND0PT5WHbqNaIbHMp6S5CO1
gVZjlNnFqZ0Uq1J1wB9kBzA5q3EEhaNHl3kyxRdEhONCcq7Rk8JKSDwmk72JtE42
xBfjAOSM56vDrYsYTZnl3S56uF+oHZTOo85a3Q09x9z9n8p9/Y3tcrAOQT24etuZ
ybcPkX8yZ18=
=BgLd
-----END PGP SIGNATURE-----

--=-V9sYi4kXXcQNa6raUP4E--
