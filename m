Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DEFEC4320A
	for <linux-raid@archiver.kernel.org>; Sat, 24 Jul 2021 21:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68ECF60E90
	for <linux-raid@archiver.kernel.org>; Sat, 24 Jul 2021 21:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhGXVFK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 24 Jul 2021 17:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhGXVFJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 24 Jul 2021 17:05:09 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAF4C061575
        for <linux-raid@vger.kernel.org>; Sat, 24 Jul 2021 14:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9ppnMESMtDGtsOtVojpDQKKVPc/hIRSzhRJDkkta514=; b=cTuv4aQCyRlFY8Xa6MqI1sqEaV
        n6KpKDBnuCXPZimyIVdGJnOLs3o0E0kj8FLjbSjR2gnjDUwsFByY2FLUNb+NWXdkf2eshYhKUr9UG
        7hKdu0+PYSjRw/uFbNsMWCS9PqnyLTyerBr6GMlBux9fftkpCIhPyhto4GEXUPXvsyFQarxrn+DSz
        179CKcosWs3koQKdJrSy/vl7RnY2XYsbxVw1xIL7j38TwHBzH8YAJvbL4F7loIuXkEhDbFUcDAo7u
        dhOkvfd9AXl+SAPYbERBUDV27x1cn0EiUsUhFAUWub5pJsbaG5jegF0zQmDiv9L73cGajV4C8XRu3
        tarEefRQ==;
Received: from c-98-192-104-236.hsd1.ga.comcast.net ([98.192.104.236] helo=[192.168.19.160])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1m7PSj-0001I7-W8; Sat, 24 Jul 2021 21:45:38 +0000
Subject: Re: SSD based sw RAID: is ERC/TLER really important?
To:     Peter Grandi <pg@list.for.sabi.co.UK>,
        list Linux RAID <linux-raid@vger.kernel.org>
References: <2232919.g0K5C1TF2C@chirone>
 <24828.30134.873619.942883@cyme.ty.sabi.co.uk>
From:   Phil Turmel <philip@turmel.org>
Message-ID: <e4ecfd01-cffc-f154-5f7c-5ca08a12fd33@turmel.org>
Date:   Sat, 24 Jul 2021 17:45:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <24828.30134.873619.942883@cyme.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/24/21 4:19 PM, Peter Grandi wrote:

>> the recovery time in case of media errors could exceed kernel 
>> timeouts and possibly kick off the entire drive from the RAID set
>> and, in turn, lead to a fault of a RAID5 system upon a subsequent
>> error in a second drive.
> 
> My understanding seems different:

You understanding is incorrect.

> * The purpose of having a short device error retry period is the 
> opposite, it is to fail a drive as fast as possible, in workloads
> where latency matters ( or there is also the risk of bus/link resets
> hitting multiple drives). In those cases error retry periods of 1-2
> seconds (at most) are common, rather than the mid-way "7 seconds"
> from copy-and-paste from web pages..

Yes, the short ERC setting helps latency, but the primary purpose is to
be shorter than the kernel timeout.

> * The purpose of having a long device error retry is to instead to
> minimize the chances of declaring a drive failed, hoping that many
> retries succeed. (but note the difference between reads and writes).

Read errors do *not* kick drives out.  It takes several read errors in a
short time to fail a drive out of an array.

A drive not responding before the kernel timeout *will* get it kicked, 
though.  Because the kernel giving up propagates to the raid as a
read error (while the drive is off in la-la land) which then causes
the raid to *reconstruct* the missing sector and *write* it.  Along
with passing the reconstructed data up the chain.

That write will fail because the drive is still in la-la land.  Any
write failure *does* kick the drive out.

> * It is possible to set the kernel timeouts higher than device retry
> periods, if one does not care about latency, to minimize the chances
> of declaring a drive failed (not the difference between Linux command
> timeouts and retry timeouts, the latter can also be long).
> 
>> But in the case of SSD drives (where, possibly, the error recovery
>> activities performed by the drive firmware are very fast) [...]
> 
> I guess that depends on the firmware: On one hand MLC cells can 
> become quite unreliable, especially at higher temperatures, requiring
> many retries and lots of ECC, on the other on "write" allocating a
> new erase-block is easy, as unlike for most HDDs with a FTL, SDD
> sector logical and physical sector locations are independent.
> Unfortunately most flash SSD drive makers don't supply technical
> information on details like error recovery strategies.
> 

I don't have data on SSD behavior without ERC.  If their retry cycle is 
exhausted within the kernel default 30 seconds, the timeout mismatch 
issue will *not* apply.

Phil
