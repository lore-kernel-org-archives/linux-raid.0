From: Roman Mamedov <rm@romanrm.ru>
Subject: MD does not wait for drives on start-up with kernels 3.8+
Date: Sat, 30 Mar 2013 19:05:38 +0600
Message-ID: <20130330190538.4e3c1771@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Lv_v/Nq.XPh4xQxdbMXQXGj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Lv_v/Nq.XPh4xQxdbMXQXGj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I got a bizzare problem after trying to upgrade from 3.7.10 (which works fi=
ne)
to 3.8.3 or 3.9-rc3 (fail in the same way):

It looks like on the newer kernels MD does not wait for all drives to finish
registering before trying to bring up the arrays. As a result, on newer
kernels my arrays always come up with only 5 out of 7 members active.

dmesg 3.7.10:  http://romanrm.ru/dl/mdadm/dmesg37.txt
dmesg 3.9-rc3: http://romanrm.ru/dl/mdadm/dmesg39.txt

As you can see on 3.7.10 drives continue to go online until about 3.89sec
(Hitachi) and 4.26sec (card reader, unrelated), and only THEN, at 5.15sec t=
he
md0 starts; it has all drives and everything is good.

On 3.9-rc3 (and 3.8.3), md0 tries to become active VERY EARLY at 2.64sec of
boot-up!!! Of course missing drives which appear later, and of those, membe=
rs
of it should have been two Hitachi drives coming up at 3.33sec and 3.87sec.
So it starts degraded with 5 of 7 devices only.

What's up with this? I understand this might be not an md problem but an
udev(?) one; but how do I go about solving this?

--=20
With respect,
Roman

(resending this message since the previous one with largish attachments
didn't seem to make it to the list; also used a different dmesg for 3.7)

--Sig_/Lv_v/Nq.XPh4xQxdbMXQXGj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFW4yIACgkQTLKSvz+PZwg8JgCfaLpDWHUvquT/qe6AU8KgmlVt
cbQAmwdtv3WGGOJgUU30cKfxEAUOjDKT
=d4i6
-----END PGP SIGNATURE-----

--Sig_/Lv_v/Nq.XPh4xQxdbMXQXGj--
