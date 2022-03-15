Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCE2C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 15 Mar 2022 13:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348732AbiCONe7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348735AbiCONe7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Mar 2022 09:34:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D008D6556
        for <linux-raid@vger.kernel.org>; Tue, 15 Mar 2022 06:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647351224; x=1678887224;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8YOYntYezB+hq1ZylWftu0TZiNPVTwN1IlKNXjnd5/A=;
  b=W1Cs3IuCcNl8TstHjAmuFYKXwIXmYAv9d5CfwD0IevVD8NsyI1V1LbVS
   B8ou6mBeThFZ/sF/qKKJpqp8cFBCuvvKNGNn6LOShPGJL2EYLOgweVA++
   EGuejNA7+1E7ePWvQGfEQzYk5t5Qe/9oh8FyxGIUsrqE3TuSVXgjHzD0f
   hUxhmdJJg8H7zcsd5chP0Y7lpFH6v5rMBF+nZdCYKUzNhAxaz7XSc3wra
   kbwXyRylntI5NATemng6UlUu2ZKDekiiyR32oBH2wcyfR0v0cIxOzAr4d
   Nk8yOufSi/h2+Ech6YB5+1SF9XtHQc9tG8g3Jj4iYcXEqQtlYaeYFlOI0
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256251985"
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="256251985"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 06:33:44 -0700
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="540437419"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.16.129])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 06:33:43 -0700
Date:   Tue, 15 Mar 2022 14:33:38 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Kristoffer Knigga <kris@knigga.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: mdadm is unable to see Alder Lake IMSM array
Message-ID: <20220315143338.00000394@linux.intel.com>
In-Reply-To: <CAKhSdW3v-e6N8GA2Sq=qurACA9S1f5Bsf9pSq6oL1YH4aSR+=g@mail.gmail.com>
References: <CAKhSdW1zghNFqn2qemMZ7FJpiBcbAd0BcYifHmcM8WWPnai-=g@mail.gmail.com>
        <20220314115809.00007ac1@linux.intel.com>
        <CAKhSdW3v-e6N8GA2Sq=qurACA9S1f5Bsf9pSq6oL1YH4aSR+=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 14 Mar 2022 09:53:39 -0500
Kristoffer Knigga <kris@knigga.com> wrote:

> Mariusz,
> 
> Thanks for taking a look at this.
> 
> > This is RST family product but mdadm implements VROC solution. Both
> > products have same origin but now they are not aligned and as you
> > can see, they may not be compatible at all.
> 
> Is RST support planned for mdadm?
> 
AFAIK it is not planned.

> > Here we have Sata remapping under VMD controller. I
> > think that our mdadm implementation is not able to handle it
> > correctly, we are assuming that it must be nvme device.
> 
> Out of curiosity, would you expect an array of NVMe devices to work?

We (VROC) relies on efi variables provided by UEFI. If RST UEFI driver
provides them, it will work. We didn't validate such solution so I
cannot be sure. You need to check it yourself.
The simplest way is to run #mdadm --detail-platform. Supported devices
will be listed.

> 
> This kind of programming is far outside of my expertise, but if
> there's anything I can do to help an effort to add this support to
> mdadm, please let me know.  I can provide more information about the
> hardware, and I can build and run tests if that's useful.
> 

I can't take the challenge at this moment, but I won't block adding
such feature in upstream. I can give some suggestions and help
with review.

Thanks,
Mariusz
