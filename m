Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96356C43457
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 500CD21582
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbgJNPZh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:25:37 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17338 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgJNPZh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Oct 2020 11:25:37 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2020 11:25:35 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1602689127; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=QcEIWsd2USJLOTHT9Ygn1NJgrFrw3rbRxSOQwIdwSAyiP4wHOkphNO911UW/XLlKXjP1mUKQ+cO5rexVSEDQgflvRX9EFb3YGdrFJSdGkKkbJ/1qH66Z5LOLRwE+sEBHx6qkVV3S+faJfP9wuc2qxnDgx+wFL7gbo9k00vgsg7o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1602689127; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=qNdDFbr2izNjw1VgRMP+FCIMJx0kpRkKz2evqD8JayM=; 
        b=Z9TI1kRoDRmayfsaRryJuizCKWT8p5XtjejqgSXepcq2lwLaKBlLtHs4MhZWAJvLGzcNu9a2GHgYM5P5xEEiWXZH2+nCb1LpQP8iv3M9HZwemlIQbKGOaOQHUauEy7QmjFYHMyp2VbzLkqbsCqJDB/81+njkoXR5D0GcizMdMuc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1602689126133751.8864107321206; Wed, 14 Oct 2020 17:25:26 +0200 (CEST)
Subject: Re: [PATCH V2 2/2] Don't create bitmap for raid5 with journal disk
To:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, ncroxon@redhat.com, antmbox@youngman.org.uk
References: <1600155882-4488-1-git-send-email-xni@redhat.com>
 <1600155882-4488-3-git-send-email-xni@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <bf68ca72-9a7c-dc2d-cdea-6d8cb3f0ee15@trained-monkey.org>
Date:   Wed, 14 Oct 2020 11:25:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1600155882-4488-3-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/15/20 3:44 AM, Xiao Ni wrote:
> Journal disk and bitmap can't exist at the same time. It needs to check if the raid
> has a journal disk when creating bitmap.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Create.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Create.c b/Create.c
> index 6f84e5b..0efa19c 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -542,6 +542,7 @@ int Create(struct supertype *st, char *mddev,
>  	if (!s->bitmap_file &&
>  	    s->level >= 1 &&
>  	    st->ss->add_internal_bitmap &&
> +	    s->journaldisks == 0 &&
>  	    (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
>  	     s->consistency_policy != CONSISTENCY_POLICY_PPL) &&
>  	    (s->write_behind || s->size > 100*1024*1024ULL)) {
> 

Applied!

That said, I'd love if we could do something to get rid of some of these
very excessive if statements. It is extremely difficult to verify all
cases are correct.

Thanks,
Jes
