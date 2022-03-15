Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08CDDC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 15 Mar 2022 16:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347393AbiCOQDx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Mar 2022 12:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242652AbiCOQDw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Mar 2022 12:03:52 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376485623B
        for <linux-raid@vger.kernel.org>; Tue, 15 Mar 2022 09:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647360158; x=1678896158;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZXCwOKH1uj2qnbKec2q307655wWJvJMpOoQlBjuefvU=;
  b=iO+8e1PdNX/vCOstO3zxSVy7CPXDZbteLk4PxvqjoiUvN1CpsFbtDppK
   X3uMXSeEqqJ2g0FpIaXybX7rCnvvJBHiA7HGbBFFJtI74E7ESeynHdztM
   UBPyX6ylpoA8MvrnMaNYU/FcmmdqS5E4uHdADIU8brAyLToOqJPn4Ifen
   UhahvZ4kF6igZrd1HiXkENjA9bASR0zkJjnRb7UUE4NMJ+Jy7y98R7KiQ
   IVThoTZ128PSTzBWRs2VrKiYqRFBlUXEu5vulx8IcEOIqjrZI1vgWBzXZ
   /j4ivAeb9tclz7ikDuSgZV7XvjcBAZc7CsZeSCMLydxjCmFXgwkqOohJ2
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256069535"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="256069535"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 09:00:13 -0700
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="515927050"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.16.129])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 09:00:11 -0700
Date:   Tue, 15 Mar 2022 17:00:06 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] mdadm: Update config man regarding default files
 and multi-keyword behavior.
Message-ID: <20220315170006.00005871@linux.intel.com>
In-Reply-To: <70ee6acf-714b-10eb-dfed-284a67ae619d@suse.de>
References: <20220315085549.59693-1-lukasz.florczak@linux.intel.com>
        <20220315085549.59693-3-lukasz.florczak@linux.intel.com>
        <70ee6acf-714b-10eb-dfed-284a67ae619d@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 15 Mar 2022 17:57:09 +0800
Coly Li <colyli@suse.de> wrote:

> On 3/15/22 4:55 PM, Lukasz Florczak wrote:
> > Simplify default and alternative config file and directory location
> > references from mdadm(8) as references to mdadm.conf(5). Add FILE
> > section in config man and explain order and conditions in which
> > default and alternative config files and directories are used.
> >
> > Update config man behavior regarding parsing order when multiple
> > keywords/config files are involved.
> >
> > Additionally add missing HOMECLUSTER keyword description.
> >
> > Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>  
> 
> 
> Hi Lukasz,
> 
> 
> This patch doesn't apply on branch 20220315-testing of the mdadm-CI 
> tree, could you please rebase this series on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/colyli/mdadm.git 
> 20220315-testing
> 
> Then I will continue to test them.
> 

Hi Coly,
This is great to see that something is happening in upstream :)

I can see that you created branch where some patches were merged and
now you are reporting conflicts now. Our patches are based on last
mdadm commit (which is mdadm-4.2 ).
IMO you should try to apply them first on latest master and later
cherry-pick/ rebase them on top of your testing branch. This should
automatically resolve most of conflicts. Could you try that?

This is hard to follow all patches on list (especially that we cannot
determine in which order they will be applied). Preparing patches for
you testing branch (which could be changed in any moment), IMO is not a
good solution.

I really appreciate the work you put to enable upstream testing. If you
need some help, let me know.

Thanks,
Mariusz
