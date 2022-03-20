Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9F0C433EF
	for <linux-raid@archiver.kernel.org>; Sun, 20 Mar 2022 14:05:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243731AbiCTOHH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 20 Mar 2022 10:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242611AbiCTOHE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 20 Mar 2022 10:07:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ED0369D9
        for <linux-raid@vger.kernel.org>; Sun, 20 Mar 2022 07:05:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id F03D01F37D;
        Sun, 20 Mar 2022 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647785138; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ByYL7st7i4ImNUhuJQ2jk4++l7qEzQIQE23lXXSnEao=;
        b=mG5Jbi78O9h+Sfc/XVSpboAu5kAvS0sjnLGE0rLl90FzvwkMU+l6jAa1TzSioBXk8CZPKJ
        siPEsaJziyXPu6wClg8Ku6xM0Cuq92W7iXTFkyxHvQmdDGf55+XLova3rdR9AQvX2V6DF5
        suus4TIluKRztQbO3qtb0DR6U/J7lzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647785138;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ByYL7st7i4ImNUhuJQ2jk4++l7qEzQIQE23lXXSnEao=;
        b=5scTWGCm0y5swCV68VnOFJTeGSxFyBAwzSfAv9Zxvybm5VfgSRPnNk3h7OmSVS9DEzmCI0
        UE0cSu9t62DlacCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7E28913419;
        Sun, 20 Mar 2022 14:05:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zwTnErA0N2K1eAAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 20 Mar 2022 14:05:36 +0000
Message-ID: <cf5aa5fc-cf46-d979-f20e-50a323596610@suse.de>
Date:   Sun, 20 Mar 2022 22:05:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 2/4] mdadm: Update ReadMe
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
 <20220318082607.675665-3-lukasz.florczak@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220318082607.675665-3-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/18/22 4:26 PM, Lukasz Florczak wrote:
> Instead of hardcoded config file path give reference to config manual.
>
> Add missing monitordelay and homecluster parameters.
>
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>


Tested and verified on openSUSE,

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


> ---
>   ReadMe.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/ReadMe.c b/ReadMe.c
> index 81399765..8f873c48 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -613,7 +613,6 @@ char Help_incr[] =
>   ;
>   
>   char Help_config[] =
> -"The /etc/mdadm.conf config file:\n\n"
>   " The config file contains, apart from blank lines and comment lines that\n"
>   " start with a hash(#), array lines, device lines, and various\n"
>   " configuration lines.\n"
> @@ -636,10 +635,12 @@ char Help_config[] =
>   " than a device must match all of them to be considered.\n"
>   "\n"
>   " Other configuration lines include:\n"
> -"  mailaddr, mailfrom, program     used for --monitor mode\n"
> -"  create, auto                    used when creating device names in /dev\n"
> -"  homehost, policy, part-policy   used to guide policy in various\n"
> -"                                  situations\n"
> +"  mailaddr, mailfrom, program, monitordelay    used for --monitor mode\n"
> +"  create, auto                                 used when creating device names in /dev\n"
> +"  homehost, homecluster, policy, part-policy   used to guide policy in various\n"
> +"                                               situations\n"
> +"\n"
> +"For more details see mdadm.conf(5).\n"
>   "\n"
>   ;
>   


