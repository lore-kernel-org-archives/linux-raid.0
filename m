Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED47C433DB
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 05:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B482C2313C
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 05:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbhATFsS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jan 2021 00:48:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbhATFsO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 20 Jan 2021 00:48:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 501AA2313A;
        Wed, 20 Jan 2021 05:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611121653;
        bh=IobmIF4V2nxEfrXkalV9cWslFV/qB8V7oNP+bsltypA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kbqntAQAC21/htIwAxqeJv2wJZuzJT+EJ01v/HQYykeEDBiwMzOF8Wa+QlL9xykl+
         5TAdz198u/ZcgTfrh1pn+vAO+M5tBD+PSSkoOg3mgMktGj44d7XFZKamL28yur496S
         o+IQMTZhNpv+iIwWCZRR+wgRiwW4X6gajZz2BGJklw3pp87xk5/YyqDRXua4YzPkyi
         wN8VtsCj7Zz/Oj+GlQ0eWnZdFTmrhbaiz4yqPLPZsl0yAjvo4hMn7OdDpPE+rQhsfp
         TYj2kSf2AzCFe4gThMzdbNC2kxs0mveX/AnTZU5c/potei6ImRfdNIlFeTWgV3wTbs
         poveg7JgB7t+A==
Date:   Tue, 19 Jan 2021 21:47:31 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anthony Iliopoulos <ailiop@suse.com>, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] [PATCH AUTOSEL 5.4 03/26] dm integrity: select
 CRYPTO_SKCIPHER
Message-ID: <YAfD81Jw/0NU0eWN@sol.localdomain>
References: <20210120012704.770095-1-sashal@kernel.org>
 <20210120012704.770095-3-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210120012704.770095-3-sashal@kernel.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jan 19, 2021 at 08:26:40PM -0500, Sasha Levin wrote:
> From: Anthony Iliopoulos <ailiop@suse.com>
> 
> [ Upstream commit f7b347acb5f6c29d9229bb64893d8b6a2c7949fb ]
> 
> The integrity target relies on skcipher for encryption/decryption, but
> certain kernel configurations may not enable CRYPTO_SKCIPHER, leading to
> compilation errors due to unresolved symbols. Explicitly select
> CRYPTO_SKCIPHER for DM_INTEGRITY, since it is unconditionally dependent
> on it.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/md/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index aa98953f4462e..7dd6e98257c72 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -565,6 +565,7 @@ config DM_INTEGRITY
>  	select BLK_DEV_INTEGRITY
>  	select DM_BUFIO
>  	select CRYPTO
> +	select CRYPTO_SKCIPHER
>  	select ASYNC_XOR
>  	---help---
>  	  This device-mapper target emulates a block device that has

CRYPTO_SKCIPHER doesn't exist in 5.4 and earlier because it was renamed from
CRYPTO_BLKCIPHER in 5.5.  If this patch is really important enough to backport,
CRYPTO_SKCIPHER will need to be changed to CRYPTO_BLKCIPHER.

- Eric
