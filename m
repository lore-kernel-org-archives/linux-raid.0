From: NeilBrown <neilb@suse.de>
Subject: Re: PATCH: md/raid1: sync_request_write() may complete r1_bio
 without rescheduling
Date: Tue, 17 Jul 2012 11:45:01 +1000
Message-ID: <20120717114501.678c8098@notabene.brown>
References: <CAGRgLy7Wtk1OByAGH4m19tyH+obMbaV=QD7cAv++HyojvK+C2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qzKqNQUFrCjWHL3_RqsuMpf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy7Wtk1OByAGH4m19tyH+obMbaV=QD7cAv++HyojvK+C2Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/qzKqNQUFrCjWHL3_RqsuMpf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 17:55:25 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> this is yet another issue I encounter, which is indirectly related to
> bad-blocks code, but I think it can be hit when bad-blocks logging is
> disabled too.
>=20
> Scenario:
> - RAID1 with one device A, one device missing
> - mdadm --manage /dev/mdX --add /dev/B (fresh device B added)
> - recovery of B starts
>=20
> Now at some point, end_sync_write() on B returns with error. Now the
> following can happen:
> In sync_request_write() we do:
> 1/
> 	/*
> 	 * schedule writes
> 	 */
> 	atomic_set(&r1_bio->remaining, 1);
>=20
> 2/ then we schedule WRITEs, so for each WRITE scheduled we do:
> atomic_inc(&r1_bio->remaining);
>=20
> 3/ then we do:
> 	if (atomic_dec_and_test(&r1_bio->remaining)) {
> 		/* if we're here, all write(s) have completed, so clean up */
> 		md_done_sync(mddev, r1_bio->sectors, 1);
> 		put_buf(r1_bio);
> 	}
>=20
> So assume that end_sync_write() completed with error, before we got to
> 3/. Then in end_sync_write() we set R1BIO_WriteError, and the we
> decrement r1_bio->remaining, so it becomes 1, so we bail out and don't
> call reschedule_retry().
> Then in 3/ we decrement r1_bio->remaining again, see that it is 0 now
> and complete the bio....without marking bad block or failing the
> device. So we think that this region is in-sync, while it's not,
> because we hit IO error on B.
>=20
> I checked vs 2.6 versions and such behavior makes sense there, because
> R1BIO_WriteError or R1BIO_MadeGood cases are not present there (no
> bad-blocks functionality). But now, we must call reschedule_retry() at
> both places (if needed). Does this make sense?
>=20
> I tested the following patch, which seems to work ok:

Thanks. I agree with you analysis.

I've made a small change to fix another problem with that code.

Thanks,
NeilBrown


=46rom af671b264f271563d343249886db16155a3130e0 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Tue, 17 Jul 2012 11:43:47 +1000
Subject: [PATCH] commit 4367af556133723d0f443e14ca8170d9447317cb    md/raid=
1:
 clear bad-block record when write succeeds.

Added a 'reschedule_retry' call possibility at the end of
end_sync_write, but didn't add matching code at the end of
sync_request_write.  So if the writes complete very quickly, or
scheduling makes it seem that way, then we can miss rescheduling
the request and the resync could hang.

Also commit 73d5c38a9536142e062c35997b044e89166e063b
    md: avoid races when stopping resync.

Fix a race condition in this same code in end_sync_write but didn't
make the change in sync_request_write.

This patch updates sync_request_write to fix both of those.
Patch is suitable for 3.1 and later kernels.

Reported-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Original-version-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e2e6ec2..506d055 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1892,8 +1892,14 @@ static void sync_request_write(struct mddev *mddev, =
struct r1bio *r1_bio)
=20
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
 		/* if we're here, all write(s) have completed, so clean up */
-		md_done_sync(mddev, r1_bio->sectors, 1);
-		put_buf(r1_bio);
+		int s =3D r1_bio->sectors;
+		if (test_bit(R1BIO_MadeGood, &r1_bio->state) ||
+		    test_bit(R1BIO_WriteError, &r1_bio->state))
+			reschedule_retry(r1_bio);
+		else {
+			put_buf(r1_bio);
+			md_done_sync(mddev, s, 1);
+		}
 	}
 }
=20

--Sig_/qzKqNQUFrCjWHL3_RqsuMpf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUATDnTnsnt1WYoG5AQJsdA/9FQmYDo0UDxWMJP18cTHXSWVSMn8qtOMp
O1tIkpg8IFBj9l17rITZ+qiJssMNmK2EDYsarjd5m9Rn4Bp5KNmMZdvwjD39RGbA
l3s2g2Z50hTxgr/50r+0QOsl6V3nHaOjICpmf6lj/h4Mv6EMUuVDn3QiBiXZsvz5
ho4GgszfEWG2b27MocUk2PWDZuCzmKchUx9DmKeWmzu1EFmMO7sioVKbhfI9UM71
3/1Zah/Kb+DrjvIvQtY+U6XYevNU0K55MaBLi0YlY5Xi2BKsVgrboxU3CG9y6HR/
j5EubZym0wkuIvmjwLnf94Ilj7qjfiDAiQ1ImM5KZNNWnKpnk4yNR/jX0J1kiNr+
LUbnCw5Hip/gYVm3jg1Vo8829786G3XcQaZ5f9w/SxzsvgIJYaDJOneYn4l++zeW
8vyEtG/7kfXKf234yuag2OFEMRvvOSvUkYV+M3fcJnqVKG7DfC4Bmm4TodkP4r4c
6T7ntQKYjGfYkP1CxRVVQenKGa/bKtv1kFdTLesLIBBb9ajrOy3Nk3+7KAywmfrY
KPVLvYN2rsJfscDSUjh25FjHm5Tpg6cqk1fFFz3nz5cPkHwOnO7CPckhc67S3B5E
RJBgyVmBuSW4rKj+B1WSIvZKBZ0GDvvs35pXMPszQmgBMXM8TtfZsOl+GBncTm/A
XdTkH9ht5+w=
=zMap
-----END PGP SIGNATURE-----

--Sig_/qzKqNQUFrCjWHL3_RqsuMpf--
