Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C8E38BF8D
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 16:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782317358; cv=none; b=L9LUlwMRHhG1VxCTKnU8VJUZxkVSeSOUpCaXhL6jsugA+aTHBamlmG5BGqFTC0Se1GNE9L2qsDEB7Gyml95f6a8U+HyGb9B9/cjcIIvGkJ1opJTf3lBjsLOrjYDTGHOvyiI8YjqigJwtNrbH2oWil8Lperb5VSkZzt5Lu2pRtLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782317358; c=relaxed/simple;
	bh=FURL1g9y6funvMcQGOq7ONBkVoVjyBCL3vYH5eCqprg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qACXcViX+oa9jEwSMLNTmWtAP/hK8ryYetOyy8V+1cUItTkxKj/luEnth/Npen5iaOR32VAVBKbbk5Gj7uB0Jp9/rHqANBfFJS4BbrbEDyNrc5lo19vzHJftuclVYJFWPwnWPnWn5595wGZORK5NuBML8QDxSQpjpqt+JsO489M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N9dBOXAH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9dBOXAH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1508E1F000E9;
	Wed, 24 Jun 2026 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782317357;
	bh=tuALHQB2fCS8KUK3ipQQ9OPZdHo118WfpYDgA1ueANs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=N9dBOXAHIqGwwIkMa8m4RaI4RYA4B+VXe+OAyjofICWJlHe/IR5Sih4SRUAL6+3Lb
	 2x6/92uU12Qzpq8WBN/lNZIkposxnR24JpTIrB6LA7ODnlk4b4CrvLSZg6ix0HYn6n
	 96q+xaPRIOmVe0r5DlGA8/p1oE6KfUkCursQA1kF+sHnd6VOR82bnhU18qSEdp++pO
	 HIAwUEe/+ZvWW+pFCF3SRJdnBjPRoQu6pgpl9WZdyHj4fQimqjfvff72NMZoWM80wJ
	 NrjKVucPPdAZR9+nn4GdHjGAj8V5uXAQTHkfPqspFAI5FtrnUFwnLMdXEDU+tKfqEO
	 tCveLFz65/J5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/8] md/raid5: raise MAX_STRIPE_BATCH from 8 to 32
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260624155452.211646-8-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-8-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 16:09:16 +0000
Message-Id: <20260624160917.1508E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Increasing MAX_STRIPE_BATCH to 32 without proportionally increasin=
g STRIPE_BATCH_WORKERS serializes stripe processing and causes worker starv=
ation.
--

commit b1a0a169dabd8b46b6b9ca40375034cf879934c6
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: raise MAX_STRIPE_BATCH from 8 to 32

This commit increases the maximum stripe batch size from 8 to 32 to
amortize device_lock acquisition over more stripes. It also introduces
STRIPE_BATCH_WORKERS to decouple the worker spawning threshold from the
batch size.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index c8787ab7b309c..ad6230415af33 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
[ ... ]
> @@ -210,7 +210,7 @@ static void raid5_wakeup_stripe_thread(struct stripe_=
head *sh)
>  	/* at least one worker should run to avoid race */
>  	queue_work_on(sh->cpu, raid5_wq, &group->workers[0].work);
> =20
> -	thread_cnt =3D group->stripes_cnt / MAX_STRIPE_BATCH - 1;
> +	thread_cnt =3D group->stripes_cnt / STRIPE_BATCH_WORKERS - 1;
>  	/* wakeup more workers */
>  	for (i =3D 1; i < conf->worker_cnt_per_group && thread_cnt > 0; i++) {

[Severity: High]
Will increasing the stripe batch size while keeping the worker spawn thresh=
old
small serialize stripe processing and starve the worker threads?

With this change, raid5_wakeup_stripe_thread() still wakes up an additional
worker for every 8 pending stripes (e.g., waking 4 threads for 32 stripes).

However, the first awakened worker executing handle_active_stripes() will
greedily dequeue up to MAX_STRIPE_BATCH (32) stripes under the lock:

drivers/md/raid5.c:handle_active_stripes() {
    ...
    while (batch_size < MAX_STRIPE_BATCH &&
           (sh =3D __get_priority_stripe(conf, group)) !=3D NULL)
        batch[batch_size++] =3D sh;
    ...
}

It appears the first thread will steal all 32 pending stripes and process
them sequentially, while the other awakened threads acquire the lock,
find the lists empty, and exit without doing any work.

Could this cause a performance regression by serializing CPU-intensive pari=
ty
operations onto a single thread, while also creating unnecessary lock
contention from the starved threads?

> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 7aeba1fc7f09e..1f37dabd727be 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
[ ... ]
> @@ -496,7 +496,8 @@ struct disk_info {
>  #define BYPASS_THRESHOLD	1
>  #define NR_HASH			(PAGE_SIZE / sizeof(struct hlist_head))
>  #define HASH_MASK		(NR_HASH - 1)
> -#define MAX_STRIPE_BATCH	8
> +#define MAX_STRIPE_BATCH	32	/* stripes per handle_active_stripes pass */
> +#define STRIPE_BATCH_WORKERS	8	/* stripes-per-worker threshold for spawn=
ing */
>  #define RAID5_SYNC_WINDOW	32	/* stripes to pre-submit per sync_request c=
all */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.2116=
46-1-nishidafmly@gmail.com?part=3D7
