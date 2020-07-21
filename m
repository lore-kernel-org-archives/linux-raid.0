From: "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: Re: [PATCH v5 1/2] md-cluster: fix safemode_delay value when
 converting to clustered bitmap
Date: Tue, 21 Jul 2020 16:58:35 +0800
Message-ID: <f1b63409-5837-cfcd-2a6e-05d9cb753d3f@suse.com>
References: <1595268533-7040-1-git-send-email-heming.zhao@suse.com>
 <1595268533-7040-2-git-send-email-heming.zhao@suse.com>
 <8f122dea-2a4a-4523-653f-fe6fc2842653@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8f122dea-2a4a-4523-653f-fe6fc2842653@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.com, song@kernel.org
List-Id: linux-raid.ids



On 7/21/20 4:35 PM, Guoqing Jiang wrote:
>=20
>=20
> On 7/20/20 8:08 PM, Zhao Heming wrote:
>> When array convert to clustered bitmap, the safe_mode_delay doesn't
>> clean and vice versa. the /sys/block/mdX/md/safe_mode_delay keep origina=
l
>> value after changing bitmap type. In safe_delay_store(), the code forbid=
s
>> setting mddev->safemode_delay when array is clustered. So in cluster-md
>> env, the expected safemode_delay value should be 0.
>>
>> Reproducible steps:
>> ```
>> node1 # mdadm --zero-superblock /dev/sd{b,c,d}
>> node1 # mdadm -C /dev/md0 -b internal -e 1.2 -n 2 -l mirror /dev/sdb /de=
v/sdc
>> node1 # cat /sys/block/md0/md/safe_mode_delay
>> 0.204
>> node1 # mdadm -G /dev/md0 -b none
>> node1 # mdadm --grow /dev/md0 --bitmap=3Dclustered
>> node1 # cat /sys/block/md0/md/safe_mode_delay
>> 0.204=C2=A0 <=3D=3D doesn't change, should ZERO for cluster-md
>>
>> node1 # mdadm --zero-superblock /dev/sd{b,c,d}
>> node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdb /d=
ev/sdc
>> node1 # cat /sys/block/md0/md/safe_mode_delay
>> 0.000
>> node1 # mdadm -G /dev/md0 -b none
>> node1 # cat /sys/block/md0/md/safe_mode_delay
>> 0.000=C2=A0 <=3D=3D doesn't change, should default value
>> ```
>>
>> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
>> ---
>> =C2=A0 drivers/md/md.c | 11 +++++++++--
>> =C2=A0 1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index f567f536b529..1bde3df3fa18 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -101,6 +101,8 @@ static void mddev_detach(struct mddev *mddev);
>> =C2=A0=C2=A0 * count by 2 for every hour elapsed between read errors.
>> =C2=A0=C2=A0 */
>> =C2=A0 #define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20
>> +/* Default safemode delay: 200 msec */
>> +#define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
>> =C2=A0 /*
>> =C2=A0=C2=A0 * Current RAID-1,4,5 parallel reconstruction 'guaranteed sp=
eed limit'
>> =C2=A0=C2=A0 * is 1000 KB/sec, so the extra system load does not show up=
 that much.
>> @@ -5982,7 +5984,7 @@ int md_run(struct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mddev_is_clustered(mddev))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->safemode_d=
elay =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->safemode_delay =3D (2=
00 * HZ)/1000 +1; /* 200 msec delay */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->safemode_delay =3D DE=
FAULT_SAFEMODE_DELAY;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->in_sync =3D 1;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 smp_wmb();
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spin_lock(&mddev->lock);
>> @@ -7361,6 +7363,7 @@ static int update_array_info(struct mddev *mddev, =
mdu_array_info_t *info)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->bitmap_info.nodes =3D 0;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_cluster_ops->leave(mddev);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 mddev->safemode_delay =3D DEFAULT_SAFEMODE_DELAY;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 }
>=20
> Not about the patch itself, just confuse about the meaning of safemode_de=
lay.
> As safemode_delay represents 200 ms delay, but md_write_end has this.
>=20
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 /* The roundup() ensures this only performs locking once
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 * every ->safemode_delay *jiffies*
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 */
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 mod_timer(&mddev->safemode_timer,
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 roundup(jiffies, mddev->safemode_delay) +
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 mddev->safemode_delay);
>=20
> And the second argument in mod_timer() means "new timeout in jiffies",
> does the above need to convert from ms to jiffies? Am I miss something?
>=20
> Thanks,
> Guoqing
>=20

The safemode_delay stores jiffies not msec. it converts to ms only in safe_=
delay_{store|show}.
please see default value:
#define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
in safe_delay_store, user space input will multiple 10^3, which will conver=
t from second to msec.
then  (*HZ/1000) to jiffies.
