Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD381342C80
	for <linux-raid@vger.kernel.org>; Fri, 16 Oct 2026 04:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792125381; cv=none; b=KpyC9OzGk9U2yCsYhf3WSDa6kS74xEoprJiGxTaxe21qLOmAMY7ShyqXoylchjyd7mFrt4ufH//wL3ih6nzGxBCbpKHyQFc5bws/ac/1Dp65thITyFy3jOIVySpxfPGeh/fgg5MRb6XzR7YgjrmgaxKqQh/tFKvSm+KbSmFtDUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792125381; c=relaxed/simple;
	bh=7lt4LH6NRhw8phz4OBbqspCHOIyeeHVu+7B8WnU6rWo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=QOxGkNwewaUS6lcfI6q5Pq2wNzOxJK0ltV0w0k6dLsl4WFNTcrWVpom+5SZeZWY8sa9tsvvdejJbKaSYgoD5f6VAUgQibnWyqnFnR5HVTQwiXpbMF6GgGSRcqZmh6vgnxufqd0E75YJh3r3iKv33M4esBLJF9naOsHqZfhfh+aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F81fN2fP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F81fN2fP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A881F000C4;
	Fri, 16 Oct 2026 04:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792125378;
	bh=4z/3oSBj11p1zBsgMwfQD5D8hmYmTU+RTBB6mLaktfU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F81fN2fP+Qd9y6JnDaLVhQvN+AjGqjGT25Ehw9WW2PGF7W4UpWy+8p50gBnPMQ8o7
	 wHiLV71wIfhddHnqNjSgVa5eqyHs6nvi4l2jd4UXgxl+ijLCp1eHz0EY1k4p1t9qB6
	 0mChdiNCATQ8hf9mIGE+b6mh4OifLtqHddmqFZUkAlKX7GI6fKfk6DZW4BescRVyYE
	 Hr/5lWzLIXaq7YulmH8v47SgowKisiTIiQt7PzYbTX2vvAlk/e9UUy9e/RHmo2/RTX
	 MBvF4XOOFtnh/BIpR1rJgzm+XpaTbbcSkDHGc1SvRF/ZrUKcjdjF63W2TGdJDucR2t
	 b3wWm4KVHu9NA==
Message-ID: <sashiko-outbox-173790@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/3] md/raid5: freeze and interrupt reshape when
 handling failed reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Doug V Johnson" <me@dougvj.me>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <010101a142f57e37-cd14b78d-54cd-447b-9888-87f166a937ab-000000@us-west-2.amazonses.com>
References: <20261016042537.277516-1-me@dougvj.me>
 <010101a142f57e37-cd14b78d-54cd-447b-9888-87f166a937ab-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Oct 2026 04:36:17 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] md: stale did_freeze clears MD_RECOVERY_FROZEN requested by failed=
 reshape
--

commit 0538f5adec4b4e67f586325e5d4064322224a7a9
Author: Doug V Johnson <me@dougvj.me>

md/raid5: freeze and interrupt reshape when handling failed reshape

This commit adds a freeze flag to stop reshape operations when an
unrecoverable read occurs during a failed reshape. It prevents automatic
reshaping resumption which otherwise leads to block writes being cancelled
while the reshape continues, corrupting data.

Link: https://github.com/dougvj/md-raid-reshape-badblock-corruption-test
Link: https://patch.msgid.link/20260624075824.2601110-1-chencheng@fnnas.com

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090de..86ea65559576a 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3773,6 +3773,10 @@ static void handle_failed_reshape(struct r5conf *c=
onf, struct stripe_head *sh,
>  	bool was_expanding =3D test_and_clear_bit(STRIPE_EXPANDING, &sh->state);
>  	bool was_ready =3D test_and_clear_bit(STRIPE_EXPAND_READY, &sh->state);
> =20
> +	/* Freeze reshaping to prevent data loss */
> +	set_bit(MD_RECOVERY_FROZEN, &conf->mddev->recovery);

[Severity: High]
Does setting the frozen state locklessly from the asynchronous worker thread
race with other configuration operations that clear it based on a stale
local variable?

If a user initiates an array teardown or read-only transition via sysfs
concurrently with a failing reshape:

1. do_md_stop() or md_set_readonly() observe MD_RECOVERY_FROZEN is clear,
   set it, and cache did_freeze =3D 1 locally.

2. They call stop_sync_thread() which intentionally drops
   mddev->reconfig_mutex while waiting.

3. Concurrently, the asynchronous raid5d worker executes this new patch
   logic in handle_failed_reshape() and sets MD_RECOVERY_FROZEN to prevent
   the reshape from resuming.

4. stop_sync_thread() returns and reacquires mddev->reconfig_mutex.

5. In error paths of do_md_stop() (or unconditionally in
   md_set_readonly()), the stale did_freeze variable is evaluated and
   MD_RECOVERY_FROZEN is cleared:

drivers/md/md.c:do_md_stop() {
    ...
    if (did_freeze) {
        clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
        set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
    }
    ...
}

Will this unconditionally clear the critical freeze requested by the worker
thread, causing MD_RECOVERY_NEEDED to be set and the array to automatically
resume the failed reshape, leading to data corruption?

> +	md_sync_error(conf->mddev);
> +
>  	if (was_expanding || was_ready) {
>  		atomic_dec(&conf->reshape_stripes);
>  		wake_up(&conf->wait_for_reshape);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/010101a142f57e37-cd=
14b78d-54cd-447b-9888-87f166a937ab-000000@us-west-2.amazonses.com?part=3D1
