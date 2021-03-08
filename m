Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB3FC433E6
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:51:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08C626522A
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:51:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhCHPvY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:51:24 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17239 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhCHPvB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Mar 2021 10:51:01 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615218655; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=EIqPx9qIgBF/ab3afkeA7fKozP0QaL6M7NsGghYNO5O/CXLhhu2i5MpDOgAWjLQo3KY3cioiaPxSHniH3XQJ4OGq9m35xcTC8R6xoU+tP31KyOpdRJdWnTVgcpBjGNddFNgPZWZvrh9OV0MHoAoEH/w4/prLwrftvRqDUntc38U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615218655; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=VA9kNZe3jJClOYS3jnoj+sqMHQmzc/YY7JyIdjKcvV4=; 
        b=d3OgjQCfYY+LhMNFP24OwhmaoiHXy+Vf9gTfC9CURYq87n7sJnWg6dL80nEnF38YehgHluhdKUvmpPikoC+0OqRv5K2KN80iRXKmybE1XV7+Haa/YteQc8iq8b7+CfpOIl2ladcpLOTXB2LKcOshi19Y1C2wds35if6BCDFQh48=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615218654186121.01798361915053; Mon, 8 Mar 2021 16:50:54 +0100 (CET)
Subject: Re: [PATCH 1/1] It should be FAILED when raid has not enough active
 disks
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com
References: <1612863591-5725-1-git-send-email-xni@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <ed88bca9-562e-c603-7095-cb18e737f7e1@trained-monkey.org>
Date:   Mon, 8 Mar 2021 10:50:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1612863591-5725-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/9/21 4:39 AM, Xiao Ni wrote:
> It can't remove the disk if there are not enough disks. For example, raid5 can't remove the
> second disk. If the second disk is unplug from machine, it's better show missing and the raid
> should be FAILED. It's better for administrator to monitor the raid.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  Detail.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)

Applied!

Thanks,
Jes

