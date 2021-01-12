Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414E2C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 09:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E6522DFB
	for <linux-raid@archiver.kernel.org>; Tue, 12 Jan 2021 09:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390516AbhALJZz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:25:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42106 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390661AbhALJZy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 12 Jan 2021 04:25:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610443468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uh1C1+VMBSOoyj5eN7hXEr54YT8d/u/LFC+lRpYXlvU=;
        b=YPtl26W1RZJFUhpzBX09WIIwOZ+4Gsy8Q9U6zbxDGz9z6SVVusJBZjkbklchk00RwagawD
        nGY+spm8nqRCoEREeW7CJ8u09tsCw6ep3evk2wAGdr/7pHe9/kdQnKEgBTdEKuQnyivdKd
        O4nUvClKeRvSceythAbkgRGM1bDKmcs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-46-s-uqbYSlMNSVqkYTCojktw-1; Tue, 12 Jan 2021 04:24:26 -0500
X-MC-Unique: s-uqbYSlMNSVqkYTCojktw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5FCCB8145E0;
        Tue, 12 Jan 2021 09:24:25 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE6537771F;
        Tue, 12 Jan 2021 09:24:22 +0000 (UTC)
Subject: Re: [PATCH 1/1] Set prev_flush_start and flush_bio in an atomic way
From:   Xiao Ni <xni@redhat.com>
To:     songliubraving@fb.com, linux-raid@vger.kernel.org
Cc:     ncroxon@redhat.com, heinzm@redhat.com, djeffery@redhat.com
References: <1607582012-9501-1-git-send-email-xni@redhat.com>
Message-ID: <f1f2ef45-6fc0-4593-d312-b961a0fb1174@redhat.com>
Date:   Tue, 12 Jan 2021 17:24:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1607582012-9501-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song

Could you review this patch

Regards
Xiao

On 12/10/2020 02:33 PM, Xiao Ni wrote:
> One customer reports a crash problem which causes by flush request. It triggers a warning
> before crash.
>
>          /* new request after previous flush is completed */
>          if (ktime_after(req_start, mddev->prev_flush_start)) {
>                  WARN_ON(mddev->flush_bio);
>                  mddev->flush_bio = bio;
>                  bio = NULL;
>          }
>
> The WARN_ON is triggered. We use spin lock to protect prev_flush_start and flush_bio
> in md_flush_request. But there is no lock protection in md_submit_flush_data. It can
> set flush_bio to NULL first because of compiler reordering write instructions.
>
> For example, flush bio1 sets flush bio to NULL first in md_submit_flush_data. An
> interrupt or vmware causing an extended stall happen between updating flush_bio and
> prev_flush_start. Because flush_bio is NULL, flush bio2 can get the lock and submit
> to underlayer disks. Then flush bio1 updates prev_flush_start after the interrupt or
> exteneded stall.
>
> Then flush bio3 enters in md_flush_request. The start time req_start is behind
> prev_flush_start. The flush_bio is not NULL(flush bio2 hasn't finished). So it can
> trigger the WARN_ON now. Then it calls INIT_WORK again. INIT_WORK() will re-initialize
> the list pointers in the work_struct, which then can result in a corrupted work list
> and the work_struct queued a second time. With the work list corrupted, it can lead
> in invalid work items being used and cause a crash in process_one_work.
>
> We need to make sure only one flush bio can be handled at one same time. So add
> spin lock in md_submit_flush_data to protect prev_flush_start and flush_bio in
> an atomic way.
>
> Reviewed-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c42af46..2746d5c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -639,8 +639,10 @@ static void md_submit_flush_data(struct work_struct *ws)
>   	 * could wait for this and below md_handle_request could wait for those
>   	 * bios because of suspend check
>   	 */
> +	spin_lock_irq(&mddev->lock);
>   	mddev->prev_flush_start = mddev->start_flush;
>   	mddev->flush_bio = NULL;
> +	spin_unlock_irq(&mddev->lock);
>   	wake_up(&mddev->sb_wait);
>   
>   	if (bio->bi_iter.bi_size == 0) {

