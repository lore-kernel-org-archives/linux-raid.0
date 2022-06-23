Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D852C43334
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 21:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiFWVjY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 17:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiFWVjX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 17:39:23 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184F853A67
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 14:39:20 -0700 (PDT)
Received: from host86-158-155-35.range86-158.btcentralplus.com ([86.158.155.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o4UXm-0006PK-BJ;
        Thu, 23 Jun 2022 22:39:18 +0100
Message-ID: <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
Date:   Thu, 23 Jun 2022 22:39:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: a new install - - - putting the system on raid
Content-Language: en-GB
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 23/06/2022 19:54, Pascal Hambourg wrote:
>> If you set the fstab priorities to the same value, you get a striped 
>> raid-0 for free.
> 
> Without any redundancy. What is the point of setting up RAID1 for all 
> the rest and see your system crash pitifully when a drive fails because 
> half of the swap suddenly becomes unreachable ?

Why would it crash? Firstly, the system shouldn't be swapping. MOST 
systems, under MOST workloads, don't need swap.

And secondly, the *system* should not be using swap. User space, yes. So 
a bunch of running stuff might crash. But the system should stay up.

Raid is meant to protect your data. The benefit for raiding your swap is 
much less, and *should* be negligible.

Cheers,
Wol
