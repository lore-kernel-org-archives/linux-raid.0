Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE39AC28D13
	for <linux-raid@archiver.kernel.org>; Thu, 25 Aug 2022 07:59:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbiHYH72 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 25 Aug 2022 03:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234566AbiHYH71 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 25 Aug 2022 03:59:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788D4A3D1B
        for <linux-raid@vger.kernel.org>; Thu, 25 Aug 2022 00:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661414366; x=1692950366;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l0I1UDJGALxPU24GLk/1Kxx8n7bxkiq5Sb452bS/76o=;
  b=m+V1r8VOzYe8BoWYok6VSiLx4vBsHxHchmY8+QOdcfnQBTia4EQHCmwy
   V5Wt6dT+4045iGoG80dZVrpI7NVsxcDn20UQbBVz4foaTETHZ08bsVOsa
   BFmDzjes89h6J133y8Wl6BZ8HarKxXSfXBnbSwzIO0muz2fcO70pINgws
   9US3P1zM/qWlvu0MRG7EPZ7Z02sSAFZVwcVjAOOhqrVTcCYbUiXyObl6K
   chZMQFS5DQjYhSRXEYE4doMND3oX3i0tvNtm5ZffsRFPyvQk0mO2sE5OS
   gkFaR2AXI5tdguS5MmMExR/Js6oJiq5qTn5q4rjfzW561GsgBAzRGStBs
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="355900833"
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="355900833"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 00:59:26 -0700
X-IronPort-AV: E=Sophos;i="5.93,262,1654585200"; 
   d="scan'208";a="586771585"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.52.242])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 00:59:24 -0700
Date:   Thu, 25 Aug 2022 09:59:17 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     "NeilBrown" <neilb@suse.de>
Cc:     "Jes Sorensen" <jes@trained-monkey.org>,
        "Paul Menzel" <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
Subject: Re: [PATCH mdadm v2] super1: report truncated device
Message-ID: <20220825095917.00002549@linux.intel.com>
In-Reply-To: <166138706173.27490.18440987438153337183@noble.neil.brown.name>
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>
        <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
        <165768409124.25184.3270769367375387242@noble.neil.brown.name>
        <20220721101907.00002fee@linux.intel.com>
        <165855103166.25184.12700264207415054726@noble.neil.brown.name>
        <20220725094238.000014f0@linux.intel.com>
        <1c04ce1c-cf02-2891-cb88-c5f91a80f620@trained-monkey.org>
        <166138706173.27490.18440987438153337183@noble.neil.brown.name>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 25 Aug 2022 10:24:21 +1000
"NeilBrown" <neilb@suse.de> wrote:

> On Thu, 25 Aug 2022, Jes Sorensen wrote:
> > On 7/25/22 03:42, Mariusz Tkaczyk wrote:  
> > > On Sat, 23 Jul 2022 14:37:11 +1000
> > > "NeilBrown" <neilb@suse.de> wrote:
> > >   
> > >> On Thu, 21 Jul 2022, Mariusz Tkaczyk wrote:  
> > >>> Hi Neil,
> > >>>
> > >>> On Wed, 13 Jul 2022 13:48:11 +1000
> > >>> "NeilBrown" <neilb@suse.de> wrote:  
> > ....  
> > >>> why not just:
> > >>> if (__le64_to_cpu(super->data_offset) + __le64_to_cpu(super->data_size)
> > >>> > dsize) from my understanding, only this check matters.    
> > >>
> > >> It seemed safest to test both.  I don't remember the difference between  
> > >> ->size and ->data_size.  In getinfo_super1() we have    
> > >>
> > >> 	if (info->array.level <= 0)
> > >> 		data_size = __le64_to_cpu(sb->data_size);
> > >> 	else
> > >> 		data_size = __le64_to_cpu(sb->size);
> > >>
> > >> which suggests that either could be relevant.
> > >> I guess ->size should always be less than ->data_size.  But
> > >> load_super1() doesn't check that, so it isn't safe to assume it.  
> > > 
> > > Honestly, I don't understand why but I didn't realize that you are
> > > checking two different fields (size and data_size). I focused on
> > > understanding what is going on  here, and didn't catch difference in
> > > variables (because data_offset and data_size have similar prefix).
> > > For me, something like:
> > > 
> > > unsigned long long _size;
> > > if (st->minor_version >= 1 && st->ignore_hw_compat == 0)
> > >     _size= __le64_to_cpu(super->size);
> > > else
> > >     _size= __le64_to_cpu(super->data_size);
> > > 
> > > if (__le64_to_cpu(super->data_offset) + _size > dsize)
> > > {....}
> > > 
> > > is more readable because I don't need to analyze complex if to get the
> > > difference. Also, I removed doubled __le64_to_cpu(super->data_offset).
> > > Could you refactor this part?  
> > 
> > What is the consensus on this discussion? I see Coly pulled this into
> > his tree, but I don't see Mariusz's last concern being addressed.  
> 
> I don't think we reached a consensus.  I probably got distracted.
> I don't like that suggestion from Mariusz as it makes assumptions that I
> didn't want to make.  I think it is safest to always test dsize against
> bother ->size and ->data_size without baking in assumptions about when
> either is meaningful.
> 
Hi Neil,
It seems that I failed to understand it again. You are right, you approach is
safer. Please fix stylistic issues then and I'm fine with the change.

Sorry for confusing you,
Mariusz

