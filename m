Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC3DC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 202006108E
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 06:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbhJSHA1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Oct 2021 03:00:27 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17243 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhJSHA1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Oct 2021 03:00:27 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1634626690; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=SAfvBfAD4ajayPKM1pKlT4WOilGcl2xl1YkEahk2kP/Ag/0+b4kTq5DJ3x+a2h1qu0fj7Us9z5dwBvrf+Ne5+KHCkLtXPggb2ZG5uq2xjeOq1q556PTxDN+LkcLuNxB8yjIEiAdm3Zaop71+o3oBWZsr3tQmZ9MAK5Tuj34Kz3w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1634626690; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=w4pxqClwCZUz40Q+KCFeFZEz6+bVXtav6VXqjLKsnqg=; 
        b=fiVuX4/9FH9kM4L2cw3C82zSGSv+YG6Hy4Brl/hfAaaI3YquyWIhVsnaYG0jZMZ86eyxslfBUPnOhR/XqQ96AW+2dTWqZw5U/+SR1kosvlTB9SlFA4Fx/gsUA6Xiovt0byc8Mpnw70WRgG5a0UACkl4l/VT4FuKl2lsjuPwYI5A=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.109.156.142] (163.114.130.5 [163.114.130.5]) by mx.zoho.eu
        with SMTPS id 1634626688782137.34875461371087; Tue, 19 Oct 2021 08:58:08 +0200 (CEST)
Subject: Re: [PATCH V2] Fix 2 dc stream buffer
To:     Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org
References: <20211014160200.437040-1-ncroxon@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <79cf94e0-9945-f0a9-e15f-99b8390548ca@trained-monkey.org>
Date:   Tue, 19 Oct 2021 02:58:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211014160200.437040-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/14/21 12:02 PM, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerablility
> assessment. Static code analysis has been run and found the following
> Error: DC.STREAM_BUFFER (CWE-120): [#def46]
> mdadm-4.2: dont_call: "fscanf" assumes an arbitrarily
> long string, so callers must use correct precision specifiers or
> never use "fscanf".
> 
> The change is to define a value for string %s.
> 
> V2: Tighten the value in policy.c to match the limit of the metadata.
> Add a change to policy_save_path() to use correct precision on the
> fscanf call.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  Monitor.c | 2 +-
>  policy.c  | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Applied

Thanks
Jes

