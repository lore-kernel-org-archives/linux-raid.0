Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416AEC4167B
	for <linux-raid@archiver.kernel.org>; Wed,  2 Nov 2022 08:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbiKBIgT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Nov 2022 04:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiKBIgS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Nov 2022 04:36:18 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3E4A19C
        for <linux-raid@vger.kernel.org>; Wed,  2 Nov 2022 01:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667378176; x=1698914176;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bYlwifW0Mbf4qoLgWiHILATST/ATlQpBevUtzCE7akA=;
  b=NtFZ2PRS28AuwNRDLuCE2a3l02NHUHwJKgcrn1cDoh4DByAs7zFYDCgX
   /7N0Rph6LAQueCFuRQ5LICja5DPI52mS85U6YzFP+0w322z1SllynldbX
   F68aNEN7YSTzREZYhP/isYuOXY4NtGH94yn56OoQWPefT7Mteps+yShSg
   ysCA/KW4PU+aP8kZAaL8ILcnMRrzZio149Jn1jGfQ69rwQGOEj/69aVk8
   uGim2fQ2o2dYGV6FQP+3hQKUSFH68Z9jjQszVedYdRMGden7yrcrhsLCE
   f3xfUX0Ms9ecUm5oVDn93f1Y0qJdj54bZlkbx/VeTVdyKCE7lZ5DJxURR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="309345185"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="309345185"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 01:36:10 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="585316964"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="585316964"
Received: from mkusiak-mobl.ger.corp.intel.com (HELO [10.213.5.202]) ([10.213.5.202])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 01:36:08 -0700
Message-ID: <8ad61603-7b45-9c05-e422-1e77675d6836@linux.intel.com>
Date:   Wed, 2 Nov 2022 09:35:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] Manage: Block unsafe member failing
Content-Language: pl
To:     Jes Sorensen <jes@trained-monkey.org>,
        Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220818094721.8969-1-mateusz.kusiak@intel.com>
 <a914b695-9b6d-fd45-97d4-ca5b98f1d1f3@trained-monkey.org>
From:   "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
In-Reply-To: <a914b695-9b6d-fd45-97d4-ca5b98f1d1f3@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We have noticed that this patch introduced a regression, unwanted
behavior regarding matrix raid.
We're working on a fix, this in no.1 on our list. We'll post changes soon.

Thanks,
Mateusz

On 08/09/2022 18:53, Jes Sorensen wrote:
> On 8/18/22 05:47, Mateusz Kusiak wrote:
>> Kernel may or may not block mdadm from removing member device if it
>> will cause arrays failed state. It depends on raid personality
>> implementation in kernel.
>> Add verification on requested removal path (#mdadm --set-faulty
>> command).
>>
>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>> ---
>>  Manage.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 52 insertions(+), 1 deletion(-)
> 
> Applied!
> 
> Thanks,
> Jes
> 
> 
