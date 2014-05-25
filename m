From: NeilBrown <neilb@suse.de>
Subject: Aiming for release of mdadm-3.3.1 next week (early June)
Date: Mon, 26 May 2014 09:45:36 +1000
Message-ID: <20140526094536.3e1e4bdc@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PFUbAX=Xyr=5LOqN9I6vKVY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/PFUbAX=Xyr=5LOqN9I6vKVY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


I seem to remember suggesting a while ago that mdadm 3.3.1 would be out
before Easter.  Clearly this didn't happen, but I think I'm now about ready.
So I plan to release mdadm-3.3.1 in the first week of June.  I think it is
mostly ready now, but a few self-tests are complaining and I need to determ=
ine
where the fault is.

I've made a few changes to the DDF code just recently - mostly cleaning up
and small adjustments, but if anyone uses DDF and want to double check that
the current code still works for them, I wouldn't object.

I've also added "misc/mdcheck" which is meant to run nightly and initiate a
'check' on all drives periodically.  It will stop the 'check' after a set
period of time and  continue from where it left off.  It is currently fair
basic and I like  it that way, but if there are particular features that
people would  like to see in this sort of script, now would be a good time =
to
say "the script of here does the same thing only much better, why not just
use that"...

There have been quite a few changes to improve interaction with systemd.
This probably isn't all perfect yet but hopefully once it is in a real
release it will get tested more.

Thanks in advance for any testing and/or feedback.

NeilBrown

--Sig_/PFUbAX=Xyr=5LOqN9I6vKVY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU4KAoDnsnt1WYoG5AQLX3hAAv0TpZSona6AyJyvAWAnQwCao5WjkCUPR
uRRGwmIXl/SRSMsufwxthJgNqh0CGfFaMlMvHOxRrUYJUp5hrMFo09rGhu2HJUBS
h926slrl782XHIPmQinBBEWSd26mn1wgduTh0RTDmmkz7yJYXe6y6KNLBlv3qiB7
tnPMiuQ0QZRIUPyZqaesKUQ94fDj+hyxJejOrb8fn8RQ3nQWQ4hTow7roM1Boqp3
IJev1K4py4KCA5+JVbpdNZ5P8MrMhKRQZaFIzc5LIUtrysQ9s1NC2panUgmIUCNV
cHpbtFfUQqemXqS9MkADtu6IlPyKd/FAXCXZDfgC2J/M5Vd25Ak04fgqXyHs+33c
isLllA7TyuJ10URJNRMof7LdkPs6A5alsnLOuYx0TSi7BZd9DcUdNPdGiparakwX
o53JFJjdKupG7jYDlH6nIWUAYAd+Wu326A2HbbRzVXmPj502GijlJxlriEdL/1vF
3P9OV1v7ncPPv2GBl0reQQsPH6scp7EuMG4qHUUs+R1wLvmfCU7o+HlWuFNc9uU4
aVTyr4LYYbvsv26aBwG7XlrLQMjYqN5jUfT5aaSqzclrqV/5aw/KLqfdIYvO1DMp
0R/QMGRbFVppIXoOxnEYCmQn3e314fxE+mitKMQE9aHezN71TJC/OQnMFQJwl69v
up0QpMbIsj0=
=g7Nx
-----END PGP SIGNATURE-----

--Sig_/PFUbAX=Xyr=5LOqN9I6vKVY--
