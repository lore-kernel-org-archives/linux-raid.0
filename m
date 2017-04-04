From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH] blk: reset 'bi_next' when bio is done inside request
Date: Wed, 05 Apr 2017 07:52:13 +1000
Message-ID: <87y3vfj0xe.fsf@notabene.neil.brown.name>
References: <9505ff12-7307-7dec-76b5-2a233a592634@profitbricks.com> <877f31kwti.fsf@notabene.neil.brown.name> <9be3ca00-d802-bf64-bcdc-1e76608147f0@profitbricks.com> <871st8jyya.fsf@notabene.neil.brown.name> <2a6f8c30-616c-d6fe-1c3f-ab687c145cd7@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <2a6f8c30-616c-d6fe-1c3f-ab687c145cd7@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04 2017, Michael Wang wrote:

> On 04/04/2017 11:37 AM, NeilBrown wrote:
>> On Tue, Apr 04 2017, Michael Wang wrote:
> [snip]
>>>>
>>>> If sync_request_write() is using a bio that has already been used, it
>>>> should call bio_reset() and fill in the details again.
>>>> However I don't see how that would happen.
>>>> Can you give specific details on the situation that triggers the bug?
>>>
>>> We have storage side mapping lv through scst to server, on server side
>>> we assemble them into multipath device, and then assemble these dm into
>>> two raid1.
>>>
>>> The test is firstly do mkfs.ext4 on raid1 then start fio on it, on stor=
age
>>> side we unmap all the lv (could during mkfs or fio), then on server side
>>> we hit the BUG (reproducible).
>>=20
>> So I assume the initial resync is still happening at this point?
>> And you unmap *all* the lv's so you expect IO to fail?
>> I can see that the code would behave strangely if you have a
>> bad-block-list configured (which is the default).
>> Do you have a bbl?  If you create the array without the bbl, does it
>> still crash?
>
> The resync is at least happen concurrently in this case, we try
> to simulate the case that all the connections dropped, the IO do
> failed, also bunch of kernel log like:
>
> md: super_written gets error=3D-5
> blk_update_request: I/O error, dev dm-3, sector 64184
> md/raid1:md1: dm-2: unrecoverable I/O read error for block 46848
>
> we expect that to happen, but server should not crash on BUG.
>
> And we haven't done any thing special regarding bbl, the bad_blocks
> in sysfs are all empty.
>
>>=20
>>>
>>> The path of bio was confirmed by add tracing, it is reused in sync_requ=
est_write()
>>> with 'bi_next' once chained inside blk_attempt_plug_merge().
>>=20
>> I still don't see why it is re-used.
>> I assume you didn't explicitly ask for a check/repair (i.e. didn't write
>> to .../md/sync_action at all?).  In that case MD_RECOVERY_REQUESTED is
>> not set.
>
> Just unmap lv on storage side, no operation on server side.
>
>> So sync_request() sends only one bio to generic_make_request():
>>    r1_bio->bios[r1_bio->read_disk];
>>=20
>> then sync_request_write() *doesn't* send that bio again, but does send
>> all the others.
>>=20
>> So where does it reuse a bio?
>
> If that's the design then it would be strange... the log do showing the p=
ath
> of that bio go through sync_request(), will do more investigation.
>
>>=20
>>>
>>> We also tried to reset the bi_next inside sync_request_write() before
>>> generic_make_request() which also works.
>>>
>>> The testing was done with 4.4, but we found upstream also left bi_next
>>> chained after done in request, thus we post this RFC.
>>>
>>> Regarding raid1, we haven't found the place on path where the bio was
>>> reset... where does it supposed to be?
>>=20
>> I'm not sure what you mean.
>> We only reset bios when they are being reused.
>> One place is in process_checks() where bio_reset() is called before
>> filling in all the details.
>>=20
>>=20
>> Maybe, in sync_request_write(), before
>>=20
>> 	wbio->bi_rw =3D WRITE;
>>=20
>> add something like
>>   if (wbio->bi_next)
>>      printk("bi_next!=3D NULL i=3D%d read_disk=3D%d bi_end_io=3D%pf\n",
>>           i, r1_bio->read_disk, wbio->bi_end_io);
>>=20
>> that might help narrow down what is happening.
>
> Just triggered again in 4.4, dmesg like:
>
> [  399.240230] md: super_written gets error=3D-5
> [  399.240286] md: super_written gets error=3D-5
> [  399.240286] md/raid1:md0: dm-0: unrecoverable I/O read error for block=
 204160
> [  399.240300] md/raid1:md0: dm-0: unrecoverable I/O read error for block=
 204160
> [  399.240312] md/raid1:md0: dm-0: unrecoverable I/O read error for block=
 204160
> [  399.240323] md/raid1:md0: dm-0: unrecoverable I/O read error for block=
 204160
> [  399.240334] md/raid1:md0: dm-0: unrecoverable I/O read error for block=
 204160
> [  399.240341] md/raid1:md0: dm-0: unrecoverable I/O read error for block=
 204160
> [  399.240349] md/raid1:md0: dm-0: unrecoverable I/O read error for block=
 204160
> [  399.240352] bi_next!=3D NULL i=3D0 read_disk=3D0 bi_end_io=3Dend_sync_=
write [raid1]

It is very peculiar for r1_bio->bios[r1_bio->read_disk].bi_end_io to be
end_sync_write.
I can only see this happening when sync_request_write() assigns that,
and this printk is before there.
That seems to suggest that sync_request_write() is being performed on
the same r1_bio twice, which is also very peculiar.

I might have to try to reproduce this myself and see what is happening.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljkFY0ACgkQOeye3VZi
gbnReRAArlGI2IRgCMVsEkyICZgXzGBRcs7vR2Ii5UjD/QweLaDv5qF1ZK8OVMt7
ihHC94b5s0GOjaOXQ8TLnmCtL/1/mTHkdxnTrwrLKs0ooUB6+ZpvvjRN3Dq84kI4
nqJ3REhK1q5uBXgsg6AuohaUzRnbXWJDoDTTVrT59rqdhcgp+F2eaACMxL7KV2qr
bCkdPYokocCZljC/LoUrEDsAsiVn2IR9H/Bw2nBPxLAfElL1OTOdHClVs9wrtHFb
xgeyRvKH1mxFjgGeJPgqN1kb4s3xjyHvfM+pzYgMAkPqJiEtA/ytrr1ohBek3rUv
eLz569+GuR0I55S1DZHTC4E/61m/oMlaWRE2K8oU9zELMfKd3FmeIoQ16md8Xj+E
OyL0SwcMGvGoCw9zAnWvlWRtW60wmNP5e7DPxckEeH/4+NyMq2V0b6rI+3ZKMEbf
5z15eFZi2bsUGHmkvDTSJsXGZ2Ap4Ciwnpc4ffpRCWg/VtIvAU9LGoLRAtRoM/Iu
whfUpGzLNeCdXW96mEO3MqGbe/l0P1+6yjNxMLc1DgYXhEDtorbDWKfiD4/o4xGe
aVBA4Hp9mENg85FtwJwAcmQnJr+D1s1LujWQDD5j8l5xDb3VWX7FAIq7/+tpJuM7
8TP6CEXF97Hu4vs4z4mzRM08j52Fbpd4R3c7tWAkO1wfwY09+OU=
=JDi+
-----END PGP SIGNATURE-----
--=-=-=--
