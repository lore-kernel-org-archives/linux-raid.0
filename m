From: =?utf-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>
Subject: Re: problem with bio handling on raid5 and pblk
Date: Fri, 23 Mar 2018 13:52:28 +0100
Message-ID: <04D5C038-969C-49EB-A9AA-EBE0548521E6@javigon.com>
References: <66350920-EC5E-447F-B5DF-0F3C2CDEAA65@javigon.com>
 <97678ddd-140f-5a8b-75ee-cbb584308260@lightnvm.io>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: multipart/signed;
        boundary="Apple-Mail=_AB9485BC-2831-4432-89FE-120E14B3DFD4";
        protocol="application/pgp-signature";
        micalg=pgp-sha512
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <97678ddd-140f-5a8b-75ee-cbb584308260@lightnvm.io>
Sender: linux-kernel-owner@vger.kernel.org
To: =?utf-8?Q?Matias_Bj=C3=B8rling?= <mb@lightnvm.io>
Cc: Jens Axboe <axboe@kernel.dk>, shli@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Huaicheng Li <huaicheng@cs.uchicago.edu>
List-Id: linux-raid.ids


--Apple-Mail=_AB9485BC-2831-4432-89FE-120E14B3DFD4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

> On 22 Mar 2018, at 18.00, Matias Bj=C3=B8rling <mb@lightnvm.io> wrote:
>=20
> On 03/22/2018 03:34 PM, Javier Gonz=C3=A1lez wrote:
>> Hi,
>> I have been looking into a bug report when using pblk and raid5 on =
top
>> and I am having problems understanding if the problem is in pblk's =
bio
>> handling or on raid5's bio assumptions on the completion path.
>> The problem occurs on the read path. In pblk, we take a reference to
>> every read bio as it enters, and release it after completing the bio.
>>    generic_make_request()
>>    pblk_submit_read()
>>      bio_get()
>>      ...
>>      bio_endio()
>>      bio_put()
>> The problem seems to be that on raid5's bi_end_io completion path,
>> raid5_end_read_request(), bio_reset() is called. When put together
>> with pblk's bio handling:
>>    generic_make_request()
>>    pblk_submit_read()
>>      bio_get()
>>      ...
>>      bio_endio()
>>      raid5_end_read_request()
>>        bio_reset()
>>      bio_put()
>> it results in the newly reset bio being put immediately, thus freed.
>> When the bio is reused then, we have an invalid pointer. In the =
report
>> we received things crash at BUG_ON(bio->bi_next) at
>> generic_make_request().
>> As far as I understand, it is part of the bio normal operation for
>> drivers under generic_make_request() to be able to take references =
and
>> release them after bio completion. Thus, in this case, the assumption
>> made by raid5, that it can issue a bio_reset() is incorrect. But I =
might
>> be missing an implicit cross layer rule that we are violating in =
pblk.
>> Any ideas?
>> This said, after analyzing the problem from pblk's perspective, I see
>> not reason to use bio_get()/bio_put() in the read path as it is at =
the
>> pblk level that we are submitting bio_endio(), thus we cannot risk =
the
>> bio being freed underneath us. Is this reasoning correct? I remember =
I
>> introduced these at the time there was a bug on the aio path, which =
was
>> not cleaning up correctly and could trigger an early bio free, but
>> revisiting it now, it seems unnecessary.
>> Thanks for the help!
>> Javier
>=20
> I think I sent a longer e-mail to you and Huaicheng about this a while =
back.

I don't think I was in that email.

There are two parts to the question. One is raid5's bio completion
assumptions and the other is whether we can avoid bio_get()/put() in
pblk's read path. The first part is pblk independent and I would like to
leave it open as I would like to understand how bio_reset() in this
context is correct. Right now, I cannot see how this is correct
behaviour.

For the pblk specific part, see below.

> The problem is that the pblk encapsulates the bio in its own request.
> So the bio's are freed before the struct request completion is done
> (as you identify). If you can make the completion path (as bio's are
> completed before the struct request completion fn is called) to not
> use the bio, then the bio_get/put code can be removed.
>=20
> If it needs the bio on the completion path (e.g., for partial reads,
> and if needed in the struct request completion path), one should clone
> the bio, submit, and complete the original bio afterwards.

I don't follow how the relationship with struct request completion is
different with bio_get/put and without.

The flow in terms of bio and struct request management is today:

  generic_make_request()
   pblk_submit_read()
     bio_get()
      ...
     blk_init_request_from_bio()
     blk_execute_rq_nowait() / blk_execute_rq() // denepnding on =
sync/async
      ...
     bio_endio()
     bio_put()
      ...
     blk_mq_free_request()

bios risk to always freed in any case, as bio_put() will the last pblk
reference. The only case in which this will not happen is that somebody
else took a bio_get() on the way down. But we cannot assume anything.

I guess the problem I am having understanding this is how we can risk
the bio disappearing underneath when we are the ones completing the bio.
As I understand it, in this case we are always guaranteed that the
bio is alive due to the allocation reference. Therefore, bio_get()/put()
is not needed. Am I missing anything?

Thanks,
Javier


--Apple-Mail=_AB9485BC-2831-4432-89FE-120E14B3DFD4
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEU1dMZpvMIkj0jATvPEYBfS0leOAFAlq0+IwACgkQPEYBfS0l
eOB3zhAAhVwDJSaLzvCVdZko7Uv9gNaStmGwuWEonO6oD31DgeC48WeEb9nkIKwS
Cp+EpEmIQV7G+oUB5lc74Rm6bHB/d2P8eGfzm0ZsCmDndAqppBnGghM+UEKH86OK
jB0KpdFDxmpmwYcL+KCwAmtYBhHh1M99Jy/Z2GaHkej2LPbkVyQzySzTvWKOrI8q
di1Ig5sbCfUYExgbLdXpaIsOwI2H+fFwHLzlmGGi4VB7KWv5kL14k0acZVleM3z5
vllji7MzLHweLPxNOWplpzvFViFgXN0QlvpXMfCfhW3PWcCPqy0vaeW7GLAWA3Lg
0yjz90Qeg2iea4rgsZMcny/ZrK1HbOIVJKmkw5TefkK/2ersKQOeNB9N82PBct1e
/VWzMvxusF4TKOhjfgxXjhV0ixkL1SR/fYOk87uukEZCdroaVpMTrTUc+4vlPZUT
hXTg3U71SJNN5hiAQojWkj1zBdrlh+/+9mKg+hz3R1p9bI+3yziDxCsy/mfxQ91w
lZI4m8Q5IYXkQQvXDFI4pKgTjG+z8TU4UQwVwQPjwgeox6NStHEfVCFNoEiYTwS6
iwGnlbHMwTKXURAqaMPmCeg1wuaHJLdLMGfw5klziWjRqKlo5l1iDfK9Zj3kQozn
nEaoCGQHGe5bMEbAVcBH3zLQut7ttJif0EBTpRL0XSVOwaEWEic=
=aqO6
-----END PGP SIGNATURE-----

--Apple-Mail=_AB9485BC-2831-4432-89FE-120E14B3DFD4--
