Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD7FC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 17:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbiDFRRP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238379AbiDFRRC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 13:17:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60A24041C4
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 08:13:00 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 42F12210FC;
        Wed,  6 Apr 2022 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649257979; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++rDxnkcOF0H5KHPobpvaWoG0zGZ+mxgerl2rAF6Uro=;
        b=QynBGiwuKIwCVh2/6eXWzwNrawvx6c6Zf8Vl05LAgPaKwXS7ls8Or/9YMJ7p00aOZUsSLD
        cnB42VWesNjbM2JHofoC0Ajpw0v7Y1AXqFPEY41O8DELfHrlH7RDsgoTP5JyUJ9ryQti1a
        oQWUE1FyjdPPzcfnBRVPEMARkSr94m8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649257979;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++rDxnkcOF0H5KHPobpvaWoG0zGZ+mxgerl2rAF6Uro=;
        b=RXmvv/YMyGSq4cntmx3eq2KkhzpsWOM+6WemP4ihy2roF2gxzFk3VQTIzRIe+tgQXE1LRk
        rw30BbkEXA99SLAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5B97913A8E;
        Wed,  6 Apr 2022 15:12:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GSx5C/qtTWK7MgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 06 Apr 2022 15:12:58 +0000
Message-ID: <ef2c0d9a-df14-5066-2104-b352e57c6eea@suse.de>
Date:   Wed, 6 Apr 2022 23:12:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH] util: replace ioctl use with function
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220404124501.13218-1-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220404124501.13218-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/4/22 8:45 PM, Kinga Tanska wrote:
> Replace using of ioctl calling to get md array info with
> special function prepared to it.
>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


> ---
>   util.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/util.c b/util.c
> index cdf1da24..003b2f86 100644
> --- a/util.c
> +++ b/util.c
> @@ -268,7 +268,7 @@ int md_array_active(int fd)
>   		 * GET_ARRAY_INFO doesn't provide access to the proper state
>   		 * information, so fallback to a basic check for raid_disks != 0
>   		 */
> -		ret = ioctl(fd, GET_ARRAY_INFO, &array);
> +		ret = md_get_array_info(fd, &array);
>   	}
>   
>   	return !ret;


