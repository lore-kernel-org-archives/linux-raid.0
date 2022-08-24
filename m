Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D27C00140
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 16:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238692AbiHXQDZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 12:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237876AbiHXQDY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 12:03:24 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4C07CB7E
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 09:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661356995; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=VIXKx5yFtKNZmzrdXEZFouusK/wFhZiR2oWGv63N8Hh7hoVRLGy5gLKzeDlrpSIwM9MFHjhxHD07Ju48lHVkB9PFfBHRd1qm1aWer/UyXZ0RNfgaCu6GKb2XtEE8xsW3c4wDDgF3knFPWCJj1PH863qeLGuA8fmXzX/KgKXP1uM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661356995; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=vb4Q168j3tSGMtUrouPCnfqwgUMAI9MvgNotyoOPwH0=; 
        b=Gct2RoVTOXd9zMY5tZGXUw3wZl5pOmp9jZT8Hm6iw6H6GC/IKtX2NmUANNDTCL4FAzO1/1nkoqZKtSdPr8CQ2idC5XYD2BUJjJhyUIlDqJZ5I0yXOJ4M9+CUzoCN7e8F3rfcppRcTpNM5DW+unuCVW9Apkuh8C7p0kHE8B+qFTI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1661356992473438.3069321145706; Wed, 24 Aug 2022 18:03:12 +0200 (CEST)
Message-ID: <f16e1cc6-e373-13ef-1d3e-b3f3a00d0e80@trained-monkey.org>
Date:   Wed, 24 Aug 2022 12:03:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 2/2] mdadm: replace container level checking with
 inline
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220819005547.17343-1-kinga.tanska@intel.com>
 <20220819005547.17343-3-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220819005547.17343-3-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/18/22 20:55, Kinga Tanska wrote:
> To unify all containers checks in code, is_container() function is
> added and propagated.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  Assemble.c    |  5 ++---
>  Create.c      |  6 +++---
>  Grow.c        |  6 +++---
>  Incremental.c |  4 ++--
>  mdadm.h       | 14 ++++++++++++++
>  super-ddf.c   |  6 +++---
>  super-intel.c |  4 ++--
>  super0.c      |  2 +-
>  super1.c      |  2 +-
>  sysfs.c       |  2 +-
>  10 files changed, 32 insertions(+), 19 deletions(-)

This one fails to apply for me from patcheworks. That said, a minor nit
below.

Mind fixing this and posting an updated version?

Thanks,
Jes


> diff --git a/mdadm.h b/mdadm.h
> index c7268a71..72abfc50 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1885,3 +1885,17 @@ enum r0layout {
>   * This is true for native and DDF, IMSM allows 16.
>   */
>  #define MD_NAME_MAX 32
> +
> +/**
> + * is_container() - check if @level is &LEVEL_CONTAINER
> + * @level: level value
> + *
> + * return:
> + * 1 if level is equal to &LEVEL_CONTAINER, 0 otherwise.
> + */
> +static inline int is_container(const int level)
> +{
> +	if (level == LEVEL_CONTAINER)
> +		return 1;
> +	return 0;
> +}
> \ No newline at end of file

Please add the lost newline

