Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1E9C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 12 Mar 2022 06:54:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiCLGzY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Mar 2022 01:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbiCLGzY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Mar 2022 01:55:24 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4484912E777;
        Fri, 11 Mar 2022 22:54:16 -0800 (PST)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nSvdm-0004XO-Q0; Sat, 12 Mar 2022 07:54:14 +0100
Message-ID: <63d8d26c-b4dd-ff1d-1727-8848d1b71ca6@leemhuis.info>
Date:   Sat, 12 Mar 2022 07:54:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCHSET 0/2] Fix raid rebuild performance regression
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        llowrey@nuclearwinter.com, i400sjon@gmail.com,
        rogerheflin@gmail.com
References: <20220311173041.165948-1-axboe@kernel.dk>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <20220311173041.165948-1-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1647068057;fe5d15ef;
X-HE-SMSGID: 1nSvdm-0004XO-Q0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 11.03.22 18:30, Jens Axboe wrote:
>
> This should fix the reported RAID rebuild regression, while also
> providing better performance for other workloads particularly on
> rotating storage.

Nitpicking: From the list of CCed people it seems these patches are
fixing this regression:

https://lore.kernel.org/linux-raid/0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com/

Then the patch descriptions for the two commits should include a link
tag to the report, as per using lore.kernel.org/r/, as explained in
'Documentation/process/submitting-patches.rst' and
'Documentation/process/5.Posting.rst'. And the original reporters likely
should be honored with a "Reported-by", too. The former would my
regression tracking life a lot easier, as regzbot relies on those links
that are useful for other purposes, too (as explained in the docs).

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I'm getting a lot of
reports on my table. I can only look briefly into most of them and lack
knowledge about most of the areas they concern. I thus unfortunately
will sometimes get things wrong or miss something important. I hope
that's not the case here; if you think it is, don't hesitate to tell me
in a public reply, it's in everyone's interest to set the public record
straight.

#regzbot ^backmonitor:
https://lore.kernel.org/linux-raid/0eb91a43-a153-6e29-14b6-65f97b9f3d99@nuclearwinter.com/
