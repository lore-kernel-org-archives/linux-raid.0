From: NeilBrown <neilb@suse.de>
Subject: Re: how to handle bad sectors in md control areas?
Date: Mon, 3 Mar 2014 08:38:38 +1100
Message-ID: <20140303083838.6f6ba7c6@notabene.brown>
References: <530DA2DE.9030705@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VDFYEVUiWJJ.OQ_CVwNwPc/"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530DA2DE.9030705@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/VDFYEVUiWJJ.OQ_CVwNwPc/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Feb 2014 19:16:30 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
wrote:

> In another thread I investigated an issue with a pending sector, which no=
w seems to be
> a bad sector inside the md header (the first 256k sectors).
>=20
> The question now remaining: what is the correct approach to fixing this p=
roblem?

You could "fix" it by simply redefining it not to be a problem.
If you never get an error then is there a problem?

>=20
> The more general issue is what to do when any md control area develops an=
 error. does
> all data have redundant copies?

We don't currently have any redundancy with a device.  Of course most
metadata is replicated across all devices so there is redundancy in that
sense.
I have occasionally thought of creating a v1.3 metadata which duplicates the
superblock at both end of the device.  Never quite seemed worth the effort
though.
The write-intent-bitmap would be a lot more expensive to duplicate but as it
is identical on all devices, the  gain would be small (though there are cas=
es
where it would be useful).

The bad-block log probably should be duplicated.  That wouldn't be too
expensive and  might have  some real benefits....

>=20
> The simple way that I see is to fail the member, remove it, clear it (at =
least
> --zero-superblock and write to the bad sector) and then add it. However t=
his
> will incur a full resync (about 10 hours).
>=20
> Is there a faster, yet safe way? I was thinking that a clean umount and r=
aid stop
> should allow a create with --assume-clean (which will write to the bad se=
ctor and
> "fix" it), but the doco discourages this.

Why do you think this will write the bad sector?
When you --create and array it doesn't write too all the space on the array.
It only writes what it needs to.  So the superblock, the write-intent-bitmap
and maybe the bad-block-log.  But nothing else.
And most of that gets written during normal array activity.

So if a block remains unwritten after stop/start/check, you can be fairy su=
re
it isn't used at all, so you can ignore it.  Or write zeros to it.

>=20
> Also, it is not impossible to think that the specific bad sector (toward =
the end
> of the header) is not actually used today, meaning I can live with it as =
is, or
> write anything to the bad sector as it does not get used. Too involved th=
ough.
>=20
> A bad sector in the data area should be fixed with a standard raid 'check=
' action.
>=20
> TIA
>=20

NeilBrown

--Sig_/VDFYEVUiWJJ.OQ_CVwNwPc/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUxOk5Dnsnt1WYoG5AQJorA/9E6Z4stWedsd5iiaOcmjEDkDzBlO1fuL+
ZCJf7/qaqlgqZZABO9L94bbvFuqo+w8WIx8rne349JnC6E/CXreUj2l0ATre9smf
KeBD+jXz4EqUYczu/kLj2Gu7m1Z1CBlLJaH1OeteXxdSIM7/xz1Wepc9ryLd+aDe
TvDlSF6NSSZMzAcm2lXoz2mbe3MT6SZbTI+vX4KiQjV5JTfaEfc4NQm9xn7Tugi6
FuVD6qVA8azi2N2O2VxdNEyEfOLQuNSaneEK0leL9MdTUNcRpM4rQRNtmQ27M4/v
BMFsMTlWRhrQEV6CxdvP0y3pMQyLsYjy5I4MYw2gI7R0HYVhQKjLeiwJeETcn/Wi
KN3K1i4K5fsaFNp52RFWqUxDtgDEivnSDqc4tZMwJN0M/jFQB7NyP4w2XfENJgAX
YB6O4r6rhBqk8hifwTk957qd5wGFjGnn84PhKxLi9G0ALqJAJ/g4fz009k2eZYLE
FfonJLG/Uv744RWeAFunQjkQEMvOZ4BWJETPtR1AgiQs2eS6bMG2UJ/qUsqWofAZ
qKYzFGyNmBrW99zLy2cIO0o00RRSUa8PgxMhHJind8alxz91+9vGKnrgaM0p6gGL
SEccpLsCv2O7P794AwROMZ6iuWq8QzLo4ev7YAAu2OdEjcVCSGajetnUpOGI3g4V
OHlLM3/I6gg=
=ABjj
-----END PGP SIGNATURE-----

--Sig_/VDFYEVUiWJJ.OQ_CVwNwPc/--
