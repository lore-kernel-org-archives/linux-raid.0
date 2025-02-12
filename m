Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBBA201270
	for <linux-raid@vger.kernel.org>; Wed, 12 Feb 2025 21:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739397105; cv=none; b=o+0i/QLZP7ZwaIOISlLSglN6h02kGMJHzJ6FF6K4fxal47os9R8qfnG9eS/SJZG0NYSG9gn/y2Nj5VNaNIF9flpjaT/+2Cp4JNH2IZLLTu0mZMrT9GVt1GpkQwgAkRk2RR6BfvXTCWIvRBHjiE81Qakan9x9yT2SdqAC27vbGqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739397105; c=relaxed/simple;
	bh=3znicSa7J60lEBPbACbAO3TwohBdDBgOzMUpu1IrGNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QaLngiXQg9l9AhkNpi7YJfAmiQPCL5jrvs+n5JGhpmI1nEN3OeIZG3OT2Yu+++v16YhFCOuWNJXORNmnZ/6Z0rYPQlJFzwLe3LESY4NlmM6dQ0MIT1/12tPWY+PEYBE7u6+lZhNDDBe7IIIl5IfR82Ku05OC9PLk89QNcyVAPzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W2LtFwHg; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W2LtFwHg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739397104; x=1770933104;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3znicSa7J60lEBPbACbAO3TwohBdDBgOzMUpu1IrGNQ=;
  b=W2LtFwHgbRGy29x3Zuy1e6fTzYvuOO5ZS3lS6ISHIWQcLIrLGVgy3Oq5
   LLTweKNAx0Kmb6ekN4Q9jVNGkxq/V34JnpNRy1eG4rgrPpVZCWIUfZW3c
   SDnbzpoXC8hVaiHwtQ5LcW/yVxmuRipRCSpyxQl4XGBA0B6Qtdg69hzCE
   OnyLz2ZjNuOpNVQCcoLRqSmU0RU7RSxCUFwCsIKCtg+5FyC0sF5qGddoi
   85AkPKUUG/EEa7iLJFRDBZlklx0q3+juFm7JsX1TXcP5rcZt7p0CogxkH
   /Y2lrFcJVVkaYmVF7uhx6K2pAaBfN3/uQg8MeIP/5IsXKbWf6UerADLsF
   g==;
X-CSE-ConnectionGUID: dmu4n7cvTj2BwCi39tJTrg==
X-CSE-MsgGUID: QF5SFD51StCfAKWFJkjamg==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="39957158"
X-IronPort-AV: E=Sophos;i="6.13,281,1732608000"; 
   d="scan'208";a="39957158"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 13:51:43 -0800
X-CSE-ConnectionGUID: QDEd/BymQAGt2vPNy4QeRQ==
X-CSE-MsgGUID: ddZZREcrQyK+LozI9mSJRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="113854686"
Received: from bkucman-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.116.32])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 13:51:40 -0800
Date: Wed, 12 Feb 2025 22:51:34 +0100
From: Blazej Kucman <blazej.kucman@linux.intel.com>
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>, linux-raid@vger.kernel.org,
 ncroxon@redhat.com, song@kernel.org, xni@redhat.com, yukuai@kernel.org
Subject: Re: [PATCH] mdmon: imsm: fix metadata corruption when managing new
 array
Message-ID: <20250212225016.000060d9@linux.intel.com>
In-Reply-To: <20250212110713.1f112947@mtkaczyk-private-dev>
References: <20250210212225.10633-1-junxiao.bi@oracle.com>
 <20250212110713.1f112947@mtkaczyk-private-dev>
Organization: intel
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Feb 2025 11:07:13 +0100
Mariusz Tkaczyk <mtkaczyk@kernel.org> wrote:

