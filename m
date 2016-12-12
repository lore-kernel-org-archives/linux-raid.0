From: NeilBrown <neilb@suse.com>
Subject: Re: raid0 vs. mkfs
Date: Mon, 12 Dec 2016 14:17:58 +1100
Message-ID: <87y3zlzvh5.fsf@notabene.neil.brown.name>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com> <87oa108a1x.fsf@notabene.neil.brown.name> <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com> <87inr880au.fsf@notabene.neil.brown.name> <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com> <87d1he7zv9.fsf@notabene.neil.brown.name> <33bb250a-4dfd-0acc-9958-30fdac10918c@scylladb.com> <ccf447df-e7b5-0a08-7753-67ee4ad574ef@suse.de> <20161207165933.isq64dbkxye772nz@kernel.org> <c384d070-457c-cfee-e35f-53b9195ace10@suse.de> <20161208191906.ealqsudmgopn7wa3@kernel.org> <14867138-b0ea-fb58-dae6-70f30a3ddcc8@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14867138-b0ea-fb58-dae6-70f30a3ddcc8@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Shaohua Li <shli@kernel.org>
Cc: Avi Kivity <avi@scylladb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 09 2016, Coly Li wrote:

> On 2016/12/9 =E4=B8=8A=E5=8D=883:19, Shaohua Li wrote:
>> On Fri, Dec 09, 2016 at 12:44:57AM +0800, Coly Li wrote:
>>> On 2016/12/8 =E4=B8=8A=E5=8D=8812:59, Shaohua Li wrote:
>>>> On Wed, Dec 07, 2016 at 07:50:33PM +0800, Coly Li wrote:
>>> [snip]
>>>> Thanks for doing this, Coly! For raid0, this totally makes sense. The =
raid0
>>>> zones make things a little complicated though. I just had a brief look=
 of your
>>>> proposed patch, which looks really complicated. I'd suggest something =
like
>>>> this:
>>>> 1. split the bio according to zone boundary.
>>>> 2. handle the splitted bio. since the bio is within zone range, calcul=
ating
>>>> the start and end sector for each rdev should be easy.
>>>>
>>>
>>> Hi Shaohua,
>>>
>>> Thanks for your suggestion! I try to modify the code by your suggestion,
>>> it is even more hard to make the code that way ...
>>>
>>> Because even split bios for each zone, all the corner cases still exist
>>> and should be taken care in every zoon. The code will be more complicat=
ed.
>>=20
>> Not sure why it makes the code more complicated. Probably I'm wrong, but=
 Just
>> want to make sure we are in the same page: split the bio according to zo=
ne
>> boundary, then handle the splitted bio separately. Calculating end/start=
 point
>> of each rdev for the new bio within a zone should be simple. we then clo=
ne a
>> bio for each rdev and dispatch. So for example:
>> Disk 0: D0 D2 D4 D6 D7
>> Disk 1: D1 D3 D5
>> zone 0 is from D0 - D5, zone 1 is from D6 - D7
>> If bio is from D1 to D7, we split it to 2 bios, one is D1 - D5, the othe=
r D6 - D7.
>> For D1 - D5, we dispatch 2 bios. D1 - D5 for disk 1, D2 - D4 for disk 0
>> For D6 - D7, we just dispatch to disk 0.
>> What kind of corner case makes this more complicated?
>>=20=20
>
> Let me explain the corner cases.
>
> When upper layer code issues a DISCARD bio, the bio->bi_iter.bi_sector
> may not be chunk size aligned, and bio->bi_iter.bi_size may not be
> (chunk_sects*nb_dev) sectors aligned. In raid0, we can't simply round
> up/down them into chunk size aligned number, otherwise data
> lost/corruption will happen.
>
> Therefore for each DISCARD bio that raid0_make_request() receive, the
> beginning and ending parts of this bio should be treat very carefully.
> All the corner cases *come from here*, they are not about number of
> zones or rdevs, it is about whether bio->bi_iter.bi_sector and
> bio->bi_iter.bi_size are chunk size aligned or not.
>
> - beginning of the bio
>   If bio->bi_iter.bi_sector is not chunk size aligned, current raid0
> code will split the beginning part into split bio which only contains
> sectors from bio->bi_iter.sector to next chunk size aligned offset, and
> issue this bio by generic_make_request(). But in
> discard_large_discard_bio() we can't issue the split bio now, we have to
> record lenth of this split bio into a per-device structure, and issue a

Why?

Why cannot you just split of the start of the bio and chain it with the
rest of the bio?

If the bio doesn't start at the beginning of a stripe, just split of the
first (partial) chunk exactly was we currently do.

If it does start at the beginning of a stripe, then split off a whole
number of stripes and allocate one bio for each device.  Chain those to
the original bio together with any remainder (which isn't a whole
stripe).

I think that if you make use of bio_split() and bio_chain() properly,
the code will be much simpler.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhOFuYACgkQOeye3VZi
gbnzAw/+JO99Fg18nYJBK9FDyinZ410PFC/tsjzJIkQO8HM3QFEz2igjwJHTo9f7
M1ODeoK33EmRC7mBmgrVxLcD3hS168xcC8njduJru7OelksSIS8Q01UZf5JDcUHj
Ev5tvHdV32dyS7I4APfPRO7nz8Tish75sdtNVe9a3cPZssdcDpZjrotng4T+xJGC
Kzlj9ZXUTbFEM8+KR7wfhRrhx+j2NmIdzJlFUoYV7P4pbgqrsYI+meAQSo7RByZE
cf4PKorutOv6RIXKm9b1QPUzbQn84t16XvdUu8elj6fR/PF9xif4BPW9GcG1OXio
9N6zmLAVG0WXRdHTLUPFWZpkhbrKoF8XulzLAtG6wIAJwSlZ/Bf1iTEueU40nJ7b
pf98DWTyHj2/N4Q97ct5EFF0SLZv/niAzRV9NikTVfik7t9MuRXd8ccj/j1yusth
teYzPYZWqMiGtDGhVavKYuPIQXxM9WsSyyVawtdK7krvWETs6WdRh9ev7fjG1kt5
y8gy1z0tYwsyLGSI/k05ygQ6CwxcM5nxRfviENiMAMMcvJlF1e9/GPZQSkUFvS1L
4fh3XDaPpYwYqDaAc//bqFJ793cFmib02l9KtooJKjGmPUYPhUC3GFhblnvKy/vH
ZxaiMcSHSrLojRJacVbDxZILrht5gKW/GefTdpIl0Z+ufGEp1To=
=el9/
-----END PGP SIGNATURE-----
--=-=-=--
