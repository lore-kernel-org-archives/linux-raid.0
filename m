Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30E7EE49A0
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 12:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbjHWMyl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Aug 2023 08:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbjHWMyk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Aug 2023 08:54:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD4BE47
        for <linux-raid@vger.kernel.org>; Wed, 23 Aug 2023 05:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692795278; x=1724331278;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4iSiLQWF/bOdgOzR1YULA4BoP6lOCmqeNdY+H5PmeK0=;
  b=E8kII9jFKtUO2aLLTEtmraPKULEwVGZj3cLmHsGsYrBlQLTNLnc7ORDc
   DaT9tyMRwyMIuE2ATxH7XwqR0ZXq7C4Npw0puHeLzF+EC/TX5h97ogwvq
   mFZmF1jB/VAJ81JraSQzxOwUgdSB0mLSaI2kC5TDyKCZolERW3PoqGGnR
   8FrXbs+iAr/BUN6AIqM+R/qFsld5ojUsreeEB5ZTaOigVI30yYXci8kod
   JkZr1glbbpM5ltUk9wf/p0LI2CM6K6soSrmkiE5ssAl0/bKP7hU02KLfF
   KP578mJhWlCI49o33g0fwZymG+N8M42PIlXh10p7t6MpI809B2e9ZH5FF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="364324851"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="364324851"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 05:53:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="806687224"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="806687224"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.143.195])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 05:53:01 -0700
Date:   Wed, 23 Aug 2023 14:52:56 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Khem Raj <raj.khem@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH] restripe.c: Use _FILE_OFFSET_BITS to enable largefile
 support
Message-ID: <20230823145256.00001103@linux.intel.com>
In-Reply-To: <20221110225546.337164-1-raj.khem@gmail.com>
References: <20221110225546.337164-1-raj.khem@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 10 Nov 2022 14:55:46 -0800
Khem Raj <raj.khem@gmail.com> wrote:

> Instead of using the lseek64 and friends, its better to enable it via
> the feature macro _FILE_OFFSET_BITS = 64 and let the C library deal with
> the width of types
> 

LGTM. There are several style issues but you are not an author of them so I see
this as good to go.

Sorry, for long response time, I totally lost this one.

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

