Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 443CCC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 14:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbhLIOlU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 09:41:20 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49284 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238742AbhLIOlU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 09:41:20 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 14DE0210FF;
        Thu,  9 Dec 2021 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639060666; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWka3XTj1LwckQjeOolzh1Pv0bNzUGNFD9tVrXt1Vug=;
        b=px4c3NyEgs2YJ4iLTKensqTYbEtbbPFnkbYGp+JN9ddOlpABh94ngL59TyB7BR0nvZoZuA
        LGGDSVPk3s1hu8zqljVjn1wv0SnUYrAlO8AWJI1Bt9cOHyYDvIRIkTLEWHfmkAHsVEXU02
        OvfL6b2H+QlEyaKoVxCYpFHp9cvmsaQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639060666;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWka3XTj1LwckQjeOolzh1Pv0bNzUGNFD9tVrXt1Vug=;
        b=jyDIAVeNR7c8pEc+w4dcghfswd0e/+NyIGQFz7T8JG6bSjc4DhSdjiyg0Fq9KG7+pqT9QJ
        VRNGK66TbNXJ28Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F412813B2D;
        Thu,  9 Dec 2021 14:37:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OgIiKbcUsmHPKgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 09 Dec 2021 14:37:43 +0000
Message-ID: <15659a2b-9050-e9c2-9aba-c50ab7370ff3@suse.de>
Date:   Thu, 9 Dec 2021 22:37:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v3] Monitor: print message before quit for no array to
 monitor
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     George Gkioulis <ggkioulis@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <20210902073220.19177-1-colyli@suse.de>
 <c9e5b8af-1a1d-82c0-1ca0-af4bd1182d75@suse.de>
 <46d238f5-0757-b876-4a41-6f89605b7d8a@trained-monkey.org>
 <0cb02d8d-e74a-19e7-09df-09553397f4d5@suse.de>
 <f8f7703e-be1e-29dd-e51f-73702f867d7f@trained-monkey.org>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <f8f7703e-be1e-29dd-e51f-73702f867d7f@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/9/21 10:31 PM, Jes Sorensen wrote:
> On 12/8/21 8:18 PM, Coly Li wrote:
>> On 12/8/21 10:45 PM, Jes Sorensen wrote:
>>
>> Hi Jes,
>>
>>> Hi Coly,
>>>
>>> Didn't see this one as it was only copied to my work email. Sorry.
>> It should be my fault, I didn't notice that jes@trained-monkey.org was
>> the proper email address :-)
>>
>>> Applied!
>>>
>> Thanks. I will post patches to the trained-monkey.org address in future.
> Great, thanks!
>
> Anything else we want for 4.2?

No more from my side. Thanks.

Coly Li
