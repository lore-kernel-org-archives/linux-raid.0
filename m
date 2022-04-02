Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A63C433EF
	for <linux-raid@archiver.kernel.org>; Sat,  2 Apr 2022 15:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357496AbiDBP5b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Apr 2022 11:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345693AbiDBP5a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Apr 2022 11:57:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE9DF140F3
        for <linux-raid@vger.kernel.org>; Sat,  2 Apr 2022 08:55:38 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AFECF1FD01;
        Sat,  2 Apr 2022 15:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648914937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xrN3gYVALl00v3gwr9sVLTyCwYogM+EZvMznoH64vs4=;
        b=nMmuS/ppCcwQaOaUcZYrCWTiMAA+JPj0QHO8Jic5Ap/m1cgRPQZMRbANsYf9YhPjnvVqc1
        QN5RIh1xXay7FGjVpkd3+hfqswm+t62Ou6UI/c21MvSHvEW+VLAdSkVY+ShfAaFq8MnG4k
        OvTkt70k/vz1ZjatCwtfMRe7X704xxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648914937;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xrN3gYVALl00v3gwr9sVLTyCwYogM+EZvMznoH64vs4=;
        b=NsUlECqlbOtlg4T2pT8GQXxXvRZwgoYjNtv3L0Jmuel8hp6zfkalrR2uL1hjEA3GRRZUcP
        LSFNfdExlZaK8RDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 80D6013440;
        Sat,  2 Apr 2022 15:55:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DuO3J/dxSGK1OgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 02 Apr 2022 15:55:35 +0000
Message-ID: <460e5dd9-0e75-f49f-29d8-25d0d116e693@suse.de>
Date:   Sat, 2 Apr 2022 23:55:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] Assemble: check if device is container before
 scheduling force-clean update
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220323091001.27139-1-kinga.tanska@intel.com>
 <20220323091001.27139-2-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220323091001.27139-2-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/23/22 5:10 PM, Kinga Tanska wrote:
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


