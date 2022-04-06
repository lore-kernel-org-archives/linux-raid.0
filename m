Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8979C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 17:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239753AbiDFR4H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239559AbiDFRzj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 13:55:39 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D532C22B07
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 09:05:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3F60E1F856;
        Wed,  6 Apr 2022 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649261116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mCkm0RWjoXXZlGxNBJ2pBu0qVU1ebGtzpriMhcJfhUU=;
        b=bCLQRmEgRkS/YeHyzu+2vnuGN9XONKIJeKFcLNzE95XxOXAqR6xUAzvH+Y2bcIYhbnKcGn
        vehQIgbov3Ez5i6RmzjfYJZMwndbcVCRIlsAvNiPDloj3NSaldnggAb+fNLyljyIfvTwYM
        iGTlKZF1bannsnSHIxGpPEK0HdKjeW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649261116;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mCkm0RWjoXXZlGxNBJ2pBu0qVU1ebGtzpriMhcJfhUU=;
        b=/zK0kKteG17UiYfN/BDX9CyOWk9aue+HSzhwd+9n+ApAqdFI29ncMynKBjZ4k6Q226nZXR
        Ps5BI2EyQX2J/bDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 262FE139F5;
        Wed,  6 Apr 2022 16:05:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ixLuODq6TWKgSgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 06 Apr 2022 16:05:14 +0000
Message-ID: <00b1f91b-4ffd-929e-e2c6-05ef283f0b80@suse.de>
Date:   Thu, 7 Apr 2022 00:05:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/2] mdadm: replace container level checking with
 inline
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220404140115.16973-1-kinga.tanska@intel.com>
 <20220404140115.16973-3-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220404140115.16973-3-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/4/22 10:01 PM, Kinga Tanska wrote:
> To unify all containers checks in code, is_container() function is
> added and propagated.
>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>   Assemble.c    |  5 ++---
>   Create.c      |  6 +++---
>   Grow.c        |  6 +++---
>   Incremental.c |  4 ++--
>   mdadm.h       | 14 ++++++++++++++
>   super-ddf.c   |  6 +++---
>   super-intel.c |  4 ++--
>   super0.c      |  2 +-
>   super1.c      |  2 +-
>   sysfs.c       |  2 +-
>   10 files changed, 32 insertions(+), 19 deletions(-)
>
snipped.


> diff --git a/Incremental.c b/Incremental.c
> index a57fc323..077d4eea 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -244,7 +244,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>   		c->autof = ci->autof;
>   
>   	name_to_use = info.name;
> -	if (name_to_use[0] == 0 && info.array.level == LEVEL_CONTAINER) {
> +	if (name_to_use && is_container(info.array.level)) {
>   		name_to_use = info.text_version;
>   		trustworthy = METADATA;
>   	}
I am not sure whether the above change is correct, name_to_use[0] is 
different from name_to_use.

The rested part of this patch is fine to me.


> @@ -472,7 +472,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>   
>   	/* 7/ Is there enough devices to possibly start the array? */
>   	/* 7a/ if not, finish with success. */
> -	if (info.array.level == LEVEL_CONTAINER) {
> +	if (is_container(info.array.level)) {
>   		char devnm[32];
>   		/* Try to assemble within the container */
>   		sysfs_uevent(sra, "change");


snipped.

Coly Li


