Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231C2ECAAD2
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 09:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiH1Jyq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Aug 2022 05:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiH1Jyp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Aug 2022 05:54:45 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30D23D5B8
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 02:54:43 -0700 (PDT)
Received: from host86-128-157-135.range86-128.btcentralplus.com ([86.128.157.135] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oSF06-0003vI-3q;
        Sun, 28 Aug 2022 10:54:42 +0100
Message-ID: <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
Date:   Sun, 28 Aug 2022 10:54:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: RAID 6, 6 device array - all devices lost superblock
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
To:     Peter Sanders <plsander@gmail.com>, linux-raid@vger.kernel.org
Cc:     Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
 <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk>
In-Reply-To: <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28/08/2022 10:14, Wols Lists wrote:
>> Currently I have no /dev/md* devices.
>> I have access to the old mdadm.conf file - have tried assembling with
>> it, with the default mdadm.conf, and with no mdadm.conf file in /etc
>> and /etc/mdadm.
> 
> It looks like the drives weren't partitioned :-( I think you're into 
> forensics.

Whoops - my system froze while I was originally writing my reply, and I 
forgot to put this into my rewrite ...

Look up overlays in the wiki. I've never done it myself, but a fair few 
people have said the instructions worked a treat.

You're basically making the drives read-only (all writes get dumped into 
the overlay file), and then re-creating the array over the top, so you 
can test whether you got it right. If you don't, you just ditch the 
overlays and start again, if you did get it right you can recreate the 
array for real.

Cheers,
Wol
