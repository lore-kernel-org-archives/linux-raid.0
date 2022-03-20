Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBC9BC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 20 Mar 2022 14:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244144AbiCTOzz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 20 Mar 2022 10:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiCTOzx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 20 Mar 2022 10:55:53 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6886263CA
        for <linux-raid@vger.kernel.org>; Sun, 20 Mar 2022 07:54:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 225B31F37C;
        Sun, 20 Mar 2022 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647788069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7LoyMer6BtgAdaKLl+8IoUGPKvY+piG8TNTX+rt6mqg=;
        b=r7J7i6p3Ex3tpPSz6Zkk+ydbKDSITvCJO1Nb+2k/U3nOl1wuMNDgRDRXjxE4AFZsII0f1y
        hCBfKZD7SpUVF7byN6mwKsrkJfk6A0CtJD3lXHuWJdcmBRYjPInHO1dDozBBaiEhrMpJ30
        +fYZYYhTCR18XFW8VSe1RrwPr0LhvqY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647788069;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7LoyMer6BtgAdaKLl+8IoUGPKvY+piG8TNTX+rt6mqg=;
        b=Mn/hKVJ9olmB8PPgm6p+GEhAsRLgece/70QtDTKup4v6gjeHkj3uop5bWIZP9RdC1vqogQ
        3kTg/JaMfJgdApBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C5B3C13479;
        Sun, 20 Mar 2022 14:54:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id N/jCOSFAN2LzCAAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 20 Mar 2022 14:54:25 +0000
Message-ID: <f62662ab-3046-5003-cac8-6aa145c9cb95@suse.de>
Date:   Sun, 20 Mar 2022 22:54:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 4/4] mdadm: Update config manual
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
 <20220318082607.675665-5-lukasz.florczak@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220318082607.675665-5-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/18/22 4:26 PM, Lukasz Florczak wrote:
> Add missing HOMECLUSTER keyword description.
>
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>

Tested and verified on openSUSE,

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


> ---
>   mdadm.conf.5.in | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
>
> diff --git a/mdadm.conf.5.in b/mdadm.conf.5.in
> index dd331a6a..cd4e6a9d 100644
> --- a/mdadm.conf.5.in
> +++ b/mdadm.conf.5.in
> @@ -439,6 +439,23 @@ from any possible local name. e.g.
>   .B /dev/md/1_1
>   or
>   .BR /dev/md/home_0 .
> +
> +.TP
> +.B HOMECLUSTER
> +The
> +.B homcluster
> +line gives a default value for the
> +.B \-\-homecluster=
> +option to mdadm.  It specifies  the  cluster name for the md device.
> +The md device can be assembled only on the cluster which matches
> +the name specified. If
> +.B homcluster
> +is not provided, mdadm tries to detect the cluster name automatically.
> +
> +There should only be one
> +.B homecluster
> +line.  Any subsequent lines will be silently ignored.
> +
>   .TP
>   .B AUTO
>   A list of names of metadata format can be given, each preceded by a


