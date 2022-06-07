Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFACC43334
	for <linux-raid@archiver.kernel.org>; Tue,  7 Jun 2022 06:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiFGGcg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Jun 2022 02:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiFGGce (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Jun 2022 02:32:34 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA739BE3F
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 23:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654583552; x=1686119552;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pa5e/igRmbF6Qn1o3ytDVmE4aveVPpQBmjMthvH5QHw=;
  b=HvGdf1c52a5rOM+o2buOV1xtOl2K//c8qU6vumDO0ELahVj/68qvL8X8
   Hi68krLakaL6L0FBDMfY70RCsaoU5pylzJ0aS+6pl+eOvHa9ot/EcqQ7M
   U8XAXxfhRLYvAOPMx6D8x/NU1FqpyeqYvwuiLRuiIuO64VvRziWG8Icy8
   vIahZIJJEfdFTFBVy5c+Isbg0BMZ4erUERsVVs37qX8qel0AbhyWgDqHP
   H0yzhTaypgbkQjNZkFLQMG0WmNT7b5atmeF73ifJf5hoEZPrGyxIlDBlj
   4sbhRq3Zz89geGLMiC1W0AG7MIRX4ZawdOmgI5fwuIxObNC9TL+GBQwot
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10370"; a="337958719"
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="337958719"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 23:32:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,283,1647327600"; 
   d="scan'208";a="635972578"
Received: from paarayac-mobl.amr.corp.intel.com (HELO localhost) ([10.252.44.134])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 23:32:30 -0700
Date:   Tue, 7 Jun 2022 08:32:25 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Wu Guanghao <wuguanghao3@huawei.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org, linfeilong@huawei.com,
        lixiaokeng@huawei.com
Subject: Re: [PATCH 5/5] get_vd_num_of_subarray: fix memleak
Message-ID: <20220607083225.00006c76@linux.intel.com>
In-Reply-To: <1cbeaaa7-4b49-478a-9333-1885e8047a3f@molgen.mpg.de>
References: <00992179-9572-ceb4-eb49-492c42e67695@huawei.com>
        <f1bee99f-a9b0-0e58-36fb-e5eee110dcc9@huawei.com>
        <20220531101132.00002141@linux.intel.com>
        <1cbeaaa7-4b49-478a-9333-1885e8047a3f@molgen.mpg.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 31 May 2022 10:25:31 +0200
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Mariusz,
> 
> 
> Am 31.05.22 um 10:11 schrieb Mariusz Tkaczyk:
> > On Tue, 31 May 2022 14:51:13 +0800 Wu Guanghao wrote:
> >   
> >> sra = sysfs_read() should be free before return in
> >> get_vd_num_of_subarray()
> >>
> >> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> >> ---
> >>   super-ddf.c | 9 +++++++--
> >>   1 file changed, 7 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/super-ddf.c b/super-ddf.c
> >> index 8cda23a7..827e4ae7 100644
> >> --- a/super-ddf.c
> >> +++ b/super-ddf.c
> >> @@ -1599,15 +1599,20 @@ static unsigned int get_vd_num_of_subarray(struct
> >> supertype *st) sra = sysfs_read(-1, st->devnm, GET_VERSION);
> >>   	if (!sra || sra->array.major_version != -1 ||
> >>   	    sra->array.minor_version != -2 ||
> >> -	    !is_subarray(sra->text_version))
> >> +	    !is_subarray(sra->text_version)) {
> >> +		if (sra)
> >> +			sysfs_free(sra);
> >>   		return DDF_NOTFOUND;
> >> +	}
> >>
> >>   	sub = strchr(sra->text_version + 1, '/');
> >>   	if (sub != NULL)
> >>   		vcnum = strtoul(sub + 1, &end, 10);
> >>   	if (sub == NULL || *sub == '\0' || *end != '\0' ||
> >> -	    vcnum >= be16_to_cpu(ddf->active->max_vd_entries))
> >> +	    vcnum >= be16_to_cpu(ddf->active->max_vd_entries)) {
> >> +		sysfs_free(sra);
> >>   		return DDF_NOTFOUND;
> >> +	}
> >>
> >>   	return vcnum;
> >>   }  
> > 
> > Acked-by:mariusz.tkaczyk@linux.intel.com  
> 
> Thank you for your review. The common format is:
> 
> Acked-by: Name <address>
> 
> 
Hi Paul,
Thanks, fixed.

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
