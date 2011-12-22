From: NeilBrown <neilb@suse.de>
Subject: Re: dirty chunks on bitmap not clearing (RAID1)
Date: Fri, 23 Dec 2011 09:48:15 +1100
Message-ID: <20111223094815.6beaf413@notabene.brown>
References: <CAGtzr3fC8bWLa4A5eRRgjHCtgfENdx4jtaKNb53dD7NX61nf7g@mail.gmail.com>
	<20110831173842.44ab5b03@notabene.brown>
	<alpine.DEB.2.00.1108311313550.27546@ubuntu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/iS4fZeobtb+yxCLeSbH1ltU"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1108311313550.27546@ubuntu>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Pearson <pearson.christopher.j@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/iS4fZeobtb+yxCLeSbH1ltU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 31 Aug 2011 13:23:01 -0500 (CDT) Chris Pearson
<pearson.christopher.j@gmail.com> wrote:

> I'm happy to apply a patch to whichever kernel you like, but the blocks h=
ave since cleared, so I will try and reproduce it first.

I have finally identified the problem here.  I was looking into a different
but related problem and saw what was happening.  I don't know what I didn't
notice it before.

You can easily reproduce the problem by writing to an array with a bitmap
while a spare is recovering. Any bits that get set in the section that has
already been recovered will stay set.

This patch fixes it and will - with luck - be in 3.2.

Thanks,
NeilBrown

=46rom b9664495d2a884fbf7195e1abe4778cc6c3ae9b7 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Fri, 23 Dec 2011 09:42:52 +1100
Subject: [PATCH] md/bitmap: It is OK to clear bits during recovery.

commit d0a4bb492772ce5c4bdfba3744a99ed6f6fb238f introduced a
regression which is annoying but fairly harmless.

When writing to an array that is undergoing recovery (a spare
in being integrated into the array), writing to the array will
set bits in the bitmap, but they will not be cleared when the
write completes.

For bits covering areas that have not been recovered yet this is not a
problem as the recovery will clear the bits.  However bits set in
already-recovered region will stay set and never be cleared.
This doesn't risk data integrity.  The only negatives are:
 - next time there is a crash, more resyncing than necessary will
   be done.
 - the bitmap doesn't look clean, which is confusing.

While an array is recovering we don't want to update the
'events_cleared' setting in the bitmap but we do still want to clear
bits that have very recently been set - providing they were written to
the recovering device.

So split those two needs - which previously both depended on 'success'
and always clear the bit of the write went to all devices.

Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index b690711..6d03774 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1393,9 +1393,6 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t =
offset, unsigned long secto
 			 atomic_read(&bitmap->behind_writes),
 			 bitmap->mddev->bitmap_info.max_write_behind);
 	}
-	if (bitmap->mddev->degraded)
-		/* Never clear bits or update events_cleared when degraded */
-		success =3D 0;
=20
 	while (sectors) {
 		sector_t blocks;
@@ -1409,7 +1406,7 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t =
offset, unsigned long secto
 			return;
 		}
