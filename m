Received: from sg-1-33.ptr.blmpb.com (sg-1-33.ptr.blmpb.com [118.26.132.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBBA285CBA
	for <linux-raid@vger.kernel.org>; Wed, 11 Feb 2026 02:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770777127; cv=none; b=WTKOCvCD9EDo/71RDG3Bf0TBxoXfz8uOJT+/ia1Zusg2j1snMxJ+MbwYSbAnhlEIWrbnGQ0i0hji3LmyriMVLq07uQ1NGPOviNXH6YQQQ0NIR330ED3yqDH60bDar2rZ7cw5WhBl+qZQKWn7+y9gIRJ7dfORBR4L+Ck3NKt1LKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770777127; c=relaxed/simple;
	bh=DrilC8ubGDJYCKzWNDn1l5iEdAJoChlfjApS6ZSSFgU=;
	h=To:Mime-Version:Cc:In-Reply-To:From:Subject:Date:Message-Id:
	 Content-Type:References; b=SKAgPLoedRn5C4uOd+lR9bMWYdwVOH6ZUWIgWwSF9xqmJajmv0iG8EOLVvuemLdB1YEB9agN9dRW6sdQeTDfwRafvYZkvcQ11pLogsCLM4pUmvWJpX/3fUo8/vWzbXrTNgkhXTQJeJofKoLSdBcYLb7HChoHoFR6uKU0trYt86c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=LnjY05H1; arc=none smtp.client-ip=118.26.132.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="LnjY05H1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1770777118;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=kWJjP9x2zxcOFgYzgaBzoFgJO2NNQYra/DZ7aNTyXdw=;
 b=LnjY05H1nRuNYizd2YC7MM7NJy4Zb7OKgNrQa6MW2Gq/XK4htY1HcIJzHaI/XnnKvguPrd
 I7BU/PQc9OxnkNzK48W7ZX275sQ9U1VT6haJmCgvwjOMgU1GprD14rv+sUEoe6FY0cJQnX
 l26cOGY7NP1TbcTt3beO9cCtGon+Hma/TicU5neLf+liBD+s72HidCb/gKwFKtij2TEpro
 mEwD6f04AADyMgCZCWIluThAWzkGdEO3tPNmPbVPie+NcDalYdcvHrMajYv8n6Y3C0Xp5n
 v27qiAA+iaNqUcuf0SyEqt5rbMlRrbnbBlIUYVfwMqbY32Y4ZRfMUMevAoFxMQ==
To: "Xiao Ni" <xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <song@kernel.org>, <linux-raid@vger.kernel.org>, 
	<linan666@huaweicloud.com>, <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260206053826.37416-3-xni@redhat.com>
X-Lms-Return-Path: <lba+2698bea1c+915452+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Wed, 11 Feb 2026 10:31:55 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH 2/2] md/raid1: serialize overlapped io for writemostly disk
Date: Wed, 11 Feb 2026 10:31:54 +0800
Content-Language: en-US
Reply-To: yukuai@fnnas.com
Message-Id: <9bd6581f-289a-4490-af6d-f15589446e1e@fnnas.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
References: <20260206053826.37416-1-xni@redhat.com> <20260206053826.37416-3-xni@redhat.com>

Hi,

=E5=9C=A8 2026/2/6 13:38, Xiao Ni =E5=86=99=E9=81=93:
> In behind mode, overlap bios for writemostly device are queued. They
> In behind mode, bios which overlap the bio from the interval tree
> need to wait in waitqueue. Those bios will be handled once the in-tree
> bio finishes. They are waken up and try to get the tree lock. The bio
> which gets the lock will be handled. So the sequence can't be guaranteed.
>
> For example
> bio1(100,200)
> bio2(150,200)
> bio3(150,300)
> The write sequence of fast device is bio1,bio2,bio3. But the write
> sequence of slow device is bio1,bio3,bio2. This causes data corruption.
> Replace waitqueue with a fifo list to guarantee the write sequence.

To be honest, I think this is fine with the respect user won't send overlap
bios. In this case, bio1 is done in fast disk and pending in slow disk, the=
n
bio2 will stuck while issuing and waiting for bio1 to return from slow disk=
.
So send bio3 in this case is not expected, and if you do you can't guarante=
e
the complete order from fast disk as bio2, bio3 as well.

>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c    |  1 -
>   drivers/md/md.h    |  4 +++-
>   drivers/md/raid1.c | 39 +++++++++++++++++++++++++++++----------
>   3 files changed, 32 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 59cd303548de..ab91d17c2d68 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -188,7 +188,6 @@ static int rdev_init_serial(struct md_rdev *rdev)
>  =20
>   		spin_lock_init(&serial_tmp->serial_lock);
>   		serial_tmp->serial_rb =3D RB_ROOT_CACHED;
> -		init_waitqueue_head(&serial_tmp->serial_io_wait);
>   	}
>  =20
>   	rdev->serial =3D serial;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index ac84289664cd..64ffbb2efb87 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -126,7 +126,6 @@ enum sync_action {
>   struct serial_in_rdev {
>   	struct rb_root_cached serial_rb;
>   	spinlock_t serial_lock;
> -	wait_queue_head_t serial_io_wait;
>   };
>  =20
>   /*
> @@ -382,6 +381,9 @@ struct serial_info {
>   	sector_t start;		/* start sector of rb node */
>   	sector_t last;		/* end sector of rb node */
>   	sector_t _subtree_last; /* highest sector in subtree of rb node */
> +	struct list_head	list_node;
> +	struct list_head	waiters;
> +	struct completion	ready;
>   };
>  =20
>   /*
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a41b1ec3d695..38c73538d038 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -57,19 +57,25 @@ INTERVAL_TREE_DEFINE(struct serial_info, node, sector=
_t, _subtree_last,
>   		     START, LAST, static inline, raid1_rb);
>  =20
>   static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r1_=
bio,
> -				struct serial_info *si, int idx)
> +				struct serial_info *si)
>   {
>   	unsigned long flags;
>   	int ret =3D 0;
>   	sector_t lo =3D r1_bio->sector;
>   	sector_t hi =3D lo + r1_bio->sectors - 1;
> +	int idx =3D sector_to_idx(r1_bio->sector);
>   	struct serial_in_rdev *serial =3D &rdev->serial[idx];
> +	struct serial_info *head_si;
>  =20
>   	spin_lock_irqsave(&serial->serial_lock, flags);
>   	/* collision happened */
> -	if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
> +	head_si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
> +	if (head_si && head_si !=3D si) {
> +		si->start =3D lo;
> +		si->last =3D hi;
> +		list_add_tail(&si->list_node, &head_si->waiters);
>   		ret =3D -EBUSY;
> -	else {
> +	} else if (!head_si) {
>   		si->start =3D lo;
>   		si->last =3D hi;
>   		raid1_rb_insert(si, &serial->serial_rb);
> @@ -83,19 +89,23 @@ static void wait_for_serialization(struct md_rdev *rd=
ev, struct r1bio *r1_bio)
>   {
>   	struct mddev *mddev =3D rdev->mddev;
>   	struct serial_info *si;
> -	int idx =3D sector_to_idx(r1_bio->sector);
> -	struct serial_in_rdev *serial =3D &rdev->serial[idx];
>  =20
>   	if (WARN_ON(!mddev->serial_info_pool))
>   		return;
>   	si =3D mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
> -	wait_event(serial->serial_io_wait,
> -		   check_and_add_serial(rdev, r1_bio, si, idx) =3D=3D 0);
> +	INIT_LIST_HEAD(&si->waiters);
> +	INIT_LIST_HEAD(&si->list_node);
> +	init_completion(&si->ready);
> +	while (check_and_add_serial(rdev, r1_bio, si)) {
> +		wait_for_completion(&si->ready);
> +		reinit_completion(&si->ready);
> +	}
>   }
>  =20
>   static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t h=
i)
>   {
>   	struct serial_info *si;
> +	struct serial_info *first_si;
>   	unsigned long flags;
>   	int found =3D 0;
>   	struct mddev *mddev =3D rdev->mddev;
> @@ -106,16 +116,25 @@ static void remove_serial(struct md_rdev *rdev, sec=
tor_t lo, sector_t hi)
>   	for (si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
>   	     si; si =3D raid1_rb_iter_next(si, lo, hi)) {
>   		if (si->start =3D=3D lo && si->last =3D=3D hi) {
> -			raid1_rb_remove(si, &serial->serial_rb);
> -			mempool_free(si, mddev->serial_info_pool);
>   			found =3D 1;
>   			break;
>   		}
>   	}
>   	if (!found)
>   		WARN(1, "The write IO is not recorded for serialization\n");
> +	else {
> +		raid1_rb_remove(si, &serial->serial_rb);
> +		if (!list_empty(&si->waiters)) {
> +			first_si =3D list_first_entry(&si->waiters,
> +						struct serial_info, list_node);
> +			list_del_init(&first_si->list_node);
> +			list_splice_init(&si->waiters, &first_si->waiters);
> +			raid1_rb_insert(first_si, &serial->serial_rb);
> +			complete(&first_si->ready);
> +		}
> +		mempool_free(si, mddev->serial_info_pool);
> +	}
>   	spin_unlock_irqrestore(&serial->serial_lock, flags);
> -	wake_up(&serial->serial_io_wait);
>   }
>  =20
>   /*

--=20
Thansk,
Kuai
