From: NeilBrown <neilb@suse.com>
Subject: Re: [md PATCH 10/14] md/raid1: stop using bi_phys_segment
Date: Tue, 21 Feb 2017 11:05:37 +1100
Message-ID: <87bmtws90u.fsf@notabene.neil.brown.name>
References: <148721992248.7521.17160361058957519076.stgit@noble> <148721994272.7521.4656357457037580183.stgit@noble> <CACVXFVMZqivgG39HBAjPKE+CJ3=nXZ3fD0XfujeUbe+_3J9HLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACVXFVMZqivgG39HBAjPKE+CJ3=nXZ3fD0XfujeUbe+_3J9HLg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Feb 20 2017, Ming Lei wrote:

> On Thu, Feb 16, 2017 at 12:39 PM, NeilBrown <neilb@suse.com> wrote:
>>
>> +static void inc_pending(struct r1conf *conf, sector_t start_next_window,
>> +                       sector_t bi_sector)
>> +{
>> +       /* The current request requires multiple r1_bio, so
>> +        * we need to increment the pending count, and the corresponding
>> +        * window count.
>> +        */
>> +       spin_lock(&conf->resync_lock);
>> +       conf->nr_pending++;
>
> Just be curious, in current code 'nr_pending' is increased in wait_barrier(),
> and looks this patch introduces inc_pending() to do that on each r10_bio, but
> not see any change in wait_barrier(), so that means there might be issue in
> current implementation about operating on this counter?

Did you read the more detailed description in the previous raid10.c
patch?
This patch follows the same logic as that patch.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlirhFEACgkQOeye3VZi
gbktmg/7BbQnd/HaqRjoFrJ2jYa0htfUsEL6WcwvkWsf4nUNmUef319ejIPnW2cO
wYU7Yl1gZX5H3qTv/KQ+IhaHolJdMEsbhqBL3RExcAborYfOteCi0ZFzfRhwt9GF
9qdp8PLVwYiLkIYDsgRS8TkE7v2+whFhVciOqCmmxEP88LEcSrWbkEDiuE5xHZAY
PrPsgR3/tcCzh39uSGJC6QcWPP1uoM4FjNDdEXVwRynNWVJgw0SCrFpeDDCtq06F
rK+r46gesUBAUFgA0XzmkLn+9km72IqRNmTE0hB+hPvlf78beLoSrRZh0UQdwS9e
4Atim/ssjjXt0LFIkBmZmIy3cP2ZUQWglE5skk91eEcXvmN/ecM5WY+4pRyn8E4O
DR9dAhluXnuHWI4ETekb7HTubI8rniKZvlRQ49XbcrttGE543fiY70dIPHZYaJbE
vuqN8mttDLZq3bsTamhDr6BDSOJPsNLn1g1UafMzQMly8XbXdVfcFFNQxROkGf3J
d0slzvSZqU9tgA3VTspfptTnAxGSvVJFcv0mzVaec7gwCTJTDMtwM5S7r1j7/s8a
9AcABeOv1b6Gd2tJ523L+Ff2JF88cy57W3whHaPxcSFGjEHqGdPYFeI5yS0djmGh
cCBnGa5EXsamk0FWCwH8zGHW1nGefxCpRasihZtCnVz//Zi4liI=
=yFwk
-----END PGP SIGNATURE-----
--=-=-=--
