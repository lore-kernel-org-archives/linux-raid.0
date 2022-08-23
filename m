Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A62B4C32772
	for <linux-raid@archiver.kernel.org>; Tue, 23 Aug 2022 17:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343581AbiHWREd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 23 Aug 2022 13:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343864AbiHWRDi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 23 Aug 2022 13:03:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760A414013
        for <linux-raid@vger.kernel.org>; Tue, 23 Aug 2022 07:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661263665; x=1692799665;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Jeio8y8W+mJR1jmEKq4JDYI3Wzjl9fD56AEze82sY7A=;
  b=T72lOj+7KuvF9twyZA+DDNkQY2XWd1J/e5d5/Un+asnvsTHz3CcRFyPp
   xsz457vyi6Vs23CWZyjpZXLeeDWHXu6HEjJGoMIHHY9ghSKH06sbDzoKm
   EQ0M7JZJ/BDQS5G8fG4p5WT5eZ4e3aW2YrLIt4GX8806CJSYy4xxDwSvC
   dkMoFVnfgSFZySFZhL4GbcJtFZXytr6AttWjQtn3lb0MXwj0swm2OQKYZ
   4tVy/hNAKPhMqNwjTXQgoUWWiR/0Gd8m1Y3m2Z5g41vqeq1mER6GJV/gS
   jSLl/Wg3w7h2LVXQseGPCzo3M/Oq2XVwkqnIgKqtsla5I3NsjcXgGBsOh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10448"; a="294484085"
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="294484085"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 07:07:27 -0700
X-IronPort-AV: E=Sophos;i="5.93,257,1654585200"; 
   d="scan'208";a="670045592"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.178])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 07:07:23 -0700
Date:   Tue, 23 Aug 2022 16:07:18 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>, Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm] mdadm: Don't open md device for CREATE and
 ASSEMBLE
Message-ID: <20220823160718.00004367@linux.intel.com>
In-Reply-To: <c3810d35-c918-e128-5184-52cef5710422@trained-monkey.org>
References: <20220714223749.17250-1-logang@deltatee.com>
        <150ffbb2-9881-9c1f-cc5e-331926b8e423@linux.dev>
        <20220719132739.00001b94@linux.intel.com>
        <dcaf3af0-95c5-bf9a-bd2c-9c6a60c67e97@deltatee.com>
        <20220720102015.00000bd0@linux.intel.com>
        <c3810d35-c918-e128-5184-52cef5710422@trained-monkey.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 23 Aug 2022 09:49:11 -0400
Jes Sorensen <jes@trained-monkey.org> wrote:

> On 7/20/22 04:20, Mariusz Tkaczyk wrote:
> > On Tue, 19 Jul 2022 10:43:06 -0600
> > Logan Gunthorpe <logang@deltatee.com> wrote:
> >   
> >> On 2022-07-19 05:27, Mariusz Tkaczyk wrote:  
> >>> On Fri, 15 Jul 2022 10:20:26 +0800
> >>> Guoqing Jiang <guoqing.jiang@linux.dev> wrote:    
> >>>> On 7/15/22 6:37 AM, Logan Gunthorpe wrote:    
> >>>>> To fix this, don't bother trying to open the md device for CREATE and
> >>>>> ASSEMBLE commands, as the file descriptor will never be used anyway
> >>>>> even if it is successfully openned.    
> >>> Hi All,
> >>>
> >>> This is not a fix, it just reduces race probability because file
> >>> descriptor will be opened later.    
> >>
> >> That's not correct. The later "open" call actually will use the new_array
> >> parameter which will wait for the workqueue before creating a new array
> >> device, so the old one is properly cleaned up and there is no longer
> >> a race condition with this patch. If new_array doesn't exist and it falls
> >> back to a regular open, then it will still do the right thing and open the
> >> device with create_on_open.  
> > 
> > Array is created by /sys/module/md/parameters/new_array if chosen_name has
> > certain form. For IMSM, when we are creating arrays using "/dev/md/name" or
> > "name" only create_on_open is used (if no "names=yes" in config). I
> > understand that it works with tests but I don't feel that it is complete
> > yet. Could you how it behaves when we use "whatever"? 
> > 
> > #mdadm -CR whatever -l0 -n2 /dev/nvme[01]n1
> > 
> > Please do not use --name= parameter.
> > 
> > I want to disable create_on_open and always use new_array in the future,
> > without fallback to create_on_open possibility. So I would like to have
> > solution which is not relying on it.  
> >>  
> >>> I tried to resolve it in the past by adding completion to md driver and
> >>> force mdadm --stop command to wait for sysfs clean up but I have never
> >>> finished it. IMO it is a better way, wait for device to be fully removed
> >>> by MD during stop. Thoughts?    
> >>
> >> I don't think that would work very well. Userspace would end up blocking
> >> on --stop indefinitely if there are any references delaying cleanup to
> >> the device. That's not very user friendly. Given that opening the md
> >> device has side-effects, I think we should avoid opening when we
> >> should know that we are about to try to create a new device.  
> > 
> > Got it, thanks!
> > 
> > Hmm, so maybe the existing MD device should be marked as "in the middle of
> > removal" somehow to gives mdadm possibility to detect that. If we are using
> > node as name "/dev/mdX" then we will need to throw error, but when node
> > needs to be determined by find_free_devnm() then it will simply skip this
> > one and gives next one. But it will require changes in kernel probably.
> >   
> >>  
> >>> One objection I have here is that error handling is changed, so it could
> >>> be harmful change for users.     
> >>
> >> Hmm, yes seems like I was a bit sloppy here. However, it still seems
> >> possible to fix this up by not pre-opening the device. The only use for
> >> the mdfd in CREATE, ASSEMBLE and BUILD is to get the minor number if
> >> ident.super_minor == -2 and check if an existing specified device is an md 
> >> device (which may be redundant). We could replace this with a stat() call
> >> to avoid opening the device. What about the patch at the end of this
> >> email?  
> > 
> > LGTM, I put small comment. But as I said before, probably it don't fix all
> > creation cases.  
> 
> Hi Mariusz,
> 
> Just to recap on this, do you support applying this patch as is, or
> should we wait for the longer term fix you were mentioning?
> 
Hi Jes,
This patch looks good. Please apply next one version:
https://lore.kernel.org/linux-raid/20220727215246.121365-3-logang@deltatee.com/

Thanks,
Mariusz
