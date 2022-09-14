Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA5FFC6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 17:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiINRje (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 13:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiINRjc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 13:39:32 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC7CD97
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 10:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663177168; x=1694713168;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8oTHm6p/PaDPvnefvwoYFOAaihPwq9qut++1MPJkZOY=;
  b=LV4GWO/0UW0TUFKK3FAtfbocfx+TN83fT2Fp8oG5xBNqzahXDmITSIwp
   rOTyOn94oQdWZ3wWULcuKhgutcptntmvszurX7app0lfZcnTV5iO19Es9
   F6lYK4dtDIvVwIJ0A+Tqv1z1IAJFXv+nRnV+B3JBqRImrwWKau22o4ha0
   hsWO465EQbnUl99yvPAG7jG/2MXF8rbNahKJ2KE7QmCjtmeLGPw62QVeR
   IB3b7hSbqRA31ckuNEXmzssNxkrwa0hv/Ljdv77iZ1wjs7TBqqsUHo7uy
   nAwrdh6Qn7310VqaWjkfwxgMlSZB8d4QlJVdsG6bGAwwEGMq4MLxLPtNE
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="281526699"
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="281526699"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 10:39:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="679152197"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.226])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 10:39:23 -0700
Date:   Wed, 14 Sep 2022 19:39:19 +0200
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
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
Message-ID: <20220914193919.0000011e@linux.intel.com>
In-Reply-To: <0ecc42e3-53bf-ac8d-2154-db28f27fabc3@deltatee.com>
References: <20220908230847.5749-1-logang@deltatee.com>
        <20220908230847.5749-2-logang@deltatee.com>
        <20220909115749.00007431@linux.intel.com>
        <6dd46583-05ef-12e7-8a37-b732cbe79f23@deltatee.com>
        <20220913093559.0000438b@linux.intel.com>
        <856072cb-ebdf-52fe-1a13-857763077bca@deltatee.com>
        <20220914140106.00000b36@linux.intel.com>
        <0ecc42e3-53bf-ac8d-2154-db28f27fabc3@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 14 Sep 2022 10:29:53 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 2022-09-14 06:01, Mariusz Tkaczyk wrote:
> >>>> As I understand it the offset and size will give the bounds of the
> >>>> data region on the disk. Do you not think it works for zoned raid0?    
> >>>
> >>> mdadm operates on 512B, so using 4K data regions could be destructive.
> >>> Also left shift causes that size value is increasing. We can't clear more
> >>> that user requested. We need to use 512b sectors as mdadm does.    
> >>
> >> I don't really follow this.  
> > 
> > I understand that you want left shit is used to round size to data region
> > and I assumed that data_region is 4K and that is probably wrong.
> > You are right I has no sense, my apologizes.
> > 
> > Let's imagine that our size is for example, 2687 sectors. Left shit will
> > cause that we will get 2751488 and that will be passed as a size to
> > function. Similar for data_offset. That is much more than we want to clear.
> > Do I miss something? I guess that ioctl operates on sectors too but please
> > correct me if that is wrong.  
> 
> The BLKDISCARD ioctl assumes bytes for the range, not sectors. Though it
> does have to be sector aligned.
> 
> dv->data_offset is then in sectors, so we shift by 9.
> 
> s->size is in KB, so we shift by 10.
> 
Got it!
I will be thankful if you can create #defines for that. For Example:
KIB_TO_BYTES(s->size)
SEC_TO_BYTES(dv->offset)

We could reuse them later in other places.
Thanks,
Mariusz
