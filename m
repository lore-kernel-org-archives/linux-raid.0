From: NeilBrown <neilb@suse.com>
Subject: Re: internal write-intent bitmap is horribly slow with RAID10 over 20 drives
Date: Wed, 07 Jun 2017 08:02:59 +1000
Message-ID: <87fufcdbak.fsf@notabene.neil.brown.name>
References: <CAGqmV7qRh+_BXAr-qf6vUkiZyzi69E8CiX_vA92tZV2LfDxq_A@mail.gmail.com> <87tw3tdbs1.fsf@notabene.neil.brown.name> <CAGqmV7qVq8nBmop5h7OZKr9ZjCjGLcoPqMF5xa4d2iHzf2uQdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qVq8nBmop5h7OZKr9ZjCjGLcoPqMF5xa4d2iHzf2uQdw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 06 2017, CoolCold wrote:

> Hello!
> Neil, thanks for reply, further inline
>
> On Tue, Jun 6, 2017 at 10:40 AM, NeilBrown <neilb@suse.com> wrote:
>> On Mon, Jun 05 2017, CoolCold wrote:
>>
>>> Hello!
>>> Keep testing the new box and while having not the best sync speed,
>>> it's not the worst thing I found.
>>>
>>> Doing FIO testing, for RAID10 over 20 10k RPM drives, I have very bad
>>> performance, like _45_ iops only.
>>
>> ...
>>>
>>>
>>> Output from fio with internal write-intent bitmap:
>>> Jobs: 1 (f=3D1): [w(1)] [28.3% done] [0KB/183KB/0KB /s] [0/45/0 iops]
>>> [eta 07m:11s]
>>>
>>> array definition:
>>> [root@spare-a17484327407661 rovchinnikov]# cat /proc/mdstat
>>> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
>>> md1 : active raid10 sdx[19] sdw[18] sdv[17] sdu[16] sdt[15] sds[14]
>>> sdr[13] sdq[12] sdp[11] sdo[10] sdn[9] sdm[8] sdl[7] sdk[6] sdj[5]
>>> sdi[4] sdh[3] sdg[2] sdf[1] sde[0]
>>>       17580330880 blocks super 1.2 64K chunks 2 near-copies [20/20]
>>> [UUUUUUUUUUUUUUUUUUUU]
>>>       bitmap: 0/66 pages [0KB], 131072KB chunk
>>>
>>> Setting journal to be
>>> 1) on SSD (separate drives), shows
>>> Jobs: 1 (f=3D1): [w(1)] [5.0% done] [0KB/18783KB/0KB /s] [0/4695/0 iops]
>>> [eta 09m:31s]
>>> 2) to 'none' (disabling) shows
>>> Jobs: 1 (f=3D1): [w(1)] [14.0% done] [0KB/18504KB/0KB /s] [0/4626/0
>>> iops] [eta 08m:36s]
>>
>> These numbers suggest that the write intent bitmap causes a 100-fold slow
>> down.
>> i.e. 45 iops instead of 4500 iops (roughly).
>>
>> That is certainly more than I would expect, so maybe there is a bug.
> I suppose noone is using raid10 over more than 4 drives then, i can't
> believe i'm the one who hit this problem.

We have customers who use RAID10 will many more than 4 drives, but I
haven't had reports like this.  Presumably whatever problem is affecting
you is not affecting them.  We cannot know until we drill down to
understand the problem.

>
>>
>> Large RAID10 is a worst-base for bitmap updates as the bitmap is written
>> to all devices instead of just those devices that contain the data which
>> the bit corresponds to.  So every bitmap update goes to 10 device.
>>
>> Your bitmap chunk size of 128M is nice and large, but making it larger
>> might help - maybe 1GB.
> Tried that already, wasn't any much difference, but will gather more stat=
istics.
>
>>
>> Still 100-fold ... that's a lot..
>>
>> A potentially useful exercise would be to run a series of tests,
>> changing the number of devices in the array from 2 to 10, changing the
>> RAID chunk size from 64K to 64M, and changing the bitmap chunk size from
>> 64M to 4G.
> Changing chunk size to up to 64M just to gather statistics or you
> suppose it may be some practical usage for this?

I don't have any particular reason to expect this to have an effect.
But it is easy to change, and changing it might show provide some hints.
So probably "just to gather statistics".

NeilBrown


>> In each configuration, run the same test and record the iops.
>> (You don't need to wait for a resync each time, just use
>> --assume-clean).
> This helps, thanks
>> Then graph all this data (or just provide the table and I'll graph it).
>> That might provide an insight into where to start looking for the
>> slowdown.
>>
>> NeilBrown
>
>
>
> --=20
> Best regards,
> [COOLCOLD-RIPN]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlk3JpQACgkQOeye3VZi
gblk7A/9Hc1NHoSn0k3He+MQdvZ0psfAeLJo9aplfy6NBMLoedvXIORuazI4AkEE
S6vw96WI+Brqgc+cePcIgJAKVCyM8CVfhFOoRlc2orrRa9HLIDuLCfR9lvByg9Gm
hoygc1UG+J3Pb/5MfG/OD0gKP8bJF6OztwzMSYHTSMBXL9hHBNA/V9LUWhDtrjUn
0LMuywddkmcCnn20FuV799DlMXgVpbs9f4Y6ySeLH1tCRAqZqIdheuN08WfXlna9
JB3L3YrrbFCjrpNb4o5v4y96XetaGc2e5SbRh2sYRMmp8GBMUSmh7ouwuSFuIOCr
vO3s4PnGvxpp1ZDYuTe3QUWpqpSsDQ+LRGJmNnKZazHHJ4qq3h3SPMqkVPfHU7dD
Xkzx3l3UFQw30l8l1yr5pi0SZkPChGBvUe77PDSrDT8N76UBN0PGVtuCENS2KMRs
jxCzD+eQZBh0kkvCJy3KQZV6Jr724Nox1uAnDsI5MSOkxrxYl094HWXrH2CIf7Mu
D40mmf0f6F4r8Iz8wV3qI42i9afF54XmEdq1wHIF7ZwpTSRzSxFjheV7yXZSXeB1
9oq/nqxFbutbuPNd1CVyqOqsknczQTDfvv+vkDC74CRqVJfbMVOEQqGlIQhKD73m
mVtVw5oEnK4dW9cNzU8RE5F3UAOHKuYBa9QV2SboBt4OoJlnWyI=
=voH5
-----END PGP SIGNATURE-----
--=-=-=--
