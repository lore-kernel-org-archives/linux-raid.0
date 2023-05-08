Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F47C77B75
	for <linux-raid@archiver.kernel.org>; Mon,  8 May 2023 20:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjEHU0l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 May 2023 16:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbjEHU0i (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 May 2023 16:26:38 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D416F3C1B
        for <linux-raid@vger.kernel.org>; Mon,  8 May 2023 13:26:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1683577582; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=geR9hJXccASSwYXcNhNXHIkVXAkvpYUloDeBbbfF9g+HsdWQ/zZ6CnwpIuWoo5HjxUsrHPW+tXoQovvehsbwZ17Wh6eU5Me4VPxF0R7aqPbAjHDOnsFIEs5UkKPMOqf0HEGfZKhtRtg9S4UNdfVUUqLa5BJoxk9y/+6OiKpURFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1683577582; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Fqd9S13qXcYJc62k9w+8TNUmTFGPqcOOboW/m3XreFI=; 
        b=OMossm2HebXRyDgrO/IQpc0+75LLd7tctDwhplpJslJe3AJ2DBVQf4ZwyJeHEDV0nP3feAb7h+WXzSaqmAe9B2RnT1Fvb4mob7N6xAKJRfWKZKpz0y2cboXJwhyltYCjyQ3V+8ohMW8BEAwdEN7yB3GB4CPL+r1V7Pfs/f51YWs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1683577581548576.6076276337466; Mon, 8 May 2023 22:26:21 +0200 (CEST)
Message-ID: <d3fbd210-21e7-8728-c5e8-1873d4ea4dcc@trained-monkey.org>
Date:   Mon, 8 May 2023 16:26:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/4] Few config related refactors
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, colyli@suse.de, xni@redhat.com
References: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230323165017.27121-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/23/23 12:50, Mariusz Tkaczyk wrote:
> Hi Jes,
> These patches remove multiple inlines across code and replace them
> by defines or functions. No functional changes intended. The goal
> is to make this some code reusable for both config and cmdline
> (mdadm.c). I next patchset I will start optimizing names verification
> (extended v2 of previous patchset).

Applied!

I'll push the later, I left my key at home.

Thanks,
Jes


