Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D0E3CE4A8
	for <linux-raid@vger.kernel.org>; Wed, 27 May 2026 08:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779871046; cv=none; b=P6NMv1Z0u8slyW91sw/dOv3gUTwT199DWVeB9dzgW3XNKXXH+/DH5Af9rxQozINnqSpwHz8rnqD1naFixIM08+KVIAJI42DuhPHfk0hBgi6/mSIu4BzD6pyNWI/p1ZxJlJf9PBM6nJn+GgcnXjdVDZusWbso5zgF2vvOMuTzhB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779871046; c=relaxed/simple;
	bh=TR4RppqQrhW7C8H5aWFoZW05M/00msAbjrFym8wIDj8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eukugb0JIdNY7XTHMHDMA15EHnnuWmbtPbdF4Aarp9klIjMuHDfWloWkrRkrfKN8fpX1Pasi3f61Mr8TevfjCePMjaNKgZvO5eXD7sCKyPSEZUiglq7KcPOYhNd5El0OtlBpB2pun8pWI6uPmn/86r7WXALo6ZxqMnQaMr6tazM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TkiNcp5Q; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TkiNcp5Q"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43fe608cb92so6972334f8f.2
        for <linux-raid@vger.kernel.org>; Wed, 27 May 2026 01:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779871042; x=1780475842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eraFftGzlHIcWWtP0S7CHyvFuivRxOgkzUrYiSBlxFU=;
        b=TkiNcp5QNUexcudSzv9/YiugFz9kYC0yKucGFasi90UjfBtuyDKhRw2rUozEaP2qVi
         IwxGEuscg+VQuoE+ylpqKETHK0w4R/aWMAyuarP4qSkb+snHNueAvh7kn9egehF1xwz1
         kOfAzCx+BfX6fFrh9F/snbE1C5NJo2ULxgGmrGIx8Ht212ktX00EPi9+GW2HpM9Ksbml
         bV5InGnAmpz0y5l+f1HBEZtI0d685sihshtBciWyU6s+GeeiNyrIAloJmqkG0qu5jCsP
         ilC6BQfhjrx4ZEcUaXAA3UsS0XlzngVZsPbUsMkBkwBEBdLJbjDCAc/doal4qtSYUczR
         64cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779871042; x=1780475842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eraFftGzlHIcWWtP0S7CHyvFuivRxOgkzUrYiSBlxFU=;
        b=piK2np0kBGrE489N0ECh77gTKNsIgyNR45bmMHIRoseSvHZKZBjcXjt3lyICK4xyvm
         Afz+eMP1kY6qEIaM/kRJ8VVGKkdijy1Wn6XhcEvlURt6v7vrhM98MS1yW7Ty7GeApJvq
         nKSVeu1+HUQE3kK6E/00qQx7M2tLE06plag2ijXd3vpK4zb5AK2uTjL9z7ynVXERuUtO
         ZtbYiONmH7VInn4MbFAihrUvWj5QaYuEx0gsmNbkMjVz7blcllj8Q7Fn6bYIBIe2SLQM
         UfE6tMn8ruyB9dRb98L7da/clMnxqexW6ILYaq7BcHoNOpDYO4pypaQyCSzf15MKycKq
         sZFQ==
X-Forwarded-Encrypted: i=1; AFNElJ/b7/4kWN9kCPfqcvKZSaXYl6MxBzeZvlYqL2v2caaxZsqAtGSep8qT10M+2NcNNowO8ySn5JztFVqk@vger.kernel.org
X-Gm-Message-State: AOJu0YyWoQ5MUjiANnUrzrIfLK2Iem+9+15SdzXnVUSuKeschHyXIsj/
	kBHYQPK3gF7EqT3hh7RpD4vLxbkxFbSflwPGHLZsheDCsrwElZN7TZUC
X-Gm-Gg: Acq92OFvXBCBQ/hyL+yr64FpOgY6PdSvnUBcep+NKgPGofTdchCH7KCNn3ploPGtX31
	Yn3H8sR3vOhuuKZYX9dSD0nsBwwsR9WfmZCWH6oGOYxlJ098M6cHEoy8/GgnlMXsuLVrFnNAmlt
	awLJmESkJDf24GgoQjGhGlLF9Fbmzf9T3PemvP9QyvDhzPkMcbhJCcajUuFJNJXxgv4VDY8xAGT
	wXdriYSSk6kbWEeTHS56YdOO1pVd5tkpJ/YXnB3S8sN7uoJxmlvKM+S9LjUAz5Bz25AWXsaVgnY
	gljDnjsIoNjAeY72QhnTHSYa/LWuUJyqdiEAE2+MaJ048TDOfajPUehYyjGfPu0UIOu9JXeGKtg
	xKug9n+ZzC5Gx49H/W2issPkdtxKpcLR1VaGIWskaE/x7WBxFzVZNEsQl8DeTYAFvAsPUUD9HXv
	OIQ/YtLOj5l3LyBpYEREpkJ2+AMET6WdhRvdFMRfglPYuvTv+ZGO3QKGmKSjPaJBaQ
