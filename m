From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/5] MD: attach data to each bio
Date: Mon, 13 Feb 2017 20:49:33 +1100
Message-ID: <8760ke4dzm.fsf@notabene.neil.brown.name>
References: <cover.1486485935.git.shli@fb.com> <79515b1372fa1a1813c00ef0d7e0613a4512183d.1486485935.git.shli@fb.com> <87r336tw5l.fsf@notabene.neil.brown.name> <20170210064715.tpr5mzvccmgxz2af@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170210064715.tpr5mzvccmgxz2af@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, khlebnikov@yandex-team.ru, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 09 2017, Shaohua Li wrote:

> On Fri, Feb 10, 2017 at 05:08:54PM +1100, Neil Brown wrote:
>> On Tue, Feb 07 2017, Shaohua Li wrote:
>>=20
>> > Currently MD is rebusing some bio fields. To remove the hack, we attach
>> > extra data to each bio. Each personablity can attach extra data to the
>> > bios, so we don't need to rebuse bio fields.
>>=20
>> I must say that I don't really like this approach.
>> Temporarily modifying ->bi_private and ->bi_end_io seems
>> .... intrusive.   I suspect it works, but I wonder if it is really
>> robust in the long term.
>>=20
>> How about a different approach..  Your main concern with my first patch
>> was that it called md_write_start() and md_write_end() much more often,
>> and these performed atomic ops on "global" variables, particular
>> writes_pending.
>>=20
>> We could change writes_pending to a per-cpu array which we only count
>> occasionally when needed.  As writes_pending is updated often and
>> checked rarely, a per-cpu array which is summed on demand seems
>> appropriate.
>>=20
>> The following patch is an early draft - it doesn't obviously fail and
>> isn't obviously wrong to me.  There is certainly room for improvement
>> and may be bugs.
>> Next week I'll work on collection the re-factoring into separate
>> patches, which are possible good-to-have anyway.
>
> For your first patch, I don't have much concern. It's ok to me. What I do=
n't
> like is the bi_phys_segments handling part. The patches add a lot of logi=
c to
> handle the reference count. They should work, but I'd say it's not easy to
> understand and could be error prone. What we really need is a reference c=
ount
> for the bio, so let's just add a reference count. That's my logic and it's
> simple.

We already have two reference counts, and you want to add a third one.

bi_phys_segments is currently used for two related purposes.
It counts the number of stripe_heads currently attached to the bio so
that when the count reaches zero:
 1/ ->writes_pending can be decremented
 2/ bio_endio() can be called.

When the code was written, the __bi_remaining counter didn't exist.  Now
it does and it is integrated with bio_endio() so it should make the code
easier to understand if we just use bio_endio() rather and doing our own
accounting.

That just leaves '1'.  We can easily decrement ->writes_pending directly
instead of decrementing a per-bio refcount, and then when it reaches
zero, decrement ->writes_pending.  As you pointed out, that comes with a
cost.  If ->writes_pending is changed to a per-cpu array which is summed
on demand, the cost goes away.

Having an extra refcount in the bio just adds a level of indirection
that doesn't (that I can see) provide actual value.

>
> For the modifying bi_private and bi_end_io part, I saw some filesystems a=
re
> using this way, at least btrfs. If this is really intrusive, is cloning a=
 bio
> better?

The bio belongs to the filesystem.  It allocated it and can do whatever
it likes with bi_end_io and bi_private.  I don't think a block device
driver should ever change bi_private of bi_end_io of a bio that it was
passed (if it allocates its own bios, it can of course change those).
I don't think cloning the bio would really help, though you could
probably make something work.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlihgS0ACgkQOeye3VZi
gbmWag/6AiKYIVw/9/+4jIyq0d12j7q/k1SdVxvBcsIHjJez/Sfl9/gu82q4GGk8
HN9ui8BRLylWP4peofnrLujVXD+kzzX2X7okR/QQy4NGnJ/EPJWf8CRL8lBF8vn1
5HZ+4RuCQhrEumY+ciOGD3ug0vrKNvR97+8s1sJOKK6T85G/MMeSCAJr8lUsXDy/
mX1Lsoo8snzhjA9RJpAyY0voYHszlHesAlRHgFEp0dpEjy3/Wd7mpv6of1cPbGIm
lZnUUTIV0Y6O06yxuCbEKQRPJPjI1LUF2D6ADmuNgphiG6pC8OKb24eip70l+tLd
bENR309xns6ANbS2deaVaBcbjbbfSwfDNi5C6CGXE6ciG1dCqXWccg2nLB8L0SPI
mE6CjbqLIKKQ835IW8PkPLX90MqCsclcUQZ/vRPZhiSJ463Dci1XxQmRaLgt8w9c
cY1muXdOhAo6zkF1DI64VdVHw7A0w5R7GiAlm1VAF9yejb0GuzAWR1DypZRrCwGO
AbXmt/9vFeaqp3UQEol4gyIRXFIqKh/dUuPzWivKZot6bKG+889l/9k91oo3VdNC
HXc7Nngxs9Ssgw9KkR8sy6oMTaHljNPht4NH2yjWWKrH6NiY/WDT01qLr2qcoQ8e
6Yg9pBBRXn99LG/3YhkgqX9z/51ZBkKtT2UEw8mJAk0pnuEVBRE=
=vwGu
-----END PGP SIGNATURE-----
--=-=-=--
