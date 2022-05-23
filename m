Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FFE8C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 23 May 2022 15:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbiEWPnM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 23 May 2022 11:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238094AbiEWPnL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 23 May 2022 11:43:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DFA205F2
        for <linux-raid@vger.kernel.org>; Mon, 23 May 2022 08:43:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C5B5D1F8D6;
        Mon, 23 May 2022 15:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653320588; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=blSK0wmB7ThD2UxIFkBPnjy4k93PMQtDGcmqVbjbyGg=;
        b=lYoXtrgpLoxilf3v7FKtw5wRa5uW2J3O+3bebLlWhCTQx/SvT0jdbYPMDe3OzaSH1aZZD/
        dpDUfnmVscrBzBCNJd8y7SJsbVgiGbX7SwV6GkDRCIFfQ5u8p7wtlgDxyc9FM/A/z7RFmi
        Z138kMPPLuBp0n422Jjp9Qpg8P9TPgg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653320588;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=blSK0wmB7ThD2UxIFkBPnjy4k93PMQtDGcmqVbjbyGg=;
        b=TlsXTH29oZjWZ8lCMBLSRxeeACesB5gnuHY9nYvoOMcu1E9481BVblJs6oTbr8dki0d28k
        0uQO2yWT0lio3sDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C064139F5;
        Mon, 23 May 2022 15:43:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7kuPDouri2LhHQAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 23 May 2022 15:43:07 +0000
Message-ID: <be4e3857-5577-b896-aec2-48fe6a915d81@suse.de>
Date:   Mon, 23 May 2022 23:43:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] Revert "mdadm: fix coredump of mdadm --monitor -r"
Content-Language: en-US
To:     Nigel Croxon <ncroxon@redhat.com>
References: <20220418174423.846026-1-ncroxon@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org,
        wuguanghao3@huawei.com, mariusz.tkaczyk@linux.intel.com
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220418174423.846026-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/19/22 1:44 AM, Nigel Croxon wrote:
> This reverts commit 546047688e1c64638f462147c755b58119cabdc8.
>
> The change from commit mdadm: fix coredump of mdadm
> --monitor -r broke the printing of the return message when
> passing -r to mdadm --manage, the removal of a device from
> an array.
>
> If the current code reverts this commit, both issues are
> still fixed.
>
> The original problem reported that the fix tried to address
> was:  The --monitor -r option requires a parameter,
> otherwise a null pointer will be manipulated when
> converting to integer data, and a core dump will appear.
>
> The original problem was really fixed with:
> 60815698c0a Refactor parse_num and use it to parse optarg.
> Which added a check for NULL in 'optarg' before moving it
> to the 'increments' variable.
>
> New issue: When trying to remove a device using the short
> argument -r, instead of the long argument --remove, the
> output is empty. The problem started when commit
> 546047688e1c was added.
>
> Steps to Reproduce:
> 1. create/assemble /dev/md0 device
> 2. mdadm --manage /dev/md0 -r /dev/vdxx
>
> Actual results:
> Nothing, empty output, nothing happens, the device is still
> connected to the array.
>
> The output should have stated "mdadm: hot remove failed
> for /dev/vdxx: Device or resource busy", if the device was
> still active. Or it should remove the device and print
> a message:
>
> mdadm: set /dev/vdd faulty in /dev/md0
> mdadm: hot removed /dev/vdd from /dev/md0
>
> The following commit should be reverted as it breaks
> mdadm --manage -r.
>
> commit 546047688e1c64638f462147c755b58119cabdc8
> Author: Wu Guanghao <wuguanghao3@huawei.com>
> Date:   Mon Aug 16 15:24:51 2021 +0800
> mdadm: fix coredump of mdadm --monitor -r
>
> -Nigel

Maybe it could be better to remove the above signature?


>
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


> ---
>   ReadMe.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/ReadMe.c b/ReadMe.c
> index 8f873c48..bec1be9a 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
>    *     found, it is started.
>    */
>   
> -char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
> +char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>   char short_bitmap_options[]=
> -		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
> +		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
>   char short_bitmap_auto_options[]=
> -		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
> +		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
>   
>   struct option long_options[] = {
>       {"manage",    0, 0, ManageOpt},


