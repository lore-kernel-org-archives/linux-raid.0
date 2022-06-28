Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94298C43334
	for <linux-raid@archiver.kernel.org>; Tue, 28 Jun 2022 07:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343704AbiF1HC6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Jun 2022 03:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343915AbiF1HCs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Jun 2022 03:02:48 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA02627165
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 00:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656399766; x=1687935766;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rAloK1GGDKIdp7yd9HoRpwSFbijbo91q4YMG/mlo/ac=;
  b=KwBWEvj5QZ5mxlFIH11qRMyZ0reCrL3wNN6zXRr/5YXfgbexAKD5no2+
   JudyMKiHUDGDWpwAOON8/iS7SgDa6D2l+P4eLGFV1zZLRufm2uaw8Ht15
   N1z6FUG495Ispygn09PRnGvaNVJpqrbq/tDgqWcI/Lwck6bnZrl99fJQt
   Nl0zVPSFyMnsa7dLJ6TMhZyF1WXAh75N9kH6mRrSMwaVgjRPB5H0SmD5I
   H6O0LKFuApjIXfRs9/2Je36FLbBrD4UQFOoxfBJsKkd6WbtWXOmx45pQM
   zzKtNm5roNb/EQfZLrEPDd48cq2o5mxUStQGkH+HV21Xe8g4UgYBDIAFb
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="343343928"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="343343928"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 00:02:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="646783107"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.37.142])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 00:02:31 -0700
Date:   Tue, 28 Jun 2022 09:02:27 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Alex Wu <alexwu@synology.com>,
        BingJing Chang <bingjingc@synology.com>,
        Danny Shih <dannyshih@synology.com>,
        ChangSyun Peng <allenpeng@synology.com>
Subject: Re: [PATCH mdadm v2 04/14] mdadm/Grow: Fix use after close bug by
 closing after fork
Message-ID: <20220628090227.000034bc@linux.intel.com>
In-Reply-To: <20220622202519.35905-5-logang@deltatee.com>
References: <20220622202519.35905-1-logang@deltatee.com>
        <20220622202519.35905-5-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 22 Jun 2022 14:25:09 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> The test 07reshape-grow fails most of the time. But it succeeds around
> 1 in 5 times. When it does succeed, it causes the tests to die because
> mdadm has segfaulted.
> 
> The segfault was caused by mdadm attempting to repoen a file
> descriptor that was already closed. The backtrace of the segfault
> was:
> 
>   #0  __strncmp_avx2 () at ../sysdeps/x86_64/multiarch/strcmp-avx2.S:101
>   #1  0x000056146e31d44b in devnm2devid (devnm=0x0) at util.c:956
>   #2  0x000056146e31dab4 in open_dev_flags (devnm=0x0, flags=0)
>                          at util.c:1072
>   #3  0x000056146e31db22 in open_dev (devnm=0x0) at util.c:1079
>   #4  0x000056146e3202e8 in reopen_mddev (mdfd=4) at util.c:2244
>   #5  0x000056146e329f36 in start_array (mdfd=4,
>               mddev=0x7ffc55342450 "/dev/md0", content=0x7ffc55342860,
>               st=0x56146fc78660, ident=0x7ffc55342f70, best=0x56146fc6f5d0,
>               bestcnt=10, chosen_drive=0, devices=0x56146fc706b0, okcnt=5,
> 	      sparecnt=0,  rebuilding_cnt=0, journalcnt=0, c=0x7ffc55342e90,
> 	      clean=1,  avail=0x56146fc78720 "\001\001\001\001\001",
> 	      start_partial_ok=0, err_ok=0, was_forced=0)
> 	                  at Assemble.c:1206
>   #6  0x000056146e32c36e in Assemble (st=0x56146fc78660,
>                mddev=0x7ffc55342450 "/dev/md0", ident=0x7ffc55342f70,
> 	       devlist=0x56146fc6e2d0, c=0x7ffc55342e90)
> 	                 at Assemble.c:1914
>   #7  0x000056146e312ac9 in main (argc=11, argv=0x7ffc55343238)
>                          at mdadm.c:1510
> 
> The file descriptor was closed early in Grow_continue(). The noted commit
> moved the close() call to close the fd above the fork which caused the
> parent process to return with a closed fd.
> 
> This meant reshape_array() and Grow_continue() would return in the parent
> with the fd forked. The fd would eventually be passed to reopen_mddev()
> which returned an unhandled NULL from fd2devnm() which would then be
> dereferenced in devnm2devid.
> 
> Fix this by moving the close() call below the fork. This appears to
> fix the 07revert-grow test. While we're at it, switch to using
> close_fd() to invalidate the file descriptor.
> 
> Fixes: 77b72fa82813 ("mdadm/Grow: prevent md's fd from being occupied during
> delayed time") Cc: Alex Wu <alexwu@synology.com>
> Cc: BingJing Chang <bingjingc@synology.com>
> Cc: Danny Shih <dannyshih@synology.com>
> Cc: ChangSyun Peng <allenpeng@synology.com>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
