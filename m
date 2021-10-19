Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74894C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 587AD60F56
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:51:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbhJSGxM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Oct 2021 02:53:12 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17286 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhJSGxL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Oct 2021 02:53:11 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1634626257; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=XIAUf74p9ulBnj15S08GzPwqN1eHAnUWGFFbokLVtICC81sVw5O2ncRlIY3Z7IAQg1Pw7bPy4SG16HGP9cGAoasn/S2hfiiAyOVn49MQb6WNg6JcyktCyCcFXckHhXkDKovQ2AHgSdDVbpF/dAlnqcFYGPMEUMlaCrWuz2Eh1Ow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1634626257; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3YMmtLgpUWcKfLBijEneJoyAIN6vQplic0M9f1RPxmo=; 
        b=H7EDbawgZS5Gyaa65nVycCY7F8/wxsrIKU0U2E7O/X5X2WJZ+HqHxvJjeAF6o/cbExXor0FcqXkbF8o3qlX1DLHZtbPX5FLSINCWw0WO7713WIDJoscy2lV66U2VoJ5FZVJcH+lKSmxvVHr/0MxYvQ2CTy0wuF9pdeRU3EvGQXk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.109.156.142] (163.114.130.5 [163.114.130.5]) by mx.zoho.eu
        with SMTPS id 1634626255096488.4550783448392; Tue, 19 Oct 2021 08:50:55 +0200 (CEST)
Subject: Re: [PATCH] Assemble: apply sysfs rules
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
References: <20211012101616.14794-1-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <802605a2-a672-7fee-5e6e-0d591457f254@trained-monkey.org>
Date:   Tue, 19 Oct 2021 02:50:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211012101616.14794-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/12/21 6:16 AM, Kinga Tanska wrote:
> During assemblation container with quiet flag, sysfs rules are not applied.
> This commit makes sysfs_rules_apply() independent from verbose condition.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  Assemble.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Applied!

Thanks,
Jes

