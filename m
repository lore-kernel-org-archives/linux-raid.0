Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F0DC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 19 Jan 2022 13:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354896AbiASN5s (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Jan 2022 08:57:48 -0500
Received: from mga07.intel.com ([134.134.136.100]:18718 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345358AbiASN5r (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 Jan 2022 08:57:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642600667; x=1674136667;
  h=message-id:date:mime-version:from:subject:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=3Yrfpm4QrTFlUZy68g0Oocj18OTVR1P/aBpEb8Nj2hw=;
  b=If+frCAZl9TfEMALTAgL7gJjB6MAjnEbIcXTbyvPDuLjcLf6hHYpbRJY
   CPoeL6FZ/oo9Smz1H3mvUjhO37ZXIMsyNmgPf9lrva9xrRHHFTuPwhjPP
   fjEGzZD+/Cc6u+xyDMZkCkY+0hXozve83vbcVQ0lKwFDYgUOaGG5NFryp
   0/dSIrNiKX8DrvYSlLcgeqotj2zUByyxBccLMCx9d/I4JlYpnRo41Ixlp
   kANgj6Lnz/b78Dn93ZLtVlTsDJ+ETmtMrQkEUZwnzN+raiXglL916iY7u
   AEtF2mAIWujBEYjq9grYjUPhHn/sXVd/Q1P8Da9kNKiEZdIU4zi3kDWIV
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="308410417"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="308410417"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 05:57:47 -0800
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="532294715"
Received: from ktanska-mobl.ger.corp.intel.com (HELO [10.213.6.83]) ([10.213.6.83])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 05:57:46 -0800
Message-ID: <0d59208d-4e25-983d-104a-cd624b9f3b0f@linux.intel.com>
Date:   Wed, 19 Jan 2022 14:57:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   "Tanska, Kinga" <kinga.tanska@linux.intel.com>
Subject: Re: Proposal of changing generating version of mdadm
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
References: <MN2PR11MB3776740E926BE3FE37C8B6E389BE9@MN2PR11MB3776.namprd11.prod.outlook.com>
 <835df064-87ca-a3c1-bd29-d8df62c79da3@trained-monkey.org>
 <MN2PR11MB3776D436514419C88FD67B61899F9@MN2PR11MB3776.namprd11.prod.outlook.com>
In-Reply-To: <MN2PR11MB3776D436514419C88FD67B61899F9@MN2PR11MB3776.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> On 10/20/21 8:43 AM, Tanska, Kinga wrote:
>> Hi,
>>
>> recently we diagnosed few issues with 'mdadm -version' output.
>> Main problem is that end output varies on few conditions. We come with
>> simplified proposal. First let's describe current schema:
>>
>> mdadm - version - date - extraversion
>> (example: mdadm - v4.2-rc2 - 2021-08-02 - extraversion)
>>
>> or
>>
>> mdadm - version - date
>> (example: mdadm - v4.2-rc2 - 2021-08-02).
>>
>> VERSION could be taken from code (see ReadMe.c:31), but when git is
>> installed and .git directory is available in mdadm workspace, version
>> is replaced with output from # git describe HEAD command. It is assumed
>> that git command should return last tag from repo, which should contain
>> information about last release. This might not be true, especially if 
>> user
>> uses tags to mark internal milestones or custom mdadm spins.
>>
>> The second problem is DATE, which corresponds to date of last release.
>> When few patches are picked onto HEAD date is not reliable. In my opinion
>> DATE is not needed. Usually, packages do not contain this element, e.g.
>> - # git --version
>> git version 2.27.0
>> - # gcc --version
>> gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5)
>> - # yum --version
>> 4.2.23
>>
>> To make it const and reliable, I propose removing DATE and always
>> use VERSION from code. VERSION shall keep general release information.
>> I would like to move the changeable elements into EXTRAVERSION. This
>> field will respect following conditions:
>> - user definition first
>> (by respecting EXTRAVERSION=xxx during compilation)
>> - if not defined by user, result of # git describe HEAD
>> - else empty.
>>
>> Example output:
>> mdadm - version - extraversion (example: mdadm - v4.2-rc2 - 
>> extraversion).
>> Thanks for any opinion about this proposition.
>
> Hi Kinga,
>
> I am not against changing the format, however I worry that doing so may
> break scripts and tools in the field that nobody is maintaining or have
> thought of. If we are to change the output, I suggest making a new flag
> that provides the details you want and we can deprecate the old one, but
> leave it in place.
>
> Thoughts?
>
> Jes
>

Thanks for your response.
I'm wondering if this change will be used if not will be set as default. 
I suggest
providing a new flag with old, deprecated version, for any of uses where it
couldn't be changed. I can add a description which clarify the change 
and describe
flag, for anybody who will meet errors with scripts after this change.

Regards,
Kinga Tanska

