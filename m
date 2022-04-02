Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2066C433F5
	for <linux-raid@archiver.kernel.org>; Sat,  2 Apr 2022 15:55:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357485AbiDBP5D (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Apr 2022 11:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346898AbiDBP5C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Apr 2022 11:57:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C6014092
        for <linux-raid@vger.kernel.org>; Sat,  2 Apr 2022 08:55:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D14EC1FD00;
        Sat,  2 Apr 2022 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648914908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FgtPkMxb8kyYqhW9rPazon1nwciG/XPF8cqnKh8tGAs=;
        b=RWZ3wFuQ7kTXhoJcGI8T1ZYZO75Vv1ooPZJ9C9oDiFWPKm6n+rjQaf9NXL+4BCP8b+tX1Y
        d9MC5q/Tj1an8/LkIqZC5gePu4YgOwXOvdbf8wCcp73DknRopoRnKees6XmTvG5E2jJVgR
        IC3WnyAAXmAsIZELgenRopHv1f/MOzs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648914908;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FgtPkMxb8kyYqhW9rPazon1nwciG/XPF8cqnKh8tGAs=;
        b=VcreaYkM6mGPFQqPwd6ADsoC6H3wzp9vac8IgxsLc+yNeIq2AtfozryJusvc3Kr8FmTlD+
        sWHIdDkgYyXOKACA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8BF1913440;
        Sat,  2 Apr 2022 15:55:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xhYfENtxSGKTOgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 02 Apr 2022 15:55:07 +0000
Message-ID: <7b087a7a-69e5-9ed4-ed0c-29d82bcceaa6@suse.de>
Date:   Sat, 2 Apr 2022 23:54:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] mdadm: replace container level checking with inline
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220323091001.27139-1-kinga.tanska@intel.com>
 <20220323091001.27139-3-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220323091001.27139-3-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/23/22 5:10 PM, Kinga Tanska wrote:
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
> diff --git a/Assemble.c b/Assemble.c
> index f31372db..27324939 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1123,7 +1123,7 @@ static int start_array(int mdfd,
>   			       i/2, mddev);
>   	}
>   
> -	if (content->array.level == LEVEL_CONTAINER) {
> +	if (is_container(content->array.level)) {
>   		sysfs_rules_apply(mddev, content);
>   		if (c->verbose >= 0) {
>   			pr_err("Container %s has been assembled with %d drive%s",
[snipped]
>   		sysfs_uevent(sra, "change");
> diff --git a/mdadm.h b/mdadm.h
> index c7268a71..371927ae 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1885,3 +1885,17 @@ enum r0layout {
>    * This is true for native and DDF, IMSM allows 16.
>    */
>   #define MD_NAME_MAX 32
> +
> +/**
> + * is_container() - check if @level is &LEVEL_CONTAINER
> + * @level: level value
> + *
> + * return:
> + * &true if level is equal to &LEVEL_CONTAINER, &false otherwise.
> + */
> +static inline bool is_container(const int level)
> +{
> +	if (level == LEVEL_CONTAINER)
> +		return true;
> +	return false;
> +}
> \ No newline at end of file

I am overall fine with this idea. Just one thing to ask, is_container() 
is the only is_xxx() routine with bool type, others are in type int. 
Maybe is_container() may follow existing code style?


Coly Li

