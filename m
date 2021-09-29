Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8E6C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 29 Sep 2021 08:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA69B613D0
	for <linux-raid@archiver.kernel.org>; Wed, 29 Sep 2021 08:07:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244564AbhI2IJP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Sep 2021 04:09:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:7261 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244540AbhI2IJM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 29 Sep 2021 04:09:12 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10121"; a="212141363"
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="212141363"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 01:07:32 -0700
X-IronPort-AV: E=Sophos;i="5.85,331,1624345200"; 
   d="scan'208";a="554535631"
Received: from mkusiak-mobl.ger.corp.intel.com (HELO [10.213.24.195]) ([10.213.24.195])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 01:07:30 -0700
Message-ID: <a5db5b41-82bd-af57-6360-8434df02ba9b@linux.intel.com>
Date:   Wed, 29 Sep 2021 10:07:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: Mdadm opinion request
Content-Language: pl
To:     Jes Sorensen <jes@trained-monkey.org>, colyli@suse.de,
        linux-raid@vger.kernel.org
References: <d70f2c8f-eafd-f3c6-39d0-e52a94507cdf@linux.intel.com>
 <c487ed96-b7da-0fea-5020-1cbf7207a8b7@trained-monkey.org>
From:   "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
In-Reply-To: <c487ed96-b7da-0fea-5020-1cbf7207a8b7@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Added linux-raid to recipients, as it should be in original message,
sorry for inconvenience.

On 28/09/2021 23:08, Jes Sorensen wrote:
> On 9/28/21 5:28 AM, Kusiak, Mateusz wrote:
>> Hello all,
>> We've discovered an issue with mdadm monitor not checking if sendmail is
>> installed on the system. Software displays error:
>>      "/usr/sbin/sendmail: No such file or directory"
>> and continues to work.
>>
>> We have two ways to use mdmonitor:
>> - system wide mode (--scan option); this require --mail or --syslog,
>> notifications are mandatory.
>> - container/array tracking mode; notifications are optional.
>>
>> Providing wrong email does not stop mdmonitor, neither removing postfix.
>> There is a way to avoid mails in each mode, so why not make it
>> configurable globally? Any thoughts?
>>
>> Mateusz Kusiak
>>
> 
> Seems reasonable to me to make it configurable rather than implicit
> enforce it in one mode and not the other.
> 
> Jes
> 
