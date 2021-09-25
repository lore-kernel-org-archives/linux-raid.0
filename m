Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE1BC433F5
	for <linux-raid@archiver.kernel.org>; Sat, 25 Sep 2021 23:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87A6960F11
	for <linux-raid@archiver.kernel.org>; Sat, 25 Sep 2021 23:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhIYXEc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 25 Sep 2021 19:04:32 -0400
Received: from out2.migadu.com ([188.165.223.204]:47255 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhIYXEb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sat, 25 Sep 2021 19:04:31 -0400
Subject: Re: [PATCH] raid1: ensure bio doesn't have more than BIO_MAX_VECS
 sectors
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1632610974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J9KALwxkfEKt9BCE4nDAIAoWuA4dl/1iochTlFeR0Wk=;
        b=mjYva06DXKFwGd7m6Kdr5QPQmO1eEKh+MF300iswdOdYWH1hvWkf3IKQAALMS7jJcnGeaK
        PoGfco4D34Jlf6PdyyW5gVXgPqFR15YBtMX2tMSXKbxF07gDUU9FVgvVCs8D4dUuR0M8Up
        Ju1dI7CHw4d8T6ZC6fxgFK9K9WuAMwA=
To:     "Jens Stutte (Archiv)" <jens@chianterastutte.eu>,
        Ming Lei <ming.lei@redhat.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20210813060510.3545109-1-guoqing.jiang@linux.dev>
 <YRYj8A+mDfAQBo/E@infradead.org>
 <0eac4589-ffd2-fb1a-43cc-87722731438a@linux.dev>
 <YRd26VGAnBiYeHrH@infradead.org> <YReFYrjtWr9MvfBr@T590>
 <YRox8gMjl/Y5Yt/k@infradead.org> <YRpOwFewTw4imskn@T590>
 <YRtDxEw7Zp2H7mxp@infradead.org> <YRusakafZq0NMqLe@T590>
 <cc91ef81-bf25-cee6-018f-2f79c7a183ae@chianterastutte.eu>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <fd77ff25-4b08-11b8-2e67-7cec988ce834@linux.dev>
Date:   Sun, 26 Sep 2021 07:02:43 +0800
MIME-Version: 1.0
In-Reply-To: <cc91ef81-bf25-cee6-018f-2f79c7a183ae@chianterastutte.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 9/24/21 11:34 PM, Jens Stutte (Archiv) wrote:
> Hi all,
>
> I just had the occasion to test the new patch as landed in arch linux 
> 5.14.7. Unfortunately it does not work for me. Attached you can find a 
> modification that works for me, though I am not really sure why 
> write_behind seems not to be set to true on my configuration. If there 
> is any more data I can provide to help you to investigate, please let 
> me know.

Thanks for the report!  As commented in bugzilla, this is because 
write-behind
IO still happens even without write-mostly device. I will send new patch 
after
you confirm it works.


1. https://bugzilla.kernel.org/show_bug.cgi?id=213181

Thanks,
Guoqing
