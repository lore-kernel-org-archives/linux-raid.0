Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3BFECAAD8
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 18:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiIUSpk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 14:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiIUSph (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 14:45:37 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB025A2623
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 11:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=5eYkoTK3+i0F206ttmodjudgdq42BYmUeGISgKbmSZg=; b=HM1DIaXidveCpiFMm+XAjMAQGs
        8MtrFoTmOJJt7pKBOnwtgjKse1Tr4AYDB6SbSaXYO3558wrX4mJBqYuUaRNRHJ37/4mnULeP0CNDW
        RlAobwAmLhirAjz7KGYnuBZ+WisTuIHUqOv3Cbkc+i+YklghhdAaZvZCglza61koY2jRXiwTYxeOj
        NxKw2aR/bWupGN9rAPQKWZIjBGhms0LXfHQC51PevHAl6ZkepyJN2xFJpxsLsOGvBvjn+WplxCWar
        DMmrrMN/pe9PchMJPxXeP6MdKTeX4EEvtl2yyBzSl9XkZlMLQaVQHCmN6+RJ4eq4aJDQ6uEtltTfw
        W3LLGQdw==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1ob4j1-007FMP-4k; Wed, 21 Sep 2022 12:45:35 -0600
Message-ID: <10301cb1-b9bc-2f64-ccbd-ee2eb9fcbc1b@deltatee.com>
Date:   Wed, 21 Sep 2022 12:45:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-US
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220908230847.5749-1-logang@deltatee.com>
 <20220908230847.5749-2-logang@deltatee.com>
 <CALTww29eUptrS6kmxZ6N3u1T0Q_+o2PyjY09cdd9vzbcDsU9Bw@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CALTww29eUptrS6kmxZ6N3u1T0Q_+o2PyjY09cdd9vzbcDsU9Bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: xni@redhat.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-19 02:41, Xiao Ni wrote:
> When creating a raid device without specifying data offset,
> dv->data_offset is always 1 (INVALID_SECTORS).
> If users specify data offset, we need to use dv->data_offset. If users
> don't specify it, we need to use
> st->data_offset.
> 
> For super1, in the function write_init_super1, before writing
> superblock to disk, it checks data_offset. If it's
> INVALID_SECTORS, it will use st->data_offset (the default value of
> specific superblock)
> 
> And for s->size, if the raid device is a raid0, s->size is 0 here. I
> see you and Mariusz talked about the raid0
> zone. If the raid0 is created with disks of different size, it can
> have more than one zone.
> e.g.  disk1(10G)   disk2(20G)  disk3(30G)
> disk1   disk2    disk3
> 10G     10G      10G  (zone0)
>             10G      10G  (zone1)  (The zone1 is behind zone0)
>                          10G  (zone2)
> 
> If the user doesn't specify size, it will use all space of the disk
> and create zones and we can discard
> the whole disk in this situation.

Thanks, this was really useful information. I've incorporated it into v3
which I'll be sending out in a bit.

Logan
