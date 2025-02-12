Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906782063C7
	for <linux-raid@vger.kernel.org>; Wed, 12 Feb 2025 10:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739354847; cv=none; b=feNRVBkNTqKqmhHcYBw1SuZJ+a2hHeRHIrdsOUBUaOeR4BLMXscOHkFicl58b+hLC3JwIRXSBbejibViUCnI48sZLPn5mL0W7UP5KyXtqMZdWKMHY99kOESzr6zjbmhqgSH2U+d8sqiwKDOI217l6KwcvdqZHul+RdXdQmkJ0eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739354847; c=relaxed/simple;
	bh=Ji5ipDo4xVUgwAQX6V3J0Cai9GSvYpvV9TTra+txVQc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e0CC6W67kZGLT1Ne5UvGGwbrkHl+6yAb7JykZ0WxqHRfBSQIvtgCFZQUg4r/qfvMP2E8oWEBmKSy4Jn15YOdYB5gB9ZWHYMvL6lTyRIu/JtfykySJG21G/nMPwBsVGnumq7wNkKg4sE/unBRT7hRvE5KDfX1iII+MFLC4IyAj1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 42D38C4CEE2;
	Wed, 12 Feb 2025 10:07:24 +0000 (UTC)
Date: Wed, 12 Feb 2025 11:07:13 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: blazej.kucman@linux.intel.com
Cc: Junxiao Bi <junxiao.bi@oracle.com>, linux-raid@vger.kernel.org,
 mateusz.kusiak@intel.com, ncroxon@redhat.com, song@kernel.org,
 xni@redhat.com, yukuai@kernel.org
Subject: Re: [PATCH] mdmon: imsm: fix metadata corruption when managing new
 array
Message-ID: <20250212110713.1f112947@mtkaczyk-private-dev>
In-Reply-To: <20250210212225.10633-1-junxiao.bi@oracle.com>
References: <20250210212225.10633-1-junxiao.bi@oracle.com>
Organization: Linux development
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hello Junxiao,
Thanks for solid and complete explanation!

On Mon, 10 Feb 2025 13:22:25 -0800
Junxiao Bi <junxiao.bi@oracle.com> wrote:

> When manager thread detects new array, it will invoke manage_new().
> For imsm array, it will further invoke imsm_open_new(). Since
> commit bbab0940fa75("imsm: write bad block log on metadata sync"),
> it preallocates bad block log when opening the array, that requires
> increasing the mpb buffer size.
> To do that, imsm_open_new() invokes imsm_update_metadata_locally(),
> which first uses imsm_prepare_update() to allocate a larger mpb buffer
> and store it at "mpb->next_buf", and then invoke imsm_process_update()
> to copy the content from current mpb buffer "mpb->buf" to
> "mpb->next_buf", and then free the current mpb buffer and set the new
> buffer as current.
> 
> There is a small race window, when monitor thread is syncing metadata,
> it grabs current buffer pointer in
> imsm_sync_metadata()->write_super_imsm(), but before flushing the
> buffer to disk, manager thread does above switching buffer which
> frees current buffer, then monitor thread will run into
> use-after-free issue and could cause on-disk metadata corruption. If
> system keeps running, further metadata update could fix the
> corruption, because after switching buffer, the new buffer will
> contain good metadata, but if panic/power cycle happens while disk
> metadata is corrupted, the system will run into bootup failure if
> array is used as root, otherwise the array can not be assembled after
> boot if not used as root.
> 
> This issue will not happen for imsm array with only one member array,
> because the memory array has not be opened yet, monitor thread will
> not do any metadata updates.
> This can happen for imsm array with at lease two member array, in the
> following two scenarios:
> 1. Restarting mdmon process with at least two member array
> This will happen during system boot up or user restart mdmon after
> mdadm upgrade
> 2. Adding new member array to exist imsm array with at least one
> member array.
> 
> To fix this, delay the switching buffer operation to monitor thread.
> 
> Fixes: bbab0940fa75 ("imsm: write bad block log on metadata sync")
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> ---
>  managemon.c   |  6 ++++++
>  super-intel.c | 14 +++++++++++---
>  2 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/managemon.c b/managemon.c
> index d79813282457..855c85c3da92 100644
> --- a/managemon.c
> +++ b/managemon.c
> @@ -726,6 +726,7 @@ static void manage_new(struct mdstat_ent *mdstat,
>  	int i, inst;
>  	int failed = 0;
>  	char buf[SYSFS_MAX_BUF_SIZE];
> +	struct metadata_update *update = NULL;

If you are adding something new here, please follow reversed Christmas
tree convention.

>  
>  	/* check if array is ready to be monitored */
>  	if (!mdstat->active || !mdstat->level)
> @@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent *mdstat,
>  	/* if everything checks out tell the metadata handler we
> want to
>  	 * manage this instance
>  	 */
> +	container->update_tail = &update;
>  	if (!aa_ready(new) || container->ss->open_new(container,
> new, inst) < 0) {
> +		container->update_tail = NULL;
>  		goto error;
>  	} else {
> +		if (update)
> +			queue_metadata_update(update);
> +		container->update_tail = NULL;
>  		replace_array(container, victim, new);
>  		if (failed) {
>  			new->check_degraded = 1;
> diff --git a/super-intel.c b/super-intel.c
> index cab841980830..4988eef191da 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct
> intel_super *super, struct imsm_dev *dev, return failed;
>  }
>  
> +static int imsm_prepare_update(struct supertype *st,
> +			       struct metadata_update *update);
>  static int imsm_open_new(struct supertype *c, struct active_array *a,
>  			 int inst)
>  {
>  	struct intel_super *super = c->sb;
>  	struct imsm_super *mpb = super->anchor;
> -	struct imsm_update_prealloc_bb_mem u;
> +	struct imsm_update_prealloc_bb_mem *u;
> +	struct metadata_update mu;
>  
>  	if (inst >= mpb->num_raid_devs) {
>  		pr_err("subarry index %d, out of range\n", inst);
> @@ -8482,8 +8485,13 @@ static int imsm_open_new(struct supertype *c,
> struct active_array *a, dprintf("imsm: open_new %d\n", inst);
>  	a->info.container_member = inst;
>  
> -	u.type = update_prealloc_badblocks_mem;
> -	imsm_update_metadata_locally(c, &u, sizeof(u));
> +	u = xmalloc(sizeof(*u));
> +	u->type = update_prealloc_badblocks_mem;
> +	mu.len = sizeof(*u);
> +	mu.buf = (char *)u;
> +	imsm_prepare_update(c, &mu);
> +	if (c->update_tail)
> +		append_metadata_update(c, u, sizeof(*u));
>  
>  	return 0;
>  }

I don't see issues, so you have my approve but it is Intel owned code
and I need Intel to approve.
.
Blazej, Could you please create Github PR with a patch if Intel is good
with the change? I would like to see test results before merge.

Thanks,
Mariusz
