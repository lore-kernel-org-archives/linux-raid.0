Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35786EE49AB
	for <linux-raid@archiver.kernel.org>; Wed, 23 Aug 2023 07:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbjHWHaQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 23 Aug 2023 03:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233306AbjHWHaP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 23 Aug 2023 03:30:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC15E62
        for <linux-raid@vger.kernel.org>; Wed, 23 Aug 2023 00:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692775805; x=1724311805;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V0skFrwuUmg30iHxHrvV4ac/HfPsHffc7gRG6CxiNng=;
  b=L4iVu/80wta9sJYB/LDhg8AbAQuxpqt0UF0zaolKVOBwkWcdOuuJJPBW
   bhLhJt79WFc9EtQD+1d0hELqzT+liaHs6nQcUa79SsfF58sjf6ltmpwUE
   Lcl6fT+9Ud86DzlrY3Tq46xaWi9wB3lzdA8dYHwj4IfAlte/HwkIjGcMI
   i3/rLpJRJkAulfHrfBBbDAKnKQlvbEKBMzk3lxA2WsvGJIejOz42IzbH+
   tlzkTCVHmtNrtskxGDH+/sJ/oEhnavFHGjDTbRAeJ91bKUsJ008C8fmr4
   9hYP3y3gzYXAvb/szuh3gJqPsvN60XsyACApkMDNU0tzMX79qvYg4oys9
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="354420318"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="354420318"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 00:30:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="826616448"
X-IronPort-AV: E=Sophos;i="6.01,195,1684825200"; 
   d="scan'208";a="826616448"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.143.195])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2023 00:30:02 -0700
Date:   Wed, 23 Aug 2023 09:29:57 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jes Sorensen <jes@trained-monkey.org>, Xiao Ni <xni@redhat.com>,
        Paul E Luse <paul.e.luse@linux.intel.com>,
        Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org
Subject: Re: libsed in mdadm
Message-ID: <20230823092957.00001051@linux.intel.com>
In-Reply-To: <9106ad75-8c58-9edb-d066-e5ee332907d3@suse.de>
References: <20230821161604.000048c7@linux.intel.com>
        <24acd8dc-e3c6-cfb1-3fba-42d1d0699b39@trained-monkey.org>
        <9106ad75-8c58-9edb-d066-e5ee332907d3@suse.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 23 Aug 2023 08:00:51 +0200
Hannes Reinecke <hare@suse.de> wrote:

> On 8/22/23 22:54, Jes Sorensen wrote:
> > On 8/21/23 10:16, Mariusz Tkaczyk wrote:  
> >> Hello,
> >> IMSM/VROC is going to support self-encrypted drives. With this feature you
> >> need to unlock the drives during boot-up in UEFI first. It is kind of
> >> protection from physical stealing.
> >>
> >> To ensure security, Linux have to respect that. It means that we need to
> >> determine if the drive support locking and do not allow to mix locked and
> >> unlocked drives in one IMSM array.
> >>
> >> To grab that information we will need to impose the "magic commands" to the
> >> drives. There is a libsed library, designed for such purposes:
> >> https://github.com/sedcli/sedcli
> >>
> >> So far I know, this library is not released under distributions (not
> >> handled by package managers) and that will bring not user friendly
> >> dependency- you will need to compile and install the lib first to build
> >> mdadm.
> >>
> >> The sedcli project is maintained in Intel, currently it is not in active
> >> development but there are no plans to drop it, interest around it is
> >> growing as you can see. It seems to be great opportunity for this project
> >> to become integrated with mainstream distributions when mdadm will start to
> >> require it.
> >>
> >> So, my questions are: Are we fine with adding this dependency? Are there
> >> big cons you see?
> >> Obviously, I will make it optional like libudev is.
> >>
> >> I can try to re-implement the functionality I need in mdadm but it is like
> >> reinventing the wheel.
> >>
> >> Any feedback will be appreciated.  
> > 
> > Hi Mariusz,
> > 
> > I am not against adding it to mdadm, though I think a better approach is
> > to try and get the library built as a package for the distros.
> > 
> > Did you look into that yet?
> >   
> We (as in 'We as an OS distributor') actually evaluated packaging libsed 
> some time ago, but decided against it as the original authors (namely 
> Intel) apparently disbanded it. So before adding it to a distro there 
> needs to be an active maintainer, and one would be looking to Intel here.
> 

Thanks Hannes for feedback. I totally agree with you. I will raise it
internally.

Thanks,
Mariusz
