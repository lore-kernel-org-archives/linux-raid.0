Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984DEC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 22 Nov 2021 13:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbhKVNHv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:07:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:41685 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229797AbhKVNHu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 22 Nov 2021 08:07:50 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10175"; a="222001439"
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="scan'208";a="222001439"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 05:04:43 -0800
X-IronPort-AV: E=Sophos;i="5.87,254,1631602800"; 
   d="scan'208";a="496852412"
Received: from ktanska-mobl.ger.corp.intel.com (HELO [10.213.22.108]) ([10.213.22.108])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2021 05:04:42 -0800
Message-ID: <ab6c516e-c3ba-19e4-379f-692eb3c624c4@linux.intel.com>
Date:   Mon, 22 Nov 2021 14:04:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: Proposal of changing generating version of mdadm
To:     jes@trained-monkey.org
References: <MN2PR11MB3776740E926BE3FE37C8B6E389BE9@MN2PR11MB3776.namprd11.prod.outlook.com>
 <835df064-87ca-a3c1-bd29-d8df62c79da3@trained-monkey.org>
 <MN2PR11MB3776D436514419C88FD67B61899F9@MN2PR11MB3776.namprd11.prod.outlook.com>
From:   "Tanska, Kinga" <kinga.tanska@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
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
>> information about last release. This might not be true, especially if user
>> uses tags to mark internal milestones or custom mdadm spins.
>>
>> The second problem is DATE, which corresponds to date of last release.
>> When few patches are picked onto HEAD date is not reliable. In my opinion
>> DATE is not needed. Usually, packages do not contain this element, e.g.
>> -	# git --version
>> 		git version 2.27.0
>> -	# gcc --version
>> 		gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5)
>> -	# yum --version
>> 		4.2.23
>>
>> To make it const and reliable, I propose removing DATE and always
>> use VERSION from code. VERSION shall keep general release information.
>> I would like to move the changeable elements into EXTRAVERSION. This
>> field will respect following conditions:
>> -	user definition first
>>         	(by respecting EXTRAVERSION=xxx during compilation)
>> -	if not defined by user, result of # git describe HEAD
>> -	else empty.
>>
>> Example output:
>> mdadm - version - extraversion (example: mdadm - v4.2-rc2 - extraversion).
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
I suggest providing a new flag with old, deprecated version, for any of 
uses where it couldn't be changed. I can add a description which clarify 
the change and describe flag, for anybody who will meet errors with 
scripts after this change.

Regards,
Kinga Tanska
