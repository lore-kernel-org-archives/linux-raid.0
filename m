From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: Unable to handle kernel NULL pointer dereference in super_written
Date: Wed, 30 Mar 2016 10:34:18 +0800
Message-ID: <56FB3B2A.9030405@suse.com>
References: <678678296.35099303.1459240762496.JavaMail.zimbra@redhat.com>
 <538658018.35237734.1459254120634.JavaMail.zimbra@redhat.com>
 <20160329213731.GA2287@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160329213731.GA2287@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes.Sorensen@redhat.com, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids



On 03/30/2016 05:37 AM, Shaohua Li wrote:
> On Tue, Mar 29, 2016 at 08:22:00AM -0400, Xiao Ni wrote:
>> Hi all
>>
>> I encountered one NULL pointer dereference problem.
>>
>> The environment=EF=BC=9A
>> latest linux-stable and mdadm codes
>> aarch64 platform
>> the md device is created with loop devices
>>
>> It's a test case to check date integrity. I added the test script as=
 the attachment.
> Could you please try this patch:
>
>
>  From b86d9e1724184c79ad1ea63901aec802492b861c Mon Sep 17 00:00:00 20=
01
> Message-Id: <b86d9e1724184c79ad1ea63901aec802492b861c.1459285706.git.=
shli@fb.com>
> From: Shaohua Li <shli@fb.com>
> Date: Tue, 29 Mar 2016 14:00:19 -0700
> Subject: [PATCH] MD: add rdev reference for super write
>
> md_super_write() and corresponding md_super_wait() generally are call=
ed
> with reconfig_mutex locked, which prevents disk disappears.

Just for curious, I find several paths maybe also don't hold reconfig_m=
utex,
take the followings as example.

1.  md_run -> md_update_sb -> md_super_write/md_super_wait
2.  rdev_size_store -> rdev_size_change -> md_super_write/md_super_wait


Thanks,
Guoqing

> There is one
> case this rule is broken. write_sb_page of bitmap.c doesn't hold the
> mutex. next_active_rdev does increase rdev reference, but it decrease=
s
> the reference too early (eg, before IO finish). disk can disappear at
> the window. We unconditionally increase rdev reference in
> md_super_write() to avoid the race.
>
> Reported-by: Xiao Ni <xni@redhat.com>
> Cc: Neil Brown <neilb@suse.de>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>   drivers/md/md.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c068f17..bcfde333 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -718,6 +718,7 @@ static void super_written(struct bio *bio)
>  =20
>   	if (atomic_dec_and_test(&mddev->pending_writes))
>   		wake_up(&mddev->sb_wait);
> +	rdev_dec_pending(rdev, mddev);
>   	bio_put(bio);
>   }
>  =20
> @@ -732,6 +733,8 @@ void md_super_write(struct mddev *mddev, struct m=
d_rdev *rdev,
>   	 */
>   	struct bio *bio =3D bio_alloc_mddev(GFP_NOIO, 1, mddev);
>  =20
> +	atomic_inc(&rdev->nr_pending);
> +
>   	bio->bi_bdev =3D rdev->meta_bdev ? rdev->meta_bdev : rdev->bdev;
>   	bio->bi_iter.bi_sector =3D sector;
>   	bio_add_page(bio, page, size, 0);

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
