Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3E14C433DB
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 18:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3F7E64E6B
	for <linux-raid@archiver.kernel.org>; Mon,  8 Feb 2021 18:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbhBHSmX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Feb 2021 13:42:23 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:58971 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235767AbhBHSmH (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 8 Feb 2021 13:42:07 -0500
Received: from [192.168.0.5] (ip5f5aed2c.dynamic.kabel-deutschland.de [95.90.237.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id E23A620647914;
        Mon,  8 Feb 2021 19:41:15 +0100 (CET)
Subject: Re: md_raid: mdX_raid6 looping after sync_action "check" to "idle"
 transition
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+raid@molgen.mpg.de
References: <aa9567fd-38e1-7b9c-b3e1-dc2fdc055da5@molgen.mpg.de>
 <b289ae15-ff82-b36e-4be4-a1c8bbdbacd7@cloud.ionos.com>
 <37c158cb-f527-34f5-2482-cae138bc8b07@molgen.mpg.de>
 <efb8d47b-ab9b-bdb9-ee2f-fb1be66343b1@molgen.mpg.de>
 <55e30408-ac63-965f-769f-18be5fd5885c@molgen.mpg.de>
 <d95aa962-9750-c27c-639a-2362bdb32f41@cloud.ionos.com>
 <30576384-682c-c021-ff16-bebed8251365@molgen.mpg.de>
 <cdc0b03c-db53-35bc-2f75-93bbca0363b5@molgen.mpg.de>
 <bc342de0-98d2-1733-39cd-cc1999777ff3@molgen.mpg.de>
 <c3390ab0-d038-f1c3-5544-67ae9c8408b1@cloud.ionos.com>
 <a27c5a64-62bf-592c-e547-1e8e904e3c97@molgen.mpg.de>
 <6c7008df-942e-13b1-2e70-a058e96ab0e9@cloud.ionos.com>
 <12f09162-c92f-8fbb-8382-cba6188bfb29@molgen.mpg.de>
 <6757d55d-ada8-9b7e-b7fd-2071fe905466@cloud.ionos.com>
 <93d8d623-8aec-ad91-490c-a414c4926fb2@molgen.mpg.de>
 <0bb7c8d8-6b96-ce70-c5ee-ba414de10561@cloud.ionos.com>
 <e271e183-20e9-8ca2-83eb-225d4d7ab5db@molgen.mpg.de>
 <1cdfceb6-f39b-70e1-3018-ea14dbe257d9@cloud.ionos.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
Message-ID: <7733de01-d1b0-e56f-db6a-137a752f7236@molgen.mpg.de>
Date:   Mon, 8 Feb 2021 19:41:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1cdfceb6-f39b-70e1-3018-ea14dbe257d9@cloud.ionos.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Guoqing,

On 08.02.21 15:53, Guoqing Jiang wrote:
> 
> 
> On 2/8/21 12:38, Donald Buczek wrote:
>>> 5. maybe don't hold reconfig_mutex when try to unregister sync_thread, like this.
>>>
>>>          /* resync has finished, collect result */
>>>          mddev_unlock(mddev);
>>>          md_unregister_thread(&mddev->sync_thread);
>>>          mddev_lock(mddev);
>>
>> As above: While we wait for the sync thread to terminate, wouldn't it be a problem, if another user space operation takes the mutex?
> 
> I don't think other places can be blocked while hold mutex, otherwise these places can cause potential deadlock. Please try above two lines change. And perhaps others have better idea.

Yes, this works. No deadlock after >11000 seconds,

(Time till deadlock from previous runs/seconds: 1723, 37, 434, 1265, 3500, 1136, 109, 1892, 1060, 664, 84, 315, 12, 820 )

Best
   Donald
> 
> Thanks,
> Guoqing
