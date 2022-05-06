Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1550C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  6 May 2022 12:05:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391652AbiEFMI6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 May 2022 08:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346626AbiEFMI5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 May 2022 08:08:57 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2521664BEA
        for <linux-raid@vger.kernel.org>; Fri,  6 May 2022 05:05:14 -0700 (PDT)
Subject: Re: Unable to add journal device to RAID 6 array
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1651838713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3vGzK97/0akIvbTr4WVd9wyH26Cb5cbs+TC9nSq5Sig=;
        b=QbkThg9yBt5z6bUBdCifpe+wkgjr+Pl0QSG4ajJqCj7frUrBRlEEE6pnnjqREmogSNA7zc
        Wdi9hrOwLx2Ylsqf1nN04rmN3Cy7/FyXuyPLYyaM2XBMd/lBWurfPcw3aXAwLmclrn3bq3
        dEUh0ODHQgjfuKdz8ngi9Mvn7svR6No=
To:     James Stephenson <inbox@jstephenson.me>
Cc:     linux-raid@vger.kernel.org
References: <CA+an+MoM_Vb4Z3FSRcTo+ykmFTW5cwh1CQWCN9BMT45CdW_P0g@mail.gmail.com>
 <26c0f640-8801-240c-ce2c-99246b09f2e2@linux.dev>
 <CA+an+Mq8S8hNnbQP3uJCHU_yw_5Fbr+cvWjfmiL9Sa2n-cEpvA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <d51fc202-337f-382d-f82c-6a97c9e09736@linux.dev>
Date:   Fri, 6 May 2022 20:05:09 +0800
MIME-Version: 1.0
In-Reply-To: <CA+an+Mq8S8hNnbQP3uJCHU_yw_5Fbr+cvWjfmiL9Sa2n-cEpvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/6/22 7:55 PM, James Stephenson wrote:
> Thank you for your reply. I did check the source and found the same
> block, however I’m not familiar enough to understand where I would see
> this condition indicated?
>
> As of now the array seems perfectly normal:
> https://gist.github.com/jstephenson/0b615aab33bb8157a3876471ef50424e

Seems the bitmap is not clean, so resync thread might be running.

bitmap: 3/88 pages [12KB], 65536KB chunk

I suppose you can find relevant threads with "ps aux | grep md126", and also
the output of "cat /proc/mdstat" could be helpful.

Thanks,
Guoqing
