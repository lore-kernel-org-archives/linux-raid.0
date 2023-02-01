Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345E1C05027
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 08:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjBAIy5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 03:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbjBAIy4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 03:54:56 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6BC38EB8
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 00:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675241694; x=1706777694;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u0o+MYVCTp3TDLV/vnWyXfnX7lTo/Wqo4/jEiCXSVPE=;
  b=ifWb4hpHz6USiZ3AWJsd5Iqz17skGncRIr9O3jA0FtxgNX3D5BHpFW6o
   SYBwPTaxfaFFSXVNIzUczWinyVI1ol23UZoPV6rbfzSB9sBHZOPu7rnva
   FqaIeCzmM82s+oXO0dKF5yiKajx74pVl7sujdDQm2EFE0vVAqgwYs+Xmw
   USaiLJKxy3DPr2TtmNuafiPX8wTaq5wX7K4Gm0ER4vy2yv+FIwkibbR91
   85fkKF2ZTRPVGBG3YsOfmIHsKXuW7DAvfMH6buXN7BbKJTKPoAwxRsaYV
   S9nuaxBsmJvuTkQdzMtsbLNLEWa0fIIJU2rlSh2G+nZ6ZiWFMr+Ca77WN
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="330222189"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="330222189"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 00:54:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10607"; a="910254892"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="910254892"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.60.109])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 00:54:26 -0800
Date:   Wed, 1 Feb 2023 09:54:21 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Kevin Friedberg <kev.friedberg@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH] treat AHCI controllers under VMD as part of VMD
Message-ID: <20230201095421.000033f0@linux.intel.com>
In-Reply-To: <20230126021659.3801-1-kev.friedberg@gmail.com>
References: <20230126021659.3801-1-kev.friedberg@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Kevin,
Thank you for the patch. Please be aware that the RST is not officially
supported on Linux. You are going to enable RST suppport using VROC Linux
stack. You are using it at your own risk.
Intel will review your patch and will run regression, it could take around
month (sorry, we are getting back our labs now).

Thanks,
Mariusz

On Wed, 25 Jan 2023 21:16:59 -0500
Kevin Friedberg <kev.friedberg@gmail.com> wrote:

> Detect when a SATA controller has been mapped under Intel Alderlake RST
> VMD and list it as part of the domain, instead of independently, so that
> it can use the VMD controller's RAID capabilities.
> 
> Signed-off-by: Kevin Friedberg <kev.friedberg@gmail.com>
