Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77EF7ECAAD5
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 08:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiILIGk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 04:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiILIGh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 04:06:37 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C9F2CDC9
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 01:06:35 -0700 (PDT)
Received: from host86-157-192-122.range86-157.btcentralplus.com ([86.157.192.122] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1oXeSf-0009M3-Bs;
        Mon, 12 Sep 2022 09:06:33 +0100
Message-ID: <3e694d50-a636-3fc8-b662-0268f680c738@youngman.org.uk>
Date:   Mon, 12 Sep 2022 09:06:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: 3 way mirror
Content-Language: en-GB
To:     Phil Turmel <philip@turmel.org>,
        Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
 <73143dc1-e259-9dd1-d146-81d6c576b5d4@youngman.org.uk>
 <e12bc8eb-6be0-f5a2-c57e-b0685752ae2b@turmel.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <e12bc8eb-6be0-f5a2-c57e-b0685752ae2b@turmel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/09/2022 01:58, Phil Turmel wrote:
> Hi Wol,
> 
> On 9/11/22 06:08, Wols Lists wrote:
> 
> [trim /]
> 
>> old one is still good I'd go for a 3-disk raid-5 plus spare. That's my 
>> current setup.
> 
> Eww.  Don't do that.  Always convert raid5+spare to raid6.
> 
At the moment the fourth drive is, in my mind, a transient backup. I 
don't want to make it an actual part of the array in case I want to 
remove it.

I'm thinking of getting a second matching drive, but seeing as I've 
bought 16TB of drive space in the recentish past, another 8TB seems 
excessive :-)

Cheers,
Wol