> Hello Junxiao,
> Thanks for solid and complete explanation!
> 
> On Mon, 10 Feb 2025 13:22:25 -0800
> Junxiao Bi <junxiao.bi@oracle.com> wrote:
> 
> > When manager thread detects new array, it will invoke manage_new().
> > For imsm array, it will further invoke imsm_open_new(). Since
> > commit bbab0940fa75("imsm: write bad block log on metadata sync"),
> > it preallocates bad block log when opening the array, that requires
> > increasing the mpb buffer size.
> > To do that, imsm_open_new() invokes imsm_update_metadata_locally(),
> > which first uses imsm_prepare_update() to allocate a larger mpb
> > buffer and store it at "mpb->next_buf", and then invoke
> > imsm_process_update() to copy the content from current mpb buffer
> > "mpb->buf" to "mpb->next_buf", and then free the current mpb buffer
> > and set the new buffer as current.
> > 
> > There is a small race window, when monitor thread is syncing
> > metadata, it grabs current buffer pointer in
> > imsm_sync_metadata()->write_super_imsm(), but before flushing the
> > buffer to disk, manager thread does above switching buffer which
> > frees current buffer, then monitor thread will run into
> > use-after-free issue and could cause on-disk metadata corruption. If
> > system keeps running, further metadata update could fix the
> > corruption, because after switching buffer, the new buffer will
> > contain good metadata, but if panic/power cycle happens while disk
> > metadata is corrupted, the system will run into bootup failure if
> > array is used as root, otherwise the array can not be assembled
> > after boot if not used as root.
> > 
> > This issue will not happen for imsm array with only one member
> > array, because the memory array has not be opened yet, monitor
> > thread will not do any metadata updates.
> > This can happen for imsm array with at lease two member array, in
> > the following two scenarios:
> > 1. Restarting mdmon process with at least two member array
> > This will happen during system boot up or user restart mdmon after
> > mdadm upgrade
> > 2. Adding new member array to exist imsm array with at least one
> > member array.
> > 
> > To fix this, delay the switching buffer operation to monitor thread.
> > 
> > Fixes: bbab0940fa75 ("imsm: write bad block log on metadata sync")
> > Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> > ---
> >  managemon.c   |  6 ++++++
> >  super-intel.c | 14 +++++++++++---
> >  2 files changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/managemon.c b/managemon.c
> > index d79813282457..855c85c3da92 100644
> > --- a/managemon.c
> > +++ b/managemon.c
> > @@ -726,6 +726,7 @@ static void manage_new(struct mdstat_ent
> > *mdstat, int i, inst;
> >  	int failed = 0;
> >  	char buf[SYSFS_MAX_BUF_SIZE];
> > +	struct metadata_update *update = NULL;  
> 
> If you are adding something new here, please follow reversed Christmas
> tree convention.
> 
> >  
> >  	/* check if array is ready to be monitored */
> >  	if (!mdstat->active || !mdstat->level)
> > @@ -824,9 +825,14 @@ static void manage_new(struct mdstat_ent
> > *mdstat, /* if everything checks out tell the metadata handler we
> > want to
> >  	 * manage this instance
> >  	 */
> > +	container->update_tail = &update;
> >  	if (!aa_ready(new) || container->ss->open_new(container,
> > new, inst) < 0) {
> > +		container->update_tail = NULL;
> >  		goto error;
> >  	} else {
> > +		if (update)
> > +			queue_metadata_update(update);
> > +		container->update_tail = NULL;
> >  		replace_array(container, victim, new);
> >  		if (failed) {
> >  			new->check_degraded = 1;
> > diff --git a/super-intel.c b/super-intel.c
> > index cab841980830..4988eef191da 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -8467,12 +8467,15 @@ static int imsm_count_failed(struct
> > intel_super *super, struct imsm_dev *dev, return failed;
> >  }
> >  
> > +static int imsm_prepare_update(struct supertype *st,
> > +			       struct metadata_update *update);
> >  static int imsm_open_new(struct supertype *c, struct active_array
> > *a, int inst)
> >  {
> >  	struct intel_super *super = c->sb;
> >  	struct imsm_super *mpb = super->anchor;
> > -	struct imsm_update_prealloc_bb_mem u;
> > +	struct imsm_update_prealloc_bb_mem *u;
> > +	struct metadata_update mu;
> >  
> >  	if (inst >= mpb->num_raid_devs) {
> >  		pr_err("subarry index %d, out of range\n", inst);
> > @@ -8482,8 +8485,13 @@ static int imsm_open_new(struct supertype *c,
> > struct active_array *a, dprintf("imsm: open_new %d\n", inst);
> >  	a->info.container_member = inst;
> >  
> > -	u.type = update_prealloc_badblocks_mem;
> > -	imsm_update_metadata_locally(c, &u, sizeof(u));
> > +	u = xmalloc(sizeof(*u));
> > +	u->type = update_prealloc_badblocks_mem;
> > +	mu.len = sizeof(*u);
> > +	mu.buf = (char *)u;
> > +	imsm_prepare_update(c, &mu);
> > +	if (c->update_tail)
> > +		append_metadata_update(c, u, sizeof(*u));
> >  
> >  	return 0;
> >  }  
> 
> I don't see issues, so you have my approve but it is Intel owned code
> and I need Intel to approve.
> .
> Blazej, Could you please create Github PR with a patch if Intel is
> good with the change? I would like to see test results before merge.

Hi
I've added a PR on github, I'll review this change by the end of the
week.

PR: https://github.com/md-raid-utilities/mdadm/pull/152

Thanks,
Blazej

> 
> Thanks,
> Mariusz

