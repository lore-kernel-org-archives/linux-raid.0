From: NeilBrown <neilb@suse.de>
Subject: Re: [BUG,PATCH] raid1 behind write ordering (barrier) protection
Date: Tue, 3 Dec 2013 10:08:13 +1100
Message-ID: <20131203100813.67814984@notabene.brown>
References: <528E72C8.7050909@linux.vnet.ibm.com>
	<529CBFBD.9070009@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tKc.1VA=Fj2A/eKEX_ui3+E"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <529CBFBD.9070009@linux.vnet.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brett Russ <brett@linux.vnet.ibm.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tKc.1VA=Fj2A/eKEX_ui3+E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Dec 2013 12:13:33 -0500 Brett Russ <brett@linux.vnet.ibm.com>
wrote:

> Let's first agree there's a bug here needing fixing.

Sorry for not responding earlier.
Yes it does look like a bug, so it needs fixing.

>=20
> Then, we can discuss how to achieve a modern fix without the use of barri=
ers as=20
> originally intended in the patch below.

I'm not thrilled with the idea of keeping a list of outstanding requests.
Maybe we'll have to go that way but I'd like to explore other options first.

How about just keeping a record of whether there is a BIO_FLUSH request
outstanding on each "behind" leg.  While there is we don't submit new
requests.
So we have a queue of bios for each leg which are waiting for a BIO_FLUSH to
complete, and we send them on down as soon as it does.

Would that suit, do you think?

Thanks,
NeilBrown


>=20
> thanks,
> BR
>=20
> On 11/21/2013 03:53 PM, Brett Russ wrote:
> > Hi,
> >
> > We are in process of porting some mods we made against an older, barrier
> > equipped, kernel to a newer kernel without barrier support.  Our enviro=
nment is
> > unique in that we use both disk write cache and MD raid1 behind writes.=
  We see
> > that the behind write feature introduces an I/O ordering bug at the MD =
level;
> > the bug is defined in greater detail in the patch header below.
> >
> > The patch header and content are below, as ported to a RHEL 6.4 based k=
ernel
> > which has moved to flush/FUA.  However, bios that used to be marked
> > BIO_RW_BARRIER are now, ineffectively for our purposes, marked
> > BIO_FLUSH|BIO_FUA.  Pretend we wanted a barrier here, as that's what we=
 need.
> >
> > Looking for thoughts from the community on the best way(s) to solve this
> > ordering issue.  One proposal we're considering is forcing overlapping =
writes to
> > block until the first behind write completes, as long as they're in pro=
cess
> > context.
> >
> > Appreciate the look,
> > BR
> >
> > ----
> >
> > This patch ensures that barriers will be synchronous on the write behin=
d legs,
> > i.e. they will not be allowed to go behind.
> >
> > This patch adds a new capability to the md raid1 behind write feature w=
hich
> > allows us to ensure ordering when reads and/or writes go to a member de=
vice
> > which allows behind writes.  The problem we're trying to solve here is:
> >
> > 1. write1 to sector X comes to MD
> > 1a. write1 sent to primary leg
> > 1b. write1 sent to secondary leg which is write behind
> > 2. write1 completes on primary leg, upper layer is ack'd
> > 3. write2 to sector X comes to MD
> > 3a. write2 sent to primary leg
> > 3b. write2 sent to secondary leg which is write behind
> > 4. secondary leg now has two overlapping writes to it, layers beneath h=
ave
> >     freedom to reorder them, big problems ensue.
> >
> > Solution is for MD to maintain a list of outstanding behind writes to a=
llow us
> > to check all incoming I/O going to the behind member(s).  I/O is handle=
d as
> > follows:
> >
> > Reads
> >
> > Reads to the behind leg used to block if any behind writes were outstan=
ding.
> > Now they only block if they overlap an outstanding behind write.
> >
> > Writes
> >
> > Writes to the behind leg check if they overlap any outstanding behind w=
rites.
> > If they do, they are marked as a barrier on the behind leg only so orde=
ring is
> > ensured.  If they don't, they are issued as normal.  In either case, ho=
wever,
> > they are added to a list of outstanding behind writes.
> >
> > Any writes that overlap with in-progress writes on the behind list, they
> > need to be marked as a barrier to prevent reordering. However it is an
> > overkill to send a barrier to both (primary and write-mostly) legs of t=
he
> > array.
> >
> > For raid1, the upper layer wouldn't send down an overlapping write unle=
ss at
> > least one non write-mostly leg has ack'd. So there is no reason to mark=
 that leg
