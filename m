From: NeilBrown <neilb@suse.com>
Subject: Re: mismatch_cnt > 0 during initial sync?
Date: Mon, 19 Jun 2017 07:34:49 +1000
Message-ID: <87shix3rpi.fsf@notabene.neil.brown.name>
References: <9A8A3C34-EED0-42FF-B631-7AD1D6EAF9A2@stanford.edu> <D974501A-3A8C-438B-A043-8E44DE6D18C7@stanford.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D974501A-3A8C-438B-A043-8E44DE6D18C7@stanford.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Stephane Thiell <sthiell@stanford.edu>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 25 2017, Stephane Thiell wrote:

> I just did some tests and this seems normal if one of the raid disk previ=
ously has some non-zero data.  Perhaps there should be a note about that in=
 md(4) or elsewhere? (sorry if I missed it)

From=20the perspective of md, the initial sync is no different from any
other sync.  It will count the number of mismatches that it finds and
fixes.

Feel free to post a patch for md.4 or elsewhere to clarify this.

Thanks,
NeilBrown


>
> Thanks,
>
> Stephan
>
>> On Apr 24, 2017, at 3:01 PM, Stephane Thiell <sthiell@stanford.edu> wrot=
e:
>>=20
>>=20
>> Hi all,
>>=20
>> Is it normal to get any mismatch_cnt > 0 during the initial sync? I just=
 created a few new new raid6 volumes, and one of them is showing an increas=
ing number of mismatch_cnt during its initial resync. Nothing is visible in=
 the console nor after a smart short test (I also started a long test just =
in case).
>>=20
>>=20
>> $ mdadm --detail /dev/md7
>> /dev/md7:
>>        Version : 1.2
>>  Creation Time : Mon Apr 24 10:07:18 2017
>>     Raid Level : raid6
>>     Array Size : 62511163904 (59615.29 GiB 64011.43 GB)
>>  Used Dev Size : 7813895488 (7451.91 GiB 8001.43 GB)
>>   Raid Devices : 10
>>  Total Devices : 10
>>    Persistence : Superblock is persistent
>>=20
>>  Intent Bitmap : Internal
>>=20
>>    Update Time : Mon Apr 24 14:52:12 2017
>>          State : clean, resyncing=20
>> Active Devices : 10
>> Working Devices : 10
>> Failed Devices : 0
>>  Spare Devices : 0
>>=20
>>         Layout : left-symmetric
>>     Chunk Size : 64K
>>=20
>>  Resync Status : 24% complete
>>=20
>>           Name : oak-io1-s2:7  (local to host oak-io1-s2)
>>           UUID : 6ece9d71:a97f9497:4612ed73:44dfdc0a
>>         Events : 3308
>>=20
>>    Number   Major   Minor   RaidDevice State
>>       0     253       62        0      active sync   /dev/dm-62
>>       1     253       63        1      active sync   /dev/dm-63
>>       2     253       72        2      active sync   /dev/dm-72
>>       3     253       75        3      active sync   /dev/dm-75
>>       4     253       89        4      active sync   /dev/dm-89
>>       5     253       87        5      active sync   /dev/dm-87
>>       6     253      119        6      active sync   /dev/dm-119
>>       7     253       97        7      active sync   /dev/dm-97
>>       8     253      103        8      active sync   /dev/dm-103
>>       9     253      107        9      active sync   /dev/dm-107
>>=20
>> $ cat /sys/block/md7/md/sync_completed
>> 3795284824 / 15627790976
>>=20
>> $ cat /sys/block/md7/md/mismatch_cnt=20
>> 3424
>>=20
>> versions:
>>  mdadm-3.4-14.el7_3.1.x86_64
>>  CentOS7 (3.10.0-514.10.2.el7_lustre.x86_64)
>>=20
>> Thanks!
>>=20
>> Stephan
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllG8fsACgkQOeye3VZi
gbms9Q//TwRf/3BsnunO6w2JumMIy05buR8d1Lcw4OUDScC+7Ar+FQloXTj8gHma
wiKCd1jkJNeXlXfa7zdeK8iYtw9us4fg5xpjBJ1KUSd+5eIORDnaf5jAl/86vMh/
KScmL3YvMkjsOq71+LVS9DayXvB2Bjro8ZM2SCO+s6Zd7IcYH2GSfUfsa4LCC2St
B6Svsx8DESaK3zs2/LeXy4oi5Skior3AXjf/+lIAZbGQ8tkp7SaXKwL9W4vVOhoF
lQ3zllyjCu43tPhabUHIA+GT+pIhUSCwFFCvRDLHPniIXsnLfYEw9/rET/xENBsp
7aj6ApI2Y6g8uf9eLIPa4Rp7jcyDu+9O8tsuwWsFaykptBi8LzfZKQF1y/XqO0U1
fQESjFmjc4Rqx5+ZJVK2uYH+gGariij+4mHu84pfpnggUvBKVz58ON1gnfROe4oM
d0sZVQA93gPN3eysR+dPfnONInsYPgqNyWStoihFsC5bV3liMglJaf/qcfRi9enG
f5K+WRO7oxBdOqecDdQV+CrugLnuOxfR6ZnOUfzUcsAuzi8JcgWa5LpN+D4eTEQb
ZNac2LwXuAMM6bekAPoMRBaEHQutl0lzZBo+VU6LO4IrI07HukEv5SAqtB3/Yo41
FBf7moX4RZvVynTfaNTK8Rhh1fKb+ZB5B/x9Nr+g4JIYGbaRHLw=
=6UH6
-----END PGP SIGNATURE-----
--=-=-=--
