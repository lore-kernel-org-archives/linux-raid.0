Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F089FC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 29 Jun 2022 13:12:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiF2NMV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Jun 2022 09:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiF2NMT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Jun 2022 09:12:19 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50481DA75
        for <linux-raid@vger.kernel.org>; Wed, 29 Jun 2022 06:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656508338; x=1688044338;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PlDS7wB5hVQMFB8kuKsJEVonmbOIbN5VNNq+YmGXnHM=;
  b=Ge7VJyPG/IWbBQ6VW2LDLJHfrM7S9tg2wdRw8SBiv68UOCc0jx9o0kwU
   AObqeh1K8iQJ3v7NjVneYnnzhamXWX6qeC73aTw4SE68OYhh1HU5FFPFG
   MCqEbg0oCECLI5lZotAexYumxKc9B6tAwS6nw/rM6ojhYrLTJYqvdAfz4
   uTPCRg4vBBmsRmC6SEfoJXBYthxOpNi0+ao+CoS65+ECDkbKB8BZbzUCQ
   K/ZZBzL+D9NkxOpGbV7XCko+rpQcfZIaualhM0YiLLor6rkLOz2VJX77K
   61N+WCf9nue1klcsiK4u6mF4xp057+DJ00iqBgDjhxFQBtr/m7Evm0bEQ
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368339395"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="368339395"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 06:12:18 -0700
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="647388587"
Received: from mkusiak-mobl.ger.corp.intel.com (HELO [10.213.24.105]) ([10.213.24.105])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 06:12:17 -0700
Message-ID: <43497f54-7b9f-7ad3-b965-b9f83a3fbed3@linux.intel.com>
Date:   Wed, 29 Jun 2022 15:12:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
Content-Language: pl
To:     Coly Li <colyli@suse.de>, Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
 <A520DF12-AC0A-4E2E-9E96-0FEEA001C4DC@suse.de>
 <702B9063-D708-451A-A8F2-6DFD77728B9B@suse.de>
From:   "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
In-Reply-To: <702B9063-D708-451A-A8F2-6DFD77728B9B@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/06/2022 17:56, Coly Li wrote:
> 
> 
>> 2022年6月21日 01:21，Coly Li <colyli@suse.de> 写道：
>>
>>
>>
>>> 2022年6月9日 15:41，Mateusz Kusiak <mateusz.kusiak@intel.com> 写道：
>>>
>>> Grow_reshape should be split into helper functions given its size.
>>> - Add helper function for preparing reshape on external metadata.
>>> - Close cfd file descriptor.
>>>
>>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>>
>> Hi Mateusz,
>>
>> Overall I am fine with this patch. Currently it dose apply on branch 20220621-testing of the mdadm-CI tree. This branch is based on mdadm upstream commit 756a15f32338 (“imsm: Remove possibility for get_imsm_dev to return NULL”) and stacked with other asked patch from for-jes/20220620.
>>
>> I will response this patch after other queuing patches are handled by Jes. If the change is minor, I will do the patch rebase and inform you.
> 
> Hi Mateusz,
> 
> I just rebased the patch and pushed to mdadm-CI tree into branch 20220621-testing. This is the only patch in this testing branch. It looks fine to me, but can you help to confirm whether the rebase is correctly? The conflict happens in Grow.c:Grow_reshap().
> 
> Thanks.
> 
> Coly Li
> 

Hi Coly,
I checked the conflict myself, and the changes on the branch also look
fine for me.

Thanks,
Mateusz
