Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F0EC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 21 Mar 2022 14:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349309AbiCUObs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Mar 2022 10:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349446AbiCUOa2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Mar 2022 10:30:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4692052E2B
        for <linux-raid@vger.kernel.org>; Mon, 21 Mar 2022 07:27:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C77321F385;
        Mon, 21 Mar 2022 14:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647872850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twLgeMQDmc1gnCGu+bY5QCrHrG+VtrPDlS1o2U5zY8g=;
        b=LKTnXcfXCR7Y/0yN3hzuWojkaSfiYk3lKCgoNIDMPFfyIIh14sQApkJH2UaQ0GaPbh3B8n
        jiXIBSfSDYg4To2lrrd0J0SggUnEYb0yHke/J2tFicuM8HRz1KF6BOJmtlgEKZp996DABa
        jpt/4x3m5SzboYLMwt4KeioJmNSnlSQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647872850;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=twLgeMQDmc1gnCGu+bY5QCrHrG+VtrPDlS1o2U5zY8g=;
        b=CHMer+8HWFkqgvoOU5XNFlpYuBTrnuL3Xzl/n7OkvMj0Laxb4t/5P/og1UcnEbGTAJv0cz
        tkHkTTw09MFyciAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CEE8213479;
        Mon, 21 Mar 2022 14:27:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id j3hRI1CLOGI2dgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 21 Mar 2022 14:27:28 +0000
Message-ID: <562e0c60-1f73-b56f-17b7-60fbf5a168f2@suse.de>
Date:   Mon, 21 Mar 2022 22:27:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] Assemble: check if device is container before scheduling
 force-clean update
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Kinga Tanska <kinga.tanska@intel.com>, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
References: <20220209090940.11973-1-kinga.tanska@intel.com>
 <da2d2717-c278-62bc-d1e5-e0d371b66f9b@suse.de>
 <20220321145226.00003e01@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220321145226.00003e01@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/21/22 9:52 PM, Mariusz Tkaczyk wrote:
> On Sat, 19 Mar 2022 23:12:36 +0800
> Coly Li <colyli@suse.de> wrote:
>
>> Hi Kinga,
>>
>>
>> I am fine with the above idea, except the extra is_container(). IMHO
>> comparing directly with LEVEL_CONTAINER is fine, adding
>> is_container() doesn't help too much.
>>
>>
> Hi Coly,
>
> It is used in many places and is long. This is the main reason we
> changed that. As you can see, some ifs was simplified and readability
> is improved.
> Generally, if something is repeated two or more times, it should be
> gathered inside function. This simplifies future changes (for example
> if we decide to add other level check here). Also it simplifies code
> analysis (IDE will show us all usages) and it gives basic description.
> In this case it could be redundant but IMO it is a design we should
> follow.
>
> We already proposed similar inline for raid456 in other patch.


Hmm, using is_container() may reduce 5 characters, and there are around 
19 replacement and reduces around 95~100 characters, but introducing 
is_container() increases around 280+ characters. This is why I am not 
able to fully support the is_container() replacement.


Except for the is_container() replacement, I am OK with the problem 
fixed. Could you please divide the original patch into 2 parts, one is 
adding the LEVEL_CONTAINER checking, one is the is_container() 
replacement, then I can be supportive to the fix itself, and conserve my 
opinion to the is_container() replacement.


Thanks.


Coly Li

