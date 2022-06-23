Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C98CAC433EF
	for <linux-raid@archiver.kernel.org>; Thu, 23 Jun 2022 22:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiFWW2M (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Jun 2022 18:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiFWW2K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Jun 2022 18:28:10 -0400
X-Greylist: delayed 12813 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 15:28:02 PDT
Received: from mallaury.nerim.net (smtp-104-thursday.noc.nerim.net [178.132.17.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4BBF9DFCE
        for <linux-raid@vger.kernel.org>; Thu, 23 Jun 2022 15:28:01 -0700 (PDT)
Received: from [192.168.0.250] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id 179E0DB17C;
        Fri, 24 Jun 2022 00:27:51 +0200 (CEST)
Message-ID: <1de4bf1f-242b-7d02-23dc-a6d05893db81@plouf.fr.eu.org>
Date:   Fri, 24 Jun 2022 00:27:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: a new install - - - putting the system on raid
Content-Language: en-US
To:     Wols Lists <antlists@youngman.org.uk>,
        o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf59G6UjOe-80oqgwPmMY14t0_E=D20cbUwDwtOT8=AFcLQ@mail.gmail.com>
 <81c50899-7edb-e629-3bbc-16cfa8f17e34@youngman.org.uk>
 <b777865e-b265-1e83-dae0-f89654e86332@plouf.fr.eu.org>
 <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <5cbd9dd1-73fc-ce11-4a9d-8752f7bea979@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



Le 23/06/2022 à 23:39, Wols Lists a écrit :
> On 23/06/2022 19:54, Pascal Hambourg wrote:
>>> If you set the fstab priorities to the same value, you get a striped 
>>> raid-0 for free.
>>
>> Without any redundancy. What is the point of setting up RAID1 for all 
>> the rest and see your system crash pitifully when a drive fails 
>> because half of the swap suddenly becomes unreachable ?
> 
> Why would it crash?

Do you really believe a program can lose some of its data and still 
behave as if nothing happened ? If that were true, then why not just 
discard data instead of swap them out when memory is short ?

> Firstly, the system shouldn't be swapping. MOST 
> systems, under MOST workloads, don't need swap.

Conversely, some systems, under some workloads, do need swap. And when 
they do, swap needs to be as reliable as any other storage space.

> And secondly, the *system* should not be using swap. User space, yes. So 
> a bunch of running stuff might crash. But the system should stay up.

Firstly, the *system* is not only the kernel. Many user space processes 
are part of the *system*. Secondly, you were the one who wrote:

"/tmp - is usually tmpfs nowadays, if you need disk backing, just make 
sure you've got a big-enough swap (tmpfs defaults to half ram, make it 
bigger and let it swap)."

> Raid is meant to protect your data. The benefit for raiding your swap is 
> much less, and *should* be negligible.

No, this is what backup is meant to. RAID does not protect your data 
against accidental or malicious deletion or corruption. RAID is meant to 
provide availabity. The benefit of having everything including swap on 
RAID is that the system as a whole will continue to operate normally 
when a drive fails.
