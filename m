From: NeilBrown <neilb@suse.de>
Subject: Re: Replace RAID devices without resorting to degraded mode?
Date: Thu, 13 Mar 2014 10:18:33 +1100
Message-ID: <20140313101833.7fccbabe@notabene.brown>
References: <CAK_KU4ZfsCOyZxgkxLC7AFOJ2XEvcHi-Gr7itv4q_pPOQbaAYA@mail.gmail.com>
	<53202503.10901@hesbynett.no>
	<CAE6VuKFxqRET=tQoSvbHFd7iiKeXBPJZTBUgTTwMpzOnrPEmbg@mail.gmail.com>
	<532056EB.2080206@hesbynett.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VoJmwLsTpc0qZcDS9WpM40L"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <532056EB.2080206@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Raul Dias <raul@dias.com.br>, Scott D'Vileskis <sdvileskis@gmail.com>, "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/VoJmwLsTpc0qZcDS9WpM40L
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Mar 2014 13:45:31 +0100 David Brown <david.brown@hesbynett.no>
wrote:

> So for raid1, you would add a new mirror device, making a 3-way mirror
> instead of a 2-way one (I don't know off-hand if md raid allows this
> re-shape).

It sure does. raid1 can be 1-way, 2-way, 3-way, 4-way ..... and "mdadm
--grow" can easily switch between them.

NeilBrown


--Sig_/VoJmwLsTpc0qZcDS9WpM40L
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyDrSTnsnt1WYoG5AQJG3g/9FSjsUODRcihXDRJqUl+q0cmBcQCkaNBs
EcbUInkto18Rr3JzQQt1/tZXo4vipd8rcAYWG2sqbvu+AFH5Z9mrxrYH37atb3FB
yYTdhxuulPB2j0ak87Yi26wjjI1Z6vQtQHwWdldT4qsymuzZJ0SYdVgXXkziVq9I
93DFl1zHhXRRzaUOIr3xO/Z8hpFxWz0Yr65u+5NVXb3KwoZIZ2CZ85D+RjNnH37o
+jPG8jeBl4qdekr4oOXOCQYmYm7zflkunrMmqkDwLeOdpXuZx1btmvMM1bm6CWOO
oCojCXABRwtSMy5fqrjb6gjDf7wlrCcGgezV5VSthY3P2WZOf3A3MRbF8rajTtAE
0wwHGrF2+WTMcM/Xi8ruMmtmmFmIMMs9MG63ZruzGRLAPxVWNBJ8jwBTPSFAX+iX
5h2mmi4Mu1dejacqe4c4a44fjTnqAp3TUhDIz5XCo9ITsA2+t2+Au5OwIcsRPV9Q
Rok+ZB7mM5TzFW+qscxD6W0xqRXsjRDKPFfkNV0jtb8wR8vcoFmm5v6YXvmjoogZ
0UBcvmrvHlIkgOjfWEfkHfQG7Ob5QO48fuZMsytUGcm6m+PMctu3hc07psxjb/23
/xSAGmR9u/GxgEg6I8NR+tA6JnkwFymCyHfrrzOjqRkCDBikhNnPlL9k0IOG2yaN
EbvL3aj19x0=
=9QFu
-----END PGP SIGNATURE-----

--Sig_/VoJmwLsTpc0qZcDS9WpM40L--
