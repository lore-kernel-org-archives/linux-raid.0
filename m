From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [md PATCH 01/36] md: beginnings of bad block management.
Date: Tue, 26 Jul 2011 14:17:12 +0900
Message-ID: <1311657432.1522.2.camel@leonhard>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	 <20110721025847.8422.29443.stgit@notabene.brown> <878vrq5pda.fsf@gmail.com>
	 <20110726122627.5288a3ff@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110726122627.5288a3ff@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011-07-26 (=ED=99=94), 12:26 +1000, NeilBrown:
> On Sat, 23 Jul 2011 00:03:45 +0900 Namhyung Kim <namhyung@gmail.com> =
wrote:
>=20
> > NeilBrown <neilb@suse.de> writes:
> >=20
> > > This the first step in allowing md to track bad-blocks per-device=
 so
> > > that we can fail individual blocks rather than the whole device.
> > >
> > > This patch just adds a data structure for recording bad blocks, w=
ith
> > > routines to add, remove, search the list.
> > >
> > > Signed-off-by: NeilBrown <neilb@suse.de>
> > > ---
> > >
> > >  drivers/md/md.c |  457 +++++++++++++++++++++++++++++++++++++++++=
++++++++++++++
> > >  drivers/md/md.h |   49 ++++++
> > >  2 files changed, 502 insertions(+), 4 deletions(-)
> > >
> > > +
> > > +/* Bad block management.
> > > + * We can record which blocks on each device are 'bad' and so ju=
st
> > > + * fail those blocks, or that stripe, rather than the whole devi=
ce.
> > > + * Entries in the bad-block table are 64bits wide.  This compris=
es:
> > > + * Length of bad-range, in sectors: 0-511 for lengths 1-512
> > > + * Start of bad-range, sector offset, 54 bits (allows 8 exbibyte=
s)
> > > + *  A 'shift' can be set so that larger blocks are tracked and
> > > + *  consequently larger devices can be covered.
> > > + * 'Acknowledged' flag - 1 bit. - the most significant bit.
> > > + */
> > > +/* Locking of the bad-block table is a two-layer affair.
> > > + * Read access through ->active_page only requires an rcu_readlo=
ck.
> > > + * However if ->active_page is found to be NULL, the table
> > > + * should be accessed through ->page which requires an irq-spinl=
ock.
> > > + * Updating the page requires setting ->active_page to NULL,
> > > + * synchronising with rcu, then updating ->page under the same
> > > + * irq-spinlock.
> > > + * We always set or clear bad blocks from process context, but
> > > + * might look-up bad blocks from interrupt/bh context.
> > > + *
> >=20
> > Empty line.
> >=20
> > If the locking is complex, it'd be better defining separate functio=
ns to
> > deal with it, IMHO. Please see below.
>=20
> I too have been feeling uncomfortable about the locking and I recentl=
y
> realised that I really should be using a seqlock rather than trying t=
o force
> RCU into the mould.  So I have changed it and it is much better now. =
 Below
> is new version.
>=20
>=20
> > > +EXPORT_SYMBOL_GPL(rdev_set_badblocks);
> >=20
> > I think it would be better if all exported functions in md.c have
> > prefixed 'md_'.
> >=20
>=20
> Probably good advice.  I don't think I'll change it now but maybe in =
a
> subsequent patch so that I change them all at once.
>=20
> Thanks,
> NeilBrown
>=20
> commit 0980048be17a45ae9e181ad04a549c31a499dee9
> Author: NeilBrown <neilb@suse.de>
> Date:   Tue Jul 26 12:22:08 2011 +1000
>=20
>     md: beginnings of bad block management.
>    =20
>     This the first step in allowing md to track bad-blocks per-device=
 so
>     that we can fail individual blocks rather than the whole device.
>    =20
>     This patch just adds a data structure for recording bad blocks, w=
ith
>     routines to add, remove, search the list.
>    =20
>     Signed-off-by: NeilBrown <neilb@suse.de>

with your another badblocks.page fix:

  Reviewed-by: Namhyung Kim <namhyung@gmail.com>


--=20
Regards,
Namhyung Kim


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
