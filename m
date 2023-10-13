Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1C61CDB47E
	for <linux-raid@archiver.kernel.org>; Fri, 13 Oct 2023 13:44:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjJMNoM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Oct 2023 09:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjJMNoL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Oct 2023 09:44:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A000795
        for <linux-raid@vger.kernel.org>; Fri, 13 Oct 2023 06:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697204651; x=1728740651;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MEZFwNt464iDZi7EjCH/0+Px22SG0MKzTVQ1f/LzxIQ=;
  b=ax4hOPt1mh30pI10PAy7C8G3fAqDTIaRw7ymy8podAj1mb0RX7dX0CZ9
   I6H3HSwGKY43t4ZNC78EMEWUIwK0EGOmIpkYOTQ2QDLAc4uKlfGMB/xax
   03AGVC3R+Vs8kjdKtdnndgCdM1fP2IUB9sA1fVAi6iEw2Uho6KNJuGfDw
   +VnORNnZfdkS3aB/8wEm74p0drNdczkLGVRshNLsRU5oeXBYyCWfELzI9
   7+YGH2zzVIl/tlrPdmIJDzgKB64vrvzw/yUjEBOrGr9E0yMCe3TW4Sacl
   s1lI8fJg5yVuZUfCcL/yd2rIn8FasLA4bIJH+PiWwySqwAsxMPdySjnJr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="3785808"
X-IronPort-AV: E=Sophos;i="6.03,222,1694761200"; 
   d="scan'208";a="3785808"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 06:44:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10862"; a="845479252"
X-IronPort-AV: E=Sophos;i="6.03,222,1694761200"; 
   d="scan'208";a="845479252"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.156.199])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 06:44:08 -0700
Date:   Fri, 13 Oct 2023 15:44:02 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org, colyli@suse.de,
        neilb@suse.de
Subject: Re: [PATCH 1/1] mdadm/super1: Add MD_FEATURE_RAID0_LAYOUT if
 sb->layout is set
Message-ID: <20231013154402.00003976@linux.intel.com>
In-Reply-To: <CALTww29C_kS9e9hxbz+GFWVvAci1CZSfHxWTigD3zCYdZghmYw@mail.gmail.com>
References: <20231011130522.78994-1-xni@redhat.com>
        <20231013113034.0000298a@linux.intel.com>
        <CALTww282t6UMePRPPmoxyxBpedbjWC=9ojjHQx8o8sJttnzvSA@mail.gmail.com>
        <20231013135935.00005679@linux.intel.com>
        <CALTww29C_kS9e9hxbz+GFWVvAci1CZSfHxWTigD3zCYdZghmYw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 13 Oct 2023 20:12:38 +0800
Xiao Ni <xni@redhat.com> wrote:

> > > > So, it forces the calculations made by Neil back but I think that we can
> > > > simply compare dev_size and data_offset between members.  
> > >
> > > We don't need to consider the compatibility anymore in future?
> > >  
> > Not sure if I get your question correctly. This property is supported now so
> > why we should? It is already there so we are safe to set it.  
> 
> I asked because you said we can remove the check in future. So I don't
> know why we don't need the check in future. The check here should be
> the kernel version check, right?


We are not supporting old kernels forever. At some point of time, we would
decide that kernels older than 5.5 are no longer a valid case and then we will
free to remove verification. If we are not supporting something older than the
version where it was added, we can assume that MD_RAID0_LAYOUT is always
available and we don't need to care anymore, right?

Here a recent example:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=f8d2c4286a

Thanks,
Mariusz
