Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FFF634FF
	for <linux-raid@vger.kernel.org>; Thu, 21 Dec 2023 19:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ovewfNVW"
Date: Thu, 21 Dec 2023 14:19:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703186373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=an/cZCCqS5zxJSkNET76Ye0giZrXilZyvowEVOx+MQY=;
	b=ovewfNVWzTJ5/+VPMNm+np7pe6MWmkpAxMXribZGBxjpwXaPzz+UFxHbSv0KEBJG4G1WNi
	gOhO7sGPK7aPok4opifF0c7udDOMy0jCuXG/qjrv3QouBS3gZCws6aYI1pfcxxDr1M2VpE
	xSJPRz9kGBeMgSSE0eOOxZu+Gi0k8oM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Ed Tsai =?utf-8?B?KOiUoeWul+i7kik=?= <Ed.Tsai@mediatek.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"colyli@suse.de" <colyli@suse.de>,
	"song@kernel.org" <song@kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"janpieter.sollie@edpnet.be" <janpieter.sollie@edpnet.be>,
	"axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] block, md: Better handle REQ_OP_FLUSH
Message-ID: <20231221191930.fubcmftjkec42wsc@moria.home.lan>
References: <20231221012715.3048221-1-song@kernel.org>
 <9dfc7e93f49f5b3595985ce6ed60e4c08cf05a4c.camel@mediatek.com>
 <20231221053016.72cqcfg46vxwohcj@moria.home.lan>
 <fb146972062ea1547eaa809817237f7c546a9e88.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fb146972062ea1547eaa809817237f7c546a9e88.camel@mediatek.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 21, 2023 at 07:56:45AM +0000, Ed Tsai (蔡宗軒) wrote:
> On Thu, 2023-12-21 at 00:30 -0500, Kent Overstreet wrote:
> >  On Thu, Dec 21, 2023 at 03:36:40AM +0000, Ed Tsai (蔡宗軒) wrote:
> > > On Wed, 2023-12-20 at 17:27 -0800, Song Liu wrote:
> > > > you have verified the sender or the content.
> > > >  A recent bug report [1] shows md is handling a flush from
> > bcachefs
> > > > as read:
> > > > 
> > > > bch2_journal_write=>
> > > >   submit_bio=>
> > > >     ...
> > > >     md_handle_request =>
> > > >       raid5_make_request =>
> > > >         chunk_aligned_read =>
> > > >           raid5_read_one_chunk =>
> > > >     ...
> > > > 
> > > > It appears md code only checks REQ_PREFLUSH for flush requests,
> > which
> > > > doesn't cover all cases. OTOH, op_is_flush() doesn't check
> > > > REQ_OP_FLUSH
> > > > either.
> > > > 
> > > > Fix this by:
> > > > 1) Check REQ_PREFLUSH in op_is_flush();
> > > > 2) Use op_is_flush() in md code.
> > > > 
> > > > Thanks,
> > > > Song
> > > > 
> > > > [1] 
> > > > 
> > https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=218184__;!!CTRNKA9wMg0ARbw!gQbjtS_f5d3Du2prpIT8zUM4mkZf7qDleyaAuEfG8j5tMrDvw7cfJUB04VWl0uVAL4BJ4YWbVopp$
> > > > 
> > > 
> > > REQ_OP_FLUSH is only used by the block layer's flush code, and the
> > > filesystem should use REQ_PREFLUSH with an empty write bio.
> > > 
> > > If we want upper layer to be able to directly send REQ_OP_FLUSH
> > bio,
> > > then we should retrieve all REQ_PREFLUSH to confirm. At least for
> > now,
> > > it seems that REQ_OP_FLUSH without REQ_PREFLUSH in
> > `blk_flush_policy`
> > > will directly return 0 and no flush operation will be sent to the
> > > driver.
> > 
> > If that's the case, then it should be documented and there should be
> > a
> > WARN_ON() in generic_make_request().
> 
> Please refer to the writeback_cache_control.rst. Use an empty write bio
> with the REQ_PREFLUSH flag for an explicit flush, or as commonly
> practiced by most filesystems, use blkdev_issue_flush for a pure flush.

That's not a substitute for a proper comment in the code.

> 
> > 
> > Also, glancing at blk_types.h, we have the req_op and req_flag_bits
> > both
> > using (__force blk_opf_t), but using the same bit range - what the
> > hell?
> > That's seriously broken...
> 
> No, read the comment before req_op. We do not need to use the entire 32
> bits to represent OP; only 8 bits for OP, while the remaning 24 bits is
> used for FLAG.

No, this is just broken; it's using the same bitwise enum for two
different enums.

bitwise exists for a reason - C enums are not natively type safe, and
mixing up enums/bitflags and using them in the wrong context is a
serious source of bugs. If it would be incorrect to or the two different
flags together, you can't use the same bitwise type.
