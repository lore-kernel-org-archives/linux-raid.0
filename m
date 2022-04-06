Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21989C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 17:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239448AbiDFRvp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbiDFRvY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 13:51:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61AB307E52
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 09:00:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id ABAB62129B;
        Wed,  6 Apr 2022 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649260809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hCrOJ6j1edXLj2+GhU9n1Zn7XIh/k8nLjVQMCWzV53k=;
        b=Vmch1wiI/1mugp8WZQ6VilyX4uugzoF80CThQva7JuoESbzb2xAR7tQh8OqueiVuZtuKNp
        fo6kdBlF0osKmp113fsT3bWuxsi7W0AooZwllcwQi974qJArWGxJEuv7Le5EM5IAjOUqxY
        gSIKbhsbIWh9+dqAkN3oXe88B1fO4YY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649260809;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hCrOJ6j1edXLj2+GhU9n1Zn7XIh/k8nLjVQMCWzV53k=;
        b=SboooJe537g0j0XU+gdXM0dNZTJRLdQRkZ+OAWuJDG+jcm5GEpEcUzXpW05NBtCnBfR+pN
        IxyQOq04ltMaURAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5592F139F5;
        Wed,  6 Apr 2022 16:00:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 58yKMge5TWIsSAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 06 Apr 2022 16:00:07 +0000
Message-ID: <486efd7c-b066-7667-9327-2e1284271991@suse.de>
Date:   Thu, 7 Apr 2022 00:00:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] Assemble: check if device is container before
 scheduling force-clean update
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220404140115.16973-1-kinga.tanska@intel.com>
 <20220404140115.16973-2-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220404140115.16973-2-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/4/22 10:01 PM, Kinga Tanska wrote:
> When assemble is used with --force flag and array is not clean then
> "force-clean" update is scheduled. Containers are considered as not
> clean because this field is not set for them. To exclude them from
> meaningless update (it is ignored quietly) check if the device
> is a container first.
>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


> ---
>   Assemble.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/Assemble.c b/Assemble.c
> index 704b8293..f31372db 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1813,10 +1813,9 @@ try_again:
>   		}
>   #endif
>   	}
> -	if (c->force && !clean &&
> +	if (c->force && !clean && content->array.level != LEVEL_CONTAINER &&
>   	    !enough(content->array.level, content->array.raid_disks,
> -		    content->array.layout, clean,
> -		    avail)) {
> +		    content->array.layout, clean, avail)) {
>   		change += st->ss->update_super(st, content, "force-array",
>   					       devices[chosen_drive].devname, c->verbose,
>   					       0, NULL);


