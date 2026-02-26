Received: from sg-1-21.ptr.blmpb.com (sg-1-21.ptr.blmpb.com [118.26.132.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AFC2D94B5
	for <linux-raid@vger.kernel.org>; Thu, 26 Feb 2026 05:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772083626; cv=none; b=rul6M9LGgzxTeRbC+N1YIhHKYe6mFsj4R2/Jy2f2Q0KHUolPAAn1s6kKsrg5TKat3fy0UGfd31PWv7Oz4A6MgMNvHA7bd3R5EKiwB+MmQO/oNNsX/jA9h2TAd+7FrCu9J4I0b4YOpDBLtQ2KgZuN2k2uKNI6bBAOuHklt4c2w5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772083626; c=relaxed/simple;
	bh=FSpfY9OxCVv0aMqpe3mddWTR0rYJdp0BhmumbNh0KmA=;
	h=To:Content-Type:Date:References:In-Reply-To:From:Subject:
	 Message-Id:Mime-Version:Cc; b=jr/TqBA+jG1tlf2ApsqCH3wEZyvQ3fgQKCXU0WRLdklMuQ8zI278KQwLz0Rt16M/k2+RJeMK9yxjKL+zs+ov5g+lUZ2PwNSMJRxK3Ok9/vkkJ/nUQ5Vmch9mzGvWW8xf/MB0UwT3U6feLzn40ULnduDRoIwt5D565WCrn/qVu48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AUOmYKak; arc=none smtp.client-ip=118.26.132.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AUOmYKak"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772083496;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=McZnbb0webi+ldzx+31KHrL7DEum/GPbTCVk0fulBtI=;
 b=AUOmYKak4It3QcNzFCbIWkzn61wDEB6s2v37m9QN44VLeMaNibZVSPmZ567QhwAptHUovd
 9j2AWHp+O86ZwTghoxIR8WFzZ5AlLKcjpHG1yAEUdrNQrtukDvZM9cfjI1AjsQfe72VwOb
 IXHyP82QjT1bBG3hvokOsUIRNS3wj9x4JzPahmfDFBcjSJEh/r1ye9d8tacGqOvcbAgrbF
 AAjiCDxwahy4E10gUWlURGSkJeuaB4UORSqYPXL+GYslP69JfTGgM1NOLzabV7chQA8dlL
 XSW0yFOYjMLx5Tdv71GTKTfPru/05qI0YHoZ7s6fgHvHGYnIcLAvX1YT0bH0Xg==
To: "Josh Hunt" <johunt@akamai.com>, <song@kernel.org>, 
	<linan122@huawei.com>, <linux-raid@vger.kernel.org>, <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Feb 2026 13:24:52 +0800
Content-Transfer-Encoding: quoted-printable
References: <20260210165126.3963677-1-johunt@akamai.com>
In-Reply-To: <20260210165126.3963677-1-johunt@akamai.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2] md/raid10: fix deadlock with check operation and nowait requests
Message-Id: <f382704c-8a3a-4c94-8fc0-46938e720894@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.140]) by smtp.feishu.cn with ESMTPS; Thu, 26 Feb 2026 13:24:53 +0800
X-Lms-Return-Path: <lba+2699fd926+3a8d4f+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Cc: <ncroxon@redhat.com>, <stable@vger.kernel.org>
User-Agent: Mozilla Thunderbird
Content-Language: en-US

Hi,

=E5=9C=A8 2026/2/11 0:51, Josh Hunt =E5=86=99=E9=81=93:
> When an array check is running it will raise the barrier at which point
> normal requests will become blocked and increment the nr_pending value to
> signal there is work pending inside of wait_barrier(). NOWAIT requests
> do not block and so will return immediately with an error, and additional=
ly
> do not increment nr_pending in wait_barrier(). Upstream change
> 43806c3d5b9b ("raid10: cleanup memleak at raid10_make_request") added a
> call to raid_end_bio_io() to fix a memory leak when NOWAIT requests hit
> this condition. raid_end_bio_io() eventually calls allow_barrier() and
> it will unconditionally do an atomic_dec_and_test(&conf->nr_pending) even
> though the corresponding increment on nr_pending didn't happen in the
> NOWAIT case.
>
> This can be easily seen by starting a check operation while an applicatio=
n is
> doing nowait IO on the same array. This results in a deadlocked state due=
 to
