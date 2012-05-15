From: NeilBrown <neilb@suse.de>
Subject: Re: Add set bad lba function in md-faulty module.
Date: Tue, 15 May 2012 10:16:11 +1000
Message-ID: <20120515101611.4f2aaba0@notabene.brown>
References: <201205141822219532629@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Cg5Fd_y/w2M5BnvIC=nGNgj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201205141822219532629@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: kedacomkernel <kedacomkernel@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/Cg5Fd_y/w2M5BnvIC=nGNgj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 May 2012 18:22:25 +0800 "kedacomkernel" <kedacomkernel@gmail.com>
wrote:

> Hi all:
> 	In order to test md code, sometime we need  simulate read/write harddisk=
 error.
> 	Using hdparm --make-bad-sector to  simulate  read error.But I did not fi=
nd way of  simulating write-error.
> 	I tested md-faulty module, it can do this.But it is not provide the func=
tion link hdparm --make-bad-sector,which did not set lba.
> 	Using hdpamr --make-bad-sector to  simulate read error can cause some pr=
oblem.
> 	It will cause ata commnd reset,disk reset and so on.It take too log time.
> 	So I think add a function in md-faulty which can set read/write lba.
> 	How about ?

I don't know how --make-bad-sector works so it might not be possible to get
md to respond to the same command.  But if it can work it sounds like a good
idea.

Patches welcome.

NeilBrown


>  			=09
> --------------
> kedacomkernel
> 2012-05-14
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/Cg5Fd_y/w2M5BnvIC=nGNgj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT7GgSznsnt1WYoG5AQLZZBAAqU0yn9kDM2RS4j2uOGUEGM799tMyiisr
InJ0iwkehEC4jt6MvLRn7be+rWxFvPv0io4s+swO/lhG4yPi9LngNSQRrbv284h2
5GtIYz3EAqYY8sG8BJjCzWJMcobWLCg4iXkRtc0InNx8bK+Gab6qGUbgNDs81b2a
2dVBWLqTcA+JlgOsBkkbUhgV0Kv+rmTSwT61Ms/UgxzWEW088IzykPt1XwH6a7hk
3MYP4U1fIBiYXSZjpKW8uBar6m9zmOY8vSQv6LU9Tu89rw2PTtS0yAl6vq6XO074
1T8dVgQKK9uCG3dS7nwYnL7YktxkfJ0dOqwIOJbqPWyq0YdEyYxM6D0nXPwWZbbk
Y6jtdouu+oHzV8isAj8U/25q2h4mySM8cggWwBcxD4pOqzlhXf5dtNiS1N+UO/sZ
oyE7yIMU6Gj4rvHxpq3IRtbn+Dk9YwcFde7tjTlLtlnC0zdi70AM64H1Y2DCmXSl
504Ke7VxBJyGtRSsxDyPJYhiGGtXElgdXWn5+ZUOK6jG/byyTRQbeQRW1agMXMZp
ipyV1H2Mswuq9HTWQkIZXF+Q4P4p/mx2Nr4gC9XvDP/OudA1JepOV3N+N6P71iz7
lfl1QgyMWrDor7ghaESQON/5WCCOICRzKG6vzV5cW6T8CBD00a19YLmpU/ElApj2
KO/oEDDoGNY=
=PFci
-----END PGP SIGNATURE-----

--Sig_/Cg5Fd_y/w2M5BnvIC=nGNgj--
