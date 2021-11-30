Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AF8C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 30 Nov 2021 17:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244823AbhK3Rah (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 Nov 2021 12:30:37 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:54613 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244270AbhK3Rag (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 30 Nov 2021 12:30:36 -0500
Received: from [192.168.0.2] (ip5f5aeac2.dynamic.kabel-deutschland.de [95.90.234.194])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 583FE61E5FE02;
        Tue, 30 Nov 2021 18:27:16 +0100 (CET)
Message-ID: <3f2ad763-6fcb-a652-7131-9e20135a1405@molgen.mpg.de>
Date:   Tue, 30 Nov 2021 18:27:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V2] md: don't unregister sync_thread with reconfig_mutex
 held
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Donald Buczek <buczek@molgen.mpg.de>, it+raid@molgen.mpg.de
References: <1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com>
 <36a660ed-b995-839e-ac82-dc4ca25ccb8a@molgen.mpg.de>
 <CAPhsuW5s6fk3kua=9Z9o3VPCcN1wdUqXybXm9cp4arJW5+oBvQ@mail.gmail.com>
 <9f28f6e2-e46a-bfed-09d8-2fec941ea881@cloud.ionos.com>
 <CAPhsuW4V8JCCKePj11rf3zo4MJTz6TpW6DDeNmcJBfRSoN+NDA@mail.gmail.com>
 <a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
In-Reply-To: <a3a1fed7-b886-8603-aa20-20d667a837a7@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

[Update Guoqing’s email address]

Am 30.11.21 um 18:25 schrieb Paul Menzel:
> Dear Linux folks,
> 
> 
> Am 20.03.21 um 00:00 schrieb Song Liu:
>> On Wed, Feb 24, 2021 at 1:26 AM Guoqing Jiang wrote:
> 
>>> On 2/24/21 10:09, Song Liu wrote:
>>>> On Mon, Feb 15, 2021 at 3:08 AM Paul Menzel wrote:
>>>>>
>>>>> [+cc Donald]
>>>>>
>>>>> Am 13.02.21 um 01:49 schrieb Guoqing Jiang:
>>>>>> Unregister sync_thread doesn't need to hold reconfig_mutex since it
>>>>>> doesn't reconfigure array.
>>>>>>
>>>>>> And it could cause deadlock problem for raid5 as follows:
>>>>>>
>>>>>> 1. process A tried to reap sync thread with reconfig_mutex held 
>>>>>> after echo
>>>>>>       idle to sync_action.
>>>>>> 2. raid5 sync thread was blocked if there were too many active 
>>>>>> stripes.
>>>>>> 3. SB_CHANGE_PENDING was set (because of write IO comes from upper 
>>>>>> layer)
>>>>>>       which causes the number of active stripes can't be decreased.
>>>>>> 4. SB_CHANGE_PENDING can't be cleared since md_check_recovery was 
>>>>>> not able
>>>>>>       to hold reconfig_mutex.
>>>>>>
>>>>>> More details in the link:
>>>>>> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t 
>>>>>>
>>>>>>
>>>>>> And add one parameter to md_reap_sync_thread since it could be 
>>>>>> called by
>>>>>> dm-raid which doesn't hold reconfig_mutex.
>>>>>>
>>>>>> Reported-and-tested-by: Donald Buczek <buczek@molgen.mpg.de>
>>>>>> Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
>>>>
>>>> I don't really like this fix. But I haven't got a better (and not too
>>>> complicated)
>>>> alternative.
>>>>
>>>>>> ---
>>>>>> V2:
>>>>>> 1. add one parameter to md_reap_sync_thread per Jack's suggestion.
>>>>>>
>>>>>>     drivers/md/dm-raid.c |  2 +-
>>>>>>     drivers/md/md.c      | 14 +++++++++-----
>>>>>>     drivers/md/md.h      |  2 +-
>>>>>>     3 files changed, 11 insertions(+), 7 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>>>>>> index cab12b2..0c4cbba 100644
>>>>>> --- a/drivers/md/dm-raid.c
>>>>>> +++ b/drivers/md/dm-raid.c
>>>>>> @@ -3668,7 +3668,7 @@ static int raid_message(struct dm_target 
>>>>>> *ti, unsigned int argc, char **argv,
>>>>>>         if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], 
>>>>>> "frozen")) {
>>>>>>                 if (mddev->sync_thread) {
>>>>>>                         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>>>>> -                     md_reap_sync_thread(mddev);
>>>>>> +                     md_reap_sync_thread(mddev, false);
>>>>
>>>> I think we can add mddev_lock() and mddev_unlock() here and then we 
>>>> don't
>>>> need the extra parameter?
>>>
>>> I thought it too, but I would prefer get the input from DM people first.
>>>
>>> @ Mike or Alasdair
>>
>> Hi Mike and Alasdair,
>>
>> Could you please comment on this option: adding mddev_lock() and 
>> mddev_unlock()
>> to raid_message() around md_reap_sync_thread()?
> 
> The issue is unfortunately still unresolved (at least Linux 5.10.82). 
> How can we move forward?
> 
> 
> Kind regards,
> 
> Paul
