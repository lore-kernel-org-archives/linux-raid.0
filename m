Return-Path: <SRS0=W2Jx=DV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C108C433E7
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E55A52222C
	for <linux-raid@archiver.kernel.org>; Wed, 14 Oct 2020 15:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730356AbgJNPmn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Oct 2020 11:42:43 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17321 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgJNPmn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Oct 2020 11:42:43 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602690160; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Da/VG2zEOK3ySwYTR4fL6k68LZOx35yYvH4N855HjryR6Os4v7Jzcd8WGUcxVIyHEU7ALS2JK3zIuN6qIDXnmiqHriR5jyAoRCkDvDmkhtzmPSH6MOJ12fGBggSqk0H3+ClMqLSKX2AquGW2gXG28/BMqMUDy5pLeSpAUErc1yM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1602690160; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9xbVi7BRCtJseDN69KNEgDGbbSfRj5iO+b1cIpvuudo=; 
        b=kLhNyTgAc1g/qtbzWyFnGkX6DboZ7Ef4gr+XD9PJ0DC3ifesdNj9SjLpxWk9XyPeeIGylEzPAyvJD8Q1ZhM+Mi+UanIEGRJQkFWq0dfky6p2EinErPe29uyeBVlYnkjEEpmu4qZMhwMjctKt8OYU35w4F2+0a3uZGmUB8iuEGqk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1602690159002339.73317891898773; Wed, 14 Oct 2020 17:42:39 +0200 (CEST)
Subject: Re: [PATCH mdadm] Super1: allow RAID0 layout setting to be removed.
To:     NeilBrown <neilb@suse.de>
Cc:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <871ri1h7xb.fsf@notabene.neil.brown.name>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <5ed5ae61-75ec-5203-d2cd-d6cdccfe124c@trained-monkey.org>
Date:   Wed, 14 Oct 2020 11:42:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <871ri1h7xb.fsf@notabene.neil.brown.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/13/20 10:12 PM, NeilBrown wrote:
> 
> Once the RAID0 layout has been set, the RAID0 array cannot be assembled
> on an older kernel which doesn't understand layouts.
> This is an intentional safety feature, but sometimes people need the
> ability to roll-back to a previously working configuration.
> 
> So add "--update=layout-unspecified" to remove RAID0 layout information
> from the superblock.
> Running "--assemble --update=layout-unspecified" will cause the assembly
> the fail when run on a newer kernel, but will allow it to work on
> an older kernel.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>

Applied!

Please press [enter] to start your upgrade to linux-2.2.26..... :)

Thanks,
Jes

