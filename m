Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7EACDB474
	for <linux-raid@archiver.kernel.org>; Tue, 17 Oct 2023 07:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234689AbjJQHgZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Oct 2023 03:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbjJQHgL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Oct 2023 03:36:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F18AB
        for <linux-raid@vger.kernel.org>; Tue, 17 Oct 2023 00:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697528170; x=1729064170;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QY0ZgugMcOFrM4VoIT2L1Am32SfMhCYQh6Yt3FwsBC8=;
  b=NREb4gmPG4vlPtB31OfQHWrAed651A8kbMNxwhbo7/g1rZpfYYnpSwsM
   J7TbhLFTGuns4Z8C8QOAZ15qdlFoOBLSaemPlx2bkXGPjqmXQ7lBuQsTg
   6X0Z/Muzr0bdNfLcEfz3WAwyTjurBPz4iBjgxGEQXIJZQe/XljRa/amiu
   G/5ND7AGfeGf0wy9w70hPXFCD8Ggsi58XC5zbhtOYVgMzbHwGLkQm9ECs
   C135P1Ld+HPQZEpUkih8aAuLnUZol3+5B88ymSUSj6lMgfE6Z+0lnQOjO
   jTNGdKM42GbA7t+KwLo8qHiv7cku21OsiIpYnise9MoXAaHhV3hK352Tm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="370790042"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="370790042"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 00:36:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="1087401877"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="1087401877"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.158.98])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 00:36:06 -0700
Date:   Tue, 17 Oct 2023 09:36:01 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, colyli@suse.de, neilb@suse.de,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH V2 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT for
 all raid0 after kernel v5.4
Message-ID: <20231017093601.000019e5@linux.intel.com>
In-Reply-To: <20231017035142.41168-1-xni@redhat.com>
References: <20231017035142.41168-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 17 Oct 2023 11:51:42 +0800
Xiao Ni <xni@redhat.com> wrote:

> After and include kernel v5.4, it adds one feature bit
> MD_FEATURE_RAID0_LAYOUT. It must need to specify a layout for raid0 with more
> than one zone. But for raid0 with one zone, in fact it also has a defalut
> layout.
> 
> Now for raid0 with one zone, *unknown* layout can be seen when running mdadm
> -D command. It's the reason that mdadm doesn't set MD_FEATURE_RAID0_LAYOUT for
> raid0 with one zone. Then in kernel space, super_1_validate sets mddev->layout
> to -1 because of no MD_FEATURE_RAID0_LAYOUT. In fact, in raid0 io path, it
> uses the default layout. So in fact after/include kernel v5.4, all raid0
> device have layout.
> 
> Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  super1.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/super1.c b/super1.c
> index 856b02082662..653a2ea6c0e4 100644
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

We need to keep this code. Neil made MD_FEATURE_RAID0_LAYOUT always added for
device with various sizes. You are extending it not replacing.

I understand that now it sets MD_FEATURE_RAID0_LAYOUT if it detects
member devices with various sizes. Kernel version is irrelevant so I suspect
that if someone creates zoned raid0 array, it fails to start array if
MD_FEATURE_RAID0_LAYOUT is not supported by the MD driver. User must
acknowledge that by layout=dangerous (it means no layout I think).

We don't want remove this. It prevents users from data corruption.

Your change is to start always setting MD_FEATURE_RAID0_LAYOUT if it seems to be
safe i.e. kernel is >=5.4 but it does not invalidate the raid0_need_layout
routine from the reason raised above.

Please correct me if I missed something or if I'm wrong. I did not tested it.
I trust that you made necessary testing and can provide real-life input here.

Thanks,
Mariusz
