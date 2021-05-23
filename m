Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB210C47080
	for <linux-raid@archiver.kernel.org>; Sun, 23 May 2021 16:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAC3F61166
	for <linux-raid@archiver.kernel.org>; Sun, 23 May 2021 16:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhEWQUr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 23 May 2021 12:20:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:39702 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231818AbhEWQUr (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 23 May 2021 12:20:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621786759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6GvmKnl6c+HUBr9f6RwC3ENu3vpt2erfbeupmo1Z84=;
        b=yyPFVjIkzfcTSoZrJscEsHIItA0oLtphlEhmOjbXYR+37Pgb+fWRUcIdGc+VTxPsDL9mh7
        ZRk7fD4V6Z77ZccRQ2CzLT6Ii4dX1jbT0SDTo+DuVOBic62fKZd2NPjnR5LqejnZvvPMoK
        rvCakT+BPwP2L4LHhIzK7atXoWlJrg8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621786759;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s6GvmKnl6c+HUBr9f6RwC3ENu3vpt2erfbeupmo1Z84=;
        b=5DFIBBRSSmf1pk5mfb5aQjrw3PQ/r9vzq6fiwUutelRcwfOpSXxg5BnR0IftxLLoPfIYvw
        9tQs6AdZ5Cy2FzCQ==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 452DFAB5F;
        Sun, 23 May 2021 16:19:19 +0000 (UTC)
Subject: Re: [PATCH 12/26] bcache: convert to blk_alloc_disk/blk_cleanup_disk
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org
References: <20210521055116.1053587-1-hch@lst.de>
 <20210521055116.1053587-13-hch@lst.de>
 <d4f1c005-2ce0-51b5-c861-431f0ffb3dcf@suse.de>
 <20210521062301.GA10244@lst.de>
From:   Coly Li <colyli@suse.de>
Message-ID: <1adaadde-642d-c386-2f70-85669c37e67d@suse.de>
Date:   Mon, 24 May 2021 00:19:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210521062301.GA10244@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/21/21 2:23 PM, Christoph Hellwig wrote:
> On Fri, May 21, 2021 at 02:15:32PM +0800, Coly Li wrote:
>> The  above 2 lines are added on purpose to prevent an refcount
>> underflow. It is from commit 86da9f736740 ("bcache: fix refcount
>> underflow in bcache_device_free()").
>>
>> Maybe add a parameter to blk_cleanup_disk() or checking (disk->flags &
>> GENHD_FL_UP) inside blk_cleanup_disk() ?
> 
> Please take a look at patch 4 in the series.
> 

Thanks for the hint. I will reply in your patch.


Coly Li
