Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F4CC433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 10:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CEEB60F48
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 10:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbhJHKDe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 06:03:34 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17208 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238188AbhJHKDd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 06:03:33 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633687283; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=cuOwFoyeJ69iP/Pi2KRPzPuBlDqmz3CWX4mgISZH4vacUnzrqR7k9GVICWEnrvgpfVEzzxbH1U13Z3WItFFaPo5q6HUijF81jI1reS3HF1w1vM3V2LW0qvlE2j6em3R0xekD+OsAmhRyNTouqjLiA3NiShUgEEsbt7erpp3q5sc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633687283; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qBG6DoylBTntd1hu5Q6ei8TZmiw8UlaPs+GLe3AyAXI=; 
        b=kdlhN8gK2UVkq03ckD3S6qqMkOmldMcwCHAPRvK7rHixP++zANakJLrTmJ6r7VDy/AA2wWx3CdDF7d3yo9N/8wOuxvgAyM+EU6EDalfwztNpal1jy3W1E2kZboasDnAvA/E5PBZUOftrWODakApV4m9iEmy01op6zuQ1YLxUj7A=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 1633687276072485.20053845983955; Fri, 8 Oct 2021 12:01:16 +0200 (CEST)
Subject: Re: [PATCH]mdadm: fix coredump of mdadm --monitor -r
To:     Wu Guanghao <wuguanghao3@huawei.com>, linux-raid@vger.kernel.org
Cc:     liuzhiqiang26@huawei.com, linfeilong@huawei.com
References: <41edfa76-4327-7468-b861-1c1140ee9725@huawei.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <a223ce17-66fb-690e-cba6-935122f4af88@trained-monkey.org>
Date:   Fri, 8 Oct 2021 06:01:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <41edfa76-4327-7468-b861-1c1140ee9725@huawei.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/16/21 3:24 AM, Wu Guanghao wrote:
> Hi,
> 
> The --monitor -r option requires a parameter, otherwise a null pointer will be manipulated
> when converting to integer data, and a coredump will appear.
> 
> # mdadm --monitor -r
> Segmentation fault (core dumped)
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  ReadMe.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Something is fishy with your mail client as this didn't apply, but I
applied it manually.

This seems a reasonable fix, even though we have different usages of -r
they all require an argument. That said the whole argument parsing
handling could do with an overhaul.

Thanks,
Jes


> diff --git a/ReadMe.c b/ReadMe.c
> index 06b8f7e..070a164 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
>   *     found, it is started.
>   */
> 
> -char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
> +char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
>  char short_bitmap_options[]=
> -               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
> +               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
>  char short_bitmap_auto_options[]=
> -               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
> +               "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:RSow1tye:k";
> 
>  struct option long_options[] = {
>      {"manage",    0, 0, ManageOpt},
> --
> 2.23.0
> 

