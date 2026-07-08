Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7283C1984
	for <linux-raid@vger.kernel.org>; Wed,  8 Jul 2026 10:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783506797; cv=none; b=Ix1Y0nyicw4ExmduYoNNoupo/ZCayPavqHqe3uV87z5f5Vb8wgQkX5y2kpDnZmZOZMBMQ0825wPt6CB3SWX1NlzuFRB81bap3Um0sAnpP2UDewk7Ch8RvT+UlvQ+pXMP+C0bJZvSwy5sF5E32TEHkmX6+VXcqz2+JTLp+fw+Www=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783506797; c=relaxed/simple;
	bh=Q+dQrsF0hXAxI+rVhQ9jH7YHxsm1tV3jA9KaX/rSJFw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UAU+WdwLJ6loJ7L2E4a98JJjGxUvUkDPcJ6DihJTRWyv/xoZ2At8yd4ED+7qJI2c7js8zOeBYXFyL+/qv8mIyH1IAfsa+FUOmgh7VefTTmhZQahIq8XhkLoFVJvs7lAkRjAjMq7UIDr0/FRlrQxZQ36yXhFhm79hYd/rathBIic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/Z09sEE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/Z09sEE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7C61F000E9;
	Wed,  8 Jul 2026 10:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783506783;
	bh=0HO+0uuWSzKK64ZyqxGA5C/XFjOGq3AgdEAr8urP/Ak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M/Z09sEEeFYfdM9lyFF9Vj4dehL+y+oNPzDltNe/0Znq+w3LASf7Jb7axrofhAaO3
	 D7jTGOeDqnfuakucGH56A+vb9GMJyzAX4cVCmEi9bUkBI1CVYRy0jImjbkVr6NyaXK
	 4EJBmW9rdMvXvVff+AoxMrzpCHsargEVEwBNmtFTSKAppT/7Y02YSOEc8kIWm+go+h
	 0tvuAaOABtfXniI0hfPYrpng8ieANOWCo0hn97KK6AtrWeq5JKvusOBiJOeXSYTOr7
	 BnngJLTR4pbsrxPXqvJhoEm8hXwrmnQ+9baev5S2gbgB/wioDh0it+gL/jS8Mnsv4u
	 +2qqFKT7fv8xA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/7] md/raid10: fix r10bio leak in
 raid10_write_request() error paths
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260708101341.473750-2-abd.masalkhi@gmail.com>
References: <20260708101341.473750-1-abd.masalkhi@gmail.com>
 <20260708101341.473750-2-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 08 Jul 2026 10:33:02 +0000
Message-Id: <20260708103303.4D7C61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [High] REQ_NOWAIT bios can block waiting for blocked devices in wait_bloc=
ked_dev(), violating non-blocking semantics.
- [High] REQ_NOWAIT bios can stall during memory allocation due to hardcode=
d GFP_NOIO usage.
- [High] REQ_NOWAIT bios split by bio_submit_split_bioset block waiting for=
 the barrier.
--

--- Patch [1]: [PATCH v3 1/7] md/raid10: fix r10bio leak in raid10_write_re=
quest() error paths ---
commit 3eda7e2f9e31ead6359429f927a806f3d762dc4b
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid10: fix r10bio leak in raid10_write_request() error paths

This commit fixes a memory leak in raid10_write_request() by freeing the
allocated r10_bio when a write request fails due to REQ_NOWAIT being set.

Closes: https://lore.kernel.org/linux-raid/20260613184042.BCEC01F000E9@smtp=
.kernel.org/
Link: https://lore.kernel.org/linux-raid/20260628142420.1051027-2-abd.masal=
khi@gmail.com/
Link: https://lore.kernel.org/linux-raid/20260623072456.333437-2-abd.masalk=
hi@gmail.com/

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df8..bd322eccdc3ff 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1365,6 +1365,7 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		/* Bail out if REQ_NOWAIT is set for the bio */
>  		if (bio->bi_opf & REQ_NOWAIT) {
>  			bio_wouldblock_error(bio);
> +			free_r10bio(r10_bio);
>  			return false;
>  		}
>  		for (;;) {

[ ... ]

> @@ -1398,6 +1399,7 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		if (bio->bi_opf & REQ_NOWAIT) {
>  			allow_barrier(conf);
>  			bio_wouldblock_error(bio);
> +			free_r10bio(r10_bio);
>  			return false;
>  		}

[Severity: High]
This is a pre-existing issue, but since this patch improves REQ_NOWAIT
handling, can REQ_NOWAIT bios still block waiting for blocked devices?

In raid10_write_request(), wait_blocked_dev() is called unconditionally:

    wait_blocked_dev(mddev, r10_bio);

If an rdev is blocked, wait_blocked_dev() calls md_wait_for_blocked_rdev(),
which waits up to 5 seconds via wait_event_timeout(). Should this path check
if the bio is REQ_NOWAIT to avoid stalling the submission thread?

[Severity: High]
This is another pre-existing issue, but can REQ_NOWAIT bios stall during me=
mory
allocation due to hardcoded GFP_NOIO usage?

In __make_request(), the initial allocation uses GFP_NOIO:

    r10_bio =3D mempool_alloc(&conf->r10bio_pool, GFP_NOIO);

And in raid10_write_one_disk(), the child bio allocation also uses GFP_NOIO:

    mbio =3D bio_alloc_clone(rdev->bdev, bio, GFP_NOIO, &mddev->bio_set);

Under memory pressure, GFP_NOIO will trigger direct reclaim and wait for
mempool replenishment. Should these allocations be attempted with GFP_NOWAIT
and aborted with BLK_STS_AGAIN for REQ_NOWAIT bios?

[Severity: High]
This is also a pre-existing issue, but do REQ_NOWAIT bios that are split bl=
ock
waiting for the barrier?

If a REQ_NOWAIT bio spans multiple chunks, it can be split. The wait_barrie=
r()
call uses a hardcoded false for the nowait parameter:

    wait_barrier(conf, false);

This will block if the array barrier is raised. Since returning BLK_STS_AGA=
IN
is no longer viable once the first half is submitted, is there a way to pre=
vent
stalling REQ_NOWAIT callers on split bios?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260708101341.4737=
50-1-abd.masalkhi@gmail.com?part=3D1
