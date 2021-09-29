Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAD62C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 29 Sep 2021 08:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C87D060EBD
	for <linux-raid@archiver.kernel.org>; Wed, 29 Sep 2021 08:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244385AbhI2IGh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:06:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:45134 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244389AbhI2IGe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 29 Sep 2021 04:06:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="224542106"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="224542106"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 01:04:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="437550519"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga006.jf.intel.com with ESMTP; 29 Sep 2021 01:04:31 -0700
Received: from [10.213.24.85] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.24.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 9C5335807C8;
        Wed, 29 Sep 2021 01:04:30 -0700 (PDT)
Subject: Re: [PATCH 4/4 v4] mdmon: bad block support for external metadata -
 clear bad blocks
To:     NeilBrown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com
References: <1477558425-13332-1-git-send-email-tomasz.majchrzak@intel.com>
 <1477558425-13332-4-git-send-email-tomasz.majchrzak@intel.com>
 <163287340289.31063.8425995521501370134@noble.neil.brown.name>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <4912c8dd-e15f-07aa-23a8-98d794169e8e@linux.intel.com>
Date:   Wed, 29 Sep 2021 10:04:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <163287340289.31063.8425995521501370134@noble.neil.brown.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Neil,
Thanks for your analysis and suggestions.
I will try to address them.

We are testing current implementation and it is working (at least for
tested scenarios).

Thanks,
Mariusz

On 29.09.2021 01:56, NeilBrown wrote:
> On Thu, 27 Oct 2016, Tomasz Majchrzak wrote:
>> If an update of acknowledged bad blocks file is notified, read entire
>> bad block list from sysfs file and compare it against local list of bad
>> blocks. If any obsolete entries are found, remove them from metadata.
>>
>> As mdmon cannot perform any memory allocation, new superswitch method
>> get_bad_blocks is expected to return a list of bad blocks in metadata
>> without allocating memory. It's up to metadata handler to allocate all
>> required memory in advance.
> 
> hi,
>   only 5 years late to this party :-)
> 
>   I recently had cause the look at this code and ... there are problems.
> 
>   Primarily, it assumes that the "bad_blocks" file contains a complete
>   list of bad blocks known to the kernel.  This is not correct.
>   As the documentation and nearby comments say, the contents of this file
>   is truncated to PAGE_SIZE.  It is not meant to be a complete list, only
>   an indicative list.
>   There is no way to get a complete list from the kernel once the list
>   gets too large.  Probably we should design and implement a reliable way
>   to extract this information.  I imagine it would be something like
>   unacknowledged_bad_blocks, in that mdmon could read some information,
>   then confirm that it has been read, then read some more.  But until
>   that it done, this code should be careful not to assume that the list
>   is complete - at least not without checking.
> 
>   Secondly, the interface with the metadata handler is a bit odd.
>   The 'check_for_cleared_bb' essentially does:
>     - call ->record_bad_block  for all blocks known to the kernel
>     - call ->clear_bad_block   for all blocks that were in the metadata
>    in that order.
>    It isn't quite that simple as there are optimisations:
>      if a range from kernel exactly matches a range in metadata, the
>        range is neither recorded or cleared
>      If a range from the kernel is a subrange of a range in metadata,
>        then the larger range is cleared before the new range is added,
>        AS WELL AS after.
> 
>    If there are other overlaps, then the kernel range is recorded
>    before the metadata range is cleared.  This *seems* wrong.  I would
>    expect this to clear part of the range that had just been added.
> 
>    However, it doesn't.  The ->clear_bad_block interface *DOESN'T* remove
>    all the block in the range from the bbl.  Rather, if the exact range
>    given appears as one of the ranges in the bbl, then that range is
>    deleted.  Otherwise no change happens.
>    These semantics are surprising.  The net result is that the code
>    probably works with the imsm backend.  However if someone else wrote a
>    different backend which implemented ->clear_bad_block to actually
>    remove the entire range from the bbl, then it would clear more blocks
>    than it should.
> 
>    I think it would be really good to re-implement this code in a way
>    that was more maintainable.
>    I don't think "check_for_cleared_bb()" should *ever* record new bad
>    block ranges.  They get recorded through the unacknowledged_bad_block
>    processing.  "check_for_cleared_bb()" should ONLY delete blocks from the
>    bbl, and it should ONLY do that if it certain that the information in
>    "bad_blocks" is complete.
> 
>    It should read bad_blocks in a single read().  If the returned data
>    ends with a newline, and is not a power-of-2 in size, then it is
>    safe to assume that it is complete.
>    If it doesn't end with a newline, then it is definitely not complete.
>    If it is a power-of-2 less than 4096, then it can be assumed to be
>    complete.  If it is exactly 4096 bytes, or a larger power of two, then
>    it is not safe to assume that it is complete.
> 
> Thanks,
> NeilBrown
> 

