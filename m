Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C88C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 14 Mar 2022 10:58:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiCNK70 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Mar 2022 06:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbiCNK7Z (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Mar 2022 06:59:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C87FBC9C
        for <linux-raid@vger.kernel.org>; Mon, 14 Mar 2022 03:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647255495; x=1678791495;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oHjpnBSNGbH+G2s/j2kV6BMlQ9Ymw5y8PkhdjwUgTSY=;
  b=XmOp2FPgTnnYozIAR0iatllzEyAU4IYR1iz6t1UT+kvnCHWzs7/pIj60
   q04vKYdSPfwDxZheHcU0B5aa0rYabstF1fzoUtqtjvXItKJfmSGND2fmg
   eSXYeg1JuoZmoB0Q1yuOd71CxY7GLuWu+Fml54v1VcePFS9x8PtKkbYak
   szqbd1UTBSQdAW60KpzYnMANYIpgEFNkXuKaep4aGGdnG/o0ClmCrHxQV
   02ZeUj5AlzJR78gCGrVk5EETOSif6dgEUo3GRYMuQB6Txd/+kAsO4qjdz
   F2Zm1pOXlA4LLx1o549DRbYos2oCnPyb42Cz98E2z6VW+qklEq9tLKR94
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10285"; a="236597512"
X-IronPort-AV: E=Sophos;i="5.90,180,1643702400"; 
   d="scan'208";a="236597512"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 03:58:15 -0700
X-IronPort-AV: E=Sophos;i="5.90,180,1643702400"; 
   d="scan'208";a="539916648"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.30.42])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 03:58:14 -0700
Date:   Mon, 14 Mar 2022 11:58:09 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Kristoffer Knigga <kris@knigga.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: mdadm is unable to see Alder Lake IMSM array
Message-ID: <20220314115809.00007ac1@linux.intel.com>
In-Reply-To: <CAKhSdW1zghNFqn2qemMZ7FJpiBcbAd0BcYifHmcM8WWPnai-=g@mail.gmail.com>
References: <CAKhSdW1zghNFqn2qemMZ7FJpiBcbAd0BcYifHmcM8WWPnai-=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 9 Mar 2022 10:17:14 -0600
Kristoffer Knigga <kris@knigga.com> wrote:

> Hello,
> 
> I just built a new PC using an Intel i5-12600K CPU and an Asus Prime
> H670-PLUS D4 motherboard.  Attached to the SATA ports on the
> motherboard are two HDDs and an SSD.  I have enabled VMD, mapped the
> SATA controller under VMD, and created a RAID1 array from the two HDDs
> following the steps in Asus's RAID Configuration Guide
> (https://dlcdnets.asus.com/pub/ASUS/mb/13MANUAL/RAID_Configuration_Guide_V2-EN.pdf).
> 
> However, mdadm doesn't seem to know what to do with the array.  I've
> tried the stock Fedora 35 version of mdadm (mdadm-4.2-rc2.fc35) and
> I've built mdadm 4.2 from source, most recently with DEBUG on.
> 

Hi,
This is RST family product but mdadm implements VROC solution. Both
products have same origin but now they are not aligned and as you can
see, they may not be compatible at all.

> 
> I'm having a hard time figuring out where to go from here.  Does mdadm
> not know how to deal with IMSM on this new hardware?  Or is hardware
> not behaving correctly?
> 
> Any pointers are appreciated!
> 

We are using same metadata format with RST. It should work with basic
functionalities. Here we have Sata remapping under VMD controller. I
think that our mdadm implementation is not able to handle it correctly,
we are assuming that it must be nvme device.

Thanks,
Mariusz

