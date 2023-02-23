Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FADFC636D6
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 15:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234792AbjBWP4b (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 10:56:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbjBWP43 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 10:56:29 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6756657092
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 07:56:28 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id ED3055C733;
        Thu, 23 Feb 2023 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677167786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OaHSz/5sKha8jBEp/4HUIOg3QmaRPVbuGXYpslm9JNU=;
        b=YbiEshsZHo6q39Ca3LayZq2iCEKEaVIxJrjzV4pLZUp2olAucWlgirtXAqBSHO4REiP3dQ
        eCCSsRGQL+6/8xFVFeFwDxkKKqdlAulxEHuEYglP9CJTGQDfqMGaBwO755mugifRoSkhKO
        00/7N/ZKm6OqaoSc0WcKn9V9+uvlWas=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677167786;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OaHSz/5sKha8jBEp/4HUIOg3QmaRPVbuGXYpslm9JNU=;
        b=BBbIrJmxTQ+u9xCct3i85iZqvcWbhSMW1LVnMmyusor0dEKulG3jATH/VgJjnMFzP+yFXq
        hOUo06DFta8ndvAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A5CC5139B5;
        Thu, 23 Feb 2023 15:56:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aX5nHKmM92P7TgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 23 Feb 2023 15:56:25 +0000
Date:   Thu, 23 Feb 2023 23:56:20 +0800
From:   Coly Li <colyli@suse.de>
To:     Heming Zhao <heming.zhao@suse.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        ncroxon@redhat.com
Subject: Re: [PATCH] Grow: fix can't change bitmap type from none to
 clustered.
Message-ID: <Y/eMpNTizBLDt2m3@enigma.lan>
References: <20230223143939.3817-1-heming.zhao@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230223143939.3817-1-heming.zhao@suse.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 23, 2023 at 10:39:39PM +0800, Heming Zhao wrote:
> Commit a042210648ed ("disallow create or grow clustered bitmap with
> writemostly set") introduced this bug. We should use 'true' logic not
> '== 0' to deny setting up clustered array under WRITEMOSTLY condition.
> 
> How to trigger
> 
> ```
> ~/mdadm # ./mdadm -Ss && ./mdadm --zero-superblock /dev/sd{a,b}
> ~/mdadm # ./mdadm -C /dev/md0 -l mirror -b clustered -e 1.2 -n 2 \
> /dev/sda /dev/sdb --assume-clean
> mdadm: array /dev/md0 started.
> ~/mdadm # ./mdadm --grow /dev/md0 --bitmap=none
> ~/mdadm # ./mdadm --grow /dev/md0 --bitmap=clustered
> mdadm: /dev/md0 disks marked write-mostly are not supported with clustered bitmap
> ```
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
>  Grow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 8f5cf07d10d9..bb5fe45c851c 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -429,7 +429,7 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
>  			dv = map_dev(disk.major, disk.minor, 1);
>  			if (!dv)
>  				continue;
> -			if (((disk.state & (1 << MD_DISK_WRITEMOSTLY)) == 0) &&
> +			if ((disk.state & (1 << MD_DISK_WRITEMOSTLY)) &&
>  			   (strcmp(s->bitmap_file, "clustered") == 0)) {
>  				pr_err("%s disks marked write-mostly are not supported with clustered bitmap\n",devname);
>  				free(mdi);

-- 
Coly Li
