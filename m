Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D023F23C2;
	Wed, 27 May 2026 11:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779880347; cv=none; b=UcEgg58tmT0j7e9TaXTWVhn6R0zhwiyVHSqT3WGOMcxoVpm4xbZIhtaYPOnKvD27nIFmUZseyTxxYk523Jm+hJnsonvZ7pe4xs5G7CEkQ7tIu0A+upwcnAoSk9vb9vhkO3pPQ2ZOiOBudnhamppswgrKFGdRwiTEDGZeqpX1y/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779880347; c=relaxed/simple;
	bh=/mjBrz6D+Nix+5PhgFPE6cWeeCIXFyFQUj7r8yVXsDI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bxx/Zig2LRbo9XSgWyvzCQ100g6u4trxcRHHMmNp20BscyCDkBapOFToouaPKBV6XTUPhIoegKCyHcBtXOJndKNS8Hm6y77XWsf+k6tLweiTqNkjO4R+5fTd3Jb3QjzJuTPfTH/51+H6bOw6lOPrqHuNeRIzkSah9fX1EIKWFEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACC0jpyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACC0jpyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6E41F000E9;
	Wed, 27 May 2026 11:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779880346;
	bh=FOPWFf5iskkWPh+w/MW97eAXySaXHhiPn9n33M/hFWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ACC0jpyFzYuGPzHT0IpPesOKu6k+b1ZeJtN0/42mOJWfTwNecuSpl5c6cZfhh/WHX
	 H6TqQ4mwS0dVvD6E65TunVe5sYJ+Eovn9YjvNgN4PPhgT2fhgLwE1p6gWPQZMKnrz1
	 xhmCKZe8eUgGmBjCNgA95sCZBfyugTErfeJCYIcqD66VF1a7NljSrJODWLX/gzjdrf
	 Gdt00RsZ7cedKPCfGnbjetIsxu2Mk9b8RxDtJl1HmcMANffJ3sU0qXlVJKckNljB3f
	 Cqic25AcXbv6NUCQNy4zO08xyH3GHBV1e62E22Wn7gr7JDSf4qWdZDXd2lpCjgvw4S
	 f8SCy70xyuNHQ==
Date: Wed, 27 May 2026 14:12:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/raid6: use kmalloc() in raid6_select_algo()
Message-ID: <ahbRlHKXTRUR7a-C@kernel.org>
References: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
 <20260520-lib-v1-2-cb3045bef2d8@kernel.org>
 <20260520140657.2b5b5f3b@pumpkin>
 <ahWwYIOycuWZnETn@kernel.org>
 <20260527093720.1261e697@pumpkin>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527093720.1261e697@pumpkin>

On Wed, May 27, 2026 at 09:37:20AM +0100, David Laight wrote:
> On Tue, 26 May 2026 17:38:24 +0300
> Mike Rapoport <rppt@kernel.org> wrote:
> 
> > On Wed, May 20, 2026 at 02:06:57PM +0100, David Laight wrote:
> > > On Wed, 20 May 2026 11:17:52 +0300
> > > "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:
> > >   
> > > > raid6_select_algo() allocates an order 3 (8 pages) buffer that is used
> > > > as a scratch area for selection of the best algorithm.  
> > > 
> > > Should this code really be using a 4k buffer rather than a PAGE_SIZE one?  
> > 
> > Why?
> 
> Why a PAGE_SIZE buffer at all?
> The real data will either be file-system block/fragment or raid stripe sized.
> Neither is directly related to the memory system page size.
> 
> This actually a valid question for pretty much all of these changes.
> 
> Most architectures use 4k pages (probably because 3-level page tables
> fit nicely into a 32bit word and it gave a reasonable number of pages
> for 1980s systems) but some use much larger pages; I think 64k and 256k
> both get used.
> (IIRC m68k hardware uses 2k pages, but Linux uses them in pairs.)
> Larger pages reduce allocation costs, TLB pressure and memory overhead.
> But can waste memory especially for mmap() of small files.
> 
> Most of these functions just want 'a reasonable sized buffer'.
> Possibly requesting whole pages was originally cheaper.
> But I also suspect people have written PAGE_SIZE as a name for 4096.
> (Much the same as they forget that some systems have 256 byte cache lines.)
> 
> For these changes I think I'd at least add a note in the commit message
> when nothing external relies in the size of the buffer and that it could
> be changed to 4k.

The changes from gfp to kmalloc are intentionally mechanical and
intentionally keep the same allocation size. 

The point of these changes is to stop using ancient and ugly gfp and change
users that need a buffer to use kmalloc().
It will also make it easier to differentiate uses that actually need the
*page* for the folio project.

What is the actual buffer size required is a completely different audit and
it's not related to API usage change.
 
> -- David

-- 
Sincerely yours,
Mike.
