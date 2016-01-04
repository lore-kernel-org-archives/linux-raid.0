From: NeilBrown <neilb@suse.com>
Subject: Re: raid5 async_xor: sleep in atomic
Date: Mon, 04 Jan 2016 12:33:32 +1100
Message-ID: <87wprqxh5f.fsf@notabene.neil.brown.name>
References: <CAFskJNhmU-N5_odOZV54x10Ku=7SSDnaMz5EtCbKddye+AGReg@mail.gmail.com> <87twn928qv.fsf@notabene.neil.brown.name> <CAPcyv4im63odabZ_gMF_ESuv=iZ7fyBYqLzXJDPe4cBRwtdG4g@mail.gmail.com> <87d1tw23jk.fsf@notabene.neil.brown.name> <CAPcyv4g=HBHn3f75gW9JKNdjYEnjxNCYEp3vjJBa_fGm7e+hJw@mail.gmail.com> <CAFskJNg9_gJ3HRMqD4N6FSue2R2W3CSz+1KwiZw1Bp6==dOp5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFskJNg9_gJ3HRMqD4N6FSue2R2W3CSz+1KwiZw1Bp6==dOp5A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stanislav Samsonov <slava@annapurnalabs.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Dec 28 2015, Stanislav Samsonov wrote:

> On 24 December 2015 at 00:46, Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> On Wed, Dec 23, 2015 at 2:39 PM, NeilBrown <neilb@suse.com> wrote:
>> > On Thu, Dec 24 2015, Dan Williams wrote:
>> >>> Changing the GFP_NOIO to GFP_ATOMIC in all the calls to
>> >>> dmaengine_get_unmap_data() in crypto/async_tx/ would probably fix the
>> >>> issue... or make it crash even worse :-)
>> >>>
>> >>> Dan: do you have any wisdom here?  The xor is using the percpu data in
>> >>> raid5, so it cannot be sleep, but GFP_NOIO allows sleep.
>> >>> Does the code handle failure to get_unmap_data() safely?  It looks like
>> >>> it probably does.
>> >>
>> >> Those GFP_NOIO should move to GFP_NOWAIT.  We don't want GFP_ATOMIC
>> >> allocations to consume emergency reserves for a performance
>> >> optimization.  Longer term async_tx needs to be merged into md
>> >> directly as we can allocate this unmap data statically per-stripe
>> >> rather than per request. This asyntc_tx re-write has been on the todo
>> >> list for years, but never seems to make it to the top.
>> >
>> > So the following maybe?
>> > If I could get an acked-by from you Dan, and a Tested-by: from you
>> > Slava, I'll submit upstream.
>> >
>> > Thanks,
>> > NeilBrown
>> >
>> > From: NeilBrown <neilb@suse.com>
>> > Date: Thu, 24 Dec 2015 09:35:18 +1100
>> > Subject: [PATCH] async_tx: use GFP_NOWAIT rather than GFP_IO
>> >
>> > These async_XX functions are called from md/raid5 in an atomic
>> > section, between get_cpu() and put_cpu(), so they must not sleep.
>> > So use GFP_NOWAIT rather than GFP_IO.
>> >
>> > Dan Williams writes: Longer term async_tx needs to be merged into md
>> > directly as we can allocate this unmap data statically per-stripe
>> > rather than per request.
>> >
>> > Reported-by: Stanislav Samsonov <slava@annapurnalabs.com>
>> > Signed-off-by: NeilBrown <neilb@suse.com>
>>
>> Acked-by: Dan Williams <dan.j.williams@intel.com>
>
> Tested-by: Slava Samsonov <slava@annapurnalabs.com>

Thanks.

I guess this was problem was introduced by
Commit: 7476bd79fc01 ("async_pq: convert to dmaengine_unmap_data")
in 3.13.  Do we think it deserves to go to -stable?

(I just realised that this is really Dan's code more than mine,
 so why am I submitting it ??? But we are here now so it may as well go
 in through the md tree.)

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWicvsAAoJEDnsnt1WYoG57kEQAI+LxlGJB4/wMs/kmTMHqXRQ
xPgNNJmn6gs18E3+YZiD2/0bMXBKN45lsvZIhzno2Yj6StqdFCKq14hKTIQMDDHY
+CQAE2XK/4N9YLbHpMKSzFP7X7xqtsrzg/wh/MOZ0yWn+BRLVULpB9auO42LTmo/
xmOlQ+Mw4Qv7xhT5oMLtM+sl+OC1EIOCCXRHQv+/+5LLtQX2ft8QHD9v4tJ63xnk
c3VhI0ukZeXH6+gkiBuhV3G1HqHbob+dv+799qUoXY63v9Hyq0OAPVeamMT+gdqP
RXtv3l7AzbMaQELX0IJ3erxn6K9q5CMND4nGyeFPY3atQwhCDJ5AaMDRvSOp+JE/
Lz3TJI8tgZj51rgS2FCIbL97X+M5FGCyOTDt5JGZyH0mWyXeG95bwXXlzi+2UyDK
11OZZqdCGzn2ZbT8Nc3cVbHVSGxFu8h/M0aVTga4NSNsp8AjsTshKT3J118sTEg8
qq1d2jbimhEYy1YygfZiArODwKv4GExtThn+09GrqR+EZZJJth04/z+XzIOm9T8C
jQGPCzdTnvVhKIwSoZJQ4H20rWazD5+HbgwN4XloHWfkp4TcqsiAggafRPLakKYu
est1ufQRA1CsNEPfq+2b+ENslWd3MSyFcTjjQrrbJo5A7AtBFN1bIKJIoKv0KyLH
Z/HGUGq8eL+vsLuE/zg7
=XXK2
-----END PGP SIGNATURE-----
--=-=-=--
