Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC12C433ED
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 22:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFE9F61220
	for <linux-raid@archiver.kernel.org>; Mon, 12 Apr 2021 22:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239663AbhDLWE6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 18:04:58 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17021 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238235AbhDLWE6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Apr 2021 18:04:58 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1618265074; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=VPEhOd8HkLzIb4nOAdvrTQdzydgX1Vh8sQq/7/n2ltuCXhqUrh3Yz1Dx6HZTzvr/TBw7au+ZEmaUMW3rN57njze0OpLoNiohExO7l97Iw6oza+BeH3RJaU8GABxgiZJ9n76VQTaMGc3SpsHHc03XRYasXtuMfTX/22U3FeBGtWU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1618265074; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=nIYMK9MOdgRTqlga/w2HApwMXLaWf+0gjpRd3sL3TqM=; 
        b=hpyY7EZjEFT88lewUEwlWXFCwM7TqgXW4mWCk39xYgouxHgzg3cY/Ybh3bnVHJxJd86uj4JtaEDtTboI/Mu9blmkilCUSsPc2HvQqA6Dn5T6w0NMeGdj1fJ8jogmoYKMWOB5fH49LZI8udVSWRmLhfM/VfqBG+DsLjD7hAnHr0s=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1618265072565795.4602084391242; Tue, 13 Apr 2021 00:04:32 +0200 (CEST)
Subject: Re: new mdadm release
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <b8589184-3b64-61fc-fd4c-1e12a91da4ce@linux.intel.com>
 <be13bd5f-d448-5682-c896-de5abef64be5@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <ee7c27f5-96e2-09a0-d780-b63196340c2f@trained-monkey.org>
Date:   Mon, 12 Apr 2021 18:04:31 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <be13bd5f-d448-5682-c896-de5abef64be5@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/12/21 10:39 AM, Tkaczyk, Mariusz wrote:
> Hi Jes,
> IMSM part is seems to be ready now. No new issue occurs.
> Could you please mark release candidate on current top?
> 
> Sorry for noice, I forgot to add mailing list.

Hi Mariusz,

Sounds good, I'll try and get it done this week.

Cheers,
Jes

