Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66404C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 08:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbiDEIkz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Apr 2022 04:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241232AbiDEIc4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Apr 2022 04:32:56 -0400
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE5EC1D
        for <linux-raid@vger.kernel.org>; Tue,  5 Apr 2022 01:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649147400; x=1680683400;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o1/1mtHEDtIEDPfROzoqHr/naxzbkUZzwVkW8pBTWs4=;
  b=WlU60BMWeEvmnqgYWNSEBmRiLsUzd6OHaaXwOtCs6oCprKhkh53FeZoa
   3o6as+7IuyDDkMY5l94UU94xiKuHvTNgGi1vZOg5PAQs9yh+6kExdYolR
   ZGImk2ow8J79bTkEWrI4cDuoWZYYb+V7RMiy6seiQPrTbQsj9UwAuMMPZ
   TPXl/fdwSqrmcbmo/atlhhUfVcoZBaCdUNCdNu+gTQ2eKNIovi7Q/Ezap
   N5U6zUuvoKRbRJJ1vIM0/u9aEYsdNZKPJ82dlyTabGbso5l8+CKaSLbB8
   14zxtHejiZooHBE4ipmGqLTx+9quqUyk7HB6MWxu5DbscNh6Yxfm/lPZo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="321390852"
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="321390852"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 01:28:31 -0700
X-IronPort-AV: E=Sophos;i="5.90,236,1643702400"; 
   d="scan'208";a="548969999"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.25.138])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2022 01:28:30 -0700
Date:   Tue, 5 Apr 2022 10:28:25 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] mdadm: add map_num_s()
Message-ID: <20220405102825.00002148@linux.intel.com>
In-Reply-To: <968c2d7f-5115-486d-063a-f384aba2baae@trained-monkey.org>
References: <20220120121833.16055-1-mariusz.tkaczyk@linux.intel.com>
        <20220120121833.16055-3-mariusz.tkaczyk@linux.intel.com>
        <968c2d7f-5115-486d-063a-f384aba2baae@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 4 Apr 2022 21:32:09 -0400
Jes Sorensen <jes@trained-monkey.org> wrote:

> On 1/20/22 07:18, Mariusz Tkaczyk wrote:
> > map_num() returns NULL if key is not defined. This patch adds
> > alternative, non NULL version for cases where NULL is not expected.
> > 
> > There are many printf() calls where map_num() is called on variable
> > without NULL verification. It works, even if NULL is passed because
> > gcc is able to ignore NULL argument quietly but the behavior is
> > undefined. For safety reasons such usages will use map_num_s() now.
> > It is a potential point of regression.  
> 
> Hi Mariusz,
> 
> I'll be honest with you, I don't like assert(), I consider it a lame
> excuse for proper error handling. That said, not blaming you as this
> is old code and it would take a lot of cleaning up, so this is better
> than nothing.

And that is true, assert() is not for errors handling. Is was made for
verifying function/application flows. Like here, I made not null
function and I guarantee that won't be returned. If it comes, then it
is a developer mistake and assert() should discover that during
testing.

Please see man:
https://man7.org/linux/man-pages/man3/assert.3.html

       If the macro NDEBUG is defined at the moment <assert.h> was last
       included, the macro assert() generates no code, and hence does
       nothing at all.  It is not recommended to define NDEBUG if using
       assert() to detect error conditions since the software may behave
       non-deterministically.

For production, the macro should be set and it generates no code. So
the behavior is configurable and OSV should add this flag to their
mdadm builds. In this case, we will end with previous implementation but
no additional error handling is required to satisfy our and external
requirements (like static code analysis).

It is also useful to validate function parameters which must be set, to
not insert dead conditions. Ideally, we should execute test with
asserts enabled to verify use cases.

Thanks,
Mariusz

