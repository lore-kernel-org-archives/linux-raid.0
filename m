Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JrGdOvJA"
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A720DB;
	Tue, 12 Dec 2023 01:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702373704; x=1733909704;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MHJAz3v3MCO7iUNVoczO1+k4R+v5yY9xBnHLxI+eAq8=;
  b=JrGdOvJA4V9zs9c4AvF0uzRtYvXs5VBWD3ksOmNO3ldxwTubEEbRBQGo
   h1rbziswX5Qg6HTXJU8RdAwNM4mXthTrvWnDBn4YY5eHhlqLVdNhOPj7S
   6AepYPF2KEFc3NLNbdZExPKYdp8y07dpxtLw5J4KlLWmNAIZR0RHLp/wl
   7uXIBORsb9XOSkUjGIa23ZaGYsqKMge5QNsDSRIu/P+BUcYrXvQgZA9YB
   oucs2gkAvHeP13dm1DKcYpAU5VkCH7+4PSFexklE4MbBUdUH96Now1Wvb
   z0B7uupvYWJ6HxKqdSGjmzvPfR/Np47OgV+N6N8NJ7DAd5aqpAs5ZTFHH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="16331454"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="16331454"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 01:35:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="14890458"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.144.153])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2023 01:34:59 -0800
Date: Tue, 12 Dec 2023 10:34:46 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linan666@huaweicloud.com, song@kernel.org, zlliu@suse.com,
 neilb@suse.com, shli@fb.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com,
 yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] md: Don't clear MD_CLOSING when the raid is about to
 stop
Message-ID: <20231212103446.00007e41@linux.intel.com>
In-Reply-To: <f0ab24e5-eb0a-d564-19d4-b72ecedff34f@huaweicloud.com>
References: <20231211081714.1923567-1-linan666@huaweicloud.com>
	<20231211105620.00001753@linux.intel.com>
	<f0ab24e5-eb0a-d564-19d4-b72ecedff34f@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit

On Tue, 12 Dec 2023 11:21:28 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> Hi,
> 
> ÔÚ 2023/12/11 17:56, Mariusz Tkaczyk Ð´µÀ:
> > On Mon, 11 Dec 2023 16:17:14 +0800
> > linan666@huaweicloud.com wrote:
> >   
> >> From: Li Nan <linan122@huawei.com>
> >>
> >> The raid should not be opened anymore when it is about to be stopped.
> >> However, other processes can open it again if the flag MD_CLOSING is
> >> cleared before exiting. From now on, this flag will not be cleared when
> >> the raid will be stopped.
> >>
> >> Fixes: 065e519e71b2 ("md: MD_CLOSING needs to be cleared after called
> >> md_set_readonly or do_md_stop") Signed-off-by: Li Nan
> >> <linan122@huawei.com>  
> > 
> > Hello Li Nan,
> > I was there when I needed to fix this:
> > https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?h=md-next&id=c8870379a21fbd9ad14ca36204ccfbe9d25def43
> > 
> > For sure, you have to consider applying same solution for array_store
> > "clear". Minor nit below.
> > 
> > Thanks,
> > Mariusz
> >   
> >> ---
> >>   drivers/md/md.c | 8 +++-----
> >>   1 file changed, 3 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 4e9fe5cbeedc..ebdfc9068a60 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -6238,7 +6238,6 @@ static void md_clean(struct mddev *mddev)
> >>   	mddev->persistent = 0;
> >>   	mddev->level = LEVEL_NONE;
> >>   	mddev->clevel[0] = 0;
> >> -	mddev->flags = 0;  
> > 
> > I recommend (safety recommendation):
> > 	mddev->flags = MD_CLOSING;  
> 
> Taking a look I think both MD_CLOSING and MD_DELETED should not be
> cleared, however, there is no guarantee that MD_CLOSING will be set
> before md_clean, because mdadm can be removed without running. Hence I
> think just set MD_CLOSING is werid.
> 
> I think the proper way is to keep MD_CLOSING and MD_DELETED if they are
> set. However, there is no such api to clear other bits at once. Since
> we're not expecting anyone else to write flags, following maybe
> acceptable:
> 
> mddev->flags &= BIT_ULL_MASK(MD_CLOSING) | BIT_ULL_MASK(MD_DELETED);

Yes, MD_CLOSING is a bit number to not a bit value I can assign directly.
Thanks for clarifying!

Mariusz
> 
> Or after making sure other flags cannot race, this patch is ok.
> 
> Thanks,
> Kuai
> 
> > 
> > Unless you can prove that other flags cannot race.
> >   
> >>   	mddev->sb_flags = 0;
> >>   	mddev->ro = MD_RDWR;
> >>   	mddev->metadata_type[0] = 0;  
> > 
> > .
> >   
> 

