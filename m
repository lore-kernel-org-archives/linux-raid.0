Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9289EC25B48
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 06:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjJZGJo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 02:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjJZGJn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 02:09:43 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32767115
        for <linux-raid@vger.kernel.org>; Wed, 25 Oct 2023 23:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698300582; x=1729836582;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qfChFMPAugZmR40j5YN6X64ZXJ1NQRnmGhUaL3/IB4U=;
  b=PnVpp+7MvaVCtamcXc0LCzWBZ/M8bkb5wLRI+p/PcXKvdYZyIQ/8nuqk
   a8UHPAD0xeE5Yl4NkA8fSa+h2FQKQmOyJyl57AKEFyDbhPtOtGXEsPjx2
   +peebul8vS5TBif/KEJLe0hVZWJjeOdjKJO9Ihq2VUfa8WwZHuo1JJ3IG
   P4ge1uGLUqOm/HhixAsuRll4tDDEywb9k3Ia6zk9fuFG7i9GCeRDlD301
   6wDFVK0u9kkK+7fgHfTsds7EaBdqtevFv813Ppb1hea4GO4O+FDuYn0AK
   6S/bhH670OYkIO2zg994DHvypgW+A+CNOi89uxpNy6h56XitiOO6uB9Pp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="275051"
X-IronPort-AV: E=Sophos;i="6.03,253,1694761200"; 
   d="scan'208";a="275051"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 23:09:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10874"; a="932617596"
X-IronPort-AV: E=Sophos;i="6.03,253,1694761200"; 
   d="scan'208";a="932617596"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.145.199])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 23:09:38 -0700
Date:   Thu, 26 Oct 2023 08:09:30 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jes Sorensen <jes@trained-monkey.org>, Xiao Ni <xni@redhat.com>,
        Paul E Luse <paul.e.luse@linux.intel.com>,
        Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org,
        Paul E Luse <paul.e.luse@linux.intel.com>
Subject: Re: libsed in mdadm
Message-ID: <20231026080930.0000170b@linux.intel.com>
In-Reply-To: <20230823092957.00001051@linux.intel.com>
References: <20230821161604.000048c7@linux.intel.com>
        <24acd8dc-e3c6-cfb1-3fba-42d1d0699b39@trained-monkey.org>
        <9106ad75-8c58-9edb-d066-e5ee332907d3@suse.de>
        <20230823092957.00001051@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 23 Aug 2023 09:29:57 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> On Wed, 23 Aug 2023 08:00:51 +0200
> Hannes Reinecke <hare@suse.de> wrote:
> 
> > On 8/22/23 22:54, Jes Sorensen wrote:  
> > > On 8/21/23 10:16, Mariusz Tkaczyk wrote:    
> > >> Hello,
> > >> IMSM/VROC is going to support self-encrypted drives. With this feature
> > >> you need to unlock the drives during boot-up in UEFI first. It is kind of
> > >> protection from physical stealing.
> > >>
> > >> To ensure security, Linux have to respect that. It means that we need to
> > >> determine if the drive support locking and do not allow to mix locked and
> > >> unlocked drives in one IMSM array.
> > >>
> > >> To grab that information we will need to impose the "magic commands" to
> > >> the drives. There is a libsed library, designed for such purposes:
> > >> https://github.com/sedcli/sedcli
> > >>
> > >> So far I know, this library is not released under distributions (not
> > >> handled by package managers) and that will bring not user friendly
> > >> dependency- you will need to compile and install the lib first to build
> > >> mdadm.
> > >>
> > >> The sedcli project is maintained in Intel, currently it is not in active
> > >> development but there are no plans to drop it, interest around it is
> > >> growing as you can see. It seems to be great opportunity for this project
> > >> to become integrated with mainstream distributions when mdadm will start
> > >> to require it.
> > >>
> > >> So, my questions are: Are we fine with adding this dependency? Are there
> > >> big cons you see?
> > >> Obviously, I will make it optional like libudev is.
> > >>
> > >> I can try to re-implement the functionality I need in mdadm but it is
> > >> like reinventing the wheel.
> > >>
> > >> Any feedback will be appreciated.    
> > > 
> > > Hi Mariusz,
> > > 
> > > I am not against adding it to mdadm, though I think a better approach is
> > > to try and get the library built as a package for the distros.
> > > 
> > > Did you look into that yet?
> > >     
> > We (as in 'We as an OS distributor') actually evaluated packaging libsed 
> > some time ago, but decided against it as the original authors (namely 
> > Intel) apparently disbanded it. So before adding it to a distro there 
> > needs to be an active maintainer, and one would be looking to Intel here.
> >   
> 
> Thanks Hannes for feedback. I totally agree with you. I will raise it
> internally.
> 
Hello,
The maintenance of sedcli has been given to SK Hynix. Intel is no longer
an owner. Hannes, you can reconsider the decision of packaging libsed
depending on how active new maintainer will be.
Thanks to Paul for making this happen.

We will watch the upstream activity too to determine if it is reasonable to
consider making it as mdadm dependency in the future.

Thanks,
Mariusz
