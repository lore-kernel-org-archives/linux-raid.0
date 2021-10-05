Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6984C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  5 Oct 2021 05:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4FE961505
	for <linux-raid@archiver.kernel.org>; Tue,  5 Oct 2021 05:55:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbhJEF5Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Oct 2021 01:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhJEF5P (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Oct 2021 01:57:15 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5DAC061745
        for <linux-raid@vger.kernel.org>; Mon,  4 Oct 2021 22:55:22 -0700 (PDT)
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:105:465:1:4:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4HNmyb1DdqzQkhm;
        Tue,  5 Oct 2021 07:55:19 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chianterastutte.eu;
        s=MBO0001; t=1633413317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XSoCw+INjzGpDfK163Jp7uAls8GQQFSVBhkApfgntv4=;
        b=jH0HFnoBjHLJS/UEpQ6WkBHUdyWMf8AM6YNp4ml1He4Zz06em1qi0gwm6hnvXBUC7QvmYu
        7/p+TcCPI6snroVJtFy2Tpd1hFt4i2AnlFqj5AHhAoELKjYuFKxz+kcOTXGhJYVNAiFMkI
        Rr+eGzUfh7px0lQmRBVgo57VsMp+q4h73gYJi1FcGee3LhUFO6xVBYIBI7zv3YjS08tFCi
        VvHxlk7oaneNEmw5NNCQQnimvU490Gy3NDtEkMhzE3i0pLLAxX8obQCPR3zMVMu0NkNXZ0
        OfkO2rdAydmXAvET1KQrD75gr/44vMWxQ9jtsYD/+kSsTEDE9NMYmW3kqpWDTA==
Subject: Re: [PATCH 1/6] md/raid1: only allocate write behind bio for
 WriteMostly device
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20211004153453.14051-1-guoqing.jiang@linux.dev>
 <20211004153453.14051-2-guoqing.jiang@linux.dev>
From:   Jens Stutte <jens@chianterastutte.eu>
Message-ID: <df0d3a88-4f60-b28e-5776-894e4acb38c6@chianterastutte.eu>
Date:   Tue, 5 Oct 2021 07:55:14 +0200
MIME-Version: 1.0
In-Reply-To: <20211004153453.14051-2-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Rspamd-Queue-Id: 3139F26D
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

FWIW, I can confirm that an equivalent change (except for variable 
renaming, see [1]) is running well here now for a while now.

Thank you to work on this!

Am 04.10.21 um 17:34 schrieb Guoqing Jiang:
> Commit 6607cd319b6b91bff94e90f798a61c031650b514 ("raid1: ensure write
> behind bio has less than BIO_MAX_VECS sectors") tried to guarantee the
> size of behind bio is not bigger than BIO_MAX_VECS sectors.
>
> Unfortunately the same calltrace still could happen since an array could
> enable write-behind without write mostly device.
>
> To match the manpage of mdadm (which says "write-behind is only attempted
> on drives marked as write-mostly"), we need to check WriteMostly flag to
> avoid such unexpected behavior.
>
> [1]. https://bugzilla.kernel.org/show_bug.cgi?id=213181#c25
>
> Cc: stable@vger.kernel.org # v5.12+
> Cc: Jens Stutte <jens@chianterastutte.eu>
> Reported-by: Jens Stutte <jens@chianterastutte.eu>
> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
> ---
>   drivers/md/raid1.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 19598bd38939..6ba12f0f0f03 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1496,7 +1496,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   		if (!r1_bio->bios[i])
>   			continue;
>   
> -		if (first_clone) {
> +		if (first_clone && test_bit(WriteMostly, &rdev->flags)) {
>   			/* do behind I/O ?
>   			 * Not if there are too many, or cannot
>   			 * allocate memory, or a reader on WriteMostly
