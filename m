Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1CFC4332F
	for <linux-raid@archiver.kernel.org>; Sun, 11 Dec 2022 13:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiLKNz7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Dec 2022 08:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLKNz6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 11 Dec 2022 08:55:58 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9587EBE0F
        for <linux-raid@vger.kernel.org>; Sun, 11 Dec 2022 05:55:56 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1p4Mo6-0006PD-CS;
        Sun, 11 Dec 2022 13:55:55 +0000
Message-ID: <d4e4611f-4764-c66a-0bc9-b8dbcbfae39e@youngman.org.uk>
Date:   Sun, 11 Dec 2022 13:55:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: Is it possible to restart --add?
Content-Language: en-GB
To:     Chris Dunlop <chris@onthe.net.au>, linux-raid@vger.kernel.org
References: <20221210195945.GA34756@onthe.net.au>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <20221210195945.GA34756@onthe.net.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/12/2022 19:59, Chris Dunlop wrote:
> Hi,
> 
> When replacing a failed disk with a new one using --add, is it possible 
> to restart a partially-complete --add, e.g. after a reboot?
> 
> I have a raid-6 with a failed disk, and used --add to add a new disk as 
> a replacement. From /proc/mdstat, "finish" told me it would take around 
> 24 hours to complete the add.
> 
> The machine was rebooted some hours into the add, and on restart the md 
> was missing the new disk (and the failed disk). I tried to --re-add the 
> new disk again, but mdadm told me it's "not possible":
> 
> mdadm: --re-add for /dev/sdh1 to /dev/md0 is not possible
> 
> I ended up --add'ing the disk again, so the 24 hours to complete started 
> again.
> 
> Is this expected, and/or is there a way to restart the --add rather than 
> starting from the beginning again?
> 
Raid is supposed to be robust, so this surprises me. When it rebooted it 
should have known it was part-way through a rebuild. Was it a controlled 
reboot, or a crash and restart?

What I would expect is that the array would be rebuilt including sdh1, 
and the rebuild would just carry on. So I suspect that whatever went 
wrong, it was a bit further back than that - somehow md forgot that sdh1 
was now part of the array.

Weird.

Cheers,
Wol
