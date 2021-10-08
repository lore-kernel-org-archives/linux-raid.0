Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DC8C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 15:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F7D6054E
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 15:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243046AbhJHPs3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 11:48:29 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17264 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhJHPs2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 11:48:28 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633707980; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=QhWlkfVgXpid4/0DrjwHJDV5gaq6mQncPOkIRkxa2upERU3VRMjw+I2DYBiRn5C5HC5t7gNzW3715ha/e3JUbcgF1iesAUSpNxEy2gQbQGOdvVxL8d1Bmf9/zAJZ1Xp8J0AQswXDhAgthvnTdMtCN3XA9hSMJGYAvdxdwq0MZrg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633707980; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=uetmS7Y8MdEP3Wn6U487gSBAMji+koQ8MkXxS9pe3+o=; 
        b=NKlM04CpBjvpIXz4GeIaHO/vt+Q7lE1vcGstuWQMB2HJvAYvhPkcZ4s4GF3xstLYXgRcGH8j+kOD36NBFfhnWHI42eu8G76Y9ku4mpoEzod5//WRrhLaHUsdUEMzOUx5RihyY7HTOJeQqLAm1n2/+gwXW+TGL0rjDQWWBKcFp0c=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 1633707979854849.5428832823151; Fri, 8 Oct 2021 17:46:19 +0200 (CEST)
Subject: Re: [PATCH V5] Fix buffer size warning for strcpy
To:     Nigel Croxon <ncroxon@redhat.com>, mariusz.tkaczyk@linux.intel.com,
        neilb@suse.de, xni@redhat.com, linux-raid@vger.kernel.org,
        gal.ofri@volumez.com
References: <20210825153014.2780505-1-ncroxon@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <67e9fee9-e75f-8f94-6f7b-994f7ed86bff@trained-monkey.org>
Date:   Fri, 8 Oct 2021 11:46:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210825153014.2780505-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/25/21 11:30 AM, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerability
> assessment. Static code analysis has been run and found the following
> error:
> buffer_size_warning: Calling "strncpy" with a maximum size
> argument of 16 bytes on destination array "ve->name" of
> size 16 bytes might leave the destination string unterminated.
> https://people.redhat.com/ncroxon/mdadm-4.2-rc2-scan-results.html
> 
> The change is to make the destination size to fit the allocated size.
> 
> V5:
> Simplify the the strnlen call.
> 
> V4:
> Code cleanup of the interim "if" statement.
> 
> V3: Doc change only:
> The code change from filling ve->name with spaces to filling it with
> null-terminated is to comform to the SNIA - Common RAID Disk Data
> Format Specification. The format for VD_Name (ve->name) specifies
> the field to be either ASCII or UNICODE. Bit 2 of the VD_Type field
> MUST be used to determine the Unicode or ASCII format of this field.
> If this field is not used, all bytes MUST be set to zero.
> 
> V2: Change from zero-terminated to zero-padded on memset and
> change from using strncpy to memcpy, feedback from Neil Brown.
> 
> Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  super-ddf.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Applied!

Thanks
Jes

