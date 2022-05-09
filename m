Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDE9C433F5
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 11:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbiEILag (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 07:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiEILaf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 07:30:35 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002C224F23
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 04:26:39 -0700 (PDT)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652095597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zc4T4TmDJ/m7YTzDzm4q8lGeyT6c8BvNnKXXStJzujM=;
        b=OecTXjShO3GzogGbmpZfiosPH0GB3wwuWbbpR4OZoCbWPvOD0IKDMjMmKdMh7le2KCTN1H
        XQ9LihtBiGJAsYXD7hYsOuzw7mz1WWMIrl5hiLFjBMZrHdnfjpXrijKaiL4iRB3z3jSLz+
        1xXuLRcyQ1KAsVIkVu0YcjVixfHFY0Q=
To:     Wols Lists <antlists@youngman.org.uk>, Song Liu <song@kernel.org>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <c2917c23-c218-e600-7e10-31a504c844e2@youngman.org.uk>
 <f3c2ea9a-2dd4-52be-cd3d-a8c994213fd4@linux.dev>
 <6f41c017-8102-cfe6-ad37-e07df3e23cc0@youngman.org.uk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <c2717b8b-4a17-d5ca-89d7-e6054f7be50b@linux.dev>
Date:   Mon, 9 May 2022 19:26:32 +0800
MIME-Version: 1.0
In-Reply-To: <6f41c017-8102-cfe6-ad37-e07df3e23cc0@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/9/22 7:19 PM, Wols Lists wrote:
>
> Hmm...
>
> Which backs up what I thought - if it's used by the dm people to call 
> md-raid, then asking for info/comments about it on the md list is 
> likely to get you no-where...

I don't think you know the V2 well which had been cced to dm list, just FYI.

https://lore.kernel.org/all/1613177399-22024-1-git-send-email-guoqing.jiang@cloud.ionos.com/#t

Thanks,
Guoqing
