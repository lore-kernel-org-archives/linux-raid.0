Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE94C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 30 May 2022 16:01:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240574AbiE3QBK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 May 2022 12:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243183AbiE3QAo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 May 2022 12:00:44 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3789B4EDD8;
        Mon, 30 May 2022 08:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=WyabVAhDYiZqjSLa5iju0Bgbs3O1v4mXmm6tJlHV12k=; b=JSmX09cFPFxA27bTAP0p93a5XR
        74XlYlnwPcnsFnhr83bhqymLFY9AmJW69rfr6PiYF+iBN1xU3LHacKJPhgEWZEZw3uQZQhOMCqX3C
        9Up1ynMSnkL5dXkaGj2AtN24Wwet9BHY26OKlwlpgr6E/ZfuTBzvCEeSTZ26pSY8amVRxEAytZihy
        pEEnoFP6kxfBPnsdtQ54wfgsRnU+G6nv4+Os8SyEcB1uGmxJVyn9JTL1S6VrauaJjQtmvUTqd4p5h
        NX0+GBnRHZd9CZwLBN4VvIxi/D6ViyN+w+jv5Ika3/ZRu4MiJInRTq2q/85F0r/Go17sFgbbqJHoJ
        BWYzJOOA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nvhlP-00Bk5v-OU; Mon, 30 May 2022 09:57:04 -0600
Message-ID: <7d6e6699-348a-af5a-0ab4-a7c4bd917ed1@deltatee.com>
Date:   Mon, 30 May 2022 09:57:02 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220526163604.32736-1-logang@deltatee.com>
 <20220526163604.32736-14-logang@deltatee.com>
 <YpRdrytEQkw/0vMH@infradead.org>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <YpRdrytEQkw/0vMH@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@infradead.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v2 13/17] md/raid5-cache: Add RCU protection to conf->log
 accesses
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-05-30 00:01, Christoph Hellwig wrote:
> On Thu, May 26, 2022 at 10:36:00AM -0600, Logan Gunthorpe wrote:
>> The mdadm test 21raid5cache randomly fails with NULL pointer accesses
>> of conf->log when run repeatedly. conf->log was sort of protected with
>> RCU, but most dereferences were not done with the correct functions.
>>
>> Add rcu_read_locks(), rcu_dereference_protected() and rcu_access_pointers()
>> calls to the appropriate places and mark the pointer with __rcu.
> 
> Looking at the code a bit more, is this really enough?  Calls to
> r5c_is_writeback / r5c_confi_is_writeback are sprinkled all over the
> code, and my gut feeling is the value is not expected to change over
> way longer critical sections than this.  So maybe the answer here is to
> fix up the release to be properly locked as it only affects the non-I/O
> slow path anyway.

Yeah, I think your gut feeling is correct. It looks like all the
is_writeback calls are in the IO path as well. I'll review this again
and see if we can just replace the RCU stuff and the paths that were
hitting NULL pointer deference with the taking of a lock.

Logan
