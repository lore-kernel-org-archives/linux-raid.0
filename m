From: "heming.zhao@suse.com" <heming.zhao@suse.com>
Subject: Re: cluster-md mddev->in_sync & mddev->safemode_delay may have bug
Date: Thu, 16 Jul 2020 02:40:01 +0800
Message-ID: <57e70970-814b-3a55-35cc-b1415a301895@suse.com>
References: <a29f8374-cc64-cc87-71cb-507c43aff503@suse.com>
 <91c60c65-11c4-35e7-41d2-77a1febc3249@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <91c60c65-11c4-35e7-41d2-77a1febc3249@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, linux-raid@vger.kernel.org
Cc: neilb@suse.com
List-Id: linux-raid.ids

Hello Guoqing,

Thank you for your kindly reply and review comments. I will resend that pat=
ch later.

Do you know who take care of cluster-md field in this mail list?
I want he/she to shed a little light on me.

On 7/16/20 2:17 AM, Guoqing Jiang wrote:
> On 7/15/20 5:48 AM, heming.zhao@suse.com wrote:
>> Hello List,
>>
>>
>> @Neil=C2=A0 @Guoqing,
>> Would you have time to take a look at this bug?
>=20
> I don't focus on it now, and you need CC me if you want my attention.
>=20
>> This mail replaces previous mail: commit 480523feae581 may introduce a b=
ug.
>> Previous mail has some unclear description, I sort out & resend in this =
mail.
>>
>> This bug was reported from a SUSE customer.
>>
>> In cluster-md env, after below steps, "mdadm -D /dev/md0" shows "State: =
active" all the time.
>> ```
>> # mdadm -S --scan
>> # mdadm --zero-superblock /dev/sd{a,b}
>> # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
>>
>> # mdadm -D /dev/md0
>> /dev/md0:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : 1=
.2
>> =C2=A0=C2=A0=C2=A0=C2=A0 Creation Time : Mon Jul=C2=A0 6 12:02:23 2020
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Raid Level : raid1
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Array Size : 64512 (63.00 MiB=
 66.06 MB)
>> =C2=A0=C2=A0=C2=A0=C2=A0 Used Dev Size : 64512 (63.00 MiB 66.06 MB)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Raid Devices : 2
>> =C2=A0=C2=A0=C2=A0=C2=A0 Total Devices : 2
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Persistence : Superblock is persist=
ent
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0 Intent Bitmap : Internal
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Update Time : Mon Jul=C2=A0 6 12:02=
:24 2020
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 State : active <=3D=3D=3D=3D this line
>> =C2=A0=C2=A0=C2=A0 Active Devices : 2
>> =C2=A0=C2=A0 Working Devices : 2
>> =C2=A0=C2=A0=C2=A0 Failed Devices : 0
>> =C2=A0=C2=A0=C2=A0=C2=A0 Spare Devices : 0
>>
>> Consistency Policy : bitmap
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 Name : lp-clustermd1:0=C2=A0 (local to host lp-clustermd1)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Cluster Name : hacluster
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 UUID : 38ae5052:560c7d36:bb221e15:7437f460
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Event=
s : 18
>>
>> =C2=A0=C2=A0=C2=A0 Number=C2=A0=C2=A0 Major=C2=A0=C2=A0 Minor=C2=A0=C2=
=A0 RaidDevice State
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=C2=A0 =
/dev/sda
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 16=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 active sync=C2=A0=C2=A0 /dev/s=
db
>> ```
>>
>> with commit 480523feae581 (author: Neil Brown), the try_set_sync never t=
rue, so mddev->in_sync always 0.
>>
>> the simplest fix is bypass try_set_sync when array is clustered.
>> ```
>> =C2=A0void md_check_recovery(struct mddev *mddev)
>> =C2=A0{
>> =C2=A0=C2=A0=C2=A0 ... ...
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mddev_is_clustered(mddev)=
) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struc=
t md_rdev *rdev;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* ki=
ck the device if another node issued a
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 * remove disk.
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev_=
for_each(rdev, mddev) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rdev->ra=
id_disk < 0)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_kick_rdev_from_array(rdev);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 try_set_sy=
nc =3D 1;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0 ... ...
>> =C2=A0}
>> ```
>> this fix makes commit 480523feae581 doesn't work when clustered env.
>> I want to know what impact with above fix.
>> Or does there have other solution for this issue?
>>
>>
>> --------
>> And for mddev->safemode_delay issue
>>
>> There is also another bug when array change bitmap from internal to clus=
tered.
>> the /sys/block/mdX/md/safe_mode_delay keep original value after changing=
 bitmap type.
>> in safe_delay_store(), the code forbids setting mddev->safemode_delay wh=
en array is clustered.
>> So in cluster-md env, the expected safemode_delay value should be 0.
>>
>> reproduction steps:
>> ```
>> # mdadm --zero-superblock /dev/sd{b,c,d}
>> # mdadm -C /dev/md0 -b internal -e 1.2 -n 2 -l mirror /dev/sdb /dev/sdc
>> # cat /sys/block/md0/md/safe_mode_delay
>> 0.204
>> # mdadm -G /dev/md0 -b none
>> # mdadm --grow /dev/md0 --bitmap=3Dclustered
>> # cat /sys/block/md0/md/safe_mode_delay
>> 0.204=C2=A0 <=3D=3D doesn't change, should ZERO for cluster-md
>=20
> I saw you have sent a patch, which is good. And I suggest you to improve =
the header
> with your above analysis instead of just have the reproduce steps in head=
er.
>=20
> Thanks,
> Guoqing
>=20
