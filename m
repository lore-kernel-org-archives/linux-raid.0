Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F43C64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 12:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjCCMEU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 07:04:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCCMES (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 07:04:18 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41151768D
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 04:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677845057; x=1709381057;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sBZdgMWbEy0igevUcfagRh/lmUV1GKYPzBj9Es4YVwI=;
  b=LJo47j0sc30HfnOT0h4oke1vpGgQhYislQ/fZOgvMSCP0GE8Mm9eYGIL
   LRbIObFyLaPMHkXavKnZBG5SzcbcLaZbtpub4WXxczon9tIgg9kib78Kk
   0LKhJVQH/FD3oZOBUObxJ7IR5WpyNhIBmnUFfNr0gOJA865DTYLO81aCS
   mCGL1zcf8so1M4Tg4Li2zrGWcM7P+C+C/mem/v51i1aCyZ0ZJl1LpANb5
   Rnz3Tb8/mfVz3dpsIOfIARAignTWxKXzt7AkVjmHDDUXqbH8lNvaP5jZD
   UCGcxJ26hHFiqFWCPDqrsmbsqelHYQJdveDO2uO0O7U7NHhDNxDjRdDdn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="337343600"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="337343600"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 04:04:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10637"; a="764398158"
X-IronPort-AV: E=Sophos;i="5.98,230,1673942400"; 
   d="scan'208";a="764398158"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.104])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2023 04:04:15 -0800
Date:   Fri, 3 Mar 2023 13:04:10 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     colyli@suse.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/3] mdadm: refactor ident->name handling
Message-ID: <20230303130410.000043e0@linux.intel.com>
In-Reply-To: <0017b6dc-b0c0-7d4e-4765-fcc429b41862@trained-monkey.org>
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
        <20221221115019.26276-3-mariusz.tkaczyk@linux.intel.com>
        <bef57069-acdb-3a2f-b691-2c438c4247fb@trained-monkey.org>
        <20221229103931.00006ff0@linux.intel.com>
        <0017b6dc-b0c0-7d4e-4765-fcc429b41862@trained-monkey.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 2 Mar 2023 09:52:31 -0500
Jes Sorensen <jes@trained-monkey.org> wrote:

> On 12/29/22 04:39, Mariusz Tkaczyk wrote:
> 
> Hi Mariusz,
> 
> Apologies for the slow response on this one.
> 
> > On Wed, 28 Dec 2022 10:07:22 -0500
> > Jes Sorensen <jes@trained-monkey.org> wrote:  
> 
> >> I appreciate the work to consolidate duplicate code. However, I am not a
> >> fan of new typedefs, in addition you return status_t codes in functions
> >> changed to return error_t, which is inconsistent.  
> > 
> > Hi Jes,
> > Indeed, initially I named it as error_t and I forgot to update that part.
> > I'm surprised that compiler didn't catch it. Thanks!
> > 
> > About typedef, I did it same for IMSM already:
> > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/super-intel.c#n376
> > I can change that but I wanted to define a common solution propagated later
> > to other mdadm parts.  
> 
> I am really on the fence on this one. I'd very much like to see us get
> away from the nasty 0/1/2 error codes we currently have all over the
> place, but I am also vary of reinventing the wheel.
> 
> I must admit I missed it in super-intel.c
> 
> >> I would prefer if we move towards standard POSIX error codes instead of
> >> trying to invent new ones.
> >>  
> > 
> > The POSIX errors are defined for communication with kernel space and
> > unfortunately they are not detailed enough. For example "undefined" or
> > just "general_error" statuses are not available.
> > https://man7.org/linux/man-pages/man3/errno.3.html
> > It the approach I proposed we are free to create exact errors we need.
> > Later we can create a map of error values to string and create dedicated
> > error print functions.  
> 
> I agree that POSIX codes aren't perfect, however at least for the
> current errors I see reported in this patch -EINVAL or -E2BIG ought to
> cover. If you think there are many cases where we cannot map well to
> POSIX, then I would be OK with it, but I would prefer to go straight to
> a global error code space rather than one per subsystem.
> 
> Thoughts?
> 
Hi Jes,

I was in this place with ledmon project:
https://github.com/intel/ledmon/blob/master/src/status.h

Yeah, it seems to be overhead to maintain error enum per each subsystem yet, you
are right here. I don't plan huge code reactor to make those enums common used.
If we don't plan mdadm library, then there is no need to handle define multiple
enums. It has real sense if we want to hide some statuses from library user
inside our code.

I would like to handle internal error definitions because I think that mdadm
deserves flexibility to define status what it needs. In general case we needs
just *error* but when it comes to more advanced flows I can see multiple
meaningful statuses we need to differentiate. The goal here is to make errors
straightforward.

I don't consider it as reinventing the wheel because the software is free
to define error handlers as it wants. There are no restrictions and POSIX codes
are not a solution. POSIX codes are available to us because we need to
understand kernel error codes and we need to handle them and react
appropriately.

Simply, I would like to have error possibly the best self described and the
error enum allows me to achieve that. It also forces developers to
follow the statuses we have there because if something like that is defined,
there is high probability that maintainer will ask developer to use this enum
in new function and use meaningful error codes respectively.

I would like to add this enum to mdadm.h but I will avoid to adding more enum
in the future if there is no need to. Let me know if that works for you.

Thanks for discussion!
Mariusz
