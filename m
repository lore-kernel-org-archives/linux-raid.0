From: NeilBrown <neilb@suse.de>
Subject: Re: BUG?: RAID6 reshape hung in reshape_request
Date: Wed, 29 Apr 2015 10:03:39 +1000
Message-ID: <20150429100339.5b0cf4f3@notabene.brown>
References: <CAGivzjGyifS3r0rypqM7n2P-fcA7NvPjJWa6kV_wfGx2biDrDg@mail.gmail.com>
	<20150427112056.7195d226@notabene.brown>
	<CAGivzjE4zVGpoUdGpgKR_e+EaiBE60R3Ta=o9mW+VFqO8McrrQ@mail.gmail.com>
	<CAGivzjHvk8pSUyWOMzNioNtgpQ7gRoL=hkTX0=m7Mi8KzgRWAg@mail.gmail.com>
	<20150427165926.6128d59b@notabene.brown>
	<CAGivzjF-5VWBzE0M9FB9BGpYeed=0rxNvKPzkZJdVbUAwbqyJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/+CbWrepflzxwplpliglIyi7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGivzjF-5VWBzE0M9FB9BGpYeed=0rxNvKPzkZJdVbUAwbqyJA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Wahler <dwahler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+CbWrepflzxwplpliglIyi7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Apr 2015 12:20:50 -0500 David Wahler <dwahler@gmail.com> wrote:
>=20
> I don't urgently need this array up and running, so I'm happy to leave
> it in its current state for the next few days in case there's anything
> else I can do to help track this down.

Thanks for the various status data.

I'm fairly easily able to reproduce the problem.  I clearly never thought
about 'reshape' when I was writing the bad_block handling.

You can allow the reshape to complete by the following hack:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 77dfd720aaa0..e6c68a450d4c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4306,7 +4306,7 @@ static void handle_stripe(struct stripe_head *sh)
 	 */
 	if (s.failed > conf->max_degraded) {
 		sh->check_state =3D 0;
-		sh->reconstruct_state =3D 0;
+//		sh->reconstruct_state =3D 0;
 		if (s.to_read+s.to_write+s.written)
 			handle_failed_stripe(conf, sh, &s, disks, &s.return_bi);
 		if (s.syncing + s.replacing)

It may not necessarily do exactly the right thing, but it won't be too bad.

I'm tempted to simply disable reshapes if there are bad blocks, but that
might not be necessary.

The presence of a 'bad block' can mean two things.

1/ The data is missing.  If there are enough bad blocks in a stripe then
   some data cannot be recovered.  In that case we can only let the 'grow'
   proceed if we record the destination blocks as 'bad', which isn't too ha=
rd.

2/ The media is faulty and writes fail.  A 'bad block' doesn't always mean
   this, but it can and it is hard to know if it does or not.
   This case only really matters when writing.  I could probably just
   over-write anyway and handle failure as we normally would.
   If the 'write' succeeds, I need to clear the 'bad block' record, but I
   think I do that anyway.

So I should be able to make it work.  I'll probably get mdadm to warn
strongly against reshaping an array with bad blocks though.

I'm going to have to study the code some more.

NeilBrown

--Sig_/+CbWrepflzxwplpliglIyi7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUAf2znsnt1WYoG5AQI7dg/9EqQO0DzCmXHtp1rmB3wZuAcEDO0fG4XL
FQnyS3jx7zDgw60MRiNq6yBL76/05oEou/g0I6woXM/a3P9Tqnu9sP+uglWQuYwN
falybtlo9L5r1w9FNSB7BBdH5haEDn7GIdYydLxaHKHqE+W6GsaNIcbeGejTQoSF
4L0TbiReP36GIcQziM0tEhChV3a+WCnx2NdLsYxOHYNqooQ14eVxvfQX3jvgvT5b
9IKYl0vNVEVjfq8kVQS35odZ3namhx//TbRY3hyg12GCM03sxNVBTf9z7XlNPDPy
SVP3fHVNqJh+gmFJsCSYgaHjHO8R+tGfQZwzTVQcjGS0yK6bYx5ybACnXpYhNkrw
dRRj+zY6q4vtf5y0RL6DgiZGvopQdbgZp9oKsUzxGzBeD+70owFN1Q1dPI3+mCvk
cX48Ws2QSuGB4S6KodteyVzN/fQbt/3TcnrfIeaYEO3TwOuzwLBNzQcTZv9izvdO
6g6Ryp4kuxFe/8U1QlJydII6LEduP+vl/gZq8afCJ+X+AFsxxbrjpI+YJghTfMa/
yKBlRSXs3/QwMxySBWF0YhRyjH9akZULsqQsNMZDVqHmsafuXn7tqZoxruW5Hcyx
I5+po9s2cMXkFxZxpnB6BTqzriS7lQDEgEFApursMauftC7LkGSwKcL2F+VTiw/7
vxWGbj3aOXw=
=C1Ov
-----END PGP SIGNATURE-----

--Sig_/+CbWrepflzxwplpliglIyi7--
