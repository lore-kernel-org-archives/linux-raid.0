Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89C9C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 22 Dec 2021 01:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhLVBzF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 20:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235636AbhLVBzE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Dec 2021 20:55:04 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C41CC061574
        for <linux-raid@vger.kernel.org>; Tue, 21 Dec 2021 17:55:04 -0800 (PST)
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1640138102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z6/LKGsDvlFV9k/QwWEjbjwCOITSRjcUiCba3NHwCf8=;
        b=AstheMFFmO/Bx0TS8wQDSO8HjqBv3FoDTxSzMk+OeMQXl1cN741/FF8xuFAfIkK/v7CGfx
        YVehLtX7frrAhCHqYRIUHS+WBc4gzTzy5E8e2c20fMJUbzcrDe0GkfoSWrD0FtQxyg0kjn
        +WkgGnK+jbx44D96GaJmXI7teYtVu58=
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com>
 <CALTww2818H-T5W4oOSG_o_SU1MRAp+_=u9J824V0w1JcX8zZ8Q@mail.gmail.com>
 <20211220094519.000013d0@linux.intel.com>
 <CALTww28wmeuXA5V4ReTLjH-=AZ3VbR-qHEbBMEktHRU8PQQiVg@mail.gmail.com>
 <20211221145628.0000144f@linux.intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <a42a3c37-5eda-48f1-c789-4770eb89144f@linux.dev>
Date:   Wed, 22 Dec 2021 09:54:54 +0800
MIME-Version: 1.0
In-Reply-To: <20211221145628.0000144f@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/21/21 9:56 PM, Mariusz Tkaczyk wrote:
> Hi Xiao,
> On Tue, 21 Dec 2021 09:40:50 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
>> Now for a raid0, it can't remove one member disk from raid0. It
>> returns EBUSY and the raid0 still can work well. It makes sense.
>> Because all member disks are busy, the admin can't remove the member
>> disk and mdadm gives a proper error.
> EBUSY means that drive is busy but it is not. Just drive cannot be
> safety removed. As I wrote in patch 2:
>
> If "faulty" was not set then -EBUSY was returned to
> userspace. It causes that mdadm expects -EBUSY if the array
> becomes failed. There are some reasons to not consider this mechanism
> as correct:
> - drive can't be failed for different reasons.
> - there are path where -EBUSY is not reported and drive removal leads
> to failed array, without notification for userspace.
> - in the array failure case -EBUSY seems to be wrong status. Array is
> not busy, but removal process cannot proceed safe.
>
> For compatibility reasons i cannot remove EBUSY. I left more detailed
> explanation in patch 2.
>
>> With this patch, it changes the situation. In raid0_error, it sets
>> MD_BROKEN. In fact, it isn't broken. So is it really good to set
>> MD_BROKEN here? In patch 62f7b1989c0 ("md raid0/linear: Mark array as
>> 'broken'...), MD_BROKEN is introduced
>> when the member disk disappears and the disk is really broken. For
>> raid0/linear, the raid device can't work anymore.
> It is broken, any md_error() call should end with appropriate action:
> - drive removal (if possible)
> - failing array (if cannot degrade array)
>
> We cannot trust drive if md_error() was called, so writes will be
> blocked. IMO it is reasonable- to not engage level stack, because one
> or more members cannot be trusted (even if it is still accessible). Just
> allow to read old data (if still possible).

Agree, especially for  raid0 and linear, the array is literally broken 
in case one
of member device can't be accessed.

Thanks,
Guoqing
