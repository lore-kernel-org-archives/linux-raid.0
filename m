Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A21E3C8C7C;
	Tue, 26 May 2026 14:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779806312; cv=none; b=LmQ9c9kezk0wgI2UJ46IoU3aTsKJ7KzT+TXptllHRh/lOfL2iczZs0N7uxaZHlhRfF4FUkxrwIbyrvgDHKZmtpbmzYhRcWcMfvdhFhW7sYGMAYRw7ZkVaUwa+PbcYsb9ZN5ufev0J9NmwWM6rpvjnyOi93kPr9dZN0DoSOmcMjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779806312; c=relaxed/simple;
	bh=Ce6BfXGUbMs8QZtyXK+muC3B+95BNNsIWylglHJr7/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X8COJKk4GR4RkMNu+puf/3sIYubwEcYBsHQNxyPCJmcgIMm24gpCthAlzsx12/vS4d1sPOIyIkwyBETXme6G8PgYxyJpW2xsVNTMPMs6hZtkLOZkZaUNCpfejdk8W2nBSD6G2KEgnCSlOAPDiXuhBi23smJ7yFJ/nPpBifBe1IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=InvYwEai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="InvYwEai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F531F00A3A;
	Tue, 26 May 2026 14:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779806311;
	bh=L4CDmwaP8XGp4TRqjaoMu7IDWtjRrbz8fDYCZt9wbT4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=InvYwEaia1IxbLmUgiGxnrWQRZ/rw2K4n0gteTimX4S4DUqQW627G5DkgcDXlU6et
	 cEDQUQTNrDyjZif+fbxy0WDKsYJntWW/sBg1lzxTTYmMtMsV6b7/pX8jSvLqEC2L/b
	 JxVtBmf3ejggShlMihKUo531xnJtIBknzfbaK9h5fec6uu2ni++CO8k3kV80JohozP
	 J1UA6nLVlZeVkAqiqnJwClVZWd7Y3rd0kIF3jayLNAj2SzDGiSXmj91UuhTnVjJ54t
	 7bvZG1Oz7RkNLPtZFq5PKyXeZ+GGq4IP3fkQsdJUj00BfvLzIZigLnPRiyE0KtqEcG
	 xxx+qhItT4rUQ==
Date: Tue, 26 May 2026 17:38:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
Message-ID: <ahWwYIOycuWZnETn@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
 <20260520-lib-v1-2-cb3045bef2d8@kernel.org>
 <20260520140657.2b5b5f3b@pumpkin>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520140657.2b5b5f3b@pumpkin>

On Wed, May 20, 2026 at 02:06:57PM +0100, David Laight wrote:
> On Wed, 20 May 2026 11:17:52 +0300
> "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> 
> > raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> > as a scratch area for selection of the best algorithm.
> 
> Should this code really be using a 4k buffer rather than a PAGE_SIZE one?

Why?
 
> -- David
> 
> > 
> > For such large allocations kmalloc() would fall back to alloc_pages() but
> > still kmalloc() is a better API as it does not require unnecessary
> > castings and may provide more debugging possibilities.
> > 
> > Replace __get_free_pages() call with kmalloc().
> > 
> > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  lib/raid6/algos.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > index 799e0e5eac26..89e627c62e30 100644
> > --- a/lib/raid6/algos.c
> > +++ b/lib/raid6/algos.c
> > @@ -12,6 +12,7 @@
> >   */
> >  
> >  #include <linux/raid/pq.h>
> > +#include <linux/slab.h>
> >  #ifndef __KERNEL__
> >  #include <sys/mman.h>
> >  #include <stdio.h>
> > @@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
> >  #endif
> >  
> >  #define RAID6_TEST_DISKS	8
> > -#define RAID6_TEST_DISKS_ORDER	3
> >  
> >  static inline const struct raid6_recov_calls *raid6_choose_recov(void)
> >  {
> > @@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
> >  	int i, cycle;
> >  
> >  	/* prepare the buffer and fill it circularly with gfmul table */
> > -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> > +	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
> >  	if (!disk_ptr) {
> >  		pr_err("raid6: Yikes!  No memory available.\n");
> >  		return -ENOMEM;
> > @@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
> >  	/* select raid recover functions */
> >  	rec_best = raid6_choose_recov();
> >  
> > -	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
> > +	kfree(disk_ptr);
> >  
> >  	return gen_best && rec_best ? 0 : -EINVAL;
> >  }
> > 
> 
> 

-- 
Sincerely yours,
Mike.
