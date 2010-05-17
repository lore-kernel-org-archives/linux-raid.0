From: Doug Ledford <dledford@redhat.com>
Subject: Re: Spare drive won't spin down
Date: Mon, 17 May 2010 14:11:42 -0400
Message-ID: <4BF186DE.5050502@redhat.com>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com>	<20100507162034.1370d645@notabene.brown>	<717013.48748.qm@web31703.mail.mud.yahoo.com>	<20100507194704.3ffcf17e@notabene.brown>	<4BE83B75.8050709@tmr.com> <20100512065318.44e934d4@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig560CEEB77A0614330F11DB92"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100512065318.44e934d4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Joe Bryant <tenminjoe@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig560CEEB77A0614330F11DB92
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/11/2010 04:53 PM, Neil Brown wrote:
> Theoretically, when the spares are one behind the active array and we n=
eed to
> update them all, we should update the spares first, then the rest.  If =
we
> don't and there is a crash at the wrong time, some spares could be 2 ev=
ents
> behind the most recent device.  However that is a fairly unlikely race =
to
> lose and the cost is only having a spare device fall out of the array, =
which
> is quite easy to put back it, that I might not worry to much about it.
>=20
> So if you haven't seen a patch to fix this in a week or two, please rem=
ind me.

They're spares.  They don't need to have an in-sync generation count.
Change the semantics so that spares have a 0 generation count and only
when they've been activated does their count get brought into sync with
the rest of the array.  The only thing needed to make that work is to
not kick them on assembly because their generation count doesn't match,
but that should be trivial (and sane) to do based on the fact that if
they are a spare, they don't contain data, so the generation count
really is meaningless.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig560CEEB77A0614330F11DB92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvxhuMACgkQg6WylM+/8ZQBNgCfYbC9GmC725yXaPR5G+M9xchc
NhsAn0Nsv6NrlYz9MHSQZKKqTSoTNycY
=pTRL
-----END PGP SIGNATURE-----

--------------enig560CEEB77A0614330F11DB92--