X-Received: by 2002:a05:6000:1ac7:b0:451:bbe4:b48e with SMTP id ffacd0b85a97d-45eb36b025dmr37371799f8f.5.1779871042009;
        Wed, 27 May 2026 01:37:22 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45edb5c2323sm4483703f8f.34.2026.05.27.01.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 01:37:21 -0700 (PDT)
Date: Wed, 27 May 2026 09:37:20 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
Message-ID: <20260527093720.1261e697@pumpkin>
In-Reply-To: <ahWwYIOycuWZnETn@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
	<20260520-lib-v1-2-cb3045bef2d8@kernel.org>
	<20260520140657.2b5b5f3b@pumpkin>
	<ahWwYIOycuWZnETn@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 26 May 2026 17:38:24 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> On Wed, May 20, 2026 at 02:06:57PM +0100, David Laight wrote:
> > On Wed, 20 May 2026 11:17:52 +0300
> > "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> >   
> > > raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> > > as a scratch area for selection of the best algorithm.  
> > 
> > Should this code really be using a 4k buffer rather than a PAGE_SIZE one?  
> 
> Why?

Why a PAGE_SIZE buffer at all?
The real data will either be file-system block/fragment or raid stripe sized.
Neither is directly related to the memory system page size.

This actually a valid question for pretty much all of these changes.

Most architectures use 4k pages (probably because 3-level page tables
fit nicely into a 32bit word and it gave a reasonable number of pages
for 1980s systems) but some use much larger pages; I think 64k and 256k
both get used.
(IIRC m68k hardware uses 2k pages, but Linux uses them in pairs.)
Larger pages reduce allocation costs, TLB pressure and memory overhead.
But can waste memory especially for mmap() of small files.

Most of these functions just want 'a reasonable sized buffer'.
Possibly requesting whole pages was originally cheaper.
But I also suspect people have written PAGE_SIZE as a name for 4096.
(Much the same as they forget that some systems have 256 byte cache lines.)

For these changes I think I'd at least add a note in the commit message
when nothing external relies in the size of the buffer and that it could
be changed to 4k.

-- David


>  
> > -- David
> >   
> > > 
> > > For such large allocations kmalloc() would fall back to alloc_pages() but
> > > still kmalloc() is a better API as it does not require unnecessary
> > > castings and may provide more debugging possibilities.
> > > 
> > > Replace __get_free_pages() call with kmalloc().
> > > 
> > > Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
> > > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > ---
> > >  lib/raid6/algos.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > > index 799e0e5eac26..89e627c62e30 100644
> > > --- a/lib/raid6/algos.c
> > > +++ b/lib/raid6/algos.c
> > > @@ -12,6 +12,7 @@
> > >   */
> > >  
> > >  #include <linux/raid/pq.h>
> > > +#include <linux/slab.h>
> > >  #ifndef __KERNEL__
> > >  #include <sys/mman.h>
> > >  #include <stdio.h>
> > > @@ -129,7 +130,6 @@ const struct raid6_recov_calls *const raid6_recov_algos[] = {
> > >  #endif
> > >  
> > >  #define RAID6_TEST_DISKS	8
> > > -#define RAID6_TEST_DISKS_ORDER	3
> > >  
> > >  static inline const struct raid6_recov_calls *raid6_choose_recov(void)
> > >  {
> > > @@ -250,7 +250,7 @@ int __init raid6_select_algo(void)
> > >  	int i, cycle;
> > >  
> > >  	/* prepare the buffer and fill it circularly with gfmul table */
> > > -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> > > +	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
> > >  	if (!disk_ptr) {
> > >  		pr_err("raid6: Yikes!  No memory available.\n");
> > >  		return -ENOMEM;
> > > @@ -275,7 +275,7 @@ int __init raid6_select_algo(void)
> > >  	/* select raid recover functions */
> > >  	rec_best = raid6_choose_recov();
> > >  
> > > -	free_pages((unsigned long)disk_ptr, RAID6_TEST_DISKS_ORDER);
> > > +	kfree(disk_ptr);
> > >  
> > >  	return gen_best && rec_best ? 0 : -EINVAL;
> > >  }
> > >   
> > 
> >   
> 

