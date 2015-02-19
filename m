From: Eric Mei <meijia@gmail.com>
Subject: Re: [PATCH] [md] raid5: check faulty flag for array status during
 recovery.
Date: Thu, 19 Feb 2015 15:49:32 -0700
Message-ID: <54E6687C.6020408@gmail.com>
References: <94BC57C5-6223-435B-96FD-7DA2F6B4E561@gmail.com> <20150220085147.03bb2247@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150220085147.03bb2247@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, eric.mei@seagate.com
List-Id: linux-raid.ids

Hi Neil, You are absolutely right we need RCU lock for this. Thank you=20
so much!

Eric

On 2015-02-19 2:51 PM, NeilBrown wrote:
> On Tue, 6 Jan 2015 15:24:24 -0700 Eric Mei <meijia@gmail.com> wrote:
>
>> Hi Neil,
>>
>> In a MDRAID derived work we found and fixed a data corruption bug. W=
e think this also affect vanilla MDRAID, but we didn=E2=80=99t directly=
 prove that by constructing a test to show the corruption. Following is=
 the theoretical analysis, please kindly review and see if I missed som=
ething.
>>
>> To rebuild a stripe, MD checks whether array will be optimal after r=
ebuild complete, if that=E2=80=99s true, we=E2=80=99ll mark the WIB bit=
 to be cleared, the purpose is to enable =E2=80=9Cincremental rebuild=E2=
=80=9D. The code section is like this:
>>
>> 	/* Need to check if array will still be degraded after recovery/res=
ync
>> 	 * We don't need to check the 'failed' flag as when that gets set,
>> 	 * recovery aborts.
>> 	 */
>> 	for (i =3D 0; i < conf->raid_disks; i++)
>> 		if (conf->disks[i].rdev =3D=3D NULL)
>> 			still_degraded =3D 1;
>>
>> The problem is that only checking rdev =3D=3D NULL might not be enou=
gh. Suppose both 2 drives D0 and D1 failed and marked as Faulty; We imm=
ediately removed D0 from array, but because some lingering IO on D1, it=
 remains in array with Faulty flags on. A new drive pulled in, rebuild =
against D0 starts. Now because no rdev is NULL, MD thinks array will be=
 optimal. If some writes happened before rebuild reaches the region, th=
eir dirty bits in WIB will be cleared. When later add D1 back into arra=
y, we=E2=80=99ll skip rebuilding those stripes, thus data corruption.
>>
>> The attached patch (against 3.18.0-rc6) is supposed to fix this issu=
e.
>>
>> Thanks
>> Eric
>>
> Hi Eric,
>   sorry for the delay, and thanks for the reminder...
>
> The issue you described could only affect RAID6 as it requires the ar=
ray to
> continue with two failed drives.
>
> However in the RAID6 case I think you are correct - there is a chance=
 of
> corruption if there is a double failure and a delay in removing one d=
evice.
>
> Your patch isn't quite safe as conf->disks[i].rdev can become NULL at=
 any
> moment, so it could become NULL between testing and de-referencing.
> So I've modified it as follows.
>
> Thanks,
> NeilBrown
>
>
>
> Author: Eric Mei <eric.mei@seagate.com>
> Date:   Tue Jan 6 09:35:02 2015 -0800
>
>      raid5: check faulty flag for array status during recovery.
>     =20
>      When we have more than 1 drive failure, it's possible we start
>      rebuild one drive while leaving another faulty drive in array.
>      To determine whether array will be optimal after building, curre=
nt
>      code only check whether a drive is missing, which could potentia=
lly
>      lead to data corruption. This patch is to add checking Faulty fl=
ag.
>     =20
>      Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index bc6d7595ad76..022a0d99e110 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5120,12 +5120,17 @@ static inline sector_t sync_request(struct md=
dev *mddev, sector_t sector_nr, int
>   		schedule_timeout_uninterruptible(1);
>   	}
>   	/* Need to check if array will still be degraded after recovery/re=
sync
> -	 * We don't need to check the 'failed' flag as when that gets set,
> -	 * recovery aborts.
> +	 * Note in case of > 1 drive failures it's possible we're rebuildin=
g
> +	 * one drive while leaving another faulty drive in array.
>   	 */
> -	for (i =3D 0; i < conf->raid_disks; i++)
> -		if (conf->disks[i].rdev =3D=3D NULL)
> +	rcu_read_lock();
> +	for (i =3D 0; i < conf->raid_disks; i++) {
> +		struct md_rdev *rdev =3D ACCESS_ONCE(conf->disks[i].rdev);
> +
> +		if (rdev =3D=3D NULL || test_bit(Faulty, &rdev->flags))
>   			still_degraded =3D 1;
> +	}
> +	rcu_read_unlock();
>  =20
>   	bitmap_start_sync(mddev->bitmap, sector_nr, &sync_blocks, still_de=
graded);
>  =20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
