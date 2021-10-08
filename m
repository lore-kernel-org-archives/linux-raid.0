Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 323B9C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 16:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FAB760F4F
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 16:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhJHQHx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 12:07:53 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17220 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhJHQHw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 12:07:52 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633709152; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=hCexbnEoO70SyfCZGiKikDSHXNe1xWRzFP1G5+sJAkC1yhhsEecn+LfHRsvExmLTPDIJXpwIfcANKKg+Q+oUdNYSyYkXrlrhz69zB9xYuSt4siVAiKBlMCi8h7BH77CMgnBjogQTyq1n3Jnc04noJZYCXLIFZVxoVyBWL1PblUQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633709152; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=rqX9Kposk0XKqAJEKbqyjjcGHA2bRmAOQ8lZoR0Iw58=; 
        b=JsEUs3NIj/+bd38UsIFf0Cwsz5mcFgTkE7xUPlKmPJvwH2EwJWWQdVqeFp2u7GGui9/3PGDIR80E5dEm/VUMG5S6S2dhxxMKMvhyjYDCwXgsxXyRDu6jGaY4V4WOukyRo0oM/CNDeG0PGTS0cVVZzAeL/JzHyO62miWeATJPdeQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 1633708849442164.092579755398; Fri, 8 Oct 2021 18:00:49 +0200 (CEST)
Subject: Re: [PATCH] Fix 2 dc stream buffer
To:     Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org,
        xni@redhat.com
References: <20210811133928.1791065-1-ncroxon@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <d3151041-4a21-3998-d483-ba2d146782ca@trained-monkey.org>
Date:   Fri, 8 Oct 2021 12:00:48 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210811133928.1791065-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/11/21 9:39 AM, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerablility
> assessment. Static code analysis has been run and found the following
> Error: DC.STREAM_BUFFER (CWE-120): [#def46]
> mdadm-4.2: dont_call: "fscanf" assumes an arbitrarily
> long string, so callers must use correct precision specifiers or
> never use "fscanf".
> 
> The change is to define a value for string %s.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  Monitor.c | 2 +-
>  policy.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Monitor.c b/Monitor.c
> index f5412299..8bd3b5a1 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -359,7 +359,7 @@ static int check_one_sharer(int scan)
>  			 "/proc/%d/comm", pid);
>  		comm_fp = fopen(comm_path, "r");
>  		if (comm_fp) {
> -			if (fscanf(comm_fp, "%s", comm) &&
> +			if (fscanf(comm_fp, "%19s", comm) &&
>  			    strncmp(basename(comm), Name, strlen(Name)) == 0) {
>  				if (scan) {
>  					pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
> diff --git a/policy.c b/policy.c
> index 3c53bd35..e9760a65 100644
> --- a/policy.c
> +++ b/policy.c
> @@ -784,7 +784,7 @@ int policy_check_path(struct mdinfo *disk, struct map_ent *array)
>  		if (!f)
>  			continue;
>  
> -		rv = fscanf(f, " %s %x:%x:%x:%x\n",
> +		rv = fscanf(f, " %255s %x:%x:%x:%x\n",
>  			    array->metadata,
>  			    array->uuid,
>  			    array->uuid+1,
> 

1) array->metadata is 20 bytes long but you set a limit of 255 which
could easily overflow it.

2) You address policy_check_path() but don't fix policy_save_path()
right above it which has the same issue.

Please fix.

Jes
