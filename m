Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B957C2EC09F
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 16:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782317247; cv=none; b=Madxk21kGlO7Y8uC7jlzHvrcR+9CvAPurnRQ8bqSkDLxRtb5rnp2I1+Wet337mGlB+TxHGAVqfHyIm6x4l8gwoRMDQJsHgYwrGjSHAK/fE1VSHQo23iMxOO3UGoUhlx3UgBPOWg32IEEKGZojXnvQ1drHnek/vp7stbZqL+BRPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782317247; c=relaxed/simple;
	bh=OE0MIoWrVr0JdYtG6wEir+EGBdtdY5RHOLW92Q3rfP4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qGq1Ez6nRwQedZCm9YAg8SFZLXWwNYDjcl8mRoR2L1lVc/UCFXOrUe27c/i0VSuZTz6vytQmJdxxJHd0N4eF3uSV/QN0aQXjj6bGUxeeF4XLRv3UqWrqT5C8QhVFNjDiM7CSk9hyebFp6Gg/1JitSCsIh5i4PTerP57C4P3Xx0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AN7q0lFB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AN7q0lFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9161F000E9;
	Wed, 24 Jun 2026 16:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782317246;
	bh=C3sAnjxahMmGZT7C3AeGk0+gZWqrU8x2rnClDd0wVUY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AN7q0lFBN3yexDqLT6iIQiN+F6J+g3LixGE7f+TKhrXkipwZTW+eksEpT4Ooam5dp
	 v/7nQlI82XbECN9NnQvQqLd9Acz8nSPUyjLOW8uCuGc954f1y0IpsutiizlvKdkfam
	 kmjDViiG2+Lgt8oB6N+ENaZHORf4e/TCtL7o7xYSum7KrVfaTopzgLgqC0mGDislNW
	 FMElPMmfomZ+XYM8smaGChixCVEsqXpx8PxHLpWSot0OdSVPEda8eZpMc5VOlCW69Z
	 Ko0elsmx+zF9NVXp5+eF7XySbSOrEagerny7LYYvr9KnriBOzA2tZBBloOzVzAgcxc
	 Y7odPi0BahJ1A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/8] md/raid5: allocate worker groups per NUMA node
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260624155452.211646-7-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-7-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 16:07:25 +0000
Message-Id: <20260624160726.2B9161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The patch incorrectly uses a sequential loop index `i` as the NUMA=
 node ID parameter to `kzalloc_node()`.

Pre-existing issues:
- [High] The `worker_groups` array is sized using `num_possible_nodes()` bu=
t is indexed by the raw NUMA node ID, leading to out-of-bounds accesses on =
systems with sparse NUMA node IDs.
--

commit bce08bf6ce446b00da625ff4028f5782b756e17c
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: allocate worker groups per NUMA node

alloc_thread_groups() previously allocated all r5worker arrays in a
single kcalloc() block, assigning workers for NUMA node N from node 0
memory.  On multi-socket systems this causes remote memory traffic on
every worker->work and worker->temp_inactive_list access.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 8e9edaaca667b..c8787ab7b309c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
[ ... ]
> @@ -7336,7 +7340,6 @@ static int alloc_thread_groups(struct r5conf *conf,=
 int cnt, int *group_cnt,
[ ... ]
>  	*group_cnt =3D num_possible_nodes();
> -	size =3D sizeof(struct r5worker) * cnt;
> -	workers =3D kcalloc(size, *group_cnt, GFP_NOIO);
>  	*worker_groups =3D kzalloc_objs(struct r5worker_group, *group_cnt,
>  				      GFP_NOIO);

[Severity: High]
This isn't a bug introduced by this patch, but could this array sizing cause
an out-of-bounds access on systems with sparse NUMA nodes?

We size the worker_groups array using num_possible_nodes(), which is a coun=
t.
On systems with sparse NUMA node IDs (for example, nodes 0 and 8), the array
would only have 2 elements. Later, in raid5_wakeup_stripe_thread(), we index
into this array using cpu_to_group(cpu) which expands to cpu_to_node(cpu).
If a CPU belongs to node 8, we would access conf->worker_groups[8], exceedi=
ng
the allocated size and corrupting memory.

> -	if (!*worker_groups || !workers) {
> -		kfree(workers);
> -		kfree(*worker_groups);
> +	if (!*worker_groups)
>  		return -ENOMEM;
> -	}
> =20
> +	size =3D sizeof(struct r5worker) * cnt;
>  	for (i =3D 0; i < *group_cnt; i++) {
> -		struct r5worker_group *group;
> +		struct r5worker_group *group =3D &(*worker_groups)[i];
> +		struct r5worker *workers;
> +
> +		workers =3D kzalloc_node(size, GFP_NOIO, i);

[Severity: High]
Could passing the sequential loop index i directly to kzalloc_node cause a
NULL pointer dereference on systems with sparse NUMA nodes?

Since num_possible_nodes returns a count rather than an upper bound on IDs,
on a system with nodes 0 and 8, i would be evaluated as 1. Passing an
unpopulated node ID to kzalloc_node without validation can lead to a crash
when accessing NODE_DATA(nid). Should this loop use
for_each_node_state(nid, N_MEMORY) or similar to get the actual node ID
instead of using the loop counter?

> +		if (!workers)
> +			goto out_free;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.2116=
46-1-nishidafmly@gmail.com?part=3D6
