From: NeilBrown <neilb@suse.de>
Subject: commit backport request
Date: Mon, 9 Jul 2012 14:02:30 +1000
Message-ID: <20120709140230.3cf926ec@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BF=sltx895y1CGEbp=TrhdZ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Jose Manuel dos Santos Calhariz <jose.calhariz@netvisao.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/BF=sltx895y1CGEbp=TrhdZ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Mr Stable,

 please apply patch

commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
Author: Shaohua Li <shli@kernel.org>
Date:   Tue Jul 3 15:57:19 2012 +1000

    raid5: delayed stripe fix


to 3.4.y and 3.2.y.

It fixes a deadlock in RAID5 which can cause all IO to hang.
It has been demonstrated to fix a real-life problem (the race is not
theoretical).

Thanks,
NeilBrown

--Sig_/BF=sltx895y1CGEbp=TrhdZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/pX1jnsnt1WYoG5AQJwGg/7BefdxtR7bq6dUn5ZpmmadoXuqaHMqFsB
GYnNmACmMXiBOrOO3OK9t0I9m3uM+CzKvWjgPs+EUWUUwhx7vwdxYleJnq5j48Hg
mMF6eLTVIvMA7nRm5SSQM9eEfHsKg//NYeSE0umgdE9zOpR0V8KoIMQgLcBpLVPX
8KuaXaCAMeaFzKpNH4IxqVFetjvU90meDhenln1QPOAD9SK+NFyKCY+mWSVYr51m
VNIgN59/PiCzHKK9kAOh8wXAWvDhOTGBcW1LHZPfEhZn/cpttJpg1YWYfUVOLLRl
qAg9Gi9jeDzVJ4ZWsTPSUquoJU3qtOXDOe5LBVnKp2bvDUn9IfdVRk25lJehktyS
LpvjKZK2gMM1auec5ivE0r+JbyIHyi75jir4n7yh90u4TY7b75TqaAxaYfVlGQnb
Bk3QSjCleXdI9U4LLHQOayMwFaZfwdz8AVjLLWnsgfokIb4bOFJxgkeBdh6k3ZYF
SXQW58JbD8K7fTlnZw3OjiUHiJVBKFlqD8igTJcAbigCnQ4N35vC+XbjroO9bzF8
iKOi2XfMDLZTCxtdFYKynmTyqLVfmmtLpTsOI0ECqba18lo7WRdHl1itDzK08KbD
B6J5zRsnhREsF50QwZ71307GNAzo/oJvnrEB0twVj324HwmxXRhHTyL4rmKU0gia
cCbx8XxvSmU=
=FUEG
-----END PGP SIGNATURE-----

--Sig_/BF=sltx895y1CGEbp=TrhdZ--