> > as a barrier.
> >
> >
> > Signed-Off-By: Aniket Kulkarni <aniket.kulkarni@us.ibm.com>
> > Signed-off-by: Brett Russ <brett@linux.vnet.ibm.com>
> > Signed-off-by: Jay Wentworth <jwentworth@us.ibm.com>
> >
> > Index: b/drivers/md/raid1.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -368,10 +368,15 @@ static void close_write(struct r1bio *r1
> >   {
> >       /* it really is the end of this request */
> >       if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
> > +        unsigned long flags;
> > +        struct r1conf *conf =3D r1_bio->mddev->private;
> >           /* free extra copy of the data pages */
> >           int i =3D r1_bio->behind_page_count;
> >           while (i--)
> >               safe_put_page(r1_bio->behind_bvecs[i].bv_page);
> > +        spin_lock_irqsave(&conf->device_lock, flags);
> > +        list_del(&r1_bio->behind_list);
> > +        spin_unlock_irqrestore(&conf->device_lock, flags);
> >           kfree(r1_bio->behind_bvecs);
> >           r1_bio->behind_bvecs =3D NULL;
> >       }
> > @@ -958,6 +963,36 @@ do_sync_io:
> >       pr_debug("%dB behind alloc failed, doing sync I/O\n", bio->bi_siz=
e);
> >   }
> >
> > +
> > +/* This function allows us to determine if an incoming request overlap=
s the
> > + * sector range of any outstanding behind writes.  Knowing this will a=
llow us
> > + * to prevent writes and/or reads from potential reordering below MD.
> > + */
> > +static int test_overlap_and_enq_behind_writes(struct r1bio *newreq, in=
t enq)
> > +{
> > +    unsigned long flags;
> > +    struct r1conf *conf;
> > +    struct r1bio *listreq;
> > +    sector_t newreq_end;
> > +    int olap =3D 0;
> > +
> > +    conf =3D newreq->mddev->private;
> > +    newreq_end =3D newreq->sector + newreq->sectors;
> > +
> > +    spin_lock_irqsave(&conf->device_lock, flags);
> > +    list_for_each_entry(listreq, &conf->behind_list, behind_list) {
> > +        if ((newreq_end > listreq->sector) &&
> > +            (newreq->sector < listreq->sector + listreq->sectors)) {
> > +                olap =3D 1;
> > +                break;
> > +        }
> > +    }
> > +    if (enq)
> > +        list_add(&newreq->behind_list, &conf->behind_list);
> > +    spin_unlock_irqrestore(&conf->device_lock, flags);
> > +    return olap;
> > +}
> > +
> >   static int make_request(struct mddev *mddev, struct bio * bio)
> >   {
> >       struct r1conf *conf =3D mddev->private;
> > @@ -969,11 +1004,11 @@ static int make_request(struct mddev *md
> >       unsigned long flags;
> >       const int rw =3D bio_data_dir(bio);
> >       const bool do_sync =3D bio_rw_flagged(bio, BIO_RW_SYNCIO);
> > -    const unsigned long do_flush_fua =3D (bio->bi_rw & (BIO_FLUSH | BI=
O_FUA));
> >       struct md_rdev *blocked_rdev;
> >       int first_clone;
> >       int sectors_handled;
> >       int max_sectors;
> > +    unsigned int do_flush_fua, do_behind_flush;
> >
> >       /*
> >        * Register the new request and wait if the reconstruction
> > @@ -1047,7 +1082,7 @@ read_again:
> >           mirror =3D conf->mirrors + rdisk;
> >
> >           if (test_bit(WriteMostly, &mirror->rdev->flags) &&
> > -            bitmap) {
> > +            bitmap && test_overlap_and_enq_behind_writes(r1_bio, 0)) {
> >               /* Reading from a write-mostly device must
> >                * take care not to over-take any writes
> >                * that are 'behind'
> > @@ -1216,6 +1251,35 @@ read_again:
> >       }
> >       sectors_handled =3D r1_bio->sector + max_sectors - bio->bi_sector;
> >
> > +    do_flush_fua =3D 0;
> > +    do_behind_flush =3D 0;
> > +
> > +    /* If this is a flush/fua request don't
> > +     * ever let it go "behind".  Keep all the
> > +     * mirrors in sync.
> > +     */
> > +    if (bio_rw_flagged(bio, BIO_FLUSH | BIO_FUA)) {
> > +        set_bit(R1BIO_BehindIO, &r1_bio->state);
> > +        do_flush_fua =3D  bio->bi_rw & (BIO_FLUSH | BIO_FUA);
> > +    }
> > +    else if (bitmap && mddev->bitmap_info.max_write_behind) {
> > +        if (atomic_read(&bitmap->behind_writes)
> > +            < mddev->bitmap_info.max_write_behind &&
> > +            !waitqueue_active(&bitmap->behind_wait))
> > +                set_bit(R1BIO_BehindIO, &r1_bio->state);
> > +        /* If this write is going behind, enqueue it on a
> > +          * behind_list. Also check if this write overlaps any existing
> > +          * behind writes. If it does, mark it as a flush(barrier) on =
the
> > +          * behind leg(s) only so ordering is guaranteed. Any writes
> > +          * *beyond* the max_write_behind limit won't go behind and
> > +          * therefore can't result in an overlap and thus aren't
> > +          * enqueued in the behind_list.
> > +          */
> > +        if (test_overlap_and_enq_behind_writes(
> > +            r1_bio, test_bit(R1BIO_BehindIO, &r1_bio->state)))
> > +            do_behind_flush =3D BIO_FLUSH;
> > +    }
> > +
> >       atomic_set(&r1_bio->remaining, 1);
> >       atomic_set(&r1_bio->behind_remaining, 0);
> >
> > @@ -1261,7 +1325,6 @@ read_again:
> >               if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
> >                   atomic_inc(&r1_bio->behind_remaining);
> >           }
> > -
> >           r1_bio->bios[i] =3D mbio;
> >
> >           mbio->bi_sector    =3D (r1_bio->sector +
> > @@ -1271,6 +1334,15 @@ read_again:
> >           mbio->bi_rw =3D WRITE | do_flush_fua | (do_sync << BIO_RW_SYN=
CIO);
> >           mbio->bi_private =3D r1_bio;
> >
> > +        if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
> > +            /* any write that goes to write mostly leg AND overlaps wi=
th
> > +              * an outstanding write behind needs to be a barrier
> > +              * however the non-write-mostly leg doesn't need a barrier
> > +              * because we wouldn't have an overlapping write unless t=
he
> > +              * non-write-mostly io has been ack'd
> > +              */
> > +            mbio->bi_rw |=3D do_behind_flush;
> > +
> >           atomic_inc(&r1_bio->remaining);
> >           spin_lock_irqsave(&conf->device_lock, flags);
> >           bio_list_add(&conf->pending_bio_list, mbio);
> > @@ -2843,6 +2915,7 @@ static struct r1conf *setup_conf(struct
> >       conf->raid_disks =3D mddev->raid_disks;
> >       conf->mddev =3D mddev;
> >       INIT_LIST_HEAD(&conf->retry_list);
> > +    INIT_LIST_HEAD(&conf->behind_list);
> >
> >       spin_lock_init(&conf->resync_lock);
> >       init_waitqueue_head(&conf->wait_barrier);
> > Index: b/drivers/md/raid1.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- a/drivers/md/raid1.h
> > +++ b/drivers/md/raid1.h
> > @@ -51,6 +51,7 @@ struct r1conf {
> >
> >       /* queue pending writes to be submitted on unplug */
> >       struct bio_list        pending_bio_list;
> > +    struct list_head    behind_list; /* oustanding behind writes */
> >       int            pending_count;
> >
> >       /* for use when syncing mirrors:
> > @@ -126,6 +127,7 @@ struct r1bio {
> >       int            read_disk;
> >
> >       struct list_head    retry_list;
> > +    struct list_head    behind_list;
> >       /* Next two are only valid when R1BIO_BehindIO is set */
> >       struct bio_vec        *behind_bvecs;
> >       int            behind_page_count;
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/tKc.1VA=Fj2A/eKEX_ui3+E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUp0S3jnsnt1WYoG5AQL1nA/+O5Kh63a+DhvdnCPTym5zjWVH9Y2FcYcA
+FAmCYS5fOz52AVaunWRU0W0rlE+W+fcPMz2kiGPjWO5a+cn5l9wJqnuFLXJQVJZ
gMfwq+cJBTXXiH6ifHAwJT8a+iq1cNxlEktt0kHXQFi380jtfMLXH5naANuTEFit
qKYNzkaYxjIt4x2k84uAd4r55hFCb1cHBSxcwjfX+lelZBYqE2tTgd+u+9Gseg4N
OLlvX5G8qC+da8Fq56GQv87WvieTs3XfIgjkJ/JDzc30aHyCjmUeQlVzg2d36UDL
31SEMvBgUunw49nVbTR3LNi4n25r0Llsy3mRwoVgxBeGC+EFptfDo9EIDTEtmMc2
8iiQBsW+YQkO7DkHUX3lhvLtb9DwoCxhCEYdpweenim3ZNzEkx4aOR0YydAXh/IR
W7BcG0wXMGToUHypKZhhmIQJ9gghRiI8hCYM2EfxeFPHxXrD8kNEdeUWv67Jg5Zf
WvMuaJ8hkrgL+NSr6kLpsOB8orAQ6ldqjIE+SceOeULBg3Ccro4xmWkG5BVfokoM
udwc5sBmEXGstHzxbIMYRAR7dUz336DtsJUEAWB/wxGkOX/0U1kOy+zCCYZeolyi
KL1lMiAvaKR/jvoPkSRcc1XnztMgwgxveBeEyjJIX0WwKJ5m5Cdx3oX/As59kAOs
phAA3m3imTo=
=tSQB
-----END PGP SIGNATURE-----

--Sig_/tKc.1VA=Fj2A/eKEX_ui3+E--
