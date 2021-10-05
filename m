Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AEBC433EF
	for <linux-raid@archiver.kernel.org>; Tue,  5 Oct 2021 01:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 777FC6154B
	for <linux-raid@archiver.kernel.org>; Tue,  5 Oct 2021 01:05:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbhJEBHd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Oct 2021 21:07:33 -0400
Received: from out0.migadu.com ([94.23.1.103]:52814 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229744AbhJEBHc (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 4 Oct 2021 21:07:32 -0400
Subject: Re: [PATCH 1/6] md/raid1: only allocate write behind bio for
 WriteMostly device
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633395940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eeNOofS+8as25i/6k7oX7JI4HUSFkT/SqEC/8pl6TPU=;
        b=c2eQ1MxhX6xsbnPZ+1Pt65INfpFvhT1bd6HCWvSafcvpvO/sZpv5XdmlJIbdd2Tcmtjzld
        LSVI05xlYHgSvC1SRXaB54BJsRQyBv/eml33xBjvjPjLq7P37hhoDOdKOyaOzZ3Q11anI3
        DJi2gDojNgqxerwmWRhINSVu5mEJNq4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     song@kernel.org
Cc:     linux-raid@vger.kernel.org, jens@chianterastutte.eu
References: <20211004153453.14051-1-guoqing.jiang@linux.dev>
 <20211004153453.14051-2-guoqing.jiang@linux.dev>
Message-ID: <f601dddd-1239-e7bd-7ce9-7c43845fbce5@linux.dev>
Date:   Tue, 5 Oct 2021 09:05:30 +0800
MIME-Version: 1.0
In-Reply-To: <20211004153453.14051-2-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now cc Jens actually.

On 10/4/21 11:34 PM, Guoqing Jiang wrote:
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

