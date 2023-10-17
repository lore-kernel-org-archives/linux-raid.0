Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DBECCDB482
	for <linux-raid@archiver.kernel.org>; Tue, 17 Oct 2023 11:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbjJQL3r (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Oct 2023 07:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQL3r (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Oct 2023 07:29:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB52EA
        for <linux-raid@vger.kernel.org>; Tue, 17 Oct 2023 04:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697542185; x=1729078185;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CLtwj3IcumKeLqcX/Ohm7Qa1fz01YBdqaeJLab5y1bo=;
  b=QMNvMqH2/9Buj5pXsQyL5LyjQP5RCKUdpMVg8TcHLY6NMzxTSSG6dY5Z
   5l1rcc+BaUxuYBBnGpxH1TH1+Zfxwkp53TsJqP+Hu+QPR+nGWvdTMzzJX
   L5bzQV6KTkGbVgBsTrvsEW38clWOX7rDCYE1Vor0DkmFjEwh/+XM4ro/L
   q3z4PKZzqw5ozvmJaqR8btq5NvLUWQ9KruqA1XlOnu0W4ha67PMipQtPP
   zrimkDyJMS044v/painOVZDoE5hzTRMHEkFtOf27lQiTUDWLzZvuDMZpI
   Cwb1ayqtCg80sy/vQ8+ZIj9P7GP+CQ4yIIMynxJt7lY3DBInx4A9EYVLT
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="384639323"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="384639323"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 04:29:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="785454041"
X-IronPort-AV: E=Sophos;i="6.03,231,1694761200"; 
   d="scan'208";a="785454041"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.158.98])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 04:29:43 -0700
Date:   Tue, 17 Oct 2023 13:29:36 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, colyli@suse.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm/udev: Don't add member disk if super is
 disabled in conf file
Message-ID: <20231017132936.0000665d@linux.intel.com>
In-Reply-To: <20231017095615.00000088@linux.intel.com>
References: <20231017054848.42279-1-xni@redhat.com>
        <20231017095615.00000088@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 17 Oct 2023 09:56:15 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> I'm reading manual and for me it is something that should gone. Why we need
> this? Kernel is responsible for bringing up partitions, not udev.
> https://linux.die.net/man/5/mdadm.conf
> 
> "From 2.6.28 all md array devices are partitionable, hence this option is not
> needed."
> 
> I need from you to deeply understand this feature, why it was needed, what it
> gives now to help community take a decision what is the right thing to do.

Please ignore, I read auto= instead of AUTO.

Mariusz
