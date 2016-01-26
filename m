From: NeilBrown <neilb@suse.com>
Subject: Re: md127 auto created when use "-B" to build a legacy array without superblocks
Date: Wed, 27 Jan 2016 09:03:45 +1100
Message-ID: <87y4bc2e2m.fsf@notabene.neil.brown.name>
References: <597548646.22274436.1441628869039.JavaMail.zimbra@redhat.com> <87k2r5iu0t.fsf@notabene.neil.brown.name> <56A72D21.20707@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A72D21.20707@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: yizhan <yizhan@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 26 2016, yizhan wrote:

> On 10/02/2015 03:55 PM, Neil Brown wrote:
>> Yi Zhang <yizhan@redhat.com> writes:
>>
>>> Hi Neil
>>>
>>> When testing 00raid1, found the md127 auto created when use "-B" to bui=
ld a legacy array without superblocks, is it reasonable?
>> This happens because udev notices a new device has appeared, looks
>> inside it, sees that it could be part of an md array, and so runs
>> "mdadm --incremental" on it.
> Hi Neil
> I tried the mdadm --incremental, but it doesn't work, below is the=20
> operation.
> # mdadm -D /dev/md0
> /dev/md0:
>          Version :
>    Creation Time : Tue Jan 26 03:16:17 2016
>       Raid Level : raid1
>       Array Size : 2097152 (2.00 GiB 2.15 GB)
>    Used Dev Size : 2097152 (2.00 GiB 2.15 GB)
>     Raid Devices : 2
>    Total Devices : 2
>
>            State : clean
>   Active Devices : 2
> Working Devices : 2
>   Failed Devices : 0
>    Spare Devices : 0
>
>      Number   Major   Minor   RaidDevice State
>         0       7        0        0      active sync   /dev/loop0
>         1       7        1        1      active sync   /dev/loop1
> # mdadm -D /dev/md127
> /dev/md127:
>          Version : 1.2
>       Raid Level : raid0
>    Total Devices : 1
>      Persistence : Superblock is persistent
>
>            State : inactive
>
>             Name : 0
>             UUID : 13ada118:129135ff:686de7b7:4cb71d6d
>           Events : 17
>
>      Number   Major   Minor   RaidDevice
>
>         -       9        0        -        /dev/md0
> # mdadm -I /dev/md127
> mdadm: /dev/md127 is not part of an md array.
> # mdadm -I /dev/md0
> mdadm: cannot reopen /dev/md0: Device or resource busy.
>
> After I stopped md127, the md0 can be used again.

If, after stopping md127, you try

  mdadm -I /dev/md0

again it will start /dev/md127 again.  This is what udev does which
causes md127 to appear in the first place.

NeilBrown


