Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A63A6C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 17:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E3956054E
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 17:01:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhKBREN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 13:04:13 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17212 "EHLO
        sender12-1.zoho.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S229684AbhKBREJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 13:04:09 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1635869516; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=c22QSHf22VzrK8beIEfTBUCEtOEQnPl6vwsqWE6t7I+YdR602k9l5N94SrYkR75ho1ALb+yZ9dvSSv3FjXQivJO3r/O2nMSP9lEc9VlqZ9Jjz8tvvqD9cuQgobjlWlOzGpe+q75r2F8D22HBamXk5DU4dRIUwGJpqpYLsuX+otU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1635869516; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8FQY/HvHgf64VBkpjSeBnrSnw/b/2/gLCs5RqjMfHP8=; 
        b=hVdHNDt+jMISzES5zs3rko77WJ6ZUvjZVBxCdEgpVRgnqUB80KwenuXIAE6/Pe1y277EiM8ZX6dnk8JdDwwcIfL7DHkUkvFxB1Qwi29F9bQEMpL/S4VIHjUceT6P2I+TzifWBdyaeuT9mkimUESUP2w5KzeTw9nNoXxojAyaKGY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1635869513049567.5764336695256; Tue, 2 Nov 2021 17:11:53 +0100 (CET)
Subject: Re: [PATCH v2] imsm: introduce helpers to manage file descriptors
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20211019100743.12247-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <457d68d1-520d-8d8d-a6b8-a972eade7a85@trained-monkey.org>
Date:   Tue, 2 Nov 2021 12:11:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211019100743.12247-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/19/21 6:07 AM, Mariusz Tkaczyk wrote:
> To avoid direct comparisions define dedicated inlines.
> This patch propagates them in super-intel.c. They are declared globally
> for future usage outside IMSM.
> 
> Additionally, it adds fd check in save_backup_imsm() to remove
> code vulnerability and simplifies targets array implementation.
> 
> It also propagates pr_vrb() macro instead if (verbose) condidtion.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
> Changes:
> - Fixed bug reported by Jes
> - changed close_fd to do_close in __free_imsm_disk()
> 
>  mdadm.h       |  25 ++++++++
>  super-intel.c | 167 +++++++++++++++++++++++---------------------------
>  2 files changed, 100 insertions(+), 92 deletions(-)

Applied!

Thanks,
Jes


