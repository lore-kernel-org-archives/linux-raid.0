Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A9DC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  5 Apr 2022 02:34:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiDECgR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 22:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiDECgQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 22:36:16 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D898434DDE3
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 18:32:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1649122331; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=i6p7UBGEZ919w7Rs8N9NSmcY9B5wT+EH/6fBGxVAuUCzMxDTnGEqkzzj3y5857c5AM0QjvRehBOvH24m6NaCMmcOK7tmiOaZIZlq7dIxVpOInhQhx+LVZ6AOo2GYeYHIrdvD1odUgEsE831A+pLlA6pQXJrFa8y0I3B6uPumszs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1649122331; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=WZnlvyRhPl0m0Urz8Hvt7qwZcPd318GmItqmrMx0spU=; 
        b=iwd+psw1snk46kQ18IIHQlDQXkWR5wpwTutoqQ+1+9gxaKbet5SgE3ClwPJOJJ1khKvpYycop4s1JrCLWjZ1RCcjZ3BzvZAGCGT3UrrTkdK/1V1QWa/5iwCGV6n1+w6PKoq//dDXMhs4/M5GGvwN0SpKTFjvCuBtenc9g+VrqdE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1649122330177340.88630577511435; Tue, 5 Apr 2022 03:32:10 +0200 (CEST)
Message-ID: <968c2d7f-5115-486d-063a-f384aba2baae@trained-monkey.org>
Date:   Mon, 4 Apr 2022 21:32:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 2/2] mdadm: add map_num_s()
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20220120121833.16055-1-mariusz.tkaczyk@linux.intel.com>
 <20220120121833.16055-3-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220120121833.16055-3-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/20/22 07:18, Mariusz Tkaczyk wrote:
> map_num() returns NULL if key is not defined. This patch adds
> alternative, non NULL version for cases where NULL is not expected.
> 
> There are many printf() calls where map_num() is called on variable
> without NULL verification. It works, even if NULL is passed because
> gcc is able to ignore NULL argument quietly but the behavior is
> undefined. For safety reasons such usages will use map_num_s() now.
> It is a potential point of regression.

Hi Mariusz,

I'll be honest with you, I don't like assert(), I consider it a lame
excuse for proper error handling. That said, not blaming you as this is
old code and it would take a lot of cleaning up, so this is better than
nothing.

I have applied it with one minor change:

> diff --git a/mdadm.h b/mdadm.h
> index 6aff034..9e9c4d8 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -769,7 +769,7 @@ extern int restore_stripes(int *dest, unsigned long long *offsets,
>  #endif
>  
>  #define SYSLOG_FACILITY LOG_DAEMON
> -
> +char *map_num_s(mapping_t *map, int num);
>  extern char *map_num(mapping_t *map, int num);
>  extern int map_name(mapping_t *map, char *name);
>  extern mapping_t r0layout[], r5layout[], r6layout[],

I changed this to be extern to be consistent with the other declarations.

Thanks,
Jes

