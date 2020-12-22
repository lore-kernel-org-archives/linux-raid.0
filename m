Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43F0C433E6
	for <linux-raid@archiver.kernel.org>; Tue, 22 Dec 2020 11:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA7423333
	for <linux-raid@archiver.kernel.org>; Tue, 22 Dec 2020 11:13:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgLVLM5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 22 Dec 2020 06:12:57 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:44108 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgLVLM5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 22 Dec 2020 06:12:57 -0500
Received: from host86-149-69-253.range86-149.btcentralplus.com ([86.149.69.253] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1krfaQ-000BhF-5h; Tue, 22 Dec 2020 11:12:14 +0000
Subject: Re: [RFC PATCH] badblocks: Improvement badblocks_set() for handling
 multiple ranges
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk,
        dan.j.williams@intel.com, vishal.l.verma@intel.com
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org
References: <20201203171535.67715-1-colyli@suse.de>
 <3f4bf4c4-1f1f-b1a6-5d91-2dbe02f61e67@youngman.org.uk>
 <c50e7c65-d7bf-e957-d8eb-efed6c24f089@suse.de>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <3233b821-4674-b45a-cad4-4943401eff3d@youngman.org.uk>
Date:   Tue, 22 Dec 2020 11:12:14 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <c50e7c65-d7bf-e957-d8eb-efed6c24f089@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20/12/2020 09:46, Coly Li wrote:
> Currently blocks/badblocks.c is used by md raid and nvdimm code, and the
> badblocks table is irrelevant to any of these two subsystems.

Good to know.
> 
> If there will be better code for similar or better functionality, it
> should be cool. For me, if the reporting bug is fixed, no difference in
> my view:-)
> 
Hopefully that will improve the badblocks handling in md. Sounds like 
that could in part be the problems we've been seeing.

If I integrate dm-integrity into md, badblocks should be mutually 
exclusive with it, but because dm-integrity is both a performance and 
disk-space hit, people might well not want to enable it.

Cheers,
Wol
