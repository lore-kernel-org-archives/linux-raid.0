From: NeilBrown <neilb@suse.de>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 14:16:50 +1100
Message-ID: <20140225141650.56b8dac4@notabene.brown>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>
	<530AA09B.3090708@fnarfbargle.com>
	<530AA460.602@eyal.emu.id.au>
	<530AAA55.2080508@fnarfbargle.com>
	<530ABF21.7030200@eyal.emu.id.au>
	<BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl>
	<530BADF2.3090907@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/j98ev+SHPTIUK92uvdut3dP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530BADF2.3090907@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

--Sig_/j98ev+SHPTIUK92uvdut3dP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Feb 2014 07:39:14 +1100 Eyal Lebedinsky <eyal@eyal.emu.id.au>
wrote:

> My main interest is to understand why 'check' does not actually check.
> I already know how to fix the problem, by writing to the location I
> can force the pending reallocation to happen, but then I will not have
> the test case anymore.
>=20
> The OP asks for a specific solution, but I think that the 'check' action
> should already correctly rewrite failed (i/o error) sectors. It does not
> always know which sector to rewrite when it finds a raid6 mismatch
> without an i/o error (with raid5 it never knows).
>=20

I cannot reproduce the problem.  In my testing a read error is fixed by
'check'.  For you it clearly isn't.  I wonder what is different.

During normal 'check' or 'repair' etc the read requests are allowed to be
combined by the io scheduler so when we get a read error, it could be one
error for a megabyte of more of the address space.
So the first thing raid5.c does is arrange to read all the blocks again but
to prohibit the merging of requests.  This time any read error will be for a
single 4K block.

Once we have that reliable read error the data is constructed from the other
blocks and the new block is written out.

This suggests that when there is a read error you should see e.g.

[  714.808494] end_request: I/O error, dev sds, sector 8141872

then shortly after that another similar error, possibly with a slightly
different sector number (at most a few thousand sectors later).

Then something like

md/raid:md0: read error corrected (8 sectors at 8141872 on sds)


However in the log Mikael Abrahamsson posted on 16 Jan 2014=20
(Subject: Re: read errors not corrected when doing check on RAID6)

we only see that first 'end_request' message.  No second one and no "read
error corrected".

This seems to suggest that the second read succeeded, which is odd (to say
the least).

In your log posted 21 Feb 2014
(Subject: raid 'check' does not provoke expected i/o error)
there aren't even any read errors during 'check'.
The drive sometimes reports a read error and something doesn't?
Does reading the drive with 'dd' already report an error, and with 'check'
never report an error?



So I'm a bit stumped.  It looks like md is doing the right thing, but maybe
the drive is getting confused.
Are all the people who report this using the same sort of drive??

NeilBrown

--Sig_/j98ev+SHPTIUK92uvdut3dP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUwwLIjnsnt1WYoG5AQKAPw//c+ZGccqHmRLlCTjvv4eaZ11rBontpFii
hxilovzwYQASWMPQn7Wes/WRGrWjL51ElD6FnfiERoiXX4DU71iI0OOLU65i3ezk
XNUxnGVgGh9dosd4osS163yqmr9JNqq3ffk11Msn1yf/iKTmPE9qQOh7mXBw6uL8
ufyv6BIKgmLVN69diERhgCEljsAAUvmRC/ZPNKsunmkBKQm94oV5+ckAG+z6kb+H
nQ7JfUZbBDB0AggfrSlGKgBBE7vzYgxmy9ZFmcJEs7cxRJBGxTXnyjj8/bRvEyW0
g4dztshdL7tdBLr71mqZ/kHNlJv1iAjyarEJzitA0rWTP5c31ymbnE4WrSBh18Qh
icVvkSPLkGduX8H/Clv4gHbgMS83n+9//yfBeWB1xLbYJGV/YDzD+rgk3vaqWR/A
7HcNmcTFAkdQxqlcGdONCaA9eySGdNmBdNAp07Lvb8It1sAnnWPT48SXGz2yvqeZ
ySdYPW3YS3tapQECecSx/Q8fgZEjsC1axT685Rm7q9nCpITaNtbRtA/98Kus8vBE
HmQnmkKrPa6+eSUB3hi4urG8PmwtLm/QrZa9S3jDFKGgg439xpDPyM9sZSxAmAb3
RbiXFBfuTmWE5JwzcUwdRsQk1Hpx/KOv3I4priFtVACARwaTrvqhy93jm953qdjV
V5p3XYOUyrc=
=/j/t
-----END PGP SIGNATURE-----

--Sig_/j98ev+SHPTIUK92uvdut3dP--
