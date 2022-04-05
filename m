Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6981CC433EF
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 02:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiDECh2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiDEChU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 22:37:20 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C996D1F1D0F
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 18:34:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649121344; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=jUjX7/GyunFfGGBSTl0kcby53cK+GKW3VdWqHWSF0sZFrdMXrA2zofAjN4Z6dJ7PZnUjDRCKxdFgx5KOhMg/VTi54iGEv+5fFWpWytS4RA7Jkgj0yKulxTLpelpUhpUYzvoUlkZGt9/snrRcCP2u0bqHsALzyfEzZ7Y/RmbJlyo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1649121344; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gxVn/VjwOlKkZWVwAL7Jr2wVRXeEJPfiteDUifIMku8=; 
        b=Co0+hjxdZYFAyNQNzzLsOgAb5lGhcujw6RAXpST4MYCstbrbvtGHbNoIHjOZiz8xQBRzGaSxiNBOTMv1qI0MR7Zb0scw1CdtkS6e2/VxOP9CMBJ7lZhPhpk8poRYQoaQ8BX/uECHH2difSA9d3X3SbMZOfA38HFUrbE/p4qn9J0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 16491213434931.9644866655601163; Tue, 5 Apr 2022 03:15:43 +0200 (CEST)
Message-ID: <0d697c85-eec0-33be-b69a-7811c0049172@trained-monkey.org>
Date:   Mon, 4 Apr 2022 21:15:42 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 3/4] mdadm: Update config man regarding default files and
 multi-keyword behavior
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de, pmenzel@molgen.mpg.de
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
 <20220318082607.675665-4-lukasz.florczak@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220318082607.675665-4-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/18/22 04:26, Lukasz Florczak wrote:
> Simplify default and alternative config file and directory location references
> from mdadm(8) as references to mdadm.conf(5). Add FILE section in config man
> and explain order and conditions in which default and alternative config files
> and directories are used.
> 
> Update config man behavior regarding parsing order when multiple keywords/config
> files are involved.
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> ---
>  mdadm.8.in      | 30 +++++++++--------------
>  mdadm.conf.5.in | 65 ++++++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 71 insertions(+), 24 deletions(-)


Applied!

Thanks,
Jes


