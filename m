From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH] raid1: reset 'bi_next' before reuse the bio
Date: Thu, 06 Apr 2017 12:03:02 +1000
Message-ID: <87efx6gund.fsf@notabene.neil.brown.name>
References: <dcd33b53-5c6f-3ebc-8c07-04f0c0372796@profitbricks.com> <87shlnizqn.fsf@notabene.neil.brown.name> <465f2653-3afc-3329-dbf4-af13010113b7@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <465f2653-3afc-3329-dbf4-af13010113b7@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>, linux-raid@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05 2017, Michael Wang wrote:

> On 04/05/2017 12:17 AM, NeilBrown wrote:
> [snip]
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 7d67235..0554110 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -1986,11 +1986,13 @@ static int fix_sync_read_error(struct r1bio *r1=
_bio)
>>>  		/* Don't try recovering from here - just fail it
>>>  		 * ... unless it is the last working device of course */
>>>  		md_error(mddev, rdev);
>>> -		if (test_bit(Faulty, &rdev->flags))
>>> +		if (test_bit(Faulty, &rdev->flags)) {
>>>  			/* Don't try to read from here, but make sure
>>>  			 * put_buf does it's thing
>>>  			 */
>>>  			bio->bi_end_io =3D end_sync_write;
>>> +			bio->bi_next =3D NULL;
>>> +		}
>>>  	}
>>>=20=20
>>>  	while(sectors) {
>>=20
>>=20
>> Ah - I see what is happening now.  I was looking at the vanilla 4.4
>> code, which doesn't have the failfast changes.
>
> My bad to forgot mention... yes our md stuff is very much close to the
> upstream.
>
>>=20
>> I don't think your patch is correct though.  We really shouldn't be
>> re-using that bio, and setting bi_next to NULL just hides the bug.  It
>> doesn't fix it.
>> As the rdev is now Faulty, it doesn't make sense for
>> sync_request_write() to submit a write request to it.
>
> Make sense, while still have concerns regarding the design:
>   * in this case since the read_disk already abandoned, is it fine to
>     keep r1_bio->read_disk recording the faulty device index?

I guess we could set it to -1.  I'm not sure that would help at all.


>   * we assign the 'end_sync_write' to the original read bio in this
>     case, but when is this supposed to be called?

It isn't called.  But the value of ->bi_end_io is tests a couple of
times.  Particularly in put_buf(), but also a little further down in
fix_sync_read_errors().=20

>
>>=20
>> Can you confirm that this works please.
>
> Yes, it works.
>
> Tested-by: Michael Wang <yun.wang@profitbricks.com>

Thanks.  I'll add that and submit the patch.

Thanks,
NeilBrown

>
> Regards,
> Michael Wang
>
>>=20
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index d2d8b8a5bd56..219f1e1f1d1d 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2180,6 +2180,8 @@ static void sync_request_write(struct mddev *mddev=
, struct r1bio *r1_bio)
>>  		     (i =3D=3D r1_bio->read_disk ||
>>  		      !test_bit(MD_RECOVERY_SYNC, &mddev->recovery))))
>>  			continue;
>> +		if (test_bit(Faulty, &conf->mirrors[i].rdev->flags))
>> +			continue;
>>=20=20
>>  		bio_set_op_attrs(wbio, REQ_OP_WRITE, 0);
>>  		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags))
>>=20
>>=20
>> Thanks,
>> NeilBrown
>>=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljlodYACgkQOeye3VZi
gbk6Sw//bRD3o6osmo9je8xdDAqYuyI1I707kUtbPOVxHfJ4EG62MsjtZsQ/pR5s
fWYb20sn+Ozd9OLIvY+Kk5GIZCg6NvFVielhG6lyIAF1jtX1DUcfhhWzKE0jyIGM
KATipfbLBMS1drxMrBQQgcvuhlCSRMEmFXK9kYS18RgfC4b6ZX1Qy2anMtsuLYuL
lv48wsvdhjNn7C+0xZtMU+BgV6JD67y5qCbotOC55Lqx/yOzcIgtc7gJyHXWfWwr
kDikViriiAoL4gpeJn1LP28EUIVf3LZ5y76VYDwBgp8LzNQKyXat8oOHW/IgDjoY
QUhu6KXZKYvYrWO9Q6maM9Rc/akyOux7RxUbuIqYvijNb762OhLQeXzzWw0xYg2e
fY+kQFPh36cOy6xatuXHbPLITvtgS+4fgMe7hQ6FmvDyCuAWC3iCGjfmizEv+NA/
Zk8wHPZf4a0x0tYIqfnKMiRdAKCv359MMk9E2pEHopIagQdKbikCJR6IuMCn2rhR
a1ACYmLeaXGZIu636l0trT7M7rSH14iqK8K9cVnyZRw6ZyEfTjIg1NXlIg1aHhKd
vuZbHy7bq1wR0RePxhjYuFvlDIrVwOFb9/jyOhYeIfndhSyxTHQLFAG7ltgjiRPZ
ope88uSNFia+LuHrHjr155GgfppS/WeyNtJPryaJW6WbWn1SlD0=
=/GzA
-----END PGP SIGNATURE-----
--=-=-=--
