Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12315C43334
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 16:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376520AbiFVQjs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Jun 2022 12:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359602AbiFVQjg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Jun 2022 12:39:36 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1881369F7
        for <linux-raid@vger.kernel.org>; Wed, 22 Jun 2022 09:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=Ai40kSrncDMiBkfn94Xl93MZYT5lrxjc0iaF188KD8I=; b=hI1v1aI0XrT5sS+FfxDkw2Isqk
        NVKw7PTiBV/AmEIZPJP5VyxCikUym5iplHtYjos6vVtt+I+FY6P134EjIjCUK5VHVvMjebV1zpILv
        EvW/AFVwUfg1xF6W86jZA6IVCJTYdyXj0JjvaIvqDw4qFVVQ2gSibVQxzQuEfL9IHbOsbv7ybc+Uz
        tswSp2++2dYVS8zWbGrnJ46rcxTd06s8rUkn4I/85PPP4NWOscer57GSXoFCVanWBQl08+GOBN2GW
        y0zoUb5+CQDH8uyR8pnep8ASsX4zx8xog7sswLNyl94+6cBYcN5p/xV6EXHSk2IUcmTDSsBsGQ6zH
        AnYmFpsw==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1o43O2-00EDvG-Tk; Wed, 22 Jun 2022 10:39:27 -0600
Message-ID: <8c52bde0-7d5d-152e-4749-5247b5b8e1ed@deltatee.com>
Date:   Wed, 22 Jun 2022 10:39:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220609211130.5108-1-logang@deltatee.com>
 <20220609211130.5108-2-logang@deltatee.com>
 <20220620160838.00000d73@linux.intel.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220620160838.00000d73@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org, jsorensen@fb.com, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v1 01/14] Makefile: Don't build static build with
 everything
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-06-20 08:08, Mariusz Tkaczyk wrote:
> Hi Logan,
> Thanks for this patchset. I really appreciate effort you did here.
> 
> On Thu,  9 Jun 2022 15:11:17 -0600
> Logan Gunthorpe <logang@deltatee.com> wrote:
> 
>> Running the test require building everything, but it seems to be
>> difficult to build the static version of mdadm now seeing there
>> is no readily available static udev library.
>>
>> There's no need to build it, so just remove it.
> 
> I think that you want to remove it totally, right?
> 
> What with following targets:
> everything-test
> install-static
> mdadm.static
> clear

I figured leaving the explicit targets (mdadm.static and install-static)
would be fine so that if someone wants to, they can still build the
static binary. Removing them from the 'everything' target was my
intention seeing that's what the test scripts tell you to do.

However I missed everything-test, so I'll make that change for v2 which
I'll send shortly.

Logan
