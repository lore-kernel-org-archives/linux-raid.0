From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 4/4] md/bitmap: Don't write bitmap while earlier writes might be in-flight
Date: Tue, 08 Nov 2016 07:19:05 +1100
Message-ID: <87d1i7niva.fsf@notabene.neil.brown.name>
References: <147823807607.6764.8460942745584467311.stgit@noble> <147823836359.6764.7855525110697020696.stgit@noble> <20161105003325.qnmcu363ocbli74x@kernel.org> <87r36onrt5.fsf@notabene.neil.brown.name> <20161107191947.mzdkby6kbqpqssbv@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161107191947.mzdkby6kbqpqssbv@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 08 2016, Shaohua Li wrote:

> On Mon, Nov 07, 2016 at 09:53:42AM +1100, Neil Brown wrote:
>> On Sat, Nov 05 2016, Shaohua Li wrote:
>>=20
>> > On Fri, Nov 04, 2016 at 04:46:03PM +1100, Neil Brown wrote:
>> >> As we don't wait for writes to complete in bitmap_daemon_work, they
>> >> could still be in-flight when bitmap_unplug writes again.  Or when
>> >> bitmap_daemon_work tries to write again.
>> >> This can be confusing and could risk the wrong data being written las=
t.
>> >
>> > Applied the first 3 patches, thanks!
>> >
>> > This one seems not completely solving the race condition. It's still p=
ossible
>> > bitmap_daemon_work clears BITMAP_PAGE_NEEDWRITE but hasn't dispatch th=
e IO yet,
>> > bitmap_unplug then does nothing and thinks bitmap is updated to disk. =
Why don't
>> > we add locking here?
>>=20
>> Thanks for the review!
>>=20
>> BITMAP_PAGE_NEEDWRITE is set for pages that need to be written out in
>> order to clear bits that don't need to be set any more.  There is never
>> any urgency to do this.
>> BITMAP_PAGE_DIRTY is set of pages that need to be written out in order
>> to set bits representing regions that are about to be written to.  These
>> have to be flushed by bitmap_unplug().
>> Pages can have both bits set, in which case bitmap_daemon_work() will
>> leave them for bitmap_unplug() to deal with.
>>=20
>> So if bitmap_daemon_work() clears BITMAP_PAGE_PENDING on a page, then it
>> is a page that bitmap_unplug() doesn't need to wait for.
>
> Oops, I misread the code. Yes, this is very clear, thanks for the explain=
ation.
>
> So I can understand the patch fixes the confusion. when is there risk wro=
ng
> data is written?

The goal is to avoid the possibility that two writes to the same
location are in flight at the same time.
It isn't clear that this would cause a problem, but it isn't clear that
it is completely safe either.
In general, this doesn't happen - certainly not from the page cache - so
drivers will not be prepared for it.
As an extreme example, suppose that the target device is a multi-path
device.
One write is sent and just after it is DMAed to one path, the in-memory
page is changed and a second write is submitted, and the data is DMAed
down the other path.  Are we certain the two will be committed to
storage in the intended order?
Probably they will be.  But maybe with a more complex stack, the chance
of one IO overtaking the other (even after the first DMA) increases.

So I cannot argue very strongly for this code, but it seems like a good
idea and is reasonably simple....

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYIOG5AAoJEDnsnt1WYoG5ifsP/jC1BBmPCu0U1UGH8MJWIzPZ
lLU3cLW93ScQypGOdZD89XkdDELYrusSbTB39vSURdZ19gsXYE4404Og0b2KPvPB
jS/Iw6qL91VbBYIPAnu8M55wwDNJXUvma7IkulfID0hhHzmZ3Dnb2heMbXsOWrr6
Z2v6e/ubmFDvTDl9CVj/xcdtjIYfpt4v5//Z+O/wk5ZW4I5ym9lTicvvQgSeVndY
wjFqi39Bods54OIZ47+oMkiDOAjmXho+GPOBNkmT+lB7kV1H2BXf5/9p4d/YFiZw
l7IfWYCXaO9maVeVWxfw1nWHP/dHoZam6OBuaJv5FoXd9V1fMzgk9tul1I8KpP+4
Tblh70pS76pWXXMo6NZFv9yHPIWHqzLqG6AkRAbQIMBcNDwI4BhSot6RqaWHgld3
MWjEwvb4KSm3a4g3mpk1Ad4CyOXtpiQSbMHK73fIQEjNsAqih2zoFvS4rg7CWRSk
oXc/LL8LUmPQUrg9jMiPFK4jhjEx2sKWnhT/XkDsz51duCcqfBoQaKFhzFVbId4H
Y2hbBD6SenJy6c9H16ZT974F/GZdKTBjXwxS+6ujCg+lHm/xfilVf34WNbAEinnh
PJ3tC/Qdj5clWkPa1/VOPeUGcoc/xnAJqRlpSQ/l1wZZUGzYK7A4ZY/qCpaBhFHp
MkOhwk0E/GRv97Bda5yc
=cS3h
-----END PGP SIGNATURE-----
--=-=-=--
