Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6461C44236B
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789392040; cv=none; b=oi5pEQHE95JmQQN+ChHrA6YLzL/h2MEEnBJPH+xaqnwHUbs3SsEfzaxrXCZ9LdHK8PT4MoSpdrkG0qBHvNrztrxUbZLRfo6r+0qVFVyy6BVU64DzfBqNlJD8Dy6OkJ4fVBz8GDGKGPr7M5tT8HPaz9mSTtI+xDNNTmEesRPIf3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789392040; c=relaxed/simple;
	bh=3yaLPciVpIAZ+xMa44FL+/yZ2JI2YsunC2HNCYWVP2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9FprRUlBk3vqDha49dwxlrnRrgAOReOmg9iMz5YRglhC3r+yaV0tViCh9CQTjtz1wGM/XIN+311cx7y6Oy6VBKWRuafZa5uFsOBMOZKPQYNP9jxHXTPdNSDrxFmPqydhX3TW3IzH+2jZxi6qj6UdYUZAyhfNBZk2t9pB6ublkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBKIsaKR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBKIsaKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064621F000FF;
	Mon, 14 Sep 2026 13:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789392039;
	bh=orxAc0wt0M8waCKEvwFhCIWDtrkkET2gxeAVkxTu4Mg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LBKIsaKRTY4xRWlzST/Dz3nKFY7/pWk1362hguSNZVpr34d74xi8W8V2QfMY13Unn
	 iXkAIfAewo6fKchK/hcEGyugaOTQ1HeKpWaNlvsAy0FhQCRkh9blWWBf/TTwonGdYG
	 Sv28VrMD8LcYWGuwtScOEnxptMEx7DHd37JRHsLVZBxtl60SWn4saOHXm45/AzjABX
	 pPjzhlixZEeWGbpW8suidfcDBmomzvVgeDlBGS9sNYooAl+LFWGRRlPMHnDiW+6yAO
	 rPaUlgBn5Uo+UaRV8B5ouV0mCdJC7oLxgLwdxovGP4P0tDdyqvNZVKL6p5rQoGUHmM
	 /yXu5yV1eGEfQ==
Message-ID: <37784fda-a91d-4b70-864a-67b62aed1828@kernel.org>
Date: Mon, 14 Sep 2026 15:20:34 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] md: Use folio_alloc_buffers()
To: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, linux-raid@vger.kernel.org, linux-mm@kvack.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-1-willy@infradead.org>
 <7efaff54-3f19-4c0c-a8c9-fcbacb1aa4e2@kernel.org>
 <aqf0A22W4MHXD9wG@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqf0A22W4MHXD9wG@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/14/26 15:17, Matthew Wilcox wrote:
> On Mon, Sep 14, 2026 at 03:12:31PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/14/26 06:18, Matthew Wilcox (Oracle) wrote:
>>> Remove the last user of alloc_page_buffers().  This isn't _great_,
>>
>> You should tell us "why" this isn't great.
>>
>> Because we're allocating folios although these things are not actually folios? I
>> can only speculate :)
> 
> Well, we actually aren't allocating folios in md-bitmap:
> 
>         for ( ; pnum < num_pages; pnum++) {
>                 store->filemap[pnum] = alloc_page(GFP_KERNEL|__GFP_ZERO);
> 
> and it's not clear to me that we should be allocating folios; they're
> internal memory to the md-bitmap code that are never mapped to userspace,
> nor enter the page cache.  But they do have buffer heads attached to them.

Confusing indeed.

> 
> The md-bitmap code probably needs to be rewritten to not use buffer heads
> at all, but then I hear from some people that it's scheduled for deletion,
> so don't spend any time on it.  But I can't find anything official about
> that anywhere.
> 
>> Code itself looks good.
> 
> Thanks!

I'd assume Zi will pick up your patches and can massage the patch description to
summarize why folios are awkward here, but that cleaning this up is future work.

-- 
Cheers,

David
