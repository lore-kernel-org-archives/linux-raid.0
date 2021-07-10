Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C0CC07E95
	for <linux-raid@archiver.kernel.org>; Sat, 10 Jul 2021 18:43:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E881861249
	for <linux-raid@archiver.kernel.org>; Sat, 10 Jul 2021 18:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhGJSqH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Jul 2021 14:46:07 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:55333 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhGJSqF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 10 Jul 2021 14:46:05 -0400
Received: from host86-159-54-55.range86-159.btcentralplus.com ([86.159.54.55] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1m2Hwc-000392-51; Sat, 10 Jul 2021 19:43:18 +0100
Subject: Re: What about the kernel patch "failfast" and SCTERC/kernel-driver
 timeouts
To:     BW <m40636067@gmail.com>, linux-raid@vger.kernel.org
References: <CADcL3SDHb-0U2cjoNOMXbFmbiwpVfytzczyg9VkaK=vWyKiFtA@mail.gmail.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <46aa1b53-596f-a647-64ef-10e2fdb614e8@youngman.org.uk>
Date:   Sat, 10 Jul 2021 19:43:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CADcL3SDHb-0U2cjoNOMXbFmbiwpVfytzczyg9VkaK=vWyKiFtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/07/2021 13:15, BW wrote:
> I don't know if the "failfast" patch was ever pushed into the kernel
> back in 2017, but if it was, does it change anything in regards to the
> SCTERC/Kernel-driver. timeout issue(s)?
> 
> Link to a thread about the patch: https://lkml.org/lkml/2016/11/18/1
> 
> And what is the reason why mdadm just doesn't mark a drive fail if no
> response has been received from a array-member-device within e.g. 29
> seconds (just less than kernel-driver default timeout of 30 sec) e.g.
> because of write/read issue. Then all those SCTERC/kernel-driver
> timeout-issues would be solved, right?
> 
https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

I suggest you read up on what the timeout mismatch problem really is.

And why doesn't mdadm just mark a device as failed? - the problem is it 
does EXACTLY THAT! And it is doing that that will destroy your parity 
raid if you are unlucky.

The whole point of the mismatch problem is that the kernel timeout MUST 
be GREATER than the drive timeout. Modern desktop drives do NOT have a 
configurable timeout which, with modern shingled drives, can be measured 
in TENS of MINUTES.

Cheers,
Wol
