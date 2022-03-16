Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD468C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 16 Mar 2022 08:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347256AbiCPIx6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Mar 2022 04:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354673AbiCPIx4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Mar 2022 04:53:56 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B187652C0
        for <linux-raid@vger.kernel.org>; Wed, 16 Mar 2022 01:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647420762; x=1678956762;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Csk0v3U+AGXCHmaQoFQ49RI7na+6CYResC1kz7ZIV74=;
  b=KpuQtGs/2jGhfG43A0snso5YpiE6ulj2/vHgTk3NpncQpJpDRDqjchO5
   Luvr8m7buWvaBsBFoCWSmgrH+FCprYY5rV+fPF50gc2/8OUISFUcbdqaS
   nELKFMFedh1tXw40yPEvzXk2p3FVlhkI2wLDSXV/slDgzwzeeeIMzxcur
   BW+uTzGoixQKTV/5iA0CIQ3Vqvh+/zGQyWKoJx0nI0qRGe+Mw9Khq+fSu
   t9Ps55B1fyp6spy/UF267Q32pjup/V15tUYksBUjJPhcKxpkDChH0K289
   0Qso7WPPyAqIrzdjq34I8L0gg+G/oRp9BFUttBlBRwP/WvvFPu9K7XILG
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="243981059"
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="243981059"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 01:52:42 -0700
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="516246147"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.3.58])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 01:52:40 -0700
Date:   Wed, 16 Mar 2022 09:52:35 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] mdadm: Update config man regarding default files
 and multi-keyword behavior.
Message-ID: <20220316095235.0000264f@linux.intel.com>
In-Reply-To: <8ee252df-3ee2-36b0-7c4e-ef1f9c8e6f49@suse.de>
References: <20220315085549.59693-1-lukasz.florczak@linux.intel.com>
        <20220315085549.59693-3-lukasz.florczak@linux.intel.com>
        <70ee6acf-714b-10eb-dfed-284a67ae619d@suse.de>
        <20220315170006.00005871@linux.intel.com>
        <8ee252df-3ee2-36b0-7c4e-ef1f9c8e6f49@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 16 Mar 2022 00:43:57 +0800
Coly Li <colyli@suse.de> wrote:

> On 3/16/22 12:00 AM, Mariusz Tkaczyk wrote:
> > On Tue, 15 Mar 2022 17:57:09 +0800
> > Coly Li <colyli@suse.de> wrote:
> >
> >> On 3/15/22 4:55 PM, Lukasz Florczak wrote:
> >>> Simplify default and alternative config file and directory
> >>> location references from mdadm(8) as references to mdadm.conf(5).
> >>> Add FILE section in config man and explain order and conditions
> >>> in which default and alternative config files and directories are
> >>> used.
> >>>
> >>> Update config man behavior regarding parsing order when multiple
> >>> keywords/config files are involved.
> >>>
> >>> Additionally add missing HOMECLUSTER keyword description.
> >>>
> >>> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> >>
> >> Hi Lukasz,
> >>
> >>
> >> This patch doesn't apply on branch 20220315-testing of the mdadm-CI
> >> tree, could you please rebase this series on
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/colyli/mdadm.git
> >> 20220315-testing
> >>
> >> Then I will continue to test them.
> >>
> > Hi Coly,
> > This is great to see that something is happening in upstream :)
> >
> > I can see that you created branch where some patches were merged and
> > now you are reporting conflicts now. Our patches are based on last
> > mdadm commit (which is mdadm-4.2 ).
> > IMO you should try to apply them first on latest master and later
> > cherry-pick/ rebase them on top of your testing branch. This should
> > automatically resolve most of conflicts. Could you try that?
> 
> 
> The testing branch is updated to latest mdadm upstream. Indeed the 
> conflict is about blank line as I see, e.g. it removes some \t from 
> empty line, but such issue was removed in latest upstream.
> 
> Ineed I can fix the conflict, but I don't know how to make you update 
> the change from my side. Does it work if I sand you a diff of the
> patch?
> 
Hi Coly,
Resolving conflicts is a normal maintenance work. Just add you
sign-off and modify whatever is necessary, ofc. if are sure that it is
correct. If not, then ask owner to do that.
IMO you should send a note that you resolved something, we can
verify it ourselves in commit later.

Thanks,
Mariusz
