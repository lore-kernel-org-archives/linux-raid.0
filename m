Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECB2C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 10:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F1F16117A
	for <linux-raid@archiver.kernel.org>; Thu,  7 Oct 2021 10:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240736AbhJGKWM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Oct 2021 06:22:12 -0400
Received: from out10.migadu.com ([46.105.121.227]:57938 "EHLO out10.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232166AbhJGKWM (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 7 Oct 2021 06:22:12 -0400
Subject: Re: [PATCH 2/6] md/bitmap: don't set max_write_behind if there is no
 write mostly device
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633602017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x0OPlmrSjkteKT4s2vtnRnFj3xo8aNV1m4qUzs8vxao=;
        b=O7yN2XYgy3YcoYSFhCdcwuLOWfo6k3b8GsJVjdyBUWkDEvI92c+v/e3ZCk7oraiO2CnrTS
        scTE18Wd3USKnzIqb9QY4JV3tdo+Goh5tP/+lL+ywG2txFMz14VuwKUXsRs7ORYutlapxu
        md6WsZ7iDj/wVo6PxBAxBlgmCeDaBmo=
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20211004153453.14051-1-guoqing.jiang@linux.dev>
 <20211004153453.14051-3-guoqing.jiang@linux.dev>
 <CAPhsuW58FyoNgttdXiPUoCdA9Rfr8+yeq4xe9GdGp2F8+2b+OA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <8425606e-04ce-c27b-4622-ab22094637bb@linux.dev>
Date:   Thu, 7 Oct 2021 18:20:15 +0800
MIME-Version: 1.0
In-Reply-To: <CAPhsuW58FyoNgttdXiPUoCdA9Rfr8+yeq4xe9GdGp2F8+2b+OA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/7/21 2:25 PM, Song Liu wrote:
> On Mon, Oct 4, 2021 at 8:40 AM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>> We shouldn't set it since write behind IO should only happen to write
>> mostly device.
>>
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>> ---
>>   drivers/md/md-bitmap.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index e29c6298ef5c..0346281b1555 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -2469,11 +2469,28 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
>>   {
>>          unsigned long backlog;
>>          unsigned long old_mwb = mddev->bitmap_info.max_write_behind;
>> +       struct md_rdev *rdev;
>> +       bool has_write_mostly = false;
>>          int rv = kstrtoul(buf, 10, &backlog);
>>          if (rv)
>>                  return rv;
>>          if (backlog > COUNTER_MAX)
>>                  return -EINVAL;
>> +
>> +       /*
>> +        * Without write mostly device, it doesn't make sense to set
>> +        * backlog for max_write_behind.
>> +        */
>> +       rdev_for_each(rdev, mddev)
>> +               if (test_bit(WriteMostly, &rdev->flags)) {
>> +                       has_write_mostly = true;
>> +                       break;
>> +               }
>> +       if (!has_write_mostly) {
>> +               pr_warn_ratelimited("md: No write mostly device available\n");
> Most of these _store functions do not print warnings for invalid changes. So
> I am not sure whether we want to add this one.

I think it is better to makes users know the reason of invalidation.

> If we do want it, we should make it clear, as
> "md: No write mostly device available. Cannot set backlog\n".
> We may also add the device name there.

Sure, I will make it clearer.

Thanks,
Guoqing
