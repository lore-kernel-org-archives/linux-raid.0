Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3848DC4338F
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A39760F9E
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 14:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234366AbhHBOyC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 10:54:02 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17087 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbhHBOyC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Aug 2021 10:54:02 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627916028; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=dsw7ji3DRoYs1ZqsAebmV25glQN3Fhn+8Foo36WA7vR9nuolSmAybcwMzN7VKN03TrItXbPwGu8bjRoM9tj3D92VpU796Y8Jx20TKZD0LmwTA/3mBCTZsgA/Nf7DOnUke9LiC/0Da7NnxZX0kIzqHMvWs2phl+b+sCMza2bMtsg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627916028; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=mH1KEX0tt8TgX6MIOMN/h2hxLZCzADSd9OqKhZJ75Qc=; 
        b=bmmEZCP5hrTjK8FYCOXlZLDnN3g5eyPpjlAsBqaBwqd3k0cVMrGMXDCXlvrN0imemLWJsCMFPkrNEXmu3hmJAxF8QOtHEzS/tBcxFCSXkn2ak5HhPl9fZK5YyjEe3YXjM2K7Ex4UFZB7Ld7/q3QLZ+DEo8All0P6wAnPkvYj5VQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627916026682110.27765069391364; Mon, 2 Aug 2021 16:53:46 +0200 (CEST)
Subject: Re: [PATCH 3/5] Assemble: skip devices that don't match uuid instead
 of aborting the assembly.
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Cc:     linux-raid@vger.kernel.org
References: <20210722182834.GA25244@oracle.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <1f1a4095-e9cc-cf2e-20e0-f300eb0a8826@trained-monkey.org>
Date:   Mon, 2 Aug 2021 10:53:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210722182834.GA25244@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/22/21 2:28 PM, Sudhakar Panneerselvam wrote:
> This fixes '03r0assem' test as assembly fails when looking for specific
> uuid among the device list.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  Assemble.c | 5 +++++
>  1 file changed, 5 insertions(+)
Applied!

Thanks,
Jes