>
> Thanks
> Yi
>> Sometimes we want udev to do that.  Sometimes we don't.
>> There is no easy way for udev to know what we want.
>>
>> NeilBrown
>>
>>
>>> pls check below detailed info:
>>>
>>> + mdadm -CR /dev/md0 --level=3Draid1 -n3 /dev/loop0 /dev/loop1 /dev/loo=
p2
>>> mdadm: /dev/loop0 appears to contain an ext2fs file system
>>>         size=3D58368K  mtime=3DThu Jan  1 08:00:00 1970
>>> mdadm: Note: this array has metadata at the start and
>>>      may not be suitable as a boot device.  If you plan to
>>>      store '/boot' on this device please ensure that
>>>      your boot-loader understands md/v1.x metadata, or use
>>>      --metadata=3D0.90
>>> mdadm: /dev/loop1 appears to contain an ext2fs file system
>>>         size=3D38912K  mtime=3DThu Jan  1 08:00:00 1970
>>> mdadm: Defaulting to version 1.2 metadata
>>> mdadm: array /dev/md0 started.
>>> + mdadm --wait /dev/md0
>>> + cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4] [raid1]
>>> md0 : active raid1 loop2[2] loop1[1] loop0[0]
>>>        19968 blocks super 1.2 [3/3] [UUU]
>>>=20=20=20=20=20=20=20=20
>>> unused devices: <none>
>>> + mdadm -S /dev/md0
>>> mdadm: stopped /dev/md0
>>> + mdadm -B /dev/md0 -l raid1 -n2 /dev/loop0 /dev/loop1
>>> mdadm: array /dev/md0 built and started.
>>> + sleep 2
>>> + cat /proc/mdstat
>>> Personalities : [raid6] [raid5] [raid4] [raid1]
>>> md127 : inactive md0[0](S)
>>>        19968 blocks super 1.2
>>>=20=20=20=20=20=20=20=20=20
>>> md0 : active raid1 loop1[1] loop0[0]
>>>        20000 blocks super non-persistent [2/2] [UU]
>>>=20=20=20=20=20=20=20=20
>>> unused devices: <none>
>>> [root@dhcp-12-171 bug]# uname -r
>>> 4.2.0
>>> [root@dhcp-12-171 bug]# mdadm -D /dev/md0
>>> /dev/md0:
>>>          Version :
>>>    Creation Time : Mon Sep  7 20:21:20 2015
>>>       Raid Level : raid1
>>>       Array Size : 20000 (19.53 MiB 20.48 MB)
>>>    Used Dev Size : 20000 (19.53 MiB 20.48 MB)
>>>     Raid Devices : 2
>>>    Total Devices : 2
>>>
>>>            State : clean
>>>   Active Devices : 2
>>> Working Devices : 2
>>>   Failed Devices : 0
>>>    Spare Devices : 0
>>>
>>>      Number   Major   Minor   RaidDevice State
>>>         0       7        0        0      active sync   /dev/loop0
>>>         1       7        1        1      active sync   /dev/loop1
>>> [root@dhcp-12-171 bug]# mdadm -D /dev/md127
>>> /dev/md127:
>>>          Version : 1.2
>>>       Raid Level : raid0
>>>    Total Devices : 1
>>>      Persistence : Superblock is persistent
>>>
>>>            State : inactive
>>>
>>>             Name : dhcp-12-171.nay.redhat.com:0  (local to host dhcp-12=
-171.nay.redhat.com)
>>>             UUID : 40ace956:a9dd0793:f4984d2b:8431b92b
>>>           Events : 17
>>>
>>>      Number   Major   Minor   RaidDevice
>>>
>>>         -       9        0        -        /dev/md0
>>>
>>> Best Regards,
>>>    Yi Zhang

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWp+1BAAoJEDnsnt1WYoG5194P/1rW0BPkEPZmm/FDFtGAVvWW
8QfJJYX/tShK7HkH8imur9yQx73h5t83xLnWTUmF/VW9gMr/fJgvvEDHGOK4Ie16
Y9szayDKuYWsYVEX5bBBfyV1FGcy/z3nofGeekU97gSiFjLv8CCV4nCXqq2nwv6n
HAlirY3ngF8/nbrY8Cw+TzLcqJ8x5+aGYX9Jh+RpgYDK11BwlUej62HSMw8SYCLb
ZTsk+Kwh7ptyAa258wmm85cSZw1rtHwXUNdco2pSbppk6o+olstzWL/49jN2hHYB
psalcZY8qi4eH5ff0dgiRKXzd8Ci3yAdWN4Hc75ST9dFF5HhWUueMOxT7qXC5Edm
biHsaWv2ZJK4V/cx29O2s5gXgK6kS+kBrhS7P7sktQf9qdwuFqM5NcU5F1Bystaz
Ti0NSIA4MuAAKBL26TH+TTGCAhL7waHkMTFq4HZ6ReOCxTQhHA0IoyhbwnZI8zVO
m5Z95gWZX0WSLpbJyjOuUtEE/4PIz7bQCTV8yUoB0Z5YtUpHapLK1H0IYxosbqzY
b4TsbIg0/H0plpgOdi+ccafuitg38rYLKjBy6Jx89WsQkPKeoIT297s4WzfdV6or
2spy67V6M/+ZcP+xoKRAaqRuS6Tgs9S0/SoMY0tTkHnZrz9+wkhwY/BYUNZdOwQI
Tw2IJy5ygOpdokhOMovD
=iVNS
-----END PGP SIGNATURE-----
--=-=-=--
