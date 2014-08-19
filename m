From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v1 0/8] raid6: support read-modify-write
Date: Tue, 19 Aug 2014 17:16:52 +1000
Message-ID: <20140819171652.3fc62742@notabene.brown>
References: <70b876f5-2336-4af1-bdc7-da789ecc3599@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/2nJgoVzMh0Xz0zWVxjvx+SC"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70b876f5-2336-4af1-bdc7-da789ecc3599@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: stockhausen@collogia.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/2nJgoVzMh0Xz0zWVxjvx+SC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Aug 2014 11:56:23 +0000 <stockhausen@collogia.de> wrote:

> Hello all.
>=20
> First of all thanks to an older patch from Kumar Sundararajan and=20
> Dan Williams that helped me to understand RAID6 logic inside md=20
> better. Everything is based on ideas & discussions that started
> with http://marc.info/?l=3Dlinux-raid&m=3D136624783417452&w=3D1
>=20
> So once again. Implement RMW support for RAID6. This time improve
> syndrome calculation too. The logic was split into very small =20
> parts. Each having a detailed explanation about what is going on.

Thanks a lot for these patches.  The size you split them in is good.
The order is ... not quite right.
It is important for each patch to make sense by itself and for everything to
work sensibly at every point.
Yet your first patch allows PARITY_PREFER_RMW to be set for RAID6 even thou=
gh
RAID6 doesn't support it yet ... that doesn't make sense.

Also I don't like that fact that you added functions with empty definitions,
even if you later filled out some definitions.
I would prefer to not have the 'hasxor' field, but to expect 'xor_syndrome'
to be NULL for some methods.
Then the RAID6 code would only try RMW is xor_syndrome was non-NULL.
Then you just add a complete xor_syndrome function and it becomes usable.

So I'd probably have that patches:
 1/ add declarations for xor_syndrome and the code to
    report benchmarks on boo, but no actuall xor_syndrome code yet.
 2/ improve test program
 3/ xor_syndrome for generic_int
 4/ add logic for improved rmw_syndrome.
    This always uses rmw for RAID6 if xor_syndrome is defined
 5/ xor_syndrome for SSE2
 6/ config option

Maybe swap the order for 4 and 5.

I want the config option to be last because I don't want it to go upstream,
but everything before it should be able to.

The other thing that is missing from this are performance numbers.
Any numbers at all would be a good start.  If we can collect number from
different use case to get a good overview of the improvement (or not) this
brings, then we might have case for including it upstream.
I realise you know this and made it clear in your point 4.  I just want to
emphasis it again.  I might do some testing myself, but we really need
someone with a larger number of devices to tell us how much better this mak=
es
things work for them.

Thanks for your effort so far.  If you can revise the patches so:
 - config option is last
 - 'hasxor' is not used
I'll put them all in my git tree to make it a little easier for people to
test, and probably do a little myself.

Thanks
NeilBrown

--Sig_/2nJgoVzMh0Xz0zWVxjvx+SC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/L55Dnsnt1WYoG5AQLNJg/6AvEIjZ5lhr1W6DYhRwVx2rJMzbrLuq7I
Iv9Anb42L3BZlObD9VdCSEu8VIPVaSqc/Vy448ltNvotugj9T87E1k4guCCYUeJE
Ydmkemy/nFy9EeDqKishYzUG1jupWjOyAKymmKgsRw4QHfP+/N/w3SADdvepY6mv
Erlyf7GLELyO801L2byFpQgWPNG5eJRF+qJAWZSV+L8cBH5MFJKONADZ1Z5s9yik
WQAX7iMMJYUo4wSKDlxcZAntHRelWp5+dZbnyW2nRfQ1XaFujl0LnPq03kSB0dg2
EGH7AhJJAElk4oZiB/N7TtMGbWL1LBeJ41fh8dCcvzLoDtEHYPi1I17JPEqhnkni
qRSJtRXES2j0Ky90kH3n0m3kw976pSY9NsssChf0g8MMWrmkJ3VwjLHxfPhnyj69
8UYdJKEonH/Zxy4Z81+es3qYg6NdUru9HB1Y63M0szA1KrKx/xP6LzLBlgxjbbEz
WjkgtiO3+Ec5HFfWGw8Q1gT4/Z4FpMk4y6IC+mlmW/zQqdphgHmw3/g4b6B4BHCZ
jDCmPVALzatTujVrfrT8ZO8nDKsV3j1EA+AdsU1hVbnOi9kT534oq3EkwNy+uSRa
q/CXL/6J1CPkKMJe+fBXp9AiCkPrqCbdqho64IarGhY4h17JydBt18SONMev4AVB
MhcuDoepTFg=
=xHrc
-----END PGP SIGNATURE-----

--Sig_/2nJgoVzMh0Xz0zWVxjvx+SC--
