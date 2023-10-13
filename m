Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A0F5CDB47E
	for <linux-raid@archiver.kernel.org>; Fri, 13 Oct 2023 09:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjJMJap (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Oct 2023 05:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbjJMJan (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Oct 2023 05:30:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D15C9
        for <linux-raid@vger.kernel.org>; Fri, 13 Oct 2023 02:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697189442; x=1728725442;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zdJDSAJLt5rZPvMdxL2eDaQC8fZ4bm1iyGNHnre8ixg=;
  b=fHJ1er2dlb714fryVfpAHf8I6Trgy6wimfRosRJ3gmk7PoIJS1MPx7pq
   SUFp/hgoFLJDHPCn4jR9ELU1GHoG4dx+bDDRKHWqBLXESaPJLWoSDRSdt
   oqsJfUMmBYkRwCHu3wv/vAScr9gUCIabauQ9qNEcUfkfPkfJb4+KFSICu
   x4hBk5R2QjmCksZTU2AgLd9GGG+LAY3/EqM1EhlbQZ5KnqF7ire1LXbJl
   /8KN2A+f5udepFpTPYUBZjvVxRc9sLVhLHzRqGHVEr/P6aIRJ+eupS9kB
   B50NxQm3ybhK9MOBfDTX06RmAuqOgi/dZmkkIfty/538JLDh5TRBbJkmd
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="3738588"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="3738588"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 02:30:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10861"; a="789798642"
X-IronPort-AV: E=Sophos;i="6.03,221,1694761200"; 
   d="scan'208";a="789798642"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.156.199])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 02:30:39 -0700
Date:   Fri, 13 Oct 2023 11:30:34 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org, colyli@suse.de,
        neilb@suse.de
Subject: Re: [PATCH 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if
 sb->layout is set
Message-ID: <20231013113034.0000298a@linux.intel.com>
In-Reply-To: <20231011130522.78994-1-xni@redhat.com>
References: <20231011130522.78994-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 11 Oct 2023 21:05:22 +0800
Xiao Ni <xni@redhat.com> wrote:

> In kernel space super_1_validate sets mddev->layout to -1 if
> MD_FEATURE_RAID0_LAYOUT is not set. MD_FEATURE_RAID0_LAYOUT is set in mdadm
> write_init_super1. Now only raid with more than one zone can set this bit.
> But for raid0 with same size member disks, it doesn't set this bit. The
> layout is *unknown* when running mdadm -D command. In fact it should be
> RAID0_ORIG_LAYOUT which gets from default_layout.
> 
> So set MD_FEATURE_RAID0_LAYOUT when sb->layout has value.
> 
> Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  super1.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/super1.c b/super1.c
> index 856b02082662..f29751b4a5c7 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1978,26 +1978,10 @@ static int write_init_super1(struct supertype *st)
>  	unsigned long long sb_offset;
>  	unsigned long long data_offset;
>  	long bm_offset;
> -	int raid0_need_layout = 0;
>  
> -	for (di = st->info; di; di = di->next) {
> +	for (di = st->info; di; di = di->next)
>  		if (di->disk.state & (1 << MD_DISK_JOURNAL))
>  			sb->feature_map |= __cpu_to_le32(MD_FEATURE_JOURNAL);
> -		if (sb->level == 0 && sb->layout != 0) {
> -			struct devinfo *di2 = st->info;
> -			unsigned long long s1, s2;
> -			s1 = di->dev_size;
> -			if (di->data_offset != INVALID_SECTORS)
> -				s1 -= di->data_offset;
> -			s1 /= __le32_to_cpu(sb->chunksize);
> -			s2 = di2->dev_size;
> -			if (di2->data_offset != INVALID_SECTORS)
> -				s2 -= di2->data_offset;
> -			s2 /= __le32_to_cpu(sb->chunksize);
> -			if (s1 != s2)
> -				raid0_need_layout = 1;
> -		}
> -	}
>  
>  	for (di = st->info; di; di = di->next) {
>  		if (di->disk.state & (1 << MD_DISK_FAULTY))
> @@ -2139,8 +2123,7 @@ static int write_init_super1(struct supertype *st)
>  			sb->bblog_offset = 0;
>  		}
>  
> -		/* RAID0 needs a layout if devices aren't all the same size
> */
> -		if (raid0_need_layout)
> +		if (sb->level == 0 && sb->layout)
>  			sb->feature_map |=
> __cpu_to_le32(MD_FEATURE_RAID0_LAYOUT); 
>  		sb->sb_csum = calc_sb_1_csum(sb);
Hi Xiao,

I read Neil patch:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=329dfc28de

For sure Neil has a purpose to make it this way. I think that because it breaks
creation when layout is not supported by kernel. Neil wanted to keep possible
largest compatibility so it sets layout feature only if it is necessary.
Your change forces layout bit to be always used. Can you test this change on
kernel without raid0_layout support? I expect regression for same dev size raid
arrays.

I think that before we will set layout bit we should check kernel
version, it must be higher than 5.4. In the future we would remove this check.
So, it forces the calculations made by Neil back but I think that we can simply
compare dev_size and data_offset between members.

Thanks,
Mariusz
