From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md/raid5: preserve STRIPE_PREREAD_ACTIVE in
 break_stripe_batch_list
Date: Wed, 09 Mar 2016 12:58:25 +1100
Message-ID: <87r3fkjttq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Martin Svec <martin.svec@zoner.cz>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


break_stripe_batch_list breaks up a batch and copies some flags from
the batch head to the members, preserving others.

It doesn't preserve or copy STRIPE_PREREAD_ACTIVE.  This is not
normally a problem as STRIPE_PREREAD_ACTIVE is cleared when a
stripe_head is added to a batch, and is not set on stripe_heads
already in a batch.

However there is no locking to ensure one thread doesn't set the flag
after it has just been cleared in another.  This does occasionally happen.

md/raid5 maintains a count of the number of stripe_heads with
STRIPE_PREREAD_ACTIVE set: conf->preread_active_stripes.  When
break_stripe_batch_list clears STRIPE_PREREAD_ACTIVE inadvertently
this could becomes incorrect and will never again return to zero.

md/raid5 delays the handling of some stripe_heads until
preread_active_stripes becomes zero.  So when the above mention race
happens, those stripe_heads become blocked and never progress,
resulting is write to the array handing.

So: change break_stripe_batch_list to preserve STRIPE_PREREAD_ACTIVE
in the members of a batch.

URL: https://bugzilla.kernel.org/show_bug.cgi?id=3D108741
URL: https://bugzilla.redhat.com/show_bug.cgi?id=3D1258153
URL: http://thread.gmane.org/5649C0E9.2030204@zoner.cz
Reported-by: Martin Svec <martin.svec@zoner.cz> (and others)
Tested-by: Tom Weber <linux@junkyard.4t2.com>
Fixes: 1b956f7a8f9a ("md/raid5: be more selective about distributing flags =
across batch.")
Cc: stable@vger.kernel.org (v4.1 and later)
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b4f02c9959f2..2e7d253be6ce 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4236,7 +4236,6 @@ static void break_stripe_batch_list(struct stripe_hea=
d *head_sh,
 		WARN_ON_ONCE(sh->state & ((1 << STRIPE_ACTIVE) |
 					  (1 << STRIPE_SYNCING) |
 					  (1 << STRIPE_REPLACED) |
=2D					  (1 << STRIPE_PREREAD_ACTIVE) |
 					  (1 << STRIPE_DELAYED) |
 					  (1 << STRIPE_BIT_DELAY) |
 					  (1 << STRIPE_FULL_WRITE) |
@@ -4251,6 +4250,7 @@ static void break_stripe_batch_list(struct stripe_hea=
d *head_sh,
 					      (1 << STRIPE_REPLACED)));
=20
 		set_mask_bits(&sh->state, ~(STRIPE_EXPAND_SYNC_FLAGS |
+					    (1 << STRIPE_PREREAD_ACTIVE) |
 					    (1 << STRIPE_DEGRADED)),
 			      head_sh->state & (1 << STRIPE_INSYNC));
=20
=2D-=20
2.7.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJW34NBAAoJEDnsnt1WYoG5zB4QAJKh44LfgVIa1hOSPYtnXl3i
SXDFvbjRtY8zsiawxwvJRBcg3gYDrXRWzPqKaGGZ/eSQUJmEbdhr3liu9NUdnmZo
5A8SOO8BtZKea1p+GqgbDj7At8m2SO7jnlQqJDJ3jchEzChlh8JMQM9042LhzYEn
5Mnv0WK16zm637yD3v64YxdIIgjreh9nVE+si/XRjG7SO6oMUT42Yy/jdqpWDukW
eUuZEOYi3LxOJbaKz3sQgwsusEUBqi9VQEodQnUTLaMGYeftn2Z1uf8hkBDfdxmM
eniqS9x7DXdcWTiDMgqhf/slCYfKdZqYvuv9Yt11UUUqfuwZEeZM62Gg++CiqVNd
lyMG3S9rkpogrNcE+r2YFdt94b4vQg5b8ByxIkhuy8c8Yl/yyrxAaEqbLGUHDZSE
crDCzosgrF/Y/Q8Pd/rnkBd9WlTqLcLkQN/tD3FlJcw8leUo8Zuqmb24QEXappD9
jqT9WCvfJm4fOmXPapXOEMEQ35agmr6mxdik5toZpM4nqJ07DgUURcTqD2FxOS4B
4PQCHmvYHvcwdxK3XfjS/nj0FofJkxntxNYR/48ETkSfAIiVUjinl31JtXc7ecvo
zbzWAoSXk6s7R2lcE5JWMr7AcRJGoNhOIJPqra9j3k2Ju5RkIJy2ydVNnVrQIt/G
sFbtk/zSsU6I2N1dWg+I
=Wy+g
-----END PGP SIGNATURE-----
--=-=-=--
