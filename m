Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBECC5479D
	for <linux-raid@archiver.kernel.org>; Mon,  9 Jan 2023 10:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbjAIKwC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 Jan 2023 05:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbjAIKvm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 Jan 2023 05:51:42 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8616D64D3
        for <linux-raid@vger.kernel.org>; Mon,  9 Jan 2023 02:51:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673261500; x=1704797500;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NE8NacTS9oMk8TmWRT0ADxuKO1/BIPewmr6eewzRm2I=;
  b=Kx5ApqzI+mJdD4JOuwH1PFUq9AlXneUP+On1NrBtSPCoF6NT5oPo+MOI
   Md3UizIZ0VgmLpg0y3bddN9ggbAvqKudigWyxqIRGQYWuC8D/ZAUi7Vyw
   7nSKrf6X3e8zciVIvqR86sKdSBW/C5Cw366vPju5+Tsk39+XJjxjl9SlG
   vhtXGHNHYcOQ1RQOoILkB8H28oO9VdbzylYrbKFMoq+ov1Poyuvqfwt/V
   9aqwltPy19tiIrqJO3kAaGpXmAc0MWtsh5wS6/v4YyOfEe5UOFXt3zxVV
   knHwpQt2NFBAp1BD1LkYuaNJwvilOM950+pBAltXNa1Yn1hXfZcSR5eSm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="385145825"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="385145825"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 02:51:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10584"; a="764271562"
X-IronPort-AV: E=Sophos;i="5.96,311,1665471600"; 
   d="scan'208";a="764271562"
Received: from bachaue1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.51.235])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2023 02:51:21 -0800
Date:   Mon, 9 Jan 2023 11:51:16 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     colyli@suse.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/3] mdadm: refactor ident->name handling
Message-ID: <20230109115116.00005862@linux.intel.com>
In-Reply-To: <20221229103931.00006ff0@linux.intel.com>
References: <20221221115019.26276-1-mariusz.tkaczyk@linux.intel.com>
        <20221221115019.26276-3-mariusz.tkaczyk@linux.intel.com>
        <bef57069-acdb-3a2f-b691-2c438c4247fb@trained-monkey.org>
        <20221229103931.00006ff0@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 29 Dec 2022 10:39:31 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> On Wed, 28 Dec 2022 10:07:22 -0500
> Jes Sorensen <jes@trained-monkey.org> wrote:
> 
> > On 12/21/22 06:50, Mariusz Tkaczyk wrote:  
> > > Move duplicated code for both config.c and mdadm.c to new functions.
> > > Add error enum in mdadm.h. Use MD_NAME_MAX instead hardcoded value
> > > in mddev_ident. Use secure functions.
> > > 
> > > In next patch POSIX validation is added.
> > > 
> > > Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>    
> > 
> > Hi Mariusz,
> > 
> > I appreciate the work to consolidate duplicate code. However, I am not a
> > fan of new typedefs, in addition you return status_t codes in functions
> > changed to return error_t, which is inconsistent.  
> 
> Hi Jes,
> Indeed, initially I named it as error_t and I forgot to update that part.
> I'm surprised that compiler didn't catch it. Thanks!
> 
> About typedef, I did it same for IMSM already:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/super-intel.c#n376
> I can change that but I wanted to define a common solution propagated later to
> other mdadm parts.
> 
> > 
> > I would prefer if we move towards standard POSIX error codes instead of
> > trying to invent new ones.
> >   
> 
> The POSIX errors are defined for communication with kernel space and
> unfortunately they are not detailed enough. For example "undefined" or
> just "general_error" statuses are not available.
> https://man7.org/linux/man-pages/man3/errno.3.html
> It the approach I proposed we are free to create exact errors we need.
> Later we can create a map of error values to string and create dedicated
> error print functions.
> 

Hi Jes,
Should I drop this enum in v2?

Thanks,
Mariusz
