Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADC5C77B61
	for <linux-raid@archiver.kernel.org>; Mon, 10 Apr 2023 15:52:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjDJPwB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Apr 2023 11:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDJPwB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Apr 2023 11:52:01 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0213A8F
        for <linux-raid@vger.kernel.org>; Mon, 10 Apr 2023 08:51:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681141914; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ifujJWBwRACPs2gmc67ZYljnhkSsGuZRrc5FAWLhQxolbRe0tMrVKoYqQwMR9fJaUbuv7Bzt4sxELwpaemRkHXrgC5PIC9r5WNA3cM1Jv4Ph924UN+02CZmIwK9xRqWtwQZFAVxTUDa5y+wR/jb0q+ecVXc2e3oUEgn/7VXoUyM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1681141914; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=a3fKYThJq7dNY7IfndGDT3+1LEuZ6ZFnwExc5UcQ1Es=; 
        b=ZvTzljF0CHNGsJizCKInJtqVFyYifydrqXYQn9/tuOd69R/beWAJpwUxiwx9vj4yfo1SRUSN47KUf3ZaNZdnmAeOgL54KaKNHv74Wpk2duZmXg6XztShtxUXHwiaJtJkqWXYSSrApyIePzmeyXShdZ8lQYkT2tz6u37TT8X1Gr0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1681141913028789.740777411683; Mon, 10 Apr 2023 17:51:53 +0200 (CEST)
Message-ID: <29c8870e-1d12-7664-691f-0a0f2fa0a6cb@trained-monkey.org>
Date:   Mon, 10 Apr 2023 11:51:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/1] Remove the config files in mdcheck_start|continue
 service
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     neilb@suse.de, linux-raid@vger.kernel.org
References: <20230407004528.59539-1-xni@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230407004528.59539-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/6/23 20:45, Xiao Ni wrote:
> We set MDADM_CHECK_DURATION in the mdcheck_start|continue.service files.
> And mdcheck doesn't use any configs from the config file. So we can remove
> the dependencies.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  systemd/mdcheck_continue.service | 2 --
>  systemd/mdcheck_start.service    | 2 --
>  2 files changed, 4 deletions(-)

Applied!

Thanks,
Jes


