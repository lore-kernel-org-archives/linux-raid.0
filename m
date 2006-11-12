From: Doug Ledford <dledford@redhat.com>
Subject: Re: Recovering from default FC6 install
Date: Sun, 12 Nov 2006 10:38:25 -0500
Message-ID: <1163345905.4138.501.camel@fc6.xsintricity.com>
References: <4556B86D.3030802@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9ShMH9vlt5CiIkHULKKc"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4556B86D.3030802@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--=-9ShMH9vlt5CiIkHULKKc
Content-Type: multipart/mixed; boundary="=-2pR18qWx4s8mHZ6VhKNu"


--=-2pR18qWx4s8mHZ6VhKNu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2006-11-12 at 01:00 -0500, Bill Davidsen wrote:
> I tried something new on a test system, using the install partitioning=20
> tools to partition the disk. I had three drives and went with RAID-1 for=20
> boot, and RAID-5+LVM for the rest. After the install was complete I=20
> noted that it was solid busy on the drives, and found that the base RAID=20
> appears to have been created (a) with no superblock and (b) with no=20
> bitmap. That last is an issue, as a test system it WILL be getting hung=20
> and rebooted, and recovering the 1.5TB took hours.
>=20
> Is there an easy way to recover this? The LVM dropped on it has a lot of=20
> partitions, and there is a lot of data in them asfter several hours of=20
> feeding with GigE, so I can't readily back up and recreate by hand.
>=20
> Suggestions?

First, the Fedora installer *always* creates persistent arrays, so I'm
not sure what is making you say it didn't, but they should be
persistent.

So, assuming that they are persistent, just recreate the arrays in place
as version 1.0 superblocks with internal bitmap.  I did that exact thing
on my FC6 machine I was testing with (raid1, not raid5, but no biggie
there) and it worked fine.  The detailed list of instructions:

