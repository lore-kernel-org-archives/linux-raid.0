Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E87AC4332F
	for <linux-raid@archiver.kernel.org>; Wed, 16 Nov 2022 17:11:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiKPRLc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Nov 2022 12:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233866AbiKPRLb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 16 Nov 2022 12:11:31 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4454B1B799
        for <linux-raid@vger.kernel.org>; Wed, 16 Nov 2022 09:11:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=haaCO7u2ZIBPd3iQXY6lIJf1r+Csco2Tj9bM6hteOOE=; b=A/owxefMmYlrSEJDrai+YTJnE3
        gs4MCI54PpuYkkVFmV/2SzMQD0KqEbjbx3cskKuBbMgGJ0SphE0Y2rBVWmipYzze9VA0XCFQQsNnQ
        5xnleNiML9zqXTa9koxC2Wz9uoYuHUjrMSHhe6aOqpZGMgK3B47izGP94FKVfs8zHsIGq9kwuxrNH
        Wj3islVZbmijTobofGHWlkqFkh3+/i3oWDDkZ/sr89zDQkyVTx5l2xt65N3E2y32ACvhfFem6XDlr
        JhOn2Gek8A/ffPCPuBn/4ypE8+egmEtdKY7WOMtf0tRWC7TdWj2ccEX0HUYsnWHqoRv9j2ZXApViq
        xwtuhTZg==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ovLwW-003zAv-F4; Wed, 16 Nov 2022 10:11:22 -0700
Message-ID: <716b86e4-e7eb-8d07-c1cb-962c10537ea3@deltatee.com>
Date:   Wed, 16 Nov 2022 10:11:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20221007201037.20263-1-logang@deltatee.com>
 <CALTww28HQUPbB647oP9WKvkLX=9PqZv+9am-884zZVM923H-KA@mail.gmail.com>
 <8ee5368c-1808-d2bc-9ad2-2f8332d2704e@deltatee.com>
 <yq15ygo4jkv.fsf@ca-mkp.ca.oracle.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <yq15ygo4jkv.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: martin.petersen@oracle.com, xni@redhat.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v4 0/7] Write Zeroes option for Creating Arrays
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sorry a little late responding to this.

On 2022-10-12 19:33, Martin K. Petersen wrote:
> 
> Logan,
> 
>> 2) We could split up the fallocate call into multiple calls to zero
>> the entire disk. This would allow a quicker ctrl-c to occur, however
>> it's not clear what the best size would be to split it into. Even
>> zeroing 1GB can take a few seconds,
> 
> FWIW, we default to 32MB per request in SCSI unless the device
> explicitly advertises wanting something larger.
> 
>> (with NVMe, discard only requires a single command to handle the
>> entire disk
> 
> In NVMe there's a limit of 64K blocks per range and 256 ranges per
> request. So 8GB or 64GB per request for discard depending on the block
> size. So presumably it will take several operations to deallocate an
> entire drive.
> 
>> where as write-zeroes requires a minimum of one command per 2MB of
>> data to zero).
> 
> 32MB for 512-byte blocks and 256MB for 4096-byte blocks. Which matches
> how it currently works for SCSI devices.

The 2MB I was referring to was the typical maximum we see on real
devices. We tested a number of NVMe drives from a number of different
vendors and found most to be a maximum of 2MB, some devices had 512KB.
Which is unfortunate.

>> I was hoping write-zeroes could be made faster in the future, at least
>> for NVMe.
> 
> Deallocate had a bit of a head start and vendors are still catching up
> in the zeroing department. Some drives do support using Deallocate for
> zeroing and we quirk those in the driver so they should perform OK with
> your change.

Yeah, my hope is that larger zeroing requests can be supported which
will be handled performantly by deallocating the device. So I don't want
mdadm to slow this down by splitting the request to the kernel into a
number of smaller requests. But this seems to be the only way forward
because the request is uninterruptible and we don't want to hang the
user for several minutes.

Logan
