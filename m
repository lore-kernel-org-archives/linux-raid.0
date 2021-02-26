Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C96AC433E0
	for <linux-raid@archiver.kernel.org>; Fri, 26 Feb 2021 22:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EDDE64EC4
	for <linux-raid@archiver.kernel.org>; Fri, 26 Feb 2021 22:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBZWV5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 Feb 2021 17:21:57 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17252 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhBZWVs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 Feb 2021 17:21:48 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614378060; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=KqsYWZNatlOUMG66tSaCGrVLNImjClh6KYNBFRuOXYU/QL+bgTSPUvDIb659bypVdZl5u9gzVjH9hGM8XAR7DQfbOpD7teI/UqZJ0jF9C4++UC0/oMW8u12sgp3IP5004ABgr8xWgtIoxXJO3MnPYvOsaGwNa0NPzk971SAwLRU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1614378060; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=LinEOCQp23kjuGVOxh1KlkmSSGYXm78vh4q6eYE0IZA=; 
        b=lXeAT0O4Spjm8baxeTHjBOFimqRShsrwg6R6CSA8YQ9GeM1pWOvPwRj4WIn+4WfSFHe58JNQQrzeH6gG4nHJd6q2jxmX3j+vU6Bu7FfAkfzz7Suz3M6Muv+A4WSwVQE0ReOt7joMf1yztLhFPyaKxka8Qd6ebUNoHI3Wlr1qMTI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1614378058339396.1163673796394; Fri, 26 Feb 2021 23:20:58 +0100 (CET)
Subject: Re: [PATCH mdadm] Grow: be careful of corrupt dev_roles list
To:     NeilBrown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org
References: <87pn0niqtv.fsf@notabene.neil.brown.name>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <efcd7aba-0d7b-7707-00fb-682b31a10ad4@trained-monkey.org>
Date:   Fri, 26 Feb 2021 17:20:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <87pn0niqtv.fsf@notabene.neil.brown.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/25/21 8:02 PM, NeilBrown wrote:
> 
> I've seen a case where the dev_roles list of a linear array
> was corrupt.  ->max_dev was > 128 and > raid_disks, and the
> extra slots were '0', not 0xFFFE or 0xFFFF.
> 
> This caused problems when a 128th device was added.
> 
> So:
>  1/ make Grow_Add_device more robust so that if numbers
>    look wrong, it fails-safe.
> 
>  2/ make examine_super1() report details if the dev_roles
>    array is corrupt.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  Grow.c   | 15 ++++++++++++---
>  super1.c | 48 ++++++++++++++++++++++++++++++++++++++----------
>  2 files changed, 50 insertions(+), 13 deletions(-)
> 

Ohhh error handling!

Applied!

Thanks,
Jes


