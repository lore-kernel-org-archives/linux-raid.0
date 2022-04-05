Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 505BDC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 02:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiDECxD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiDECwR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 22:52:17 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B1A3A42A0
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 19:00:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649121165; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=bLhqDv/MSi7PHCvofSMz78FBGSCo+5EJKW7JjUVuhP1tfbjrHXjQWiDd0ywzA6ePo70k6VyZZsSq7qk630hMIWWQNOjvNvgBLE4nE/hTIwEFx4ODjjwBHK9eM/VmAJCdeNQZLYwdIj9EL51r1rsSGwog3PCUiF/htiD0pY3ZWis=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1649121165; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=mM8w9w9Dxri+5MXUZzcvEXPjZ0QvapiIYNbJUozyRBY=; 
        b=AhistGlQ6IQiWkOM04FA9YQGyh9euwd3obolqGnhFOajBonyx7jBnqIB80rzvCGVE0vyzev8D4pzxEd4b58Jo73xEubJbb5PCGkKdgZQSKm5D9ELEK6USQe/wMtKBPAATF4rYN7rIEo7GnN9Yt/fA6v7Wkon5UhwXD813SzON2s=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 164912116222581.94611409498987; Tue, 5 Apr 2022 03:12:42 +0200 (CEST)
Message-ID: <1b383112-0d59-657e-2e99-9da3a915d8ac@trained-monkey.org>
Date:   Mon, 4 Apr 2022 21:12:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 1/4] mdadm: Respect config file location in man
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de, pmenzel@molgen.mpg.de
References: <20220318082607.675665-1-lukasz.florczak@linux.intel.com>
 <20220318082607.675665-2-lukasz.florczak@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220318082607.675665-2-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/18/22 04:26, Lukasz Florczak wrote:
> Default config file location could differ depending on OS (e.g. Debian family).
> This patch takes default config file into consideration when creating mdadm.man
> file as well as mdadm.conf.man.
> 
> Rename mdadm.conf.5 to mdadm.conf.5.in. Now mdadm.conf.5 is generated automatically.
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> ---


Applied!

Thanks,
Jes


