From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v5] md: protect against crash upon fsync on ro array
Date: Tue, 5 Feb 2013 09:30:43 +1100
Message-ID: <20130205093043.3ea21a02@notabene.brown>
References: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk>
	<5102A01B.7000407@profitbricks.com>
	<1359229480.2894.21.camel@deadeye.wl.decadent.org.uk>
	<20130127163942.GA28572@infradead.org>
	<510653A3.9090403@profitbricks.com>
	<51067164.4050301@profitbricks.com>
	<1359438326.3367.41.camel@deadeye.wl.decadent.org.uk>
	<5107B03A.9030109@profitbricks.com>
	<1359462593.2417.1.camel@mattotaupa>
	<510AC77A.2000702@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/aoRxshDEMqFg6PNpL=YVBE5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <510AC77A.2000702@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, Christoph Hellwig <hch@infradead.org>, Paul Menzel <pm.debian@googlemail.com>, linux-raid@vger.kernel.org, 696650@bugs.debian.org
List-Id: linux-raid.ids

--Sig_/aoRxshDEMqFg6PNpL=YVBE5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Jan 2013 20:35:22 +0100 Sebastian Riemer
<sebastian.riemer@profitbricks.com> wrote:

> Hi Neil,
>=20
> please apply this patch! It is correct, now.
>=20
> It applies to 3.2.y, 3.4.y, 3.7.y and latest 3.8-rc5. All these versions
> are affected by this bug.
>=20
> 3.0.y and 2.6.34.y are also affected. Please also find the patches for
> these versions attached. I've tested them. They work.
>=20
> The strange thing is that 2.6.32.y is immune against this bug. So it
> must be a regression. The patch restores the same behavior as present in
> 2.6.32: fsync receives success.
>=20
> I've tested against the following versions: 3.8-rc5, 3.7.5, 3.4.28,
> 3.2.37, 3.0.61, 2.6.34.14 and 2.6.32.60.
>=20
> Cheers,
> Sebastian

Thanks!
I've added "Cc: stable@vger.kernel.org" and will forward it to Linus shortl=
y.

NeilBrown

--Sig_/aoRxshDEMqFg6PNpL=YVBE5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURA2kznsnt1WYoG5AQJxARAAsqAXjfoD+2fq+fIudqINM3+RDvYZ1ogD
XxXKW+PD1dqncCKtpwgssWj6Tz+Kf3SHB4aXzF4Z+MbIMIcRFn3MpzWi1WI2yj2l
wmouAxyxlKA34PEqi60AR6iduwSjTZhuegqDUeOLVVNNU9xp2AdWbCzDFl5rnqft
bGa1Rl7HqOCSYAs2C753HaDpUUhg82hmc4ER9mqd3YHatvQeVOYcClS5G8vZb6Ke
je2rqvMoYOuN8EH3QzhYGEwdR46ndVp1e8EUWVKlK6x/bgXPxshPY+HEJGcVNvGB
c+lmMoQNgMAvFlszCraC6o7HXoAsy8iJcVl/32ZsGYdYXp0R8Be9aus9Du9tyR7V
usUlhfVHx5YkTw9ziuvUwiBWqN7YmUDZGfMZCFtFzMduBQpb/Ykhp545u+5ghi54
KbtnifwW9IfE5qwGl2UqCv20WVxfU+Iibz5ENqKmWGOjCZj/RFNUiBAndtqfWrGi
ISm5HSnTLj3lmeNht8C/ELXsgU9P4JVkkOhKYBPQ0f+mqQRuH/zL2hGdhn7K6qpy
PG55t2J09r1ZD8exigvWkcYgNH062CGbxiw+/NF0HtstIqx1uxh/uS9D2o5C7mcX
kYXNDSSmAijudyrHZMDQcdn7ddEyLoqTTxqBf/Lsg5iMrc9U8ZF07Pf0ddttQet/
L5B8hI8IsXU=
=7zqr
-----END PGP SIGNATURE-----

--Sig_/aoRxshDEMqFg6PNpL=YVBE5--
