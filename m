Received: from sg-1-30.ptr.blmpb.com (sg-1-30.ptr.blmpb.com [118.26.132.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364EF239E7E
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 02:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772590741; cv=none; b=q5/Olo/+KIefbKidQkiudi5bctCOq0sw+3ZSnmXfyLboe7k8GuO7E8aXy5ScVxyaC9+52LR+cLxJvTQBQU1cCwGMNJja37PmVumefAHOVY/kQKPmhL4SNuDLlJS/v+nwtnRYOa5uMC8dNbTY95v7lpwZsW1BoeK267wOGHAPr1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772590741; c=relaxed/simple;
	bh=AxjOMASTfdq+3mnv8B9AggdHsIJp6qfP3Mp+h3e0IE0=;
	h=In-Reply-To:From:Message-Id:Mime-Version:Content-Type:References:
	 Cc:Date:To:Subject; b=GD1lQ9NANDMx48hAGAHHizZfABpaiMOCIaXPdkElGLtg4iuF9tQLmC1kzuSfTnhFED9aXLMC20De8wGGnUaujzIelPMO+xyfAbjltTRNhf1zKLaVOSIxhpLlsZZEcOt7jmAkjZiOhTl5E/YyJQu0DlzGv27gvKezm21JlYUQmVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=2fy+s7zw; arc=none smtp.client-ip=118.26.132.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="2fy+s7zw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772590725;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=s2idoR7obNOLPGXXRWo+TTj4IXagnotgcd2SBp5sm04=;
 b=2fy+s7zwooTCWjb9x1TZFnsB73GH6XhEVVFpnWIryczS3RfcjopH+8TFhJhyeFiQQuBX4k
 Xq/ETxJHgTpJd9raQnu1bSRiWpIIdzL4CN2mLn9ARZrLhChwxc/wK7LxuyOzlA9pxncD3l
 j+Ii1XOcoVUMcKlm0fsqpJwOG3N7qvGAoGgtjaryIdBo6R48G7epEqDQrqS4dZftaGmDQY
 eYhcQ2R6FBwYEgvv5xl6dQ68UGKpWJKkJC/6N3d5lLJPD8um4Qe7BD0zZisjWPjnDbynvP
 Rs/lfLDZ1IKMhIk1EBvmHenAQDPLBd8B8Yd8iTBERQuqErEUiOzfNnW7sMjlLA==
In-Reply-To: <20260303005619.1352958-1-johunt@akamai.com>
Content-Transfer-Encoding: quoted-printable
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <54af459e-2671-417b-bc9f-2b13f111f749@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
References: <20260303005619.1352958-1-johunt@akamai.com>
Received: from [192.168.1.104] ([39.182.0.182]) by smtp.feishu.cn with ESMTPS; Wed, 04 Mar 2026 10:18:42 +0800
Reply-To: yukuai@fnnas.com
Cc: <ncroxon@redhat.com>, <stable@vger.kernel.org>
Date: Wed, 4 Mar 2026 10:18:40 +0800
Content-Language: en-US
To: "Josh Hunt" <johunt@akamai.com>, <song@kernel.org>, 
	<linan122@huawei.com>, <linux-raid@vger.kernel.org>, <yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269a79683+058066+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: [PATCH v3] md/raid10: fix deadlock with check operation and nowait requests

=E5=9C=A8 2026/3/3 8:56, Josh Hunt =E5=86=99=E9=81=93:

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
> crash> struct r10conf.barrier,nr_pending,nr_waiting,nr_queued <addr of r1=
0conf>
> 	barrier =3D 1,
>          nr_pending =3D {
>            counter =3D -41
>          },
>          nr_waiting =3D 15,
>          nr_queued =3D 0,
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
> v3:
>    * Call free_r10bio() as per Yu Kuai's suggestion
> ---
>   drivers/md/raid10.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

There are some checkpatch errors and warnings, applied to md-7.0 with some
changes to commit message.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 9debb20cf129..b4892c5d571c 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1184,7 +1184,7 @@ static void raid10_read_request(struct mddev *mddev=
, struct bio *bio,
>   	}
>  =20
>   	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
> -		raid_end_bio_io(r10_bio);
> +		free_r10bio(r10_bio);
>   		return;
>   	}
>  =20
> @@ -1372,7 +1372,7 @@ static void raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  =20
>   	sectors =3D r10_bio->sectors;
>   	if (!regular_request_wait(mddev, conf, bio, sectors)) {
> -		raid_end_bio_io(r10_bio);
> +		free_r10bio(r10_bio);
>   		return;
>   	}
>  =20

--=20
Thansk,
Kuai
