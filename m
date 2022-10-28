Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCECFA3742
	for <linux-raid@archiver.kernel.org>; Fri, 28 Oct 2022 15:46:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJ1PqM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJ1PqL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Oct 2022 11:46:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10651D2F7D
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 08:46:10 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6326B21D52;
        Fri, 28 Oct 2022 15:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666971969; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/qnaexsbR7go+PdBn5rXOmog3XvMZXAktwTi8DeUbb8=;
        b=Ap8hEf1WKChf5BGzzuof+L8H6a85fvRTnAhZbfcBtGsIL5v0VpTK/o9ux8CgXXNRZ5k4/l
        AH5UwzIk47kBBANvN3BHypcmpNNy5Dri+RVkcu337aNXTDAXq72TRW865qCneX+UC/q0eO
        cN09OmS516KF4q+NVezT2ShEPTxl144=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666971969;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/qnaexsbR7go+PdBn5rXOmog3XvMZXAktwTi8DeUbb8=;
        b=PovXQfqIADnv36tosRAgjfsSKrok+TL6m/2NKnAcFssSDR+0UfXOK3fd4J2oY9SVOuKful
        5xhATcqC/hfJbEBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7B56A13A6E;
        Fri, 28 Oct 2022 15:46:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WXlWEUD5W2NMVQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 28 Oct 2022 15:46:08 +0000
Message-ID: <22a949b5-b2be-5749-4ab8-9d0916fc702a@suse.de>
Date:   Fri, 28 Oct 2022 23:46:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH 5/9] Add helpers to determine whether directories or files
 are soft links
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
 <20220907125657.12192-6-mateusz.grzonka@intel.com>
Content-Language: en-US
In-Reply-To: <20220907125657.12192-6-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/22 8:56 PM, Mateusz Grzonka wrote:
> Signed-off-by: Mateusz Grzonka<mateusz.grzonka@intel.com>

Except for the comment style, the rested part is good to me.


Acked-by: Coly Li <colyli@suse.de>

Thanks.


Coly Li



> ---
>   mdadm.h |  3 +++
>   util.c  | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 49 insertions(+)
>
> diff --git a/mdadm.h b/mdadm.h
> index 09915a00..9183ee70 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1707,6 +1707,9 @@ extern int cluster_get_dlmlock(void);
>   extern int cluster_release_dlmlock(void);
>   extern void set_dlm_hooks(void);
>   
> +extern bool is_directory(const char *path);
> +extern bool is_file(const char *path);
> +
>   #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
>   #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
>   #define ROUND_UP_PTR(ptr, base)	((typeof(ptr)) \
> diff --git a/util.c b/util.c
> index cc94f96e..97926f19 100644
> --- a/util.c
> +++ b/util.c
> @@ -2375,3 +2375,49 @@ out:
>   	close(fd_zero);
>   	return ret;
>   }
> +
> +/**
> + * is_directory() - Checks if directory provided by path is indeed a regular directory.
> + * @path: directory path to be checked
> + *
> + * Doesn't accept symlinks.
> + *
> + * Return: true if is a directory, false if not
> + */
> +bool is_directory(const char *path)
> +{
> +	struct stat st;
> +
> +	if (lstat(path, &st) != 0) {
> +		pr_err("%s: %s\n", strerror(errno), path);
> +		return false;
> +	}
> +
> +	if (!S_ISDIR(st.st_mode))
> +		return false;
> +
> +	return true;
> +}
> +
> +/**
> + * is_file() - Checks if file provided by path is indeed a regular file.
> + * @path: file path to be checked
> + *
> + * Doesn't accept symlinks.
> + *
> + * Return: true if is  a file, false if not
> + */
> +bool is_file(const char *path)
> +{
> +	struct stat st;
> +
> +	if (lstat(path, &st) != 0) {
> +		pr_err("%s: %s\n", strerror(errno), path);
> +		return false;
> +	}
> +
> +	if (!S_ISREG(st.st_mode))
> +		return false;
> +
> +	return true;
> +}


