Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933639479
	for <linux-raid@vger.kernel.org>; Thu, 21 Dec 2023 05:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kRhdb6F3"
Date: Thu, 21 Dec 2023 00:30:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1703136619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3X2Kz2GJCI5v3h5PevwcewBKZ/aw39cvbj+ixcFBpQs=;
	b=kRhdb6F3QCIo1RU1bDvmnzBFQCHzmFoFzKqWLNqVISIfXMYCTJJVyA48acsD/Yge4a0fTl
	tCSNktFIPmrdLzvTNxefr7NveEsHT8KYn/UomP00iUPC+xR5cwM0EoaTu/X9qoxEbeK2XY
	T3IzLN1VvZALPZTG3b+27lPiOPCiMxI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Ed Tsai =?utf-8?B?KOiUoeWul+i7kik=?= <Ed.Tsai@mediatek.com>
Cc: "song@kernel.org" <song@kernel.org>,
	"bagasdotme@gmail.com" <bagasdotme@gmail.com>,
	"colyli@suse.de" <colyli@suse.de>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"janpieter.sollie@edpnet.be" <janpieter.sollie@edpnet.be>,
	"axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] block, md: Better handle REQ_OP_FLUSH
Message-ID: <20231221053016.72cqcfg46vxwohcj@moria.home.lan>
References: <20231221012715.3048221-1-song@kernel.org>
 <9dfc7e93f49f5b3595985ce6ed60e4c08cf05a4c.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9dfc7e93f49f5b3595985ce6ed60e4c08cf05a4c.camel@mediatek.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Dec 21, 2023 at 03:36:40AM +0000, Ed Tsai (蔡宗軒) wrote:
> On Wed, 2023-12-20 at 17:27 -0800, Song Liu wrote:
> >  	 
> > External email : Please do not click links or open attachments until
> > you have verified the sender or the content.
> >  A recent bug report [1] shows md is handling a flush from bcachefs
> > as read:
> > 
> > bch2_journal_write=>
> >   submit_bio=>
> >     ...
> >     md_handle_request =>
> >       raid5_make_request =>
> >         chunk_aligned_read =>
> >           raid5_read_one_chunk =>
> > 	    ...
> > 
> > It appears md code only checks REQ_PREFLUSH for flush requests, which
> > doesn't cover all cases. OTOH, op_is_flush() doesn't check
> > REQ_OP_FLUSH
> > either.
> > 
> > Fix this by:
> > 1) Check REQ_PREFLUSH in op_is_flush();
> > 2) Use op_is_flush() in md code.
> > 
> > Thanks,
> > Song
> > 
> > [1] 
> > https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id=218184__;!!CTRNKA9wMg0ARbw!gQbjtS_f5d3Du2prpIT8zUM4mkZf7qDleyaAuEfG8j5tMrDvw7cfJUB04VWl0uVAL4BJ4YWbVopp$
> > 
> 
> REQ_OP_FLUSH is only used by the block layer's flush code, and the
> filesystem should use REQ_PREFLUSH with an empty write bio.
> 
> If we want upper layer to be able to directly send REQ_OP_FLUSH bio,
> then we should retrieve all REQ_PREFLUSH to confirm. At least for now,
> it seems that REQ_OP_FLUSH without REQ_PREFLUSH in `blk_flush_policy`
> will directly return 0 and no flush operation will be sent to the
> driver.

If that's the case, then it should be documented and there should be a
WARN_ON() in generic_make_request().

Also, glancing at blk_types.h, we have the req_op and req_flag_bits both
using (__force blk_opf_t), but using the same bit range - what the hell?
That's seriously broken...
