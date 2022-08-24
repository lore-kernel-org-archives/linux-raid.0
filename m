Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96952C00140
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 16:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239525AbiHXQeE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 12:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239550AbiHXQeA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 12:34:00 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FEC923FA
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 09:33:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661358810; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=OusjIxywDqBxBej6ZBI51TY6qkzJkEy0qCXpBM1HJa3517pqhfmYh6sozT+jr74zArrWFMQ/tJQZ0GuLBYff+X8S809xG8JI45yR9PMZsT3tI0PSRzuxRT30nxbe7GzSOvYiIcXq4AITNbV5hycztkB2Nt4ESqiFgbqn/lwYj2w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661358810; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=pzebTsAfCYa40zVH6Wp3jTLaUUtVs1Qc9UTTlLfBlio=; 
        b=SKgTWSHMSQWejdIauMJ7ydcJ01FnsbMRmJyO9/zVjVkbr1y3nJVJmeTHeHAcfWLGUkGohv7a8rGthAOu6L5TRDgDfyhualHzle/2VvZ2yMLkH2Su9XM8u1bO7hyD11ImtEq25Pc0xF4NqV0MD6z0XN8nQTQl2SKr0SGmS/+L6eo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1661358806815958.7344190044031; Wed, 24 Aug 2022 18:33:26 +0200 (CEST)
Date:   Wed, 24 Aug 2022 12:33:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
 <9b885a13-21cf-3c9a-f320-c047301294de@trained-monkey.org>
 <2622AABD-75DC-41D4-9F1E-E958463E9FD0@suse.de>
 <42df7fa8-1a9a-afdc-5298-1850f5bce879@trained-monkey.org>
 <193A9B1E-ACB9-40C1-A6B0-BE0FC5C29753@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <f732cc9e-65d5-2b8a-cd66-20f99bc2d625@trained-monkey.org>
In-Reply-To: <193A9B1E-ACB9-40C1-A6B0-BE0FC5C29753@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/24/22 12:09, Coly Li wrote:
> 
> 
>> 2022年8月24日 23:56，Jes Sorensen <jes@trained-monkey.org> 写道：
>>> Hi Jes,
>>>
>>> Please check the version I post to you in series “mdadm-CI for-jes/20220728: patches for merge” (Message-Id: <20220728122101.28744-1-colyli@suse.de>), the patch in this series is rebased and confirmed with Mateusz, it could be applied to upstream mdadm.
> 
>> I applied this one, but none of the versions applied cleanly. I had to
>> play formail games to pull it out of your stack, as I am not going to
>> apply a set of 23 commits in one batch without going through them.
> 
> These days I was in partner’s office and planed to repost the rebased version soon. If you don’t do the rebase yet, please wait for me to post a v4 version on behavior of Mateusz tomorrow.

No worries, I already pulled some of it in, but you can check my repo
and see whats there.

>> It's really awesome to have your help reviewing patches, much
>> appreciated, but I would prefer to keep them in the original batches so
>> I can pull them from patchwork, rather than trying to deal with the
>> giant stack.
> 
> How about we improve the process like this,
> 1) I will continue to review and response the patches from the original emails, so patch work may track them as they were.
> 2) For all the reviewed patches are not handled by your after a period, let’s set it as 2 weeks for now, I will post a email with all the patches with their message-IDs to you as a remind.

This sounds good to me! I think it's also fine to have a branch with
everything applied for testing, it's just less easy for me to pull from.

Thanks,
Jes

