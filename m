Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F3CC433EF
	for <linux-raid@archiver.kernel.org>; Sat, 19 Mar 2022 15:12:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbiCSPOE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 19 Mar 2022 11:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiCSPOD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 19 Mar 2022 11:14:03 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259E95A085
        for <linux-raid@vger.kernel.org>; Sat, 19 Mar 2022 08:12:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 71F0A21102;
        Sat, 19 Mar 2022 15:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647702760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wMhYQC9hNsv0BHgy31bnPlsg1ZG7fiIC/iAVAvY0sXs=;
        b=Je6YzZK6ZI/LNK9GBuZ/wCXad6hUtSj07Q07K4O/DFCIfDlO0iyHcMhU2+8vMRL2DJQqbi
        kHh9VqInqXWhxEcsmubByKAbFvGthZDFGeifNpQKcl8ojCtjgDet/CeL70xbeago9DzqX9
        Hl/Vysn0XTDwi5BhgS8rHRKvvyqJDlw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647702760;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wMhYQC9hNsv0BHgy31bnPlsg1ZG7fiIC/iAVAvY0sXs=;
        b=ILPViS6mNEvTVDtnDvCXRfdww5CI6h0to+5OThvUpfQnW+jr2uLTrpj4iJhttQDqm75Zgj
        KjJY4BLMt9mX4vAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 491D0132D4;
        Sat, 19 Mar 2022 15:12:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mq4iBOfyNWJXCgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 19 Mar 2022 15:12:39 +0000
Message-ID: <da2d2717-c278-62bc-d1e5-e0d371b66f9b@suse.de>
Date:   Sat, 19 Mar 2022 23:12:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] Assemble: check if device is container before scheduling
 force-clean update
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220209090940.11973-1-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220209090940.11973-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/9/22 5:09 PM, Kinga Tanska wrote:
> When assemble is used with --force flag and array is not clean then
> "force-clean" update is scheduled. Containers are considered as not
> clean because this field is not set for them. To exclude them from
> meaningless update (it is ignored quietly) check if the device
> is a container first.
> To unify all containers checks in code, is_container() function is
> added and propagated.
>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>


Hi Kinga,


I am fine with the above idea, except the extra is_container(). IMHO 
comparing directly with LEVEL_CONTAINER is fine, adding is_container() 
doesn't help too much.


Except for the code replacement with is_container(), it looks good to me 
for your fix.


> ---
>   Assemble.c    | 10 ++++------
>   Create.c      |  6 +++---
>   Grow.c        |  6 +++---
>   Incremental.c |  4 ++--
>   mdadm.h       | 14 ++++++++++++++
>   super-ddf.c   |  6 +++---
>   super-intel.c |  4 ++--
>   super0.c      |  2 +-
>   super1.c      |  2 +-
>   sysfs.c       |  2 +-
>   10 files changed, 34 insertions(+), 22 deletions(-)
>
> diff --git a/Assemble.c b/Assemble.c
> index 704b8293..3d65212c 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1123,7 +1123,7 @@ static int start_array(int mdfd,
>   			       i/2, mddev);
>   	}

[snipped]


>   	}
> -	if (c->force && !clean &&
> +	if (c->force && !clean && !is_container(content->array.level) &&
>   	    !enough(content->array.level, content->array.raid_disks,
> -		    content->array.layout, clean,
> -		    avail)) {
> +		    content->array.layout, clean, avail)) {
>   		change += st->ss->update_super(st, content, "force-array",
>   					       devices[chosen_drive].devname, c->verbose,
>   					       0, NULL);


For the above change,

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li

[snipped]


