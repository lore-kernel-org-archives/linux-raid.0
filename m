Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UkPzaIjQ"
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63D6F5
	for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 04:21:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701087710; x=1732623710;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N6O7KSlgZkTTDgZPIEVbV5nH9TojttJ95dfdKCb25vk=;
  b=UkPzaIjQ01jb5RAuAcSkFeXOcLgY1NgxqrxOkoaxyzV1uBL89jXZefCI
   guBKfrzbu6n2ulkwBSs+CyJAXkTSzMiFbfuK8Imcy1Hj9o/xM5gap/tGw
   JEIZmGufcbisT032yi6K1c+ixQVK8Ej221bMDZuAZ3Mnav6O0inn9pzFw
   CgiR0LzoVYHOGV40kaAb8bnHxac31nTL68A9KzDuwSKzaPcuEYnsJnfoA
   wpSKH2OBQS8fKCTCn9hOoW4IhCpkt5pMIAPyNDbCy8BC7QR494UVUo3Nu
   b+SZgCADC/FnsIFAOGZ8SzV/Vqe2XgmiLxSTjOrcSSKf2JfV7D1iI9Z/j
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10906"; a="395507510"
X-IronPort-AV: E=Sophos;i="6.04,230,1695711600"; 
   d="scan'208";a="395507510"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 04:21:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10906"; a="941542642"
X-IronPort-AV: E=Sophos;i="6.04,230,1695711600"; 
   d="scan'208";a="941542642"
Received: from cdewhirx-mobl.amr.corp.intel.com (HELO peluse-desk5) ([10.209.163.221])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 04:21:49 -0800
Date: Mon, 27 Nov 2023 04:21:48 -0800
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yiming Xu <teddyxym@outlook.com>, song@kernel.org,
 linux-raid@vger.kernel.org, paul.e.luse@intel.com, firnyee@gmail.com
Subject: Re: [RFC] md/raid5: optimize RAID5 performance.
Message-ID: <20231127042148.3b9bee3f@peluse-desk5>
In-Reply-To: <ZWQ63SpjIE4bc+pi@infradead.org>
References: <SJ2PR11MB75742EC42986F1532F7A0977D8BEA@SJ2PR11MB7574.namprd11.prod.outlook.com>
	<ZWQ63SpjIE4bc+pi@infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 26 Nov 2023 22:44:45 -0800
Christoph Hellwig <hch@infradead.org> wrote:

> Hi Shushu,
> 
> the work certainly looks interesting!
> 
> However:
> 
> > Optimized by using fine-grained locks, customized data structures,
> > and scattered address space. Achieves significant improvements in
> > both throughput and latency.
> 
> this is a lot of work for a single Linux patch, we usually do that
> work pice by pice instead of complete rewrite, and for such
> signigicant changes the commit logs also tend to be a bit extensive.
> 
> I'm also not quite sure what scattered address spaces are - I bet
> reading the paper (I plan to get to that) would explain it, but it
> also helps to explain the idea in the commit message.
> 
> That's my high level nitpicking for now, I'll try to read the paper
> and the patch in detail and come back later.
> 
> 

For sure the paper provides a lot more context. Is there more
performance data avialble, like a general sweep of various IO sizes,
patterns and queue depths?  ALso, what kind of data integrity testing
has been done?