> nr_pending value underflowing and so the md resync thread gets stuck wait=
ing
> for nr_pending to =3D=3D 0.
>
> Output of r10conf state of the array when we hit this condition:
>
>    crash> struct r10conf.barrier,nr_pending,nr_waiting,nr_queued <addr of=
 r10conf>
>      barrier =3D 1,
>      nr_pending =3D {
>        counter =3D -41
>      },
>      nr_waiting =3D 15,
>      nr_queued =3D 0,
>
> Example of md_sync thread stuck waiting on raise_barrier() and other requ=
ests
> stuck in wait_barrier():
>
> md1_resync
> [<0>] raise_barrier+0xce/0x1c0
> [<0>] raid10_sync_request+0x1ca/0x1ed0
> [<0>] md_do_sync+0x779/0x1110
> [<0>] md_thread+0x90/0x160
> [<0>] kthread+0xbe/0xf0
> [<0>] ret_from_fork+0x34/0x50
> [<0>] ret_from_fork_asm+0x1a/0x30
>
> kworker/u1040:2+flush-253:4
> [<0>] wait_barrier+0x1de/0x220
> [<0>] regular_request_wait+0x30/0x180
> [<0>] raid10_make_request+0x261/0x1000
> [<0>] md_handle_request+0x13b/0x230
> [<0>] __submit_bio+0x107/0x1f0
> [<0>] submit_bio_noacct_nocheck+0x16f/0x390
> [<0>] ext4_io_submit+0x24/0x40
> [<0>] ext4_do_writepages+0x254/0xc80
> [<0>] ext4_writepages+0x84/0x120
> [<0>] do_writepages+0x7a/0x260
> [<0>] __writeback_single_inode+0x3d/0x300
> [<0>] writeback_sb_inodes+0x1dd/0x470
> [<0>] __writeback_inodes_wb+0x4c/0xe0
> [<0>] wb_writeback+0x18b/0x2d0
> [<0>] wb_workfn+0x2a1/0x400
> [<0>] process_one_work+0x149/0x330
> [<0>] worker_thread+0x2d2/0x410
> [<0>] kthread+0xbe/0xf0
> [<0>] ret_from_fork+0x34/0x50
> [<0>] ret_from_fork_asm+0x1a/0x30
>
> Fixes: 43806c3d5b9b ("raid10: cleanup memleak at raid10_make_request")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>   drivers/md/raid10.c | 40 +++++++++++++++++++++++++++-------------
>   1 file changed, 27 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9debb20cf129..b05066dde693 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -68,6 +68,7 @@
>    */
>  =20
>   static void allow_barrier(struct r10conf *conf);
> +static void allow_barrier_nowait(struct r10conf *conf);
>   static void lower_barrier(struct r10conf *conf);
>   static int _enough(struct r10conf *conf, int previous, int ignore);
>   static int enough(struct r10conf *conf, int ignore);
> @@ -317,7 +318,7 @@ static void reschedule_retry(struct r10bio *r10_bio)
>    * operation and are ready to return a success/failure code to the buff=
er
>    * cache layer.
>    */
> -static void raid_end_bio_io(struct r10bio *r10_bio)
> +static void raid_end_bio_io(struct r10bio *r10_bio, bool adjust_pending)
>   {
>   	struct bio *bio =3D r10_bio->master_bio;
>   	struct r10conf *conf =3D r10_bio->mddev->private;
> @@ -332,7 +333,10 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
>   	 * Wake up any possible resync thread that waits for the device
>   	 * to go idle.
>   	 */
> -	allow_barrier(conf);
> +	if (adjust_pending)
> +		allow_barrier(conf);
> +	else
> +		allow_barrier_nowait(conf);
>  =20
>   	free_r10bio(r10_bio);
>   }
> @@ -414,7 +418,7 @@ static void raid10_end_read_request(struct bio *bio)
>   			uptodate =3D 1;
>   	}
>   	if (uptodate) {
> -		raid_end_bio_io(r10_bio);
> +		raid_end_bio_io(r10_bio, true);
>   		rdev_dec_pending(rdev, conf->mddev);
>   	} else {
>   		/*
> @@ -446,7 +450,7 @@ static void one_write_done(struct r10bio *r10_bio)
>   			if (test_bit(R10BIO_MadeGood, &r10_bio->state))
>   				reschedule_retry(r10_bio);
>   			else
> -				raid_end_bio_io(r10_bio);
> +				raid_end_bio_io(r10_bio, true);
>   		}
>   	}
>   }
> @@ -1030,13 +1034,23 @@ static bool wait_barrier(struct r10conf *conf, bo=
ol nowait)
>   	return ret;
>   }
>  =20
> -static void allow_barrier(struct r10conf *conf)
> +static void __allow_barrier(struct r10conf *conf, bool adjust_pending)
>   {
> -	if ((atomic_dec_and_test(&conf->nr_pending)) ||
> +	if ((adjust_pending && atomic_dec_and_test(&conf->nr_pending)) ||
>   			(conf->array_freeze_pending))
>   		wake_up_barrier(conf);
>   }
>  =20
> +static void allow_barrier(struct r10conf *conf)
> +{
> +	__allow_barrier(conf, true);
> +}
> +
> +static void allow_barrier_nowait(struct r10conf *conf)
> +{
> +	__allow_barrier(conf, false);
> +}
> +
>   static void freeze_array(struct r10conf *conf, int extra)
>   {
>   	/* stop syncio and normal IO and wait for everything to
> @@ -1184,7 +1198,7 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,
>   	}
>  =20
>   	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
> -		raid_end_bio_io(r10_bio);
> +		raid_end_bio_io(r10_bio, false);
>   		return;
>   	}
>  =20
> @@ -1195,7 +1209,7 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,
>   					    mdname(mddev), b,
>   					    (unsigned long long)r10_bio->sector);
>   		}
> -		raid_end_bio_io(r10_bio);
> +		raid_end_bio_io(r10_bio, true);
>   		return;
>   	}
>   	if (err_rdev)
> @@ -1240,7 +1254,7 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,
>   	return;
>   err_handle:
>   	atomic_dec(&rdev->nr_pending);
> -	raid_end_bio_io(r10_bio);
> +	raid_end_bio_io(r10_bio, true);
>   }
>  =20
>   static void raid10_write_one_disk(struct mddev *mddev, struct r10bio *r=
10_bio,
> @@ -1372,7 +1386,7 @@ static void raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  =20
>   	sectors =3D r10_bio->sectors;
>   	if (!regular_request_wait(mddev, conf, bio, sectors)) {
> -		raid_end_bio_io(r10_bio);
> +		raid_end_bio_io(r10_bio, false);

There really is problem, however the analyze seems a bit wrong.

The master_bio is already handled with bio_wouldblock_error(), it's wrong
to call raid_end_bio_io() directly. Looks like this problem can be fixed by
calling free_r10bio() instead.

>   		return;
>   	}
>  =20
> @@ -1523,7 +1537,7 @@ static void raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>   		}
>   	}
>  =20
> -	raid_end_bio_io(r10_bio);
> +	raid_end_bio_io(r10_bio, true);
>   }
>  =20
>   static void __make_request(struct mddev *mddev, struct bio *bio, int se=
ctors)
> @@ -2952,7 +2966,7 @@ static void handle_write_completed(struct r10conf *=
conf, struct r10bio *r10_bio)
>   			if (test_bit(R10BIO_WriteError,
>   				     &r10_bio->state))
>   				close_write(r10_bio);
> -			raid_end_bio_io(r10_bio);
> +			raid_end_bio_io(r10_bio, true);
>   		}
>   	}
>   }
> @@ -2987,7 +3001,7 @@ static void raid10d(struct md_thread *thread)
>   			if (test_bit(R10BIO_WriteError,
>   				     &r10_bio->state))
>   				close_write(r10_bio);
> -			raid_end_bio_io(r10_bio);
> +			raid_end_bio_io(r10_bio, true);
>   		}
>   	}
>  =20

--=20
Thansk,
Kuai
