Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18BDC433F5
	for <linux-raid@archiver.kernel.org>; Mon, 23 May 2022 16:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbiEWQLe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 May 2022 12:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238717AbiEWQLJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 May 2022 12:11:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5539717A9E
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 09:11:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0E3B221A64;
        Mon, 23 May 2022 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653322267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvedxZEAvWkCuxRl9I8rKi1lBn5f0eaiU8OKz7HR+1A=;
        b=pMe7yXV59lQeYZTSBt9GuraTSbrO0vW/j9pxgomQPE7Fn1L3uAlrTiSYKusKsdOn6X5FWG
        Gj6qoA5t+vbp7NNH/6YLRlgsyIqNicQM31ONUGPmq7vHM4Os1YkB0WwKXCxgfJpaxSGeeW
        POH37UIHrof7ABSPB6535B5uxR/hxX4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653322267;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvedxZEAvWkCuxRl9I8rKi1lBn5f0eaiU8OKz7HR+1A=;
        b=8NylUKI6i1+e6rN+HmLsfZfbZNFOa1IANlI2SEtiOgVj27apypbLbTDmbctt9QYd7ZzO8D
        zTbNr1kZSV8n+WBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 431B0139F5;
        Mon, 23 May 2022 16:11:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1Eh3BBqyi2K2KgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 23 May 2022 16:11:06 +0000
Message-ID: <e3f159b8-0e47-c166-8a94-5da718e6fd3f@suse.de>
Date:   Tue, 24 May 2022 00:11:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] Grow: block -n on external volumes.
Content-Language: en-US
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220519071608.26259-1-mateusz.kusiak@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220519071608.26259-1-mateusz.kusiak@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/19/22 3:16 PM, Mateusz Kusiak wrote:
> Performing --raid-devices on external metadata volume should be blocked
> as it causes unwanted behaviour.
>
> Eg. Performing
> mdadm -G /dev/md/volume -l10 -n4
> on r0_d2 inside 4 disk container, returns
> mdadm: Need 2 spares to avoid degraded array, only have 0.
>
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
>   Grow.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
>
> diff --git a/Grow.c b/Grow.c
> index 8a242b0f..f6efbc48 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1892,6 +1892,14 @@ int Grow_reshape(char *devname, int fd,
>   
>   		if (retval) {
>   			pr_err("Cannot read superblock for %s\n", devname);
> +			close(cfd);
> +			free(subarray);
> +			return 1;
> +		}
> +
> +		if (s->raiddisks && subarray) {
> +			pr_err("--raid-devices operation can be performed on a container only\n");
> +			close(cfd);
>   			free(subarray);
>   			return 1;
>   		}

Hi Mateusz,

It seems the above patch has some both-modified part with a previous 
posted patch "Grow: Split Grow_reshape into helper function."

I will skip this patch and test/review rested patches. Once them are all 
done, could you please post a rebased version again then?


Thanks.


Coly Li

