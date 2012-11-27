From: NeilBrown <neilb@suse.de>
Subject: Re: 3.7-rc4 hang with mdadm raid10 near layout, with 4 disks, and
 an internal bitmap
Date: Tue, 27 Nov 2012 12:19:14 +1100
Message-ID: <20121127121914.77f6111e@notabene.brown>
References: <50A28D53.2080409@brockmann-consult.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/wciJMMoWlmF2lYUR0k4juUT"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A28D53.2080409@brockmann-consult.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Maloney <peter.maloney@brockmann-consult.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/wciJMMoWlmF2lYUR0k4juUT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 13 Nov 2012 19:11:31 +0100 Peter Maloney
<peter.maloney@brockmann-consult.de> wrote:

> I am using kernel 3.7-rc4. I have 2 LV on a 4 disk raid10 near layout
> mdadm device which I am trying to copy to another LV on the same VG
> using dd. The mdadm device has an internal bitmap. When I copy the first
> LV, it goes smoothly, but with the 2nd it hangs before it is done.
>=20
> I don't know if I can reproduce it, so I'll just leave it broken with a
> bitmap until this is resolved, and work around by using files for what
> I'm trying to do right now. It's my home desktop machine.
>=20
> Should I start by installing 3.6.6 or 3.7.0-rc5?
>=20
> When I created my raid, I was probably using kernel 3.1 or 3.4.4. When I
> added the bitmap, it was probably 3.7-rc2.
>=20
> # uname -a
> Linux peter 3.7.0-rc4-1-default #7 SMP Sun Nov 4 23:11:57 CET 2012
> x86_64 x86_64 x86_64 GNU/Linux
>=20

....


Thanks for the report.
Should be fixed by the following.

NeilBrown

Author: NeilBrown <neilb@suse.de>
Date:   Tue Nov 27 12:14:40 2012 +1100

    md/raid1{,0}: fix deadlock in bitmap_unplug.
   =20
    If the raid1 or raid10 unplug function gets called
    from a make_request function (which is very possible) when
    there are bios on the current->bio_list list, then it will not
    be able to successfully call bitmap_unplug() and it could
    need to submit more bios and wait for them to complete.
    But they won't complete while current->bio_list is non-empty.
   =20
    So detect that case and handle the unplugging off to another thread
    just like we already do when called from within the scheduler.
   =20
    RAID1 version of bug was introduced in 3.6, so that part of fix is
    suitable for 3.6.y.  RAID10 part won't apply.
   =20
    Cc: stable@vger.kernel.org
    Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
    Reported-by: Peter Maloney <peter.maloney@brockmann-consult.de>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 636bae0..a0f7309 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -963,7 +963,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool f=
rom_schedule)
 	struct r1conf *conf =3D mddev->private;
 	struct bio *bio;
=20
-	if (from_schedule) {
+	if (from_schedule || current->bio_list) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count +=3D plug->pending_cnt;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0d5d0ff..c9acbd7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1069,7 +1069,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, boo=
l from_schedule)
 	struct r10conf *conf =3D mddev->private;
 	struct bio *bio;
=20
-	if (from_schedule) {
+	if (from_schedule || current->bio_list) {
 		spin_lock_irq(&conf->device_lock);
 		bio_list_merge(&conf->pending_bio_list, &plug->pending);
 		conf->pending_count +=3D plug->pending_cnt;

--Sig_/wciJMMoWlmF2lYUR0k4juUT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULQVEjnsnt1WYoG5AQLM5g//fJtgrzM2enPkmfhiv5ZNPKahJgAFjRgF
rrB9ONw0CvrrJbXmvIu7eEaWjGwXGrKicxkAYHyj77ee6FxJfCw1530kUzdxBnze
Ug5QYxyz5bEA+B9swmKm05cuuVr5bQMGGbW0M67gpcknPN0QcaTmqlMKBz965bMt
gXfbzY4meDT+Lu07NO1uiSzBlR/YFX5tZd983lq3gtjB4NH37iA5AotRlOZrzgl2
NtbmFWVnzTQ5aeLrIofthofwXa+JqjNk4w9qCoVn1Pn1rs0cbrgaeorj/N4tv2J6
ZqwaRKNESDPZVg8+v/x6fIWK1UXhgGqyFKMd+m/55kqyazBysh35IuPKzm2WDqPv
9iT+9VgKJFor6zbwSRMXj7EgPjBsZQgCfUXxy24HsqhzpE1whZegQyAgWWMHoYoa
koPR9KH3KhwQo2GI8igtXEE8GFOV7OL5oLFxaHQ9p24cJ1GmfxWzKIelh9X7amLn
h3ms5hx43KF6kF0F8BigS2dSKYKruYRo4D29azwJaSq2ALBsd7tYbO5oTCqFZDw2
IJZZEzkU4Btw+DtgL9XAMEdLnl7Jf2WNxvj7lPLsyKuNqE5tcIpwDndGiE+DT0/9
+9CX/r9nKb8s4pHdnOO//42tNwONDlTHiGb+9xRvUcOwSanj6Ue7p63xpGorZHlC
BfO7R9L49FM=
=rd1d
-----END PGP SIGNATURE-----

--Sig_/wciJMMoWlmF2lYUR0k4juUT--