Reboot with a rescue CD, skip the finding of the installation, when you
are at a prompt, use mdadm to examine the raid superblocks so you get
all the pertinent data such as chunk size on the raid5 and ordering of
constituent drives in the raid5 right.  Then recreate the arrays as
version 1.0 superblocks with internal write intent bitmaps.  Then mount
the partitions manually, bind mount things like /dev and /proc into
wherever you mounted the root filesystem, edit the mdadm.conf on the
root filesystem and remove the ARRAY lines (the GUIDs will be wrong
now), use mdadm -Db or mdadm -Eb to get new ARRAY lines and append them
to the mdadm.conf (possibly altering the device names for the arrays,
and if you use -E remember to correct the printout of the GUID in the
array line, it's 10:8:8:6 instead of 8:8:8:8), patch mkinitrd with
something like the attached patch, patch /etc/rc.d/rc.sysinit with
something like the other attached patch (or leave this patch out but
manually add the correct auto=3D parameter to your ARRAY lines in the
mdadm.conf), chroot into the root filesystem, remake your initrd image,
fdisk the drives and switch the linux partition types from raid
autodetect to plain linux, reboot, and you are done.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-2pR18qWx4s8mHZ6VhKNu
Content-Disposition: attachment; filename=mkinitrd.patch
Content-Type: text/x-patch; name=mkinitrd.patch; charset=ISO-8859-1
Content-Transfer-Encoding: base64

LS0tIC9zYmluL21raW5pdHJkCTIwMDYtMDktMjggMTI6NTE6MjguMDAwMDAwMDAwIC0wNDAwDQor
KysgbWtpbml0cmQJMjAwNi0xMS0xMiAxMDoyODozMS4wMDAwMDAwMDAgLTA1MDANCkBAIC0xMDk2
LDYgKzEwOTYsMTMgQEANCiAgICAgbWtub2QgJE1OVElNQUdFL2Rldi9lZmlydGMgYyAxMCAxMzYN
CiBmaQ0KIA0KK2lmIFsgLW4gIiRyYWlkZGV2aWNlcyIgXTsgdGhlbg0KKyAgICBpbnN0IC9zYmlu
L21kYWRtLnN0YXRpYyAiJE1OVElNQUdFL2Jpbi9tZGFkbSINCisgICAgaWYgWyAtZiAvZXRjL21k
YWRtLmNvbmYgXTsgdGhlbg0KKyAgICAgICAgY3AgJHZlcmJvc2UgL2V0Yy9tZGFkbS5jb25mICIk
TU5USU1BR0UvZXRjL21kYWRtLmNvbmYiDQorICAgIGZpDQorZmkNCisNCiAjIEZJWE1FIC0tIHRo
aXMgY2FuIHJlYWxseSBnbyBwb29ybHkgd2l0aCBjbHZtIG9yIGR1cGxpY2F0ZSB2ZyBuYW1lcy4N
CiAjIG5hc2ggc2hvdWxkIGRvIGx2bSBwcm9iaW5nIGZvciB1cyBhbmQgd3JpdGUgaXRzIG93biBj
b25maWdzLg0KIGlmIFsgLW4gIiR2Z19saXN0IiBdOyB0aGVuDQpAQCAtMTIzNCw4ICsxMjQxLDcg
QEANCiANCiBpZiBbIC1uICIkcmFpZGRldmljZXMiIF07IHRoZW4NCiAgICAgZm9yIGRldiBpbiAk
cmFpZGRldmljZXM7IGRvDQotICAgICAgICBjcCAtYSAvZGV2LyR7ZGV2fSAkTU5USU1BR0UvZGV2
DQotICAgICAgICBlbWl0ICJyYWlkYXV0b3J1biAvZGV2LyR7ZGV2fSINCisgICAgICAgIGVtaXQg
Im1kYWRtIC1BcyAtLWF1dG89eWVzIC9kZXYvJHtkZXZ9Ig0KICAgICBkb25lDQogZmkNCiANCg==


--=-2pR18qWx4s8mHZ6VhKNu
Content-Disposition: attachment; filename=rc.sysinit.patch
Content-Type: text/x-patch; name=rc.sysinit.patch; charset=ISO-8859-1
Content-Transfer-Encoding: base64

LS0tIC9ldGMvcmMuZC9yYy5zeXNpbml0CTIwMDYtMTAtMDQgMTg6MTQ6NTMuMDAwMDAwMDAwIC0w
NDAwDQorKysgcmMuc3lzaW5pdAkyMDA2LTExLTEyIDEwOjI5OjAzLjAwMDAwMDAwMCAtMDUwMA0K
QEAgLTQwMyw3ICs0MDMsNyBAQA0KIHVwZGF0ZV9ib290X3N0YWdlIFJDcmFpZA0KIFsgLXggL3Ni
aW4vbmFzaCBdICYmIGVjaG8gInJhaWRhdXRvcnVuIC9kZXYvbWQwIiB8IG5hc2ggLS1xdWlldA0K
IGlmIFsgLWYgL2V0Yy9tZGFkbS5jb25mIF07IHRoZW4NCi0gICAgL3NiaW4vbWRhZG0gLUEgLXMN
CisgICAgL3NiaW4vbWRhZG0gLUEgLXMgLS1hdXRvPXllcw0KIGZpDQogDQogIyBEZXZpY2UgbWFw
cGVyICYgcmVsYXRlZCBpbml0aWFsaXphdGlvbg0K


--=-2pR18qWx4s8mHZ6VhKNu--

--=-9ShMH9vlt5CiIkHULKKc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFVz/xTzP9PM7pjw8RApsVAJ9tybf56mRKZ5Jb4kyLI3fGnEfbXQCfVON6
Ag0iFLFgkFB9ymJ1vSI9lN4=
=F4ox
-----END PGP SIGNATURE-----

--=-9ShMH9vlt5CiIkHULKKc--

