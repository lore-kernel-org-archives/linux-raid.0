From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md/bitmap: don't read page from device with Bitmap_sync
Date: Mon, 19 Jun 2017 09:11:23 +1000
Message-ID: <87h8zc51t0.fsf@notabene.neil.brown.name>
References: <20170616091927.12959-1-gqjiang@suse.com> <20170616173613.c2cp6qt2hmoebgct@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170616173613.c2cp6qt2hmoebgct@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16 2017, Shaohua Li wrote:

> On Fri, Jun 16, 2017 at 05:19:27PM +0800, Guoqing Jiang wrote:
>> The device owns Bitmap_sync flag needs recovery
>> to become in sync, and read page from this type
>> device could get stale status.
>>=20
>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>> ---
>> When develop for clustered raid10 feature, if add a
>> disk under grow mode in master node, I could get
>> the "bitmap superblock UUID mismatch" warning due
>> to the page is read from Bitmap_sync device.
>>=20
>>  drivers/md/bitmap.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
>> index bf7419a..bf34cd8 100644
>> --- a/drivers/md/bitmap.c
>> +++ b/drivers/md/bitmap.c
>> @@ -156,7 +156,8 @@ static int read_sb_page(struct mddev *mddev, loff_t =
offset,
>>=20=20
>>  	rdev_for_each(rdev, mddev) {
>>  		if (! test_bit(In_sync, &rdev->flags)
>
> Why In_sync is set for the rdev? I think it shoudn't.

There are several states a device can be in.
If ->raid_disk is < 0, then the device is a spare, and doesn't contain
    and valid data.
Otherwise ->raid_disk >=3D0 and:
   In_sync is clear, which means that blocks before ->recovery_offset
       contain valid data, and blocks after there don't
   In_sync is set, which means ->recovery_offset is irrelevant and
       should be treated as MaxSector
   Bitmap_sync is set, which could apply in either of the above cases,
       and means blocks corresponding to bits that are set in the bitmap
       may not be up to date.

Bitmap_sync is only relevant before a device has been handed to the
personality.  After it has been added, ->recovery_cp ensures that the
blocks that might be wrong are not read until until the bitmap-based
recovery has fixed them up.

Bitmap_sync is only use to stop the device from being given to the
personality if a recovery won't be started because the array is
read-only.

So it is perfectly valid for both In_sync and Bitmap_sync to be set.
If they are, it makes sense to avoid reading bitmap information from the
Bitmap_sync device, as that will be out-of-date.

I'm not quite sure why Guoqing is getting a UUID mismatch ... it
suggests that the new device wasn't initialized properly.  So there
might be another bug.  But I think this is definitely a bug.
=20=20=20=20=20

>
>> -		    || test_bit(Faulty, &rdev->flags))
>> +		    || test_bit(Faulty, &rdev->flags)
>> +		    || test_bit(Bitmap_sync, &rdev->flags))
>
> I didn't see code clears the Bitmap_sync bit after disk is synced, so lik=
ely
> there is bug in this side.

There is no need to clear Bitmap_sync.  It stays set until it becomes
irrelevant.

Thanks,
NeilBrown


>
>>  			continue;
>>=20=20
>>  		target =3D offset + index * (PAGE_SIZE/512);
>> --=20
>> 2.10.0
>>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllHCJ0ACgkQOeye3VZi
gbmbUhAApj9/sCbacufE1fZSm0MYy5j357KwQENLH25NBpIJp7xZFK4anTdBeD6U
kwWwue1w5ZzSzYJTRSX2+fRlL5fuPZ8xenw2iDb42noWK/IGgoeSFRMJE/ijOZMq
FRrN86/y6w+370aJIYNZ8D8sRi6zpr4TZuXmCwvlpvTIhCQ9S4KWhhmGZj1FB8mE
NPSmVnwXOd+MuLSq37nx0jsEgiFnIyo1KGxLypB6YWseiIHuIHrmlU/yTMvs67n6
Y7nnDwI5VVgTTmkrtMHDJQONeubHGYTBtvHkOo/ERE2iqBn9Lzmq0xoCIjOPL6i1
j+MWVPX8xzB4LIoSAVUTyZrjE46LbQxzDpnKLqXVWNlpegytxZhvOu3w+wHry0Gw
ddaX8Kr+/478o3MKotwAKMUwHKg8TfbT8wd3/gEyKoj17uCywBardtZjTb/8PMvm
UesHbUfv/JUD0C17NmdAOKX6L7zdxuDt7XdbZmwV+0kDjkAds5T2T9iE3Piyjguj
mgPocaYyQK7UsH+h4nJ+Kav6uGG9HNNT1EpWXE6EZ+O7y0o8m7VYjnnwtDkc/uVv
TbL8NmxS+ugF5E28x6KnsiLZ2rkWBwTptQWU+eCP/uLtI/HIZFFLXNU65zrJzbNP
PcmtJRR+7fOjCkIg8xr3zwKj5wxbKxMmEAc0KvPu23SHi7hnK4Q=
=C7Qa
-----END PGP SIGNATURE-----
--=-=-=--
