From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 repair: sync_request() aborts if one of the drives has
 bad block recorded
Date: Mon, 16 Jul 2012 13:37:53 +1000
Message-ID: <20120716133753.1a34e149@notabene.brown>
References: <CAGRgLy6j3pEeXGXJbVc4Sz3gdShWWfaT7hyXnurgO-6N-_E_ZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pnTf2CZwpfEJeDT+LrubkjB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6j3pEeXGXJbVc4Sz3gdShWWfaT7hyXnurgO-6N-_E_ZA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/pnTf2CZwpfEJeDT+LrubkjB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jul 2012 18:38:43 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> I am testing the following simple scenario:
> - RAID1 with two drives
> - First drive has a bad block marked in the bad block list
> - "repair" is triggered

Thanks for testing!!


>=20
> What is happening is that the code in raid1.c:sync_request() selects
> candidates for reading. If it encounters a bad block recorded, it
> skips this particular drive:
> 			if (is_badblock(rdev, sector_nr, good_sectors,
> 					&first_bad, &bad_sectors)) {
> 				if (first_bad > sector_nr)
> 					.../* we don't go here*/
> 				else {
>                                         /* we go here*/
> 					bad_sectors -=3D (sector_nr - first_bad);
> 					if (min_bad =3D=3D 0 ||
> 					    min_bad > bad_sectors)
> 						min_bad =3D bad_sectors;
> 				}
> 			}
> 			if (sector_nr < first_bad) {
>                             /* we don't go here */
>                             ...
> But the second drive has no bad blocks recorded, so it is selected.
> So we end up with read_targets=3D1 and min_bad>0.
>=20
> Then the following code:
> 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && read_targets > 0)
> 		/* extra read targets are also write targets */
> 		write_targets +=3D read_targets-1;
> leaves write_targets=3D0
>=20
> Then the following code:
> 	if (write_targets =3D=3D 0 || read_targets =3D=3D 0) {
> 		/* There is nowhere to write, so all non-sync
> 		 * drives must be failed - so we are finished
> 		 */
> 		sector_t rv =3D max_sector - sector_nr;
> aborts the resync.

Oops.

>=20
> Is this the intended behavior? Because it looks like this bit does not
> take into account the bad-blocks existence.
> I am not sure about which logic would solve it, but something like "If
> we did not select a drive for reading because of bad blocks, and as a
> result we have only one read_target, and MD_RECOVERY_REQUESTED, then
> let's report only the bad block as skipped and not the whole drive".
> Something like that, but there are probably many cases I am not
> thinking about.
>=20
> What do you think?

I don't see that MD_RECOVERY_REQUESTED is really an issue is it?
We the wrong thing happen in any case where there just one device with no b=
ad
block, and at least one device with a bad block.  In that case we want to
skip forward by the number of bad blocks, not skip to the end of the array.

So this?

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 240ff31..c443f93 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2422,7 +2422,10 @@ static sector_t sync_request(struct mddev *mddev, se=
ctor_t sector_nr, int *skipp
 		/* There is nowhere to write, so all non-sync
 		 * drives must be failed - so we are finished
 		 */
-		sector_t rv =3D max_sector - sector_nr;
+		sector_t rv;
+		if (min_bad > 0)
+			max_sector =3D sector_nr + min_bad;
+		rv =3D max_sector - sector_nr;
 		*skipped =3D 1;
 		put_buf(r1_bio);
 		return rv;


Thanks,
NeilBrown


--Sig_/pnTf2CZwpfEJeDT+LrubkjB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAOMkTnsnt1WYoG5AQI9QBAAneD2BYcs9MVwdI5W0iepVsbSU7SQ37iN
bvbJ/Ubevm3dowZ4wedsEGfXV9JIqfGEDa26Q5i4ow63dVzl9/eRVeYo+EOQOakF
ttt1neEx8RTFvAxlMP5Xid3KlqraouM5vduLhljUyW+O0LS1jPQlGH9FoZV8FpBN
AxhVHWtET8kV/C3sjC3z8fObA/o5wSVhxxTxfaj6/Kawkvq6CTuuDiuA6Xz9105r
9TLD4Mo3ujGMqeIzps1d1/O9xVW6RFuhR7tIjvXfQVV6plaWqH7QrDsIaOT4Y4q3
dURbLo2C6SJqaj91BBh4EBEno8gLTozoyjKdL+Nt06Y88byHvAOpmwAbOn6OE2MO
jMOnSJnXCS9zBMVylLRJO6FqqU90vxK0i75ObASpDrQf0QzS+JY6xLVg3RwMUjlF
8/C6uIJGXFcOJ6wPjZu7+Os5b1xRrb1XXznwXbCRAgnH+pKeZuZjrVwmrgblyJu0
lia+osPox5z1ukQYntSsFiG69eMfyY8vqF9ajgENsQxdBXHfssWWmp7/HyD45u7F
dHfHv7BwkmGAYrPa0xM6qUvcP8kXzg0SWI2mr7eSage3tIx2EWAWysafj1XlDnz1
EKR2itt03jeYKptJ3edisrH5yyu86E81k4hM57XPnzRYr3KNnD4U03HRB3bgrIYa
izYtRAIxUgQ=
=CGij
-----END PGP SIGNATURE-----

--Sig_/pnTf2CZwpfEJeDT+LrubkjB--
