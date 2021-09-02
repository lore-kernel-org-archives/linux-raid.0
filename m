Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B164C432BE
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 07:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F2EE61053
	for <linux-raid@archiver.kernel.org>; Thu,  2 Sep 2021 07:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242405AbhIBH1L (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Sep 2021 03:27:11 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52408 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbhIBH1L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Sep 2021 03:27:11 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3C29620315;
        Thu,  2 Sep 2021 07:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630567572; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UQrgU+bwwF/qBZjIGYYuXihppr5Ihc1ITu2ITDpQr7k=;
        b=Tt+iHw/UbvmHXWRp5MiNFRlM9gUrpYx4LRSVgjj4zjf/yQ2/fFEsYGNM3k42gXaFPd2fGt
        iX0M+F5KR5tv38BlTIp9vH8lQFqGFpiP48/YFwAP0HnUfgZL/RQFjKPRPVvsorgyuKBtW6
        alFouyVaX23XHw8T5tXuAtAy2jB4xqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630567572;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UQrgU+bwwF/qBZjIGYYuXihppr5Ihc1ITu2ITDpQr7k=;
        b=aF558eMLKd+SgSNVR2NpHwo56RJ58wsO1OXtSE+iWL/7aG8Qi7fIjzy72j/ZbLws4Yr6Wu
        2PQiJvUQHCstJvDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3768013B70;
        Thu,  2 Sep 2021 07:26:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EcdFAJN8MGHEMwAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 02 Sep 2021 07:26:10 +0000
Subject: Re: [PATCH v2] Monitor: print message before quit for no array to
 monitor
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     George Gkioulis <ggkioulis@suse.com>,
        Jes Sorensen <jsorensen@fb.com>, linux-raid@vger.kernel.org
References: <20210902023644.509-1-colyli@suse.de>
 <59b40b04-399a-a0cd-f8be-ebdebe9a458c@linux.intel.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <478fe598-5529-50ca-aefc-27ad0a4f1ef8@suse.de>
Date:   Thu, 2 Sep 2021 15:26:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <59b40b04-399a-a0cd-f8be-ebdebe9a458c@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/2/21 3:08 PM, Tkaczyk, Mariusz wrote:
> Hi Coly,
> On 02.09.2021 04:36, Coly Li wrote:
>> @@ -258,6 +258,7 @@ int Monitor(struct mddev_dev *devlist,
>>               if (oneshot)
>>                   break;
>>               else if (!anyredundant) {
>> +                pr_err("Stop for no array to monitor\n");
>>                   break;
>
> IMO the message is not precise enough. See that if there is only raid0
> then it also stops. Something like:
> "No array with redundancy detected, stopping" is more detailed.

Copied. I will post v3 patch with your suggestion.

Thanks.

Coly Li
