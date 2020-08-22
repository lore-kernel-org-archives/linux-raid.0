Return-Path: <SRS0=RtKw=CA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B5FC433E1
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 09:28:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 007B9207C3
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 09:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SeSUd90V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgHVJ23 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 22 Aug 2020 05:28:29 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22376 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725864AbgHVJ22 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 22 Aug 2020 05:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598088506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XUZ4n4VmeyeptInhNsfkOwuxMr+V4Ce+NyYUP3ME3yc=;
        b=SeSUd90V41L8/Q5z2oKWzWB8B5PmL0hLgohOlDtFm+4AKTikpMUAgl45CgAtxNm7xOmIuL
        NNWhTP2KjaFawaq55ndVPCCHKLkoKeNZum6WCC0/wCEDm5B9sBX3O8aY+QoqdXzGQDgvTb
        iqUN8E7grVBUwS2C6VcCxye2VYyVao8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-xC2Vzj1bMayz5JZtJq6KEA-1; Sat, 22 Aug 2020 05:28:24 -0400
X-MC-Unique: xC2Vzj1bMayz5JZtJq6KEA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 427DF801AC2;
        Sat, 22 Aug 2020 09:28:23 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A5F26E715;
        Sat, 22 Aug 2020 09:28:19 +0000 (UTC)
Subject: Re: [PATCH V3 2/4] md/raid10: extend r10bio devs to raid disks
From:   Xiao Ni <xni@redhat.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     colyli@suse.de, guoqing.jiang@cloud.ionos.com, heinzm@redhat.com,
        ncroxon@redhat.com
References: <1597306476-8396-1-git-send-email-xni@redhat.com>
 <1597306476-8396-3-git-send-email-xni@redhat.com>
Message-ID: <7f9c8636-b151-a92e-2cf5-051bab84d56b@redhat.com>
Date:   Sat, 22 Aug 2020 17:28:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1597306476-8396-3-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 08/13/2020 04:14 PM, Xiao Ni wrote:
> Now it allocs r10bio->devs[conf->copies]. Discard bio needs to submit
> to all member disks and it needs to use r10bio. So extend to
> r10bio->devs[geo.raid_disks].
>
> Reviewed-by: Coly Li <colyli@suse.de>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/raid10.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index cefda2a..cef3cb8 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -91,7 +91,7 @@ static inline struct r10bio *get_resync_r10bio(struct bio *bio)
>   static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
>   {
>   	struct r10conf *conf = data;
> -	int size = offsetof(struct r10bio, devs[conf->copies]);
> +	int size = offsetof(struct r10bio, devs[conf->geo.raid_disks]);
>   
>   	/* allocate a r10bio with room for raid_disks entries in the
>   	 * bios array */
> @@ -238,7 +238,7 @@ static void put_all_bios(struct r10conf *conf, struct r10bio *r10_bio)
>   {
>   	int i;
>   
> -	for (i = 0; i < conf->copies; i++) {
> +	for (i = 0; i < conf->geo.raid_disks; i++) {
>   		struct bio **bio = & r10_bio->devs[i].bio;
>   		if (!BIO_SPECIAL(*bio))
>   			bio_put(*bio);
> @@ -327,7 +327,7 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
>   	int slot;
>   	int repl = 0;
>   
> -	for (slot = 0; slot < conf->copies; slot++) {
> +	for (slot = 0; slot < conf->geo.raid_disks; slot++) {
>   		if (r10_bio->devs[slot].bio == bio)
>   			break;
>   		if (r10_bio->devs[slot].repl_bio == bio) {
> @@ -336,7 +336,7 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
>   		}
>   	}
>   
> -	BUG_ON(slot == conf->copies);
> +	BUG_ON(slot == conf->geo.raid_disks);
Hi Song

I'm trying to fix the warning messages for these patches. What's your 
suggestion for this kind of things?
Is it ok to remove BUG_ON from the code? Or change BUG_ON to WARN_ON?

Regards
Xiao

