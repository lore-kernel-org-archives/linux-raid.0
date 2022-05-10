Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55E3C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 10 May 2022 12:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbiEJMNn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 May 2022 08:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiEJMNl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 May 2022 08:13:41 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A272992D6
        for <linux-raid@vger.kernel.org>; Tue, 10 May 2022 05:09:43 -0700 (PDT)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652184581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/f8FpVhNc8+lfkMKxaNLqZji7GcKSuZI4uL8lryQgk4=;
        b=hBFVPmeFbayNIwm0xU14mdBHu2XEXx2XJuYM9Pb8ceRcfD7keCV8+vDU7wYUUadevHP/UM
        TwnY9PdMl31Th9O7ceY1J/U4lTpZqEvuEmBVTKgp9cuQR3WHduJdiA7B9IK5cCemCV9YwC
        0J+qlB8Lfd3VjjZqTzIgUibc+cDA72A=
To:     Donald Buczek <buczek@molgen.mpg.de>, Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <CAPhsuW6U3g-Xikbw4mAJOH1-kN42rYHLiq_ocv==436azhm33g@mail.gmail.com>
 <fdabab9e-e0ce-330d-b4db-0a11fde82615@molgen.mpg.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <e50fa5ee-156a-aa22-fc49-390cefa3875f@linux.dev>
Date:   Tue, 10 May 2022 20:09:37 +0800
MIME-Version: 1.0
In-Reply-To: <fdabab9e-e0ce-330d-b4db-0a11fde82615@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/10/22 8:01 PM, Donald Buczek wrote:
>
>> I guess v2 is the best at the moment. I pushed a slightly modified v2 to
>> md-next.
>
> I think, this can be used to get a double-free from md_unregister_thread.
>
> Please review
>
> https://lore.kernel.org/linux-raid/8312a154-14fb-6f07-0cf1-8c970187cc49@molgen.mpg.de/

That is supposed to be addressed by the second one, pls consider it too.

[PATCH 2/2] md: protect md_unregister_thread from reentrancy

Thanks,
Guoqing
