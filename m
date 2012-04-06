From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 6 rebuild
Date: Fri, 6 Apr 2012 18:28:20 +1000
Message-ID: <20120406182820.6d734eb3@notabene.brown>
References: <CAJ72viMGQ-MesqGcXkwxjLH4Bt-4rXU1KT=mAgux5JhjKd0VYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hS2_LORFYDDJkMjsdMJC+wp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ72viMGQ-MesqGcXkwxjLH4Bt-4rXU1KT=mAgux5JhjKd0VYg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Bush <bbushvt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/hS2_LORFYDDJkMjsdMJC+wp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Apr 2012 03:01:26 -0400 Bryan Bush <bbushvt@gmail.com> wrote:

> If you have 2 failed drives in a raid 6 array, will it rebuild them
> both at the same time or in serial?

Maybe.

Probably not, but it can be coaxed to.

The next release of mdadm will contain

http://neil.brown.name/git?p=3Dmdadm;a=3Dcommitdiff;h=3D9f58469128c99c0d7f4=
34d28657f86789334f253

which will ensure that if you:

  mdadm /dev/md0 --add /dev/foo /dev/bar

then both will be added before the recovery starts, so both will be recover=
ed
at the same time.

Alternately you could:

 echo freeze > /sys/block/md0/md/sync_action
 mdadm /dev/md0 --add /dev/foo /dev/bar
 echo idle > /sys/blcok/md0/md/sync_action

you might even be able to leave of the first step.
The "add" will cause a recovery to start on just one device, but then when
you write 'idle', it will abort  the recovery, automatically restart, but
this time will use all available spares.

NeilBrown


--Sig_/hS2_LORFYDDJkMjsdMJC+wp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT36pJDnsnt1WYoG5AQJCRg//T8J78h4K3uigMKNAWfh8YS+BceIqE8KK
TbV5xybmpxyTN0CA6fHtBZxrfe/6K8LrmOSDijaH0r1pcTQMu+lECs0QrIkqgjGL
K12UWIXfGQUH0BDiZParo5dlfmY4wZfUVdzvJUdJXZ75KCvddUSF0IgCDM9lLr8y
xPtZrE9e3WMcvd7LdflxkZ36Mm0qX8bdw/WUZgzeQJGzPRrSGfIwkwwXzUFWfD9R
V41YlddwK9EWAces3Py5+LRuVJWtNniN58Ixxxcev3BC1+uCyZYfLwlyqYbuvhgA
7IceRYPCe0MPK75gEMFE+8lI2PUe/eD2lcqj++3NJj1QIA27QIKQ+vTHqKaYgHM6
+rsl3zjvEvtAAZwMLk+vK5VO3dBCJ7FQACxJVcg5ZA/BnfQNTCHZcfac2N5s7bPu
MLZs4nD6H+Pi1RVCHltVCzuWA4aN2O03NkQVTgTfO+9j/j/MUv2JIMN8yJAzy/FH
IUq78FOBPPd5kZi+U4MugM4SXsqQx+Y8dBuypNeBRfR/9a9b+db0zsT2dvFmD/Yb
JaJ3+lks6h2MkHU3zsUuOPj4hC+tP2Vq+IYI1+avADSxPLmKOsM0ko1cqlmH80Z4
1CwrMtEv+pVUS/cxhM9TpT2YlXvo/Trnh3a4CkSY4RPXXXJZNmci27G0HwNQCyR/
ez3q5fgNb+A=
=Jsvl
-----END PGP SIGNATURE-----

--Sig_/hS2_LORFYDDJkMjsdMJC+wp--
