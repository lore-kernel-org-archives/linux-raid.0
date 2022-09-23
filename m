Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8219C6FA82
	for <linux-raid@archiver.kernel.org>; Fri, 23 Sep 2022 11:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiIWLUT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Sep 2022 07:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiIWLUQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Sep 2022 07:20:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28799AF0F4
        for <linux-raid@vger.kernel.org>; Fri, 23 Sep 2022 04:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663932015; x=1695468015;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c6uw6xl7GI2thRYAoQSE6QrE1MayuITHQBkxlEuSscg=;
  b=Un26z3cKrLtw+hJB9uCtRGngmGWXS8RBylAJO77VLoqhL0DuwX+BN6Ct
   PRhsIC5Scjr2y/ht8+o0NtBYWLI4GyJLlP6s66IyHcQhJxl5B+hjtMP6d
   Ht5bNZUeyhFKgfaHlxOxDFIAIOleyYbcNdtrGjiOOl3+0Xc8e070Sj68i
   WXHTqMDY8cJPcuv21aObXpVV/qxD1Im3ubUaZh0Ql9BjcQfCG5go9uPng
   GkZB3YJlNNB+d4N/iZTTPfxhOku469NFasJdy2sg8E0ZiOSC3X1Vpr8/Y
   RoZ9GUO3SZGcuYsA/ROkZ2XjOITZf5mV144D484Dm0oGpg1Cdruf8mL/j
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="299290702"
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="299290702"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 04:20:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,339,1654585200"; 
   d="scan'208";a="571344747"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.213.16.20])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2022 04:20:11 -0700
Date:   Fri, 23 Sep 2022 13:20:06 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v3 5/7] mdadm: Add --write-zeros option for Create
Message-ID: <20220923132006.000006ce@linux.intel.com>
In-Reply-To: <20220921204356.4336-6-logang@deltatee.com>
References: <20220921204356.4336-1-logang@deltatee.com>
        <20220921204356.4336-6-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Logan,
One comment from my side.

Thanks,
Mariusz

On Wed, 21 Sep 2022 14:43:54 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> Add the --write-zeros option for Create which will send a write zeros
> request to all the disks before assembling the array. After zeroing
> the array, the disks will be in a known clean state and the initial
> sync may be skipped.
> 
> Writing zeroes is best used when there is a hardware offload method
> to zero the data. But even still, zeroing can take several minutes on
> a large device. Because of this, all disks are zeroed in parallel using
> their own forked process and a message is printed to the user. The main
> process will proceed only after all the zeroing processes have completed
> successfully.
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> 
> fixup! mdadm: Add --write-zeros option for Create
> ---

> diff --git a/mdadm.h b/mdadm.h
> index 1ab31564efef..c7e00195d8c8 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -273,6 +273,9 @@ static inline void __put_unaligned32(__u32 val, void *p)
>  
>  #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
>  
> +#define KIB_TO_BYTES(x)	((x) << 10)
> +#define SEC_TO_BYTES(x)	((x) << 9)
> +
>  extern const char Name[];
>  
>  struct md_bb_entry {
> @@ -387,6 +390,8 @@ struct mdinfo {
>  		ARRAY_UNKNOWN_STATE,
>  	} array_state;
>  	struct md_bb bb;
> +
> +	pid_t zero_pid;
>  };

mdinfo is  used  for raid properties. It is used for both system (sysfs_read())
and metadata(getinfo_super()). zero_pid property doesn't fit well there, it is
used once during creation. Could you please add it to mddev_dev struct or add
it to local array /list? 

