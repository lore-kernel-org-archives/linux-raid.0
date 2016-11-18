From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 1/4] md: add block tracing for bio_remapping
Date: Fri, 18 Nov 2016 11:45:34 +1100
Message-ID: <871sy9haz5.fsf@notabene.neil.brown.name>
References: <147910131504.27168.6566119701315109161.stgit@noble> <147910142095.27168.11356591734977480053.stgit@noble> <20161116192922.ylqx32zocag4xp4b@kernel.org> <87twb6hdqq.fsf@notabene.neil.brown.name> <20161117180423.tzmeqpgklihgh7vp@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161117180423.tzmeqpgklihgh7vp@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18 2016, Shaohua Li wrote:

> On Thu, Nov 17, 2016 at 04:33:33PM +1100, Neil Brown wrote:
>> On Thu, Nov 17 2016, Shaohua Li wrote:
>>=20
>> > On Mon, Nov 14, 2016 at 04:30:21PM +1100, Neil Brown wrote:
>> >> The block tracing infrastructure (accessed with blktrace/blkparse)
>> >> supports the tracing of mapping bios from one device to another.
>> >> This is currently used when a bio in a partition is mapped to the
>> >> whole device, when bios are mapped by dm, and for mapping in md/raid5.
>> >> Other md personalities do not include this tracing yet, so add it.
>> >>=20
>> >> When a read-error is detected we redirect the request to a different =
device.
>> >> This could justifiably be seen as a new mapping for the originial bio,
>> >> or a secondary mapping for the bio that errors.  This patch uses
>> >> the second option.
>> >>=20
>> >> When md is used under dm-raid, the mappings are not traced as we do
>> >> not have access to the block device number of the parent.
>> >
>> > Looks the the original sector (the last parameter of trace_block_bio_r=
emap)
>> > isn't correct.
>> > - in linear/raid0, bio_split already updated bio->bi_iter.bi_sector
>>=20
>> Oh yes, of course.  in the common case 'split =3D=3D bio' so when
>> split->bi_iter.bi_sector  is adjusted, bio->.... is as well.
>> I'll fix that, and also add calls to trace_block_split() as appropriate.
>>=20
>>=20
>> > - in raid1/raid10, r1_bio->sector is updated before the bio is sent.
>>=20
>> Here I really think my code is correct.  r1_bio->sector is always the
>> address in the array of the request.  It is only set once for each
>> r1_bio, and that is before the call to trace_block_io_remap().
>
> Oh, you are right, sorry. I think moving the trace_remap right before we =
add
> the bio to plug or pending list is better. It will make the code simpler.=
 The
> timing of the trace doesn't matter.

I agree the timing doesn't matter

The reason I didn't do that before is that bio->bi_bdev points to the
rdev when the write bio is queued to the pending list.  I'm not sure if
trace_block_bio_remap() accesses ->bi_bdev, but it could.

So I'm not completely sure that it makes the code simpler, but I'll post
a version like that to see what you think.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLk8vAAoJEDnsnt1WYoG5phoQAKV8Uug81od6R7PNHRNyKo28
/oJdjGnlH9a5BjdvRuJMfb+WzLBi6XnnfA/mn6fFeCC10ui1LM6gIlqdadTSEALl
u7+aaNYN0YIhmhvBcR+P6QIIn4kn7spSwhyDWHWb2HyiSMkgBF8XJt1MkYlp1XJ3
nPB3T2xnFfqfTGckCMzoQNyoHhl9vmd/2urMvTsKYqYpBEl4AsWnBsjQ2aO/dmN8
3UJx8M786pTIOND8uFyKn2fLF8BZVllL/wYgd/aZFvXTojqIQbmg9Y9SA3UJaLDY
qB15FzVBDvQ1Tc5+Fudiu0P21K0S5RXfqLiyAL4iyQvcCk445BOgWEAigddPKplb
ivYmCOi6HA0+lEjH0pEflrU6mdKalRd3pqibA9dYU0cKmN25wiGFwLPGHJApAPe9
YSZCEKWnIAVCldL5v65Kx7r5Rva6B9U9EnhgHIGMCcjXSnXq6dAHXifR8AM1J6Fa
nPEJxnh27UC/XE31z8F954vBEAfgAw5U+oA9cLOjTnDEV5LsqcTkLexywIH7naZO
iJ/hLBrpvpicVOAlFl1Prx4sAzEp/nmBwdeR8iNgJQsnKGrLP5dG1ysVd67PHLqE
hg23Sm6VMY47cuPvMR1CS9UNN+muKye3cohrMQwS1QCwAhpm8Qb5JSUJttPZBhAA
VH5rr1yE86QWdyeC1o+Y
=QEuM
-----END PGP SIGNATURE-----
--=-=-=--
