Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D8FC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 15:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A8ED60ED5
	for <linux-raid@archiver.kernel.org>; Mon, 18 Oct 2021 15:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhJRPb1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Oct 2021 11:31:27 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:10455 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229696AbhJRPbZ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 18 Oct 2021 11:31:25 -0400
Received: from host86-155-223-151.range86-155.btcentralplus.com ([86.155.223.151] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mcUZc-0001P4-BP; Mon, 18 Oct 2021 16:29:13 +0100
Subject: Re: RAID5 - can't assemble array of 5
To:     Romulo Albuquerque <romulo.albuquerque@gmail.com>,
        linux-raid@vger.kernel.org
References: <CACKE2TBmcQ12tyujnWzPUGCM6fYjzcUhFgmZQCT2usBAHb6MmQ@mail.gmail.com>
 <4f36271f-7355-9aea-6634-51c8d62d05a4@turmel.org>
From:   Wol <antlists@youngman.org.uk>
Message-ID: <0e312bfb-1c2c-4a95-9641-372fb39a1fd8@youngman.org.uk>
Date:   Mon, 18 Oct 2021 16:29:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <4f36271f-7355-9aea-6634-51c8d62d05a4@turmel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 17/10/2021 14:21, Phil Turmel wrote:
> Finally, investigate why /dev/sda dropped out in July, and why you 
> didn't get an email from mdmon.  (Timeout mismatch for the former, 
> perhaps, and incomplete configuration for the latter, likely.)

Are you running a gui environment? Can you run xosview?

It has options to configure it to display raid status (this wasn't 
working quite right when I reported it ages ago, hopefully it's fixed).

But try and get something like that, that just sits there in the 
background on your desktop, showing machine state. Then if anything goes 
wrong, hopefully your desktop will just "feel wrong" and you'll notice.

Cheers,
Wol
