From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/5] Fixes for RAID1 resync
Date: Thu, 18 Sep 2014 17:48:46 +1000
Message-ID: <20140918174846.6a445eaf@notabene.brown>
References: <20140910062039.26400.36745.stgit@notabene.brown>
	<D96E0116-919C-4F4B-B4B6-2564B99449FB@redhat.com>
	<8697EC47-F648-4E66-B37C-4A2DC3030696@redhat.com>
	<20140915133006.14e57085@notabene.brown>
	<2C41CCF8-8B5C-486F-AE43-42D10EBAA0A5@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/IB/HI0e32oXsHXa1z.Q5JXz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2C41CCF8-8B5C-486F-AE43-42D10EBAA0A5@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: Eivind Sarto <eivindsarto@gmail.com>, linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids

--Sig_/IB/HI0e32oXsHXa1z.Q5JXz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Sep 2014 11:31:26 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Sep 14, 2014, at 10:30 PM, NeilBrown wrote:
>=20
> > On Thu, 11 Sep 2014 12:12:01 -0500 Brassow Jonathan <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >>=20
> >> On Sep 10, 2014, at 10:45 PM, Brassow Jonathan wrote:
> >>=20
> >>>=20
> >>> On Sep 10, 2014, at 1:20 AM, NeilBrown wrote:
> >>>=20
> >>>>=20
> >>>> Jon: could you test with these patches on top of what you
> >>>> have just in case something happens to fix the problem without
> >>>> me realising it?
> >>>=20
> >>> I'm on it.  The test is running.  I'll know later tomorrow.
> >>>=20
> >>> brassow
> >>=20
> >> The test is still failing from here.  I grabbed 3.17.0-rc4, added the =
5 patches, and got the attached backtraces when testing.  As I said, the ha=
ngs are not exactly the same.  This set shows the mdX_raid1 thread in the m=
iddle of handling a read failure.
> >=20
> > Thanks.
> > mdX_raid1 is blocked in freeze_array.
> > That could be caused by conf->nr_pending nor aligning properly with
> > conf->nr_queued.
> >=20
> > Both normal IO and resync IO can be retried with reschedule_retry()
> > and so be counted into ->nr_queued, but only normal IO gets counted in
> > ->nr_pending.
> >=20
> > Previously could could only possibly have on or the other and when hand=
ling
> > a read failure it could only be normal IO.  But now that they two types=
 can
> > interleave, we can have both normal and resync IO requests queued, so w=
e need
> > to count them both in nr_pending.
> >=20
> > So the following patch might help.
> >=20
> > How complicated are your test scripts?  Could you send them to me so I =
can
> > try too?
> >=20
> > Thanks,
> > NeilBrown
> >=20
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 888dbdfb6986..6a9c73435eb8 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -856,6 +856,7 @@ static void raise_barrier(struct r1conf *conf, sect=
or_t sector_nr)
> > 			     conf->next_resync + RESYNC_SECTORS),
> > 			    conf->resync_lock);
> >=20
> > +	conf->nr_pending++;
> > 	spin_unlock_irq(&conf->resync_lock);
> > }
> >=20
> > @@ -865,6 +866,7 @@ static void lower_barrier(struct r1conf *conf)
> > 	BUG_ON(conf->barrier <=3D 0);
> > 	spin_lock_irqsave(&conf->resync_lock, flags);
> > 	conf->barrier--;
> > +	conf->nr_pending--;
> > 	spin_unlock_irqrestore(&conf->resync_lock, flags);
> > 	wake_up(&conf->wait_barrier);
> > }
>=20
> No luck, it is failing faster than before.
>=20
> I haven't looked into this myself, but the dm-raid1.c code makes use of d=
m-region-hash.c which coordinates recovery and nominal I/O in a way that al=
lows them to both occur in a simple, non-overlapping way.  I'm not sure it =
would make sense to use that instead of this new approach.  I have no idea =
how much effort that would be, but I could have someone look into it at som=
e point if you think it might be interesting.
>=20

Hi Jon,
 I can see the appeal of using known-working code, but there is every chance
 that we would break it when plugging it into md ;-)

 I've found another bug.... it is a very subtle one and it has been around
 since before the patch you bisected to so it probably isn't your bug.
 It also only affects array with bad-blocks listed.  The patch is below
 but I very much doubt testing will show any change...

 I'll keep looking..... oh, found one.  This one looks more convincing.
 If memory is short, make_request() will allocate an r1bio from the mempool
 rather than from the slab.  That r1bio won't have just been zeroed.
 This is mostly OK as we initialise all the fields that aren't left in
 a clean state ... except ->start_next_window.
 We initialise that for write requests, but not for read.
 So when we use a mempool-allocated r1bio that was previously used for
 write and had ->start_next_window set, and is now used for read,
 then things will go wrong.
 So this patch definitely is worth testing.
 Thanks for your continued patience in testing!!!


Thanks,
NeilBrown

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a95f9e179e6f..7187d9b8431f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1185,6 +1185,7 @@ read_again:
 				   atomic_read(&bitmap->behind_writes) =3D=3D 0);
 		}
 		r1_bio->read_disk =3D rdisk;
+		r1_bio->start_next_window =3D 0;
=20
 		read_bio =3D bio_clone_mddev(bio, GFP_NOIO, mddev);
 		bio_trim(read_bio, r1_bio->sector - bio->bi_iter.bi_sector,
@@ -1444,6 +1445,7 @@ read_again:
 		r1_bio->state =3D 0;
 		r1_bio->mddev =3D mddev;
 		r1_bio->sector =3D bio->bi_iter.bi_sector + sectors_handled;
+		start_next_window =3D wait_barrier(conf, bio);
 		goto retry_write;
 	}
=20

--Sig_/IB/HI0e32oXsHXa1z.Q5JXz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBqOXjnsnt1WYoG5AQL+hw//fJiQ8iKVX+eHgSfau7cJYMp7RPtpVAmP
3+nt0HqcY6p6gf6oNhELJVtG0JpCcFDe8E7EEPZst/mzfgUBw2N/CJU64cwl9h24
gobrSRxem9Xtu6nUsFPzChsbnr1EYUIP/K1i9mKKngEiYJfpWqrxfDgg2Cwmasfw
WiK0AqCdFbpUuEqBd8PfoqrqDCPk0RJ551osmia7y9qUFFVA7FdvzKZx3Lnob+Nk
AQnnaP8IRObDMLX0wRlgBrHOn2/n+u6UfcEl8SbRb8dHlLYV2tP9DicLf/nEdYm/
Yyy6NBJcnKNP0nVPjkvH/nY50lLru+dykW2PzF3l0rmSFdLwp1UwEPVKCgzs4PVK
vBNxmMImSkcx7N9pgJVqpvxqUCZsQVnd6iH5tf9EoCoXdPgfrdSz6b5un9acQfsV
J2/YZt3EsZFCdiKXZvYGjdXUtR1le3D86YMeMZL1NJRIRoi8TWNxvwZrYlUZRo4q
xjzqMxo8rvx8rMul2YHiNw3WLYbd8g9OpJmdZOJmDzRONdABkn7BTTEojze/6Vr5
14obHSJiM3C9OQ4sQsorMEvBz1xhtnfBPb0fELGIGGdWt8J2HEJMu1o4oyrzA0K/
LdrzNt5VOrh6ls9yW0XimzNRdMtNINxMOag6FnnsDK2l1ZgZHN4kLqY1Q6pbMOtC
rVEo6DJ5gnI=
=WZNM
-----END PGP SIGNATURE-----

--Sig_/IB/HI0e32oXsHXa1z.Q5JXz--
