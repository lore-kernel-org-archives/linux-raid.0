Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A17DC4167B
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 18:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F11FA22EBF
	for <linux-raid@archiver.kernel.org>; Sat,  5 Dec 2020 18:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbgLESTT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Dec 2020 13:19:19 -0500
Received: from mout.perfora.net ([74.208.4.197]:51033 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgLERic (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 5 Dec 2020 12:38:32 -0500
Received: from [192.168.1.18] ([72.94.51.172]) by mrelay.perfora.net
 (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id 1MYMv8-1kgeuw1fO6-00VRKb
 for <linux-raid@vger.kernel.org>; Sat, 05 Dec 2020 17:56:08 +0100
Subject: Re: Disk identifiers
To:     list Linux RAID <linux-raid@vger.kernel.org>
References: <5B155FE8-2761-47FF-BDBA-F5AE3A9BC396@meddatainc.com>
 <24523.11681.86857.449384@cyme.ty.sabi.co.uk>
From:   H <agents@meddatainc.com>
Message-ID: <3302e569-5ac4-1738-1d9f-9f1db66bfcee@meddatainc.com>
Date:   Sat, 5 Dec 2020 11:56:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <24523.11681.86857.449384@cyme.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:LDOuCxuYgFypsDtgpKcNj2sjGHnVXSrUdckU1+HiKy8WTdcc2FD
 4nydG+Wrxl4wuqLbKVO+klLrHqxB+bBo3z2+rEcgXIZyt4YP7qspTnjvQFbKHDKZIKU9L7x
 mYAgDciRTpQPXiqHM5juvDNFp7ONdWpQG0DwJFdkkbW9AVjBWhEpvOlUi87fSkFCC9PHMuo
 K9fHTPeK0s4Nhwk1O/piQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:0JR34RZRTdc=:DNKjJ9zqmnAInhrVt4ECDp
 QMWwotDxF79A9wbFxMbqBG/9awhmp9t3A8qMqXiZv03mkO6ERclhSt0JqwOHuIqkjWEDgAZUc
 yPYvCW1/VV54UjnIftRCflbwJfSmWWkFsvCvgYBG9AoOkk845D8uiv0AJ1JC4ozLnaLU/V4Ef
 1DwaRp9DRSDMFEh4GTtSVrOEcHvfxcmAHvAV+6xenKXiStLHQG69BBvQe9U/qmZ4fJNlElG7Q
 qiIxNPTz6EUWEiQIB//VuUHCg7U/LkQOJ8XHW4nCztXfo4MYWsulOpJD0mn0etLMplpQI/FAP
 mJQNuf72YaaLGfSYeHBrhh6ElqLAt2sXU7siSDW8/0kRMYrnL8UyBpzxtE64ZiQwDa5GYKHaP
 Z0mTa0y90ZOg0AiBnYjwFpgNS8qM6XQzb56MtjSaYew5A4Ro6nGj1DkP8cZi5YAPK2TfsH1M+
 nj1EHqgCvw==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/05/2020 01:50 AM, Peter Grandi wrote:
>> Are disk identifiers important in Linux (CentOS)? [...]  Last,
>> googling suggests there is confusion between disk identifiers
>> and partition UUIDs. I am specifically asking about the
>> former.
> That "disk identifiers" is not specific. Which one do you mean
> among disk serial numbers, disk WWNs, disk label identifiers?
> Also apart from partition identifiers there are also partition
> lavbels, MD set identifiers, MD member identifiers, and filetree
> labels and identifiers.  Not all of these are present in every
> case.
>
> It may be interesting to have a look at the contents of the
> '/dev/disk/by-*/' directories.
>
> As to the importance of any of these it depends on which
> specific configuration goals you have. Each of them has some
> advantages and disadvantages.

I was referring to what fdisk -l calls "disk identifier". Interestingly enough I found neither the all-zeroes or the third disk with a UUID disk identifier in any of the /dev/disk/by-* subdirectories.

Could it be used somewhere else?