=20
-		if (success &&
+		if (success && !bitmap->mddev->degraded &&
 		    bitmap->events_cleared < bitmap->mddev->events) {
 			bitmap->events_cleared =3D bitmap->mddev->events;
 			bitmap->need_sync =3D 1;



>=20
> On Wed, 31 Aug 2011, NeilBrown wrote:
>=20
> >Date: Wed, 31 Aug 2011 17:38:42 +1000
> >From: NeilBrown <neilb@suse.de>
> >To: Chris Pearson <kermit4@gmail.com>
> >Cc: linux-raid@vger.kernel.org
> >Subject: Re: dirty chunks on bitmap not clearing (RAID1)
> >
> >On Mon, 29 Aug 2011 11:30:56 -0500 Chris Pearson <kermit4@gmail.com> wro=
te:
> >
> >> I have the same problem.  3 chunks are always dirty.
> >>=20
> >> I'm using 2.6.38-8-generic and mdadm - v3.1.4 - 31st August 2010
> >>=20
> >> If that's not normal, then maybe what I've done differently is that I
> >> created the array, raid 1, with one live and one missing disk, then
> >> added the second one later after writing a lot of data.
> >>=20
> >> Also, though probably not the cause, I continued writing data while it
> >> was syncing, and a couple times during the syncing, both drives
> >> stopped responding and I had to power off.
> >>=20
> >> # cat /proc/mdstat
> >> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> >> [raid4] [raid10]
> >> md127 : active raid1 sdd1[0] sdc1[2]
> >>       1904568184 blocks super 1.2 [2/2] [UU]
> >>       bitmap: 3/15 pages [12KB], 65536KB chunk
> >>=20
> >> unused devices: <none>
> >>=20
> >> # mdadm -X /dev/sd[dc]1
> >>         Filename : /dev/sdc1
> >>            Magic : 6d746962
> >>          Version : 4
> >>             UUID : 43761dc5:4383cf0f:41ef2dab:43e6d74e
> >>           Events : 40013
> >>   Events Cleared : 40013
> >>            State : OK
> >>        Chunksize : 64 MB
> >>           Daemon : 5s flush period
> >>       Write Mode : Allow write behind, max 256
> >>        Sync Size : 1904568184 (1816.34 GiB 1950.28 GB)
> >>           Bitmap : 29062 bits (chunks), 3 dirty (0.0%)
> >>         Filename : /dev/sdd1
> >>            Magic : 6d746962
> >>          Version : 4
> >>             UUID : 43761dc5:4383cf0f:41ef2dab:43e6d74e
> >>           Events : 40013
> >>   Events Cleared : 40013
> >>            State : OK
> >>        Chunksize : 64 MB
> >>           Daemon : 5s flush period
> >>       Write Mode : Allow write behind, max 256
> >>        Sync Size : 1904568184 (1816.34 GiB 1950.28 GB)
> >>           Bitmap : 29062 bits (chunks), 3 dirty (0.0%)
> >
> >I cannot see how this would be happening.  If any bits are set, then they
> >will be cleared after 5 seconds, and then 5 seconds later the block hold=
ing
> >the bits will be written out so that they will appear on disk to be clea=
red.
> >
> >I assume that if you write to the array, the 'dirty' count increases, but
> >always goes back to three?
> >
> >And if you stop the array and start it again, the '3' stays there?
> >
> >If I sent you a patch to add some tracing information would you be able =
to
> >compile a new kernel with that patch applied and see what it says?
> >
> >Thanks,
> >
> >NeilBrown
> >
> >
> >>=20
> >>=20
> >> Quoting NeilBrown <neilb@suse.de>:
> >>=20
> >> > On Thu, October 15, 2009 9:39 am, aristizb@ualberta.ca wrote:
> >> >> Hello,
> >> >>
> >> >> I have a RAID1 with 2 LVM disks and I am running into a strange
> >> >> situation where having the 2 disks connected to the array the bitmap
> >> >> never clears the dirty chunks.
> >> >
> >> > That shouldn't happen...
> >> > What versions of mdadm and the Linux kernel are you using?
> >> >
> >> > NeilBrown
> >> >
> >> >>
> >> >> I am assuming also that when a RAID1 is in write-through mode, the
> >> >> bitmap  indicates that all the data has made it to all the disks if
> >> >> there are no dirty chunks using mdadm --examine-bitmap.
> >> >>
> >> >> The output of cat /proc/mdstat is:
> >> >>
> >> >> md2060 : active raid1 dm-5[1] dm-6[0]
> >> >>        2252736 blocks [2/2] [UU]
> >> >>        bitmap: 1/275 pages [12KB], 4KB chunk, file: /tmp/md2060bm
> >> >>
> >> >>
> >> >> The output of mdadm --examine-bitmap /tmp/md2060bm is:
> >> >>
> >> >> Filename : md2060bm
> >> >>             Magic : 6d746962
> >> >>           Version : 4
> >> >>              UUID : ad5fb74c:bb1c654a:087b2595:8a5d04a9
> >> >>            Events : 12
> >> >>    Events Cleared : 12
> >> >>             State : OK
> >> >>         Chunksize : 4 KB
> >> >>            Daemon : 5s flush period
> >> >>        Write Mode : Normal
> >> >>         Sync Size : 2252736 (2.15 GiB 2.31 GB)
> >> >>            Bitmap : 563184 bits (chunks), 3 dirty (0.0%)
> >> >>
> >> >>
> >> >> Having the array under no IO, I waited 30 minutes but the dirty data
> >> >> never gets clear from the bitmap, so I presume  the disks are not in
> >> >> sync; but after I ran a block by block comparison of the two device=
s I
> >> >> found that they are equal.
> >> >>
> >> >> The superblocks and the external bitmap tell me that all the events
> >> >> are cleared, so I am confused on why the bitmap never goes to 0 dir=
ty
> >> >> chunks.
> >> >>
> >> >> How can I tell if the disks are in sync?
> >> >>
> >> >>
> >> >> Thank you in advance for any help
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >


--Sig_/iS4fZeobtb+yxCLeSbH1ltU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTvOzrznsnt1WYoG5AQLuZQ/9FS4F6VupvKFnk2SOl/s7DwYi/8i/j9JU
2OR9j5xLHsvfBmoZWRPbPzYtfNdS4BQxG9+LOnNnGQwWwLa4hNquE9kfgWhY1Nxn
6HhNcqTCUEzW8wXegBlQ655ww8hWIl4QrOZYx/ArRretk0gqJ7QWAU3sVdL0xspb
2Q4h2rd2isZRYh/hMhEp1IyCkW2gtcZHp+xYEyjSDyZSpvi82eIEUvNTRdP0CCx8
DlKzn2/H4A1EYF4Pd5F/wl7nI1ILBa9HAzjut2qs/Qn1qVIM4REwiRxIaABBD9Fl
7BT/cR7uSPz7E9h6ie+MDEenA8EgGoIj0tyFnbZZLaB5lMVcWRzMm7VUyCJTx7O+
ko+kW78MKzCzJWk87zKAjEBFPyzVTMjEBGGs968Ql8B3eKDexkCUz2CGBc4MVZ3d
2r2lNa0PQ0yuxmo6thMIbPKfrmXmNwBNNDMRJGkWN3xy11CZNDx0YwUODEFn+h3s
ukCbAv0PkVMmtkc7Pk2HruUgOQ/6OznxV998LQb6U3sEOPOp/eqqW5zRr+hzzgvP
CpAkzTG4HBiRQDhEVgMoFIiD/f+rY026kS26nJxjOIk6wI6XPHiQmzXVpagqw0QU
8Wgvp3Z1coFPdrhUGQZQJM1dNlJHAnGo5BGHkgXDt+TtEX2B29eQkhjledZDavS0
bV6hRYHt4tU=
=FhA6
-----END PGP SIGNATURE-----

--Sig_/iS4fZeobtb+yxCLeSbH1ltU--
