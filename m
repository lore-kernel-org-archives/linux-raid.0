Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB763EE4993
	for <linux-raid@archiver.kernel.org>; Mon, 21 Aug 2023 14:16:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbjHUOQo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Aug 2023 10:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbjHUOQn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Aug 2023 10:16:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA8C11C
        for <linux-raid@vger.kernel.org>; Mon, 21 Aug 2023 07:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692627379; x=1724163379;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=qYSWhKNd+zB40Ld1VR9EomAopDcbRMPlYfV8yd+PV6Q=;
  b=SJY8Rj/YylsKMtrg09rZbxHn6bcAYgoG6dXNQVVZfXvgEL4VYQ/epL6r
   LEMM3ljevm44OVH0JqcgW/8A2I7uI0f9bQho/GhMpIICX8HD2UGaS/8IR
   6vQ4EFVPy2dNl8YED1yvlmN4TAS/7FkB1a0TegbKkgXfBmH40S90NpCbg
   nllPSRClhRjaRlb3k92mbAT8QnStb1qEwklhG0tpX67PlIXpmFYKZT0o4
   uHkrL6lMOfo6y2vR6k9dww05v5t/N0Xuk8HM+KJjH/Owd/+YFXi7X1N/k
   FvoYg/g6+2iH8C1o95YXHFXpAUflBIKTyPyXU85AzT/RGJV/XlR1NyE1T
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="376350022"
X-IronPort-AV: E=Sophos;i="6.01,190,1684825200"; 
   d="scan'208";a="376350022"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 07:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="770964046"
X-IronPort-AV: E=Sophos;i="6.01,190,1684825200"; 
   d="scan'208";a="770964046"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.142.139])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 07:16:09 -0700
Date:   Mon, 21 Aug 2023 16:16:04 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>,
        Paul E Luse <paul.e.luse@linux.intel.com>,
        Coly Li <colyli@suse.de>, Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: libsed in mdadm
Message-ID: <20230821161604.000048c7@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,
IMSM/VROC is going to support self-encrypted drives. With this feature you need
to unlock the drives during boot-up in UEFI first. It is kind of protection
from physical stealing.

To ensure security, Linux have to respect that. It means that we need to
determine if the drive support locking and do not allow to mix locked and
unlocked drives in one IMSM array.

To grab that information we will need to impose the "magic commands" to the
drives. There is a libsed library, designed for such purposes:
https://github.com/sedcli/sedcli

So far I know, this library is not released under distributions (not handled by
package managers) and that will bring not user friendly dependency- you will
need to compile and install the lib first to build mdadm.

The sedcli project is maintained in Intel, currently it is not in active
development but there are no plans to drop it, interest around it is growing as
you can see. It seems to be great opportunity for this project to
become integrated with mainstream distributions when mdadm will start to
require it.

So, my questions are: Are we fine with adding this dependency? Are there big
cons you see?
Obviously, I will make it optional like libudev is.

I can try to re-implement the functionality I need in mdadm but it is like
reinventing the wheel.

Any feedback will be appreciated.
Mariusz
