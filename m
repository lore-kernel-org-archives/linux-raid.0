Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67DFC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  5 Oct 2021 09:24:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB1906154B
	for <linux-raid@archiver.kernel.org>; Tue,  5 Oct 2021 09:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233174AbhJEJ0R (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Oct 2021 05:26:17 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:34311 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232773AbhJEJ0R (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 5 Oct 2021 05:26:17 -0400
Received: from [192.168.0.2] (ip5f5ae91d.dynamic.kabel-deutschland.de [95.90.233.29])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id AE2A961E64846;
        Tue,  5 Oct 2021 11:24:24 +0200 (CEST)
Subject: Re: [PATCH] mdadm: split off shared library
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Jes Sorensen <jsorensen@fb.com>,
        Jes Sorensen <jes@trained-monkey.org>
References: <7461b27b-2a4b-fbbb-5cfd-8fab416cbc9f@suse.de>
 <fc647fe7-542e-d8d0-920f-33a4edf92962@suse.de>
 <32212d11-204c-eebb-d84a-7e51d61f53b3@linux.intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <d969e684-3991-7b8a-f1c5-93d14ea7015c@molgen.mpg.de>
Date:   Tue, 5 Oct 2021 11:24:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <32212d11-204c-eebb-d84a-7e51d61f53b3@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Coly, dear Mariusz,


Am 01.10.21 um 12:44 schrieb Tkaczyk, Mariusz:
> On 26.08.2021 18:28, Coly Li wrote:

[…]

>> Hi Jes,
>>
>> If you are too busy to take care of mdadm, and you are glad, it is OK 
>> for me to take the mdadm maintenance. I can be long term stable for 
>> the maintenance task.
> 
> Hi Jes,
> We have around 40 to 50 patches waiting. We are also waiting for official
> 4.2 release (it was proposed by me in Jan'21 but it was initially 
> mentioned in
> Jul'20!). My preposition for stable release plan was also ignored[1].
> I understand that you are busy and mdadm is not in your mind right now.
> 
> Coly comes with offer to take care of mdadm, could you answer?
> Current model doesn't work, we definitely need to find new solution.
> If there any other folk interested in this position, please
> speak up loudly!
> 
> I will be pleased to cooperate with Coly, or any other maintainer which is
> active and responsible. Naturally, VROC team will give support,
> especially with external management issues.
> 
> It is a time to change something, we shouldn't wait more.

Can you please start a new thread with the offer to become maintainer, 
so it does not get lost/buried?


Kind regards,

Paul


> [1] https://lore.kernel.org/linux-raid/de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com/
