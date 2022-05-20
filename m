Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C10C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 20 May 2022 21:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353605AbiETVPD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 May 2022 17:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348920AbiETVPC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 May 2022 17:15:02 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1DCF7490
        for <linux-raid@vger.kernel.org>; Fri, 20 May 2022 14:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=QqG/OqkYNNRsJRAx1l0i/LlzM8Rjhi1q7uDktVRgu48=; b=lGsnVRHMt5g4ETola0bQhAL8P4
        a6rEAYnwElgwBTOrRjofpHIMgLVjwnkr/lJJ8uxqB7Z6dOYqwGMHh3htcjirOKnNB1HGfVEYdfd8R
        pZSmrsHUxXs5BcpvSKzIbAkg2hTjCDzDD8RhKu1cHXJ6a0cn/qAvbOzcO0I7AE8KRVrzl+7MKZwZo
        FL+y8lZX2tG9NUHbCx0W25+y88Mkj4ha+ql0YfVWQ63WOFKwTGyj+j0yFppKWt9ntQ3W3Ap7nwGMW
        JUBpubSACMlPlIq/lNJengn8IcnsqDv5RrCBubWDwowhqJ8VkAsvhwjiNW8m6hzGsvW0V2HirfOjf
        qmKGkNcQ==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ns9xa-003HiX-Jf; Fri, 20 May 2022 15:14:59 -0600
Message-ID: <978a66e2-c2c2-1365-a620-f43bb38fff26@deltatee.com>
Date:   Fri, 20 May 2022 15:14:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-CA
To:     Himanshu Madhani <himanshu.madhani@oracle.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <20220510170920.18730-1-himanshu.madhani@oracle.com>
 <2a6073e9-12ea-f468-6bfd-92609ce824df@deltatee.com>
 <F15DE600-6805-494D-99AC-497CA14127D6@oracle.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <F15DE600-6805-494D-99AC-497CA14127D6@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: himanshu.madhani@oracle.com, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v3 0/7] Resurrect mdadm test cases
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org




On 2022-05-20 15:12, Himanshu Madhani wrote:
> Hi Logan, 
> 
>> On May 20, 2022, at 11:45 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
>>
>>
>> Hi Himanshu,
>>
>> On 2022-05-10 11:09, himanshu.madhani@oracle.com wrote:
>>> From: Himanshu Madhani <himanshu.madhani@oracle.com>
>>>
>>> Hi, 
>>>
>>> I am picking up patches that were submitted earlier [1] and received
>>> comments which were addressed in [2]. This series is an attempt to
>>> resurrect the review request with combined patchset that resolves error
>>> encountered while running test cases for each of the raid types.
>>>
>>> I've tested this series with latest 5.18.0-rc4+ kernel. 
>>>
>>> [1] https://marc.info/?l=linux-raid&m=162697853622376&w=2
>>>
>>> [2] https://marc.info/?l=linux-raid&m=163907488120973&w=2
>>
>> I have also been working on these tests for the last couple weeks to get
>> them cleaned up and more reliable. I just sent a series fixing a number
>> of the kernel issues that I've found.
> 
> Let me look up the series from you online. I haven’t seen it show up in my inbox yet. 


Ah, sorry, here's a link:

https://lore.kernel.org/all/20220519191311.17119-1-logang@deltatee.com

Logan
