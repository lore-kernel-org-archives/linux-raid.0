Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0D1CDB483
	for <linux-raid@archiver.kernel.org>; Tue, 17 Oct 2023 14:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343900AbjJQOM0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Oct 2023 10:12:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343584AbjJQOMZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Oct 2023 10:12:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BCDF0
        for <linux-raid@vger.kernel.org>; Tue, 17 Oct 2023 07:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697551943; x=1729087943;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GGIZaD06c5E1M+xDI27f5Sk0u9hDfQPIz5wYRfrnq8A=;
  b=n0BY4ZnJgqToqBR0jz0+2QkPd7A+NzOXFcnziYq1n1hvm2s401hTMTln
   F6g0kybyo0JlXsE2n47GWFhsg3eyZKXSZRJXJ6oYZZiK3+OMbSbDoSfoV
   mvtfu6h9PKpLdUQRXFIElhg15Sw74Ua7Fv0o5Qj7+ZNM+2lS/1Fv6LBSP
   EpWeNwLTF4XL7EhTO8AKIRHBqaxUzXD/1juLTVQBvkAuimrG3MKLjvjSn
   sYoMhSnOJYeOLwh2e9iBK7uCKk9w3ZIkwTT1sMpzP7g5l0lCvE1stxBWa
   spNdlLHiF5QahaCgL3fdTmFO7I5i5tk6VbDx/rmSlTw8tYRQJHuhlo9IX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="388650055"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="388650055"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 07:12:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10866"; a="899923558"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="899923558"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.158.98])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 07:10:19 -0700
Date:   Tue, 17 Oct 2023 16:12:16 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, colyli@suse.de, neilb@suse.de,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH V3 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if
 kernel>=5.4
Message-ID: <20231017161216.0000565a@linux.intel.com>
In-Reply-To: <20231017123546.46292-1-xni@redhat.com>
References: <20231017123546.46292-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 17 Oct 2023 20:35:46 +0800
Xiao Ni <xni@redhat.com> wrote:

> After and include kernel v5.4, it adds one feature bit
> MD_FEATURE_RAID0_LAYOUT. It must need to specify a layout for raid0 with more
> than one zone. But for raid0 with one zone, in fact it also has a defalut
> layout.
> 
> Now for raid0 with one zone, *unknown* layout can be seen when running mdadm
> -D command. It's the reason that mdadm doesn't set MD_FEATURE_RAID0_LAYOUT for
> raid0 with one zone. Then in kernel space, super_1_validate sets mddev->layout
> to -1 because of no MD_FEATURE_RAID0_LAYOUT. In fact, in raid0 io path, it
> uses the default layout. Set raid0_need_layout to true if
> kernel_version<=v5.4.
> 
> Fixes: 329dfc28debb ('Create: add support for RAID0 layouts.')
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---

LGTM.

Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks,
Mariusz
