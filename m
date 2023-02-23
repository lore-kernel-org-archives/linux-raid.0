Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB58C61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 15:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbjBWPxr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 10:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbjBWPxq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 10:53:46 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2327013DF0
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 07:53:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C4B1834163;
        Thu, 23 Feb 2023 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677167623; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cvXDXas76johV7ifuyoO1zJ8ueJuv+YC8PcQJaYVCNU=;
        b=Bd/amc0PtZz9+cNUehmzfE2JxKN+F55IPW6wfS0M3X6PVbJL3dpLuL44b5xPZQduIHdF9w
        FbeUAvJjyqK49W59d0UE8hknW4F+6f11QacbDqHAMGe7w4i5qmqIBsrP/cXGsfjzsMvcZ8
        Vj/oUy6+afJDxABaHJoM5KhTRlcZ52Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677167623;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cvXDXas76johV7ifuyoO1zJ8ueJuv+YC8PcQJaYVCNU=;
        b=5IZlGFSJHqoBp86nYa54lrdxC5O6LKJHAFhUsigpzJEch90pzTCXEZrBsYijTWeZLj4//4
        MTnh/+ivIN3s0+CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A53F139B5;
        Thu, 23 Feb 2023 15:53:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mJf7EQWM92NoTQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 23 Feb 2023 15:53:41 +0000
Date:   Thu, 23 Feb 2023 23:53:34 +0800
From:   Coly Li <colyli@suse.de>
To:     miaoguanqin <miaoguanqin@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        linux-raid@vger.kernel.org, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>, lixiaokeng@huawei.com
Subject: Re: [PATCH] Fix memory leak for function Manage_subdevs Manage_add
 Kill V2
Message-ID: <Y/eL/u9tvAXVDrfV@enigma.lan>
References: <5ab784a2-df14-62d7-873a-622b34b6a646@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5ab784a2-df14-62d7-873a-622b34b6a646@huawei.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Feb 22, 2023 at 04:30:53PM +0800, miaoguanqin wrote:
> When we test mdadm with asan,we found some memory leaks.
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
> ---
>  Assemble.c | 16 +++++++++++++---
>  Kill.c     | 10 +++++++++-
>  Manage.c   | 16 +++++++++++++++-
>  mdadm.c    |  6 ++++++
>  4 files changed, 43 insertions(+), 5 deletions(-)
>

[snipped]
 
> diff --git a/Kill.c b/Kill.c
> index d4767e2..073288e 100644
> --- a/Kill.c
> +++ b/Kill.c

[snipped]

> @@ -77,6 +80,11 @@ int Kill(char *dev, struct supertype *st, int force, int
> verbose, int noexcl)
>  			rv = 0;
>  		}
>  	}
> +	if (flags == 1 && st) {
> +		if (st->sb)
> +			free(st->sb);

May I ask why not call st->ss->free_super(st) ?


> +		free(st);
> +	}
>  	close(fd);
>  	return rv;
>  }

[snipped]

> diff --git a/mdadm.c b/mdadm.c
> index da66c76..981fa98 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1765,6 +1765,12 @@ int main(int argc, char *argv[])
>  		autodetect();
>  		break;
>  	}
> +	if (ss) {
> +		if (ss->sb)
> +			free(ss->sb);

Same question, why not call ss->ss->free_super(ss) ?

> +		free(ss);
> +	
> +	}
>  	if (locked)
>  		cluster_release_dlmlock();
>  	if (mdfd > 0)


Overall the patch is fine to me. But it might be better to split it into
multiple patches that each has the changes for a single file.

Thanks.

-- 
Coly Li
