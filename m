From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/5] MD: attach data to each bio
Date: Tue, 14 Feb 2017 13:40:30 +1100
Message-ID: <87vasd336p.fsf@notabene.neil.brown.name>
References: <cover.1486485935.git.shli@fb.com> <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com> <87r336tw5l.fsf@notabene.neil.brown.name> <20170210064715.tpr5mzvccmgxz2af@kernel.org> <8760ke4dzm.fsf@notabene.neil.brown.name> <20170213184942.x3s2hawueq3ryzj3@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170213184942.x3s2hawueq3ryzj3@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, khlebnikov@yandex-team.ru, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13 2017, Shaohua Li wrote:

> On Mon, Feb 13, 2017 at 08:49:33PM +1100, Neil Brown wrote:
>> On Thu, Feb 09 2017, Shaohua Li wrote:
>>=20
>> > On Fri, Feb 10, 2017 at 05:08:54PM +1100, Neil Brown wrote:
>> >> On Tue, Feb 07 2017, Shaohua Li wrote:
>> >>=20
>> >> > Currently MD is rebusing some bio fields. To remove the hack, we at=
tach
>> >> > extra data to each bio. Each personablity can attach extra data to =
the
>> >> > bios, so we don't need to rebuse bio fields.
>> >>=20
>> >> I must say that I don't really like this approach.
>> >> Temporarily modifying ->bi_private and ->bi_end_io seems
>> >> .... intrusive.   I suspect it works, but I wonder if it is really
>> >> robust in the long term.
>> >>=20
>> >> How about a different approach..  Your main concern with my first pat=
ch
>> >> was that it called md_write_start() and md_write_end() much more ofte=
n,
>> >> and these performed atomic ops on "global" variables, particular
>> >> writes_pending.
>> >>=20
>> >> We could change writes_pending to a per-cpu array which we only count
>> >> occasionally when needed.  As writes_pending is updated often and
>> >> checked rarely, a per-cpu array which is summed on demand seems
>> >> appropriate.
>> >>=20
>> >> The following patch is an early draft - it doesn't obviously fail and
>> >> isn't obviously wrong to me.  There is certainly room for improvement
>> >> and may be bugs.
>> >> Next week I'll work on collection the re-factoring into separate
>> >> patches, which are possible good-to-have anyway.
>> >
>> > For your first patch, I don't have much concern. It's ok to me. What I=
 don't
>> > like is the bi_phys_segments handling part. The patches add a lot of l=
ogic to
>> > handle the reference count. They should work, but I'd say it's not eas=
y to
>> > understand and could be error prone. What we really need is a referenc=
e count
>> > for the bio, so let's just add a reference count. That's my logic and =
it's
>> > simple.
>>=20
>> We already have two reference counts, and you want to add a third one.
>>=20
>> bi_phys_segments is currently used for two related purposes.
>> It counts the number of stripe_heads currently attached to the bio so
>> that when the count reaches zero:
>>  1/ ->writes_pending can be decremented
>>  2/ bio_endio() can be called.
>>=20
>> When the code was written, the __bi_remaining counter didn't exist.  Now
>> it does and it is integrated with bio_endio() so it should make the code
>> easier to understand if we just use bio_endio() rather and doing our own
>> accounting.
>>=20
>> That just leaves '1'.  We can easily decrement ->writes_pending directly
>> instead of decrementing a per-bio refcount, and then when it reaches
>> zero, decrement ->writes_pending.  As you pointed out, that comes with a
>> cost.  If ->writes_pending is changed to a per-cpu array which is summed
>> on demand, the cost goes away.
>>=20
>> Having an extra refcount in the bio just adds a level of indirection
>> that doesn't (that I can see) provide actual value.
>
> Ok, fair enough. I do think an explict counter in the driver side will he=
lp us
> a lot, eg, we can better control when to endio and do something there (for
> example the current blk trace, or something we want to add in the future)=
. But
> I don't insist currently.
>
> For the patches, can you repost? I think:
> - patch 2 missed md_write_start for make_discard_request
> - It's unnecessary to zero bi_phys_segments in patch 5. And raid5-cache n=
eed do
>   the same change of bio_endio.
> For the md_write_start optimization, we can do it later.

Sure. I agree those two changes are needed.  I'll try to send something
in the next day or so.

NeilBrown


>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliibh4ACgkQOeye3VZi
gblimxAAlqzPSfyBysupvvyOPiPAsqduiKBX3oBd9C3LYACQiXi/TMDjZLoivJtm
mjlSfuF/DxoA0dUxlp1Gss32786hbBjplpEU28D6nnIK3h/RMfZp0mQHbD5deA50
GgUxmUskrTOK3r06LIlfZRu7K4fJzfZ3D9562Z/CvzVe3PKJbUylOy08ARz0U3NI
9lGo+3GsWme70LfolS+nGO+3ReOVWk4Q+60qUK8NBDS1CaLIdcvEOupKiyGRkO+3
jbHQEuWEHw18F5R/p/IQJtCp46KugATpz+OuGRa1K2A1H/2B3oVqNDUxpKZVthSA
T8OxQNDMq8c+3jnwUPwUybViqcS/h5JMa9brnQvZFIU4DEcZb5iMChvbLBB12FfH
FKx5tyc7PyXDeOpZXScQn03IlgBMJIOVNZU4JGJRiQ2bi1gyP3YQckVY7fHmruCR
WLkhv5zwufpnnYatZHrrfkjP5Db2Kg3m1ttGGjU/g76yI4wJ4WYdilwXEplWf1ip
8Cph4HFG+Vhq7dp+yagD5BzAM+V7w5dhFBx0KdP3Uj3SmXmy8nLWn2EXQ/f0sO/e
DGd8VF7zT5k5WR6tmHZDzyV3Ecb8Vwkb9QRoTQdcb0TxYsCceH7wLr5M7L9oQdlc
lxTstJ/ka2d39+KuMJHElwwhiy19baQGr2+WCkE55n4/vXXuDfc=
=eEDH
-----END PGP SIGNATURE-----
--=-=-=--
