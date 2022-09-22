Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31643C6FA82
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 11:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbiIVLWb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Sep 2022 07:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiIVLWa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Sep 2022 07:22:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB38E05E1
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 04:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663845749; x=1695381749;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8viLB6k/Uy9Gf0iZlfdDFNLGVFN5RCqFt6VViHAnl3E=;
  b=MnLvGwXmSJHfVNgTWtiKJ0SvnI/LciQyr3d6EZQYVNVmhovvv9G5uoKv
   b07y0Je9bX1+hBHI2DeXj84rkWrdAyZNejTSCFggJnNg/Y6IwH++1+N6P
   8quEJ335zDCL1io1+cQk7Q4PdEWMFuzOTPTg+R4sxWc5x75TjRKBBYox/
   ibhonaFosTy1tTmSZyZkn28+kPIHDjWaoZqMrm1ovoV1s2ZQXSKvLkp+K
   UGD6yt4V6QVrWACGkB2TW30hvRAkMkQDAtE8yny2DA+kvHf6d91fDhJ/c
   hGueeEPI9YtE2T2b5ZLXazFpyf3Ypjy0zruYjAdDgKHSwEddPh3jUvpjc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301116686"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301116686"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:22:25 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="948556142"
Received: from mkusiak-mobl.ger.corp.intel.com (HELO [10.213.5.202]) ([10.213.5.202])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:22:23 -0700
Message-ID: <88738717-437f-9dab-f9c0-c9df905a4931@linux.intel.com>
Date:   Thu, 22 Sep 2022 13:22:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 08/10] Change update to enum in update_super and
 update_subarray
Content-Language: pl
To:     Coly Li <colyli@suse.de>, Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-9-mateusz.kusiak@intel.com>
 <9415B7D0-E2D6-486D-8143-AE53ED7657EF@suse.de>
From:   "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
In-Reply-To: <9415B7D0-E2D6-486D-8143-AE53ED7657EF@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14/09/2022 17:03, Coly Li wrote:
> 
> 
>> 2022年8月18日 22:56，Mateusz Kusiak <mateusz.kusiak@intel.com> 写道：
>>
>> Use already existing enum, change update_super and update_subarray
>> update to enum globally.
>> Refactor function references also.
>> Remove code specific options from update_options.
>>
>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>> ---
>> Assemble.c    | 14 +++++++++-----
>> Examine.c     |  2 +-
>> Grow.c        |  9 +++++----
>> Manage.c      | 14 ++++++++------
>> maps.c        | 21 ---------------------
>> mdadm.h       | 12 +++++++++---
>> super-intel.c | 16 ++++++++--------
>> super0.c      |  9 ++++-----
>> super1.c      | 17 ++++++++---------
>> 9 files changed, 52 insertions(+), 62 deletions(-)
>>
>>
> 
> [snipped]
> 
>> diff --git a/mdadm.h b/mdadm.h
>> index 7bc31b16..afc2e2a8 100644
>> --- a/mdadm.h
>> +++ b/mdadm.h
>> @@ -1010,7 +1010,7 @@ extern struct superswitch {
>> 	 *                    it will resume going in the opposite direction.
>> 	 */
>> 	int (*update_super)(struct supertype *st, struct mdinfo *info,
>> -			    char *update,
>> +			    enum update_opt update,
>> 			    char *devname, int verbose,
>> 			    int uuid_set, char *homehost);
>>
>> @@ -1136,9 +1136,15 @@ extern struct superswitch {
>> 	/* Permit subarray's to be deleted from inactive containers */
>> 	int (*kill_subarray)(struct supertype *st,
>> 			     char *subarray_id); /* optional */
>> -	/* Permit subarray's to be modified */
>> +	/**
>> +	 * update_subarray() - Permit subarray to be modified.
>> +	 * @st: Supertype.
>> +	 * @subarray: Subarray name.
>> +	 * @update: Update option.
>> +	 * @ident: Optional identifiers.
>> +	 */
> 
> Maybe we should follow existing comment code style like,
> 
> /* Commet start here,
>  * and second line.
>  */
> 
I am not concerned, IMO the comment (function description) follows kerel
standards.
There already are functions with this type of description inside the
file like signal_s() or close_fd().

> This patch doesn’t apply on latest mdadm upstream, in the mdadm-CI tree, I rebased the patch and push it into remotes/origin/20220903-testing.
> Could you please to check the rebased patch?
> 
I checked the branch and it looks good to me.
However, since there are allready fixes to be made, I'll rebase the
whole patchset anyway, on top of the master, when sending v2.
I'm planing to resend whole patchset to avoid complications.
I'm looking forward your response regarding the rest of the questions,
and I will resend patchset when everything is clear.

Thanks,
Mateusz

> Thanks.
> 
> Coly Li
