Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1AEC4320E
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:05:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD24C6113B
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbhHBOFN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:05:13 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17083 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbhHBOEN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Aug 2021 10:04:13 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627913042; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=W4Mv4dp0n6mKxwKNAW+kUciVxFlvxjNYJmeYL5VV0/RffI4+DSJcXUrxFyCijgc+xnQdzoArDH9JmRQHWe0EvBRO5k7YYC7iagvz95ZfwCG51KdNyRxtxfXk0lZmd3CuGObtiCyZUi1Erx1KhqS9sSJ6AxgGUlqVqZAnKodzcRE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627913042; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=TCyCp60TC6ui3UG8JU/0aNz1L5jW47KZ8RiMWNrLfnU=; 
        b=VNfgpXa/ShPmXesCSNYLgh2OGC76X9puDnqQXgGmPm9vqUkRgdUk3sdadCOodC2lrMxX1Kuh4IGdLzVUqNcqzAd5clqDScezQ3bNa+s+Y2+Mo27V+Ec69UTt9+KiBzcAfFVOEp9iyKnCzLRUfEpZvZm2iObTIb07JTuy+smNgQo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627913040240906.7315797561918; Mon, 2 Aug 2021 16:04:00 +0200 (CEST)
Subject: Re: [PATCH] Fix memory leak after "mdadm --detail"
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20210727082518.10737-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <6ef3205f-26b6-c6b8-b7a6-20f07d19582f@trained-monkey.org>
Date:   Mon, 2 Aug 2021 10:03:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210727082518.10737-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/27/21 4:25 AM, Mateusz Grzonka wrote:
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Applied!

Thanks,
Jes


