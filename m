Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B894229A8
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783690776; cv=none; b=iI7eP2FZO5WN6NhS/vo7BMWfqWxOGQbPBR4y2mJ/qGfc3f/uuJI2WvDXhFBb5jmVSOftr81XTFq0I82ZDVhNqhtcwYfU6aictnb86wobIqcey1N7ytdYbwgMUywKAkNHWt4lXpN7bAklYPdEjcKyjIUFZEQL2iNaCgsL2705Hko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783690776; c=relaxed/simple;
	bh=QXWu+z2qDZM6PQu7A0TwcRb5ztN/UyPD7aYHJzwOdBk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o+Fezuihc8zmmFLzQJLwAvMTh6mf15B/4W1EW1VWXjIS+vpDkGlpT2583OLvddTlYE7wN4NVCDRF9J+Hr4uplFsbu7n4t3ZhAs0CC10uXVkKuNbA/XHdcoSoYwGvyu81f92AsV3msgo9xKH1IlOw1/zgMK+9YVb6XpKxJ9xFOC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwqHlEPv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwqHlEPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1344F1F000E9;
	Fri, 10 Jul 2026 13:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783690773;
	bh=CPhfdBZzm+bg15KXrvejuOKmKPWxcKGe/u3UB+sLQO8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jwqHlEPvD1v84uByV+ygiV441W6uC+rEuOUtXabHRueqFXvPoYksKFW6wRtQX944T
	 swcgHx4qOxOuhH4NBqsusIHHQ0bMsQ598Zq2Ah7H0fMog8fIF5WiNVn5Tiv3ygctdK
	 ZCX7gq1N8HWEKNBUVBnDi4S0CrayKSOMT9JsC436ATHqDJItrJ8qwLPujOCDKTqL56
	 kj1skuk8u66D5MhXSDtcbuRB1piB0zhnyRN5Cb6ufDtdJ8Z/oGKw7QN3wrIYb6mthL
	 eu6FjWVSpB9UhZHKJoFlRCi374t27No8t9YhgHfFYyASd8LRhFRfmFRfq1lX9/kgvm
	 digXfFY+lwrBQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/6] md/raid5: size the worker group array by
 nr_node_ids
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260710132346.7295-2-nishidafmly@gmail.com>
References: <20260710132346.7295-1-nishidafmly@gmail.com>
 <20260710132346.7295-2-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 10 Jul 2026 13:39:32 +0000
Message-Id: <20260710133933.1344F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Holding reconfig_mutex while waiting for raid5_wq workers to finis=
h can cause an ABBA deadlock if workers wait for MD_SB_CHANGE_PENDING to be=
 cleared.
--

--- Patch [1]: [PATCH 1/6] md/raid5: size the worker group array by nr_node=
_ids ---
commit 4f7875645a221b114b23eee045960c40b057b078
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: size the worker group array by nr_node_ids

This patch fixes an out-of-bounds array access when the NUMA node map is
sparse by sizing the worker_groups array using nr_node_ids rather than
num_possible_nodes().

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0c5c9fb0606ee..d8807114a6932 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7322,7 +7322,13 @@ static int alloc_thread_groups(struct r5conf *conf=
, int cnt, int *group_cnt,
>  		*worker_groups =3D NULL;
>  		return 0;
>  	}
> -	*group_cnt =3D num_possible_nodes();
> +	/*
> +	 * worker_groups is indexed by cpu_to_group() =3D=3D cpu_to_node(), a n=
ode
> +	 * id, so it must have room for the largest possible id.  Size it by
> +	 * nr_node_ids (one past that id), not num_possible_nodes(), which is
> +	 * only the node count and is smaller on a sparse node map.
> +	 */
> +	*group_cnt =3D nr_node_ids;

[Severity: High]
This is a pre-existing issue, but while reviewing this allocation change,
I noticed a potential deadlock risk in the caller,
raid5_store_group_thread_cnt(), when configuring these worker groups.

When writing to the group_thread_cnt sysfs attribute,
raid5_store_group_thread_cnt() acquires reconfig_mutex via
mddev_suspend_and_lock() and then blocks waiting for workers in
raid5_wq to finish:

drivers/md/raid5.c:raid5_store_group_thread_cnt() {
    err =3D mddev_suspend_and_lock(mddev);
    ...
    raid5_quiesce(mddev, true);

    if (new !=3D conf->worker_cnt_per_group) {
        old_groups =3D conf->worker_groups;
        if (old_groups)
            flush_workqueue(raid5_wq);

        err =3D alloc_thread_groups(conf, new, &group_cnt, &new_groups);
}

However, the raid5 workers can block waiting for the md_thread to clear
MD_SB_CHANGE_PENDING:

drivers/md/raid5.c:raid5_do_work() {
    ...
    wait_event_lock_irq(mddev->sb_wait,
        !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
        conf->device_lock);
}

The md_thread requires the reconfig_mutex to clear this flag:

drivers/md/md.c:md_check_recovery() {
    ...
    if (mddev_trylock(mddev)) {
        ...
        if (mddev->sb_flags)
            md_update_sb(mddev, 0);
}

Does this sequence create a deadlock where the sysfs thread holds
reconfig_mutex and waits for raid5_wq workers, while the workers wait for
the md_thread to clear MD_SB_CHANGE_PENDING, but the md_thread fails to
acquire reconfig_mutex via mddev_trylock()?

>  	size =3D sizeof(struct r5worker) * cnt;
>  	workers =3D kcalloc(size, *group_cnt, GFP_NOIO);
>  	*worker_groups =3D kzalloc_objs(struct r5worker_group, *group_cnt,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260710132346.7295=
-1-nishidafmly@gmail.com?part=3D1
