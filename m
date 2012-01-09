From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 device hangs in active state
Date: Mon, 9 Jan 2012 11:26:44 +1100
Message-ID: <20120109112644.489e4a48@notabene.brown>
References: <4F0A129E.5020706@nuclearwinter.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Yo_V/oOW0=LEjV1a+N0ysB4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F0A129E.5020706@nuclearwinter.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@nuclearwinter.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Yo_V/oOW0=LEjV1a+N0ysB4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 08 Jan 2012 16:03:10 -0600 Larkin Lowrey <llowrey@nuclearwinter.com>
wrote:

> Suggestions?

# echo t > /proc/sysrq-trigger

and capture that messages that go to 'dmesg'.  Post them.

Hopefully your message ring buffer is big enough to collect the entire
output.  If it isn't you might need to boot with =20
   log_buf_len=3D1M
or similar.

That should show what process is blocking on what.

NeilBrown

--Sig_/Yo_V/oOW0=LEjV1a+N0ysB4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwo0RDnsnt1WYoG5AQJzBBAAvclXBymdNefMN8L7XK+shbPKc2XwvYPW
zMRBL/cF/dDGowET2g3Uc8GcuMZw73N6unUk0w35KbRw9gM6KaUFm873GDtkJXD2
l+d2GUBGvor9/5GDKHzzZLd3uIoBOWTZeBKl/QBCY7eH957F+2toUI3sc/T22pd5
QfQJZ8LeWATN2ZUURbTJR6gUPanNyMthiwNfSRtrcLaMuUWgX0b4P7CtBEbW4dJD
mGPhm0ALlM9b4xtMg4CNklUZWXnOH7XW+1zrblf293rG6n1oNJ6r+hNWR/GIxQTR
dJCFmhXsz8Q4X/sO5p1EXHq4BX3V75L0MaNcP9yZroG7QuE9J6cpCY8uh/oxYixQ
LANHpEjZWOw4hRtUBlciFx35iTUMxWAD9s0H88kB2LWm9ipQhB1ze9TG418ecQXI
YuRKcoMo5Bh32wIXFaC92fGIxWQyYvHUv7mGWcC+jMKqJ8vEGoZrQCk0yVIHna7U
jrxBcHw3oBPc6q1QJvMupGMLm6YZmpTiYQ43ACrtnGssYhcTrvn40hotfFT9i2p3
2aEu0OFyQesR91qwSKKuQ5j5nwacRy0EAJX+PBtoua/jKVMcTz8T3QP9ZUCzIg0T
rRmuQBsFOuh1OklUS16aYQbv7QZjgYGMB2BjMuOt4EyLjQtT5rFbkAIFP9Sra3Bq
aNmOhPkCAvk=
=8m62
-----END PGP SIGNATURE-----

--Sig_/Yo_V/oOW0=LEjV1a+N0ysB4--
