From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3 05/14] md: raid1: don't use bio's vec table to manage resync pages
Date: Tue, 11 Jul 2017 09:14:01 +1000
Message-ID: <874luj6g1y.fsf@notabene.neil.brown.name>
References: <20170316161235.27110-1-tom.leiming@gmail.com> <20170316161235.27110-6-tom.leiming@gmail.com> <87mv8d5ht7.fsf@notabene.neil.brown.name> <CACVXFVP69kLQyr0NOY7zXMZ_bdJYCV7fBbDrKdFF9fBPBTsU-g@mail.gmail.com> <20170710041304.GB15321@ming.t460p> <87h8yk6h50.fsf@notabene.neil.brown.name> <20170710072538.GA32208@ming.t460p> <20170710190549.luj7zrnq7mo4x36b@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170710190549.luj7zrnq7mo4x36b@kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Ming Lei <ming.lei@redhat.com>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 10 2017, Shaohua Li wrote:

> On Mon, Jul 10, 2017 at 03:25:41PM +0800, Ming Lei wrote:
>> On Mon, Jul 10, 2017 at 02:38:19PM +1000, NeilBrown wrote:
>> > On Mon, Jul 10 2017, Ming Lei wrote:
>> >=20
>> > > On Mon, Jul 10, 2017 at 11:35:12AM +0800, Ming Lei wrote:
>> > >> On Mon, Jul 10, 2017 at 7:09 AM, NeilBrown <neilb@suse.com> wrote:
>> > ...
>> > >> >> +
>> > >> >> +             rp->idx =3D 0;
>> > >> >
>> > >> > This is the only place the ->idx is initialized, in r1buf_pool_al=
loc().
>> > >> > The mempool alloc function is suppose to allocate memory, not ini=
tialize
>> > >> > it.
>> > >> >
>> > >> > If the mempool_alloc() call cannot allocate memory it will use me=
mory
>> > >> > from the pool.  If this memory has already been used, then it wil=
l no
>> > >> > longer have the initialized value.
>> > >> >
>> > >> > In short: you need to initialise memory *after* calling
>> > >> > mempool_alloc(), unless you ensure it is reset to the init values=
 before
>> > >> > calling mempool_free().
>> > >> >
>> > >> > https://bugzilla.kernel.org/show_bug.cgi?id=3D196307
>> > >>=20
>> > >> OK, thanks for posting it out.
>> > >>=20
>> > >> Another fix might be to reinitialize the variable(rp->idx =3D 0) in
>> > >> r1buf_pool_free().
>> > >> Or just set it as zero every time when it is used.
>> > >>=20
>> > >> But I don't understand why mempool_free() calls pool->free() at the=
 end of
>> > >> this function, which may cause to run pool->free() on a new allocat=
ed buf,
>> > >> seems a bug in mempool?
>> > >
>> > > Looks I missed the 'return' in mempool_free(), so it is fine.
>> > >
>> > > How about the following fix?
>> >=20
>> > It looks like it would probably work, but it is rather unusual to
>> > initialise something just before freeing it.
>> >=20
>> > Couldn't you just move the initialization to shortly after the
>> > mempool_alloc() call.  There looks like a good place that already loops
>> > over all the bios....
>>=20
>> OK, follows the revised patch according to your suggestion.

Thanks.

That isn't as tidy as I hoped.  So I went deeper into the code to try to
understand why...

I think that maybe we should just discard the ->idx field completely.
It is only used in this code:

	do {
		struct page *page;
		int len =3D PAGE_SIZE;
		if (sector_nr + (len>>9) > max_sector)
			len =3D (max_sector - sector_nr) << 9;
		if (len =3D=3D 0)
			break;
		for (bio=3D biolist ; bio ; bio=3Dbio->bi_next) {
			struct resync_pages *rp =3D get_resync_pages(bio);
			page =3D resync_fetch_page(rp, rp->idx++);
			/*
			 * won't fail because the vec table is big enough
			 * to hold all these pages
			 */
			bio_add_page(bio, page, len, 0);
		}
		nr_sectors +=3D len>>9;
		sector_nr +=3D len>>9;
	} while (get_resync_pages(biolist)->idx < RESYNC_PAGES);

and all of the different 'rp' always have the same value for 'idx'.
This code is more complex than it needs to be.  This is because it used
to be possible for bio_add_page() to fail.  That cannot happen any more.
So we can make the code something like:

  for (idx =3D 0; idx < RESYNC_PAGES; idx++) {
     struct page *page;
     int len =3D PAGE_SIZE;
     if (sector_nr + (len >> 9) > max_sector)
         len =3D (max_sector - sector_nr) << 9
     if (len =3D=3D 0)
         break;
     for (bio =3D biolist; bio; bio =3D bio->bi_next) {
        struct resync_pages *rp =3D get_resync_pages(bio);
        page =3D resync_fetch_page(rp, idx);
        bio_add_page(bio, page, len, 0);
     }
     nr_sectors +=3D len >> 9;
     sector_nr +=3D len >> 9;
  }

Or did I miss something?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllkCjsACgkQOeye3VZi
gbnjDg//WsZC/Xdj/lu3t9jZYtYPTx3SNfeRqAH7KhBqN7sFkCnySWGwqPWxvEMl
nNUtEuLELsiiaIsQ0fbcgO6LFp9f+70DgMvvZP3zcWb+tpzq7USEo7Z7KeBzaIve
gow90QCHVXrSl29dLPzHhZmXjyBjpZZuD//DHNJPGW6SZGzckWIMRnRWuXnmer6y
kQumDgyR41IqA/GsC7UBqxtq4QsxKr+1DZVZx84eTiEOZTyXVktRNbBcZWsXNTKv
qGWftfHXn5ian544j1/sRj0aV8NKmSHZr2oJTqxOawuhLDwJi7eynghtnBjqr86t
gPnTn17iZFqQ7MJQuiVsgWW00h21B05adHCd8NN5mcQc1wtgbGfh+QQyZTuAChSJ
1vG2q2EZoVv/jx9ipcsEnTljW18OWrTgZ2E+hYxIe4LPXfkOexB4kCJTQ9319VBr
Ck+d0hRasa4gjof2T0TdZQIrDesQA2KKba9xyjtNSLP6w047p1AE6FA732vxbEae
JFzYWed4QZnu0XCYDaQiRBH/tIbK4V2HLnVua9rSrIlOfAnweMnxdZxF2EUpDj0k
x9+JE+3WZIDvIjuhJvTamIWr6tHBYXA8L+YGCeqjcoXIqfiPb7mar3X85m9tUuR+
j3BINm9CBthh4N0DZTINP84Gl75CoSTkJDAGDV5UiZEwkNVpb2A=
=7fAz
-----END PGP SIGNATURE-----
--=-=-=--
