Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA45DC05027
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 14:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjBAOBO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 09:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbjBAOBI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 09:01:08 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DF63AB7
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 06:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675260067; x=1706796067;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0X2lUjLNY0Dd/hbMlfh4kjnagH7R7iP3W1vu9whl+5c=;
  b=UHf/CKO0yCe6l6HEuHriGWSaNjW9yW5pO1ZtTtO+pZkofiuy2c6FpS2w
   7teoOPFoEadxmvMU5UZ7h1ivOC/Enlvxg1i73CDVhygrNSszAxPTmqWzm
   1u6q/aAwCjdK+c5IfucMIRYlewI6LS3rOjalWZL6Sz4+t/XOGc0Q4/UoZ
   zRvZKWGhrsNqsw8O3tjph4IHfJdbdKjlbZIt08ltqCJcaYJjuAO+iIAlH
   pqvoBizERvQU88yHnRYBTyLmCU4A7smwNIeS3I/s82VGnywKcYNETdSBQ
   RXd6CXUk37uIBkJ9+oiM6WydI4GCCCWkAjnLa3MFHN41RxGfrir7VeQrS
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="311790904"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="311790904"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 06:01:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="728409554"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="728409554"
Received: from todonova-mobl3.ger.corp.intel.com (HELO localhost) ([10.252.35.103])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 06:01:03 -0800
Date:   Wed, 1 Feb 2023 15:00:32 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>, Coly Li <colyli@suse.de>
Cc:     Logan Gunthorpe <logang@deltatee.com>, Xiao Ni <xni@redhat.com>,
        linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v6 0/7] Write Zeroes option for Creating Arrays
Message-ID: <20230201150032.00003a4f@linux.intel.com>
In-Reply-To: <753b5edc-9a34-dce3-051d-514f8d43f3cd@deltatee.com>
References: <20221123190954.95391-1-logang@deltatee.com>
        <CALTww2_veP=bkpz5Z03VjmF=0dH-D9WqD2+K5A9cBiK5Pb-USg@mail.gmail.com>
        <85822a83-f4cc-b699-d589-b6c5590b3f98@redhat.com>
        <753b5edc-9a34-dce3-051d-514f8d43f3cd@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes and Coly,
Could you take this? I believe that it is ready to be merged.

Thanks,
Mariusz

On Thu, 19 Jan 2023 10:39:54 -0700
Logan Gunthorpe <logang@deltatee.com> wrote:

> On 2023-01-06 00:53, Xiao Ni wrote:
> > Hi Jes
> > 
> > Just a reminder about this series of patches.  
> 
> Any progress on this? Should I resend it? I haven't heard much feedback
> in a while.
> 
> Thanks,
> 
> Logan

