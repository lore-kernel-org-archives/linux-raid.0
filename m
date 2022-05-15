Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D865C433F5
	for <linux-raid@archiver.kernel.org>; Sun, 15 May 2022 19:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233813AbiEOT6j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 May 2022 15:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiEOT6j (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 May 2022 15:58:39 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743F1389C
        for <linux-raid@vger.kernel.org>; Sun, 15 May 2022 12:58:37 -0700 (PDT)
Received: from host86-155-180-61.range86-155.btcentralplus.com ([86.155.180.61] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nqJvI-0004G7-AH;
        Sun, 15 May 2022 20:29:00 +0100
Message-ID: <169db918-cdc1-e461-f484-058f41cbab87@youngman.org.uk>
Date:   Sun, 15 May 2022 20:29:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: failed sector detected but disk still active ?
Content-Language: en-GB
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXh7cVHa+G1DaJwWSvgDaCOrYLP_Ppau8q6pk1V4dS3D_Q@mail.gmail.com>
 <Yn6BEym8s0kVLhD0@lazy.lzy>
 <994cb384-3782-dac2-898b-ea02816a904f@youngman.org.uk>
 <056cdd2b-e7c7-d9dc-8e33-cb0727e70d42@plouf.fr.eu.org>
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <056cdd2b-e7c7-d9dc-8e33-cb0727e70d42@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/05/2022 19:39, Pascal Hambourg wrote:
> Le 14/05/2022 à 15:46, Wols Lists a écrit :
>>
>> Or the rewrite fails, raid assumes the drive is faulty and kicks it 
>> out. That's why you should never use desktop drives unless you know 
>> EXACTLY what you are doing!
> 
> What's wrong with desktop drives ?

Once things start going wrong, they go pear-shaped very fast.

https://raid.wiki.kernel.org/index.php/Timeout_Mismatch

tl;dr

Raid/Enterprise drives have something called SCT/ERC. If there's a 
problem, the drive will abort the read/write, and return an error.

Consumer drives don't have this. If there's a problem, they can 
typically take two minutes to respond. No matter whether the problem is 
transient or real, that's a real bummer for whatever wants the data. The 
kernel typically gives up waiting after 30secs, tries to talk to the 
drive again, and on getting no response whatsoever assumes the disk has 
failed. As far as raid is concerned, a faulty, non-responsive disk is 
BAD NEWS.

It gets worse. SMR drives can - in the NORMAL course of events, take 
about ten minutes to respond!

So basically, Enterprise drives typically take about 7 seconds to sort 
out a problem. Consumer drives - the old CMR type - typically take about 
2 minutes. New SMR drives can take 10s of minutes. And transient 
problems aren't that uncommon. Worse, once things start going wrong, it 
can explode very fast.

Cheers,
Wol
