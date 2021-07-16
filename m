Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1465CC07E95
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFCF960FE7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jul 2021 14:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbhGPOae (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jul 2021 10:30:34 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17032 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbhGPOad (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jul 2021 10:30:33 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jul 2021 10:30:33 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1626445654; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=RwxP5/Et2g00PF+zOSqrmIONej+z3a9cPffm61vJquJEiYjubp7HB/cvcbp9rQFrU5YJaHQyILZgl1OWbD8PsnQKvFwfnpiElPbuMrZEIgfyC10FefbJxMEeLrEtHnCv8ZjmIclCOd9JsZDdg/SGo+JIT+G0/XDjbk7lOAS/FZE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1626445654; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+PQZiKId0gBKckb5Coo5SGuKtC8jIT/ZDoWlGUAjhG8=; 
        b=BmzK5i1D/qEiJ7JxRYLXUwZY05IcS/sY+D5r0hQnkrLu2DAZUmLdzLLgbZjDSrrkkMz4QClUuEg+TCfKz4FFvol0bam12dotkrJSmmnVuRVthCghMMm+KpP/VLLli3+ZG/na3ja1ZxilrFDCul5It7TKTlOTouRO5Uec4rsQ0VE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1626445652434927.6520394802445; Fri, 16 Jul 2021 16:27:32 +0200 (CEST)
Subject: Re: [PATCH 1/1] mdadm: Fix building errors
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com
References: <1624374955-13214-1-git-send-email-xni@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <40cd6ad1-3b2b-970a-96dc-362364f8c06c@trained-monkey.org>
Date:   Fri, 16 Jul 2021 10:27:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1624374955-13214-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/22/21 11:15 AM, Xiao Ni wrote:
> In util.c, there is a building error:
> '/md/metadata_version' directive writing 20 bytes into a
> region of size between 0 and 255 [-Werror=format-overflow=]
> 
> In mapfile.c
> It declares the fouth argument as 'int *' in map_update,
> but in mdadm.h it's previously declared as an array 'int[4]'
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  mapfile.c | 2 +-
>  util.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes

