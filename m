Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8406C64EC4
	for <linux-raid@archiver.kernel.org>; Thu,  9 Mar 2023 08:03:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjCIIDA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Mar 2023 03:03:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjCIIC3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Mar 2023 03:02:29 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D629910246
        for <linux-raid@vger.kernel.org>; Thu,  9 Mar 2023 00:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678348933; x=1709884933;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bDP+rmdL55oOuY4Pq25SVHe7wWdV60HlABSAK/IPbHE=;
  b=i4wbWCr40XFqOdfJtX3N15EEh0/KZnVXyu+QUY+8gc9rQQGBCB8LXWt/
   XW+wjhLwXWgKSG4Ugm20tCC6Cb7fj4kNxLzZK1ik9rmjx/bjd4Nkc0wau
   vQ/kXtCBHn4nMoH65LsNSW4DlRTZpK2nYTWdIwuHNYF7xbO45zDJfaybB
   Bm6yhUkqLk39l84gNjSssXxnvZf6wBFMYKniH37yImgbpFylBl7o56it0
   elDfkZK5nb1jrZ14gDU8M4bbLNuZSfyX/s7SCXyIiXiY05dP8WVar2Yzz
   c6FRPj9QMhNPC4DR6iPTh0bTtz9/p2mQXpvch/jgLw+oSeh7oymEXerK+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="316040236"
X-IronPort-AV: E=Sophos;i="5.98,245,1673942400"; 
   d="scan'208";a="316040236"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 00:02:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10643"; a="654660323"
X-IronPort-AV: E=Sophos;i="5.98,245,1673942400"; 
   d="scan'208";a="654660323"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.46.155])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 00:02:12 -0800
Date:   Thu, 9 Mar 2023 09:02:07 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     colyli@suse.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/3] mdadm: refactor ident->name handling
Message-ID: <20230309090207.00002769@linux.intel.com>
In-Reply-To: <824b2eca-cada-43b2-be8f-100676654bb2@trained-monkey.org>
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
        <20221221115019.26276-3-mariusz.tkaczyk@linux.intel.com>
        <bef57069-acdb-3a2f-b691-2c438c4247fb@trained-monkey.org>
        <20221229103931.00006ff0@linux.intel.com>
        <0017b6dc-b0c0-7d4e-4765-fcc429b41862@trained-monkey.org>
        <20230303130410.000043e0@linux.intel.com>
        <824b2eca-cada-43b2-be8f-100676654bb2@trained-monkey.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 8 Mar 2023 14:04:12 -0500
Jes Sorensen <jes@trained-monkey.org> wrote:

> On 3/3/23 07:04, Mariusz Tkaczyk wrote:
> > On Thu, 2 Mar 2023 09:52:31 -0500
> > Jes Sorensen <jes@trained-monkey.org> wrote:
> >   
> >> On 12/29/22 04:39, Mariusz Tkaczyk wrote:
> >>
> >> Hi Mariusz,
> >>
> >> Apologies for the slow response on this one.
> >>  
> >>> On Wed, 28 Dec 2022 10:07:22 -0500
> >>> Jes Sorensen <jes@trained-monkey.org> wrote:    
> >>  
> >>>> I appreciate the work to consolidate duplicate code. However, I am not a
> >>>> fan of new typedefs, in addition you return status_t codes in functions
> >>>> changed to return error_t, which is inconsistent.    
> >>>
> >>> Hi Jes,
> >>> Indeed, initially I named it as error_t and I forgot to update that part.
> >>> I'm surprised that compiler didn't catch it. Thanks!
> >>>
> >>> About typedef, I did it same for IMSM already:
> >>> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/super-intel.c#n376
> >>> I can change that but I wanted to define a common solution propagated
> >>> later to other mdadm parts.    
> >>
> >> I am really on the fence on this one. I'd very much like to see us get
> >> away from the nasty 0/1/2 error codes we currently have all over the
> >> place, but I am also vary of reinventing the wheel.
> >>
> >> I must admit I missed it in super-intel.c
> >>  
> >>>> I would prefer if we move towards standard POSIX error codes instead of
> >>>> trying to invent new ones.
> >>>>    
> >>>
> >>> The POSIX errors are defined for communication with kernel space and
> >>> unfortunately they are not detailed enough. For example "undefined" or
> >>> just "general_error" statuses are not available.
> >>> https://man7.org/linux/man-pages/man3/errno.3.html
> >>> It the approach I proposed we are free to create exact errors we need.
> >>> Later we can create a map of error values to string and create dedicated
> >>> error print functions.    
> >>
> >> I agree that POSIX codes aren't perfect, however at least for the
> >> current errors I see reported in this patch -EINVAL or -E2BIG ought to
> >> cover. If you think there are many cases where we cannot map well to
> >> POSIX, then I would be OK with it, but I would prefer to go straight to
> >> a global error code space rather than one per subsystem.
> >>
> >> Thoughts?
> >>  
> > Hi Jes,
> > 
> > I was in this place with ledmon project:
> > https://github.com/intel/ledmon/blob/master/src/status.h
> > 
> > Yeah, it seems to be overhead to maintain error enum per each subsystem
> > yet, you are right here. I don't plan huge code reactor to make those enums
> > common used. If we don't plan mdadm library, then there is no need to
> > handle define multiple enums. It has real sense if we want to hide some
> > statuses from library user inside our code.
> > 
> > I would like to handle internal error definitions because I think that mdadm
> > deserves flexibility to define status what it needs. In general case we
> > needs just *error* but when it comes to more advanced flows I can see
> > multiple meaningful statuses we need to differentiate. The goal here is to
> > make errors straightforward.
> > 
> > I don't consider it as reinventing the wheel because the software is free
> > to define error handlers as it wants. There are no restrictions and POSIX
> > codes are not a solution. POSIX codes are available to us because we need to
> > understand kernel error codes and we need to handle them and react
> > appropriately.
> > 
> > Simply, I would like to have error possibly the best self described and the
> > error enum allows me to achieve that. It also forces developers to
> > follow the statuses we have there because if something like that is defined,
> > there is high probability that maintainer will ask developer to use this
> > enum in new function and use meaningful error codes respectively.
> > 
> > I would like to add this enum to mdadm.h but I will avoid to adding more
> > enum in the future if there is no need to. Let me know if that works for
> > you.  
> 
> Sounds fair!
> 
> Maybe it would be worth starting the enum outside the range of the
> regular errno so they can overlap? Not sure if it adds any value, just a
> thought.
> 
I see no value either.
What if someone will add new error definition to errno? Should we change our
enum start then? I think that nobody will notice it until issue but it is
unlikely too. For that reason I think that it is pointless from the beggining
because we are defnining rule which won't be honored later.

I think that we can just to redefine errno codes in enum if they are needed. We
are free to change particular enum constant value to make room for errno
compatible codes if there will be need to. That should be safe if some code
does not have ugly trick like calling external function and comparing it with
enum constant:

*/ let's say that SUCCESS is 0 */
if (strncmp(arg, arg1, arg2) == ENUM_STATUS_SUCCESS)

but it is our job to catch it on review so we are safe here, right? :)

Thanks,
Mariusz
