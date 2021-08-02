Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F93FC4338F
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 15:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F9A7610FC
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 15:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhHBPtw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 11:49:52 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17017 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234910AbhHBPtw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Aug 2021 11:49:52 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627919377; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=V68HpTQt6wUM43EnFTnkABEJkYfH/H82laME2uJuQby+pF6+k2CIEy8Qf4pKhm8tRH47cLuU9eqVGLj6jQTGQEKnMpFu0adDVjo5/FFgh0o+AR9FZSgPZ1bMAJ4Hnd2WoLCWI58gP2FRyC3KFd8BlnjnhqgCahDCnAr3dj44ifQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627919377; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=FZzYOzB8SWBi1G3r3VI6eBYfSlgcm6T+Gyy9Xjp1Wbc=; 
        b=We8264NAN4Y4rInFlb7nXhDvjV3TxvCPDq+E0bOpf60N2pq8YI4LAKJtMDToNNou/m+uKZrz4UkFAFt8PVlDJh29epcnEt4PWYL2/gM1/udemgQ7GdqPy5pzAzerSeGzJny56wTezPtZ6vOY1/kChj//J/pwiG6UyzZ/3SSjtdY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627919376848956.3104826755415; Mon, 2 Aug 2021 17:49:36 +0200 (CEST)
Subject: Re: [PATCH 5/5] tests: avoid passing chunk size to raid1.
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc:     linux-raid@vger.kernel.org
References: <20210722182936.GA25474@oracle.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <698a03a1-0e87-d2c5-eaec-90cd0a29403e@trained-monkey.org>
Date:   Mon, 2 Aug 2021 11:49:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210722182936.GA25474@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/22/21 2:29 PM, Sudhakar Panneerselvam wrote:
> '04update-metadata' test fails with error, "specifying chunk size is
> forbidden for this level" added by commit, 5b30a34aa4b5e. Hence,
> correcting the test to ignore passing chunk size to raid1.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  tests/04update-metadata | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/04update-metadata b/tests/04update-metadata
> index 08c14af7ed29..591009d2797e 100644
> --- a/tests/04update-metadata
> +++ b/tests/04update-metadata
> @@ -11,7 +11,12 @@ dlist="$dev0 $dev1 $dev2 $dev3"
>  for ls in linear/4 raid1/1 raid5/3 raid6/2
>  do
>    s=${ls#*/} l=${ls%/*}
> -  mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
> +  if [[ $l == 'raid1' ]]
> +  then
> +    mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 $dlist
> +  else
> +    mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
> +  fi
>    testdev $md0 $s 19904 64
>    mdadm -S $md0
>    mdadm -A $md0 --update=metadata $dlist
> 

I took a patch from Mateusz that fixed this in a more generic way. If
it's still a problem, please let me know.

Thanks,
Jes

