Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1116EC433F5
	for <linux-raid@archiver.kernel.org>; Sun,  5 Dec 2021 13:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhLENmg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 5 Dec 2021 08:42:36 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:60938 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbhLENmf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 5 Dec 2021 08:42:35 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 200311FD54;
        Sun,  5 Dec 2021 13:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638711547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igoWGYN7LadR21E4cH7AvXPniay6jCBgM+SCI8oXuaE=;
        b=Xf3o8r3kom3KaZmJ7TvO5VJDis2v2HTDwP1eqaHE1DTZX+VRKlJlR1lPLv7BdZiKXXievn
        WJvnAjavAAwuhdcicc2ZRNQcxRHePDU3LBdwfOqVeEXUbTYgo1x/xCGFGh2LutVfI940Zl
        HDdR3FPJd0eufh3tR/nrhHzqPwzRmwM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638711547;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=igoWGYN7LadR21E4cH7AvXPniay6jCBgM+SCI8oXuaE=;
        b=55ucHZHtOOLvyYjiEzthG9ctZJUqFZT7HtSLCarHmHYD069RbXMlV95LMddi1ToTVvixwv
        1vp8Z04HtIZXjNCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 075FF13466;
        Sun,  5 Dec 2021 13:39:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lUJCJfjArGHIegAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 05 Dec 2021 13:39:04 +0000
Message-ID: <c9e5b8af-1a1d-82c0-1ca0-af4bd1182d75@suse.de>
Date:   Sun, 5 Dec 2021 21:39:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH v3] Monitor: print message before quit for no array to
 monitor
Content-Language: en-US
To:     jes@trained-monkey.org
Cc:     George Gkioulis <ggkioulis@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <20210902073220.19177-1-colyli@suse.de>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20210902073220.19177-1-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi  Jes,

Could you take this one for 4.2? It is posted for a while, which fixes a 
bug report of mine.

Thanks.

Coly Li

On 9/2/21 3:32 PM, Coly Li wrote:
> If there is no array device to monitor, Monitor() will stop monitoring
> at line 261 from the following code block,
>   257                 if (!new_found) {
>   258                         if (oneshot)
>   259                                 break;
>   260                         else if (!anyredundant) {
>   261                                 break;
>   262                         }
>
> This change was introduced by commit 007087d0898a ("Monitor: stop
> notifing about containers"). Before this commit, Monitor() will continue
> and won't quit even there is no array to monitor.
>
> It is fine to quit without any array device to monitor, but users may
> wonder whether there is something wrong with mdadm program or their
> configuration to make mdadm quit monitoring.
>
> This patch adds a simple error message to indicate Monitor() quits for
> array device to monitor, which makes users have hint to understand why
> mdadm stops monitoring.
>
> Reported-by: George Gkioulis <ggkioulis@suse.com>
> Suggested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Jes Sorensen <jsorensen@fb.com>
> ---
> Changelog:
> v3: modify printed message by suggestion from Mariusz.
> v2: add CC to Jes, and fix typo.
> v1: the original version.
>
>   Monitor.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/Monitor.c b/Monitor.c
> index f541229..839ec78 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -258,6 +258,7 @@ int Monitor(struct mddev_dev *devlist,
>   			if (oneshot)
>   				break;
>   			else if (!anyredundant) {
> +				pr_err("No array with redundancy detected, stopping\n");
>   				break;
>   			}
>   			else {

