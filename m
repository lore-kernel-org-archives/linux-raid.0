Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38B6BC00140
	for <linux-raid@archiver.kernel.org>; Mon,  8 Aug 2022 15:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243182AbiHHPqV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Aug 2022 11:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243237AbiHHPqT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Aug 2022 11:46:19 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CC4B60FF
        for <linux-raid@vger.kernel.org>; Mon,  8 Aug 2022 08:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=Jj892ADzQpm7C5z2VeS8DYjFdh76rFFb0AAMv28LvRk=; b=pia48RlbOY2r6qsgKPkD8m8Wxu
        ++/whgib4jvgUBG21Oz73FrJLg5AYhNUehNPuy8b7oV/MUT05HP3QeHjgmC8Wnh30s91SOMCcraQf
        Vr0SOFFy/e13D+gCbJ3wZardv5lYsLp+EJq6FmZCKYKQWFpMDNnGJ8Fn5wXNP2CDupYmaVP1t4hYS
        K0HRb7yvVdm2QherN0rqPjqk4KaT4Rqj54DUkLcczaWwIVPy2/hUq123x8OSkNOYIGIEzGuInEkkR
        w86h5I7b40ZQuhpvTs4QlOkCBNah4z5eywG/01duSY+CcdafoLznMUKlBVC6f2WGHEgLeLGjwILgR
        jDOGAH+A==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oL4xJ-00Bb1Y-PE; Mon, 08 Aug 2022 09:46:14 -0600
Message-ID: <809a39a1-e343-1829-40a1-d13a9625f7b8@deltatee.com>
Date:   Mon, 8 Aug 2022 09:46:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220622202519.35905-1-logang@deltatee.com>
 <1dcd5807-b7ab-f405-2209-d3d5d1220e4a@trained-monkey.org>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <1dcd5807-b7ab-f405-2209-d3d5d1220e4a@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: jes@trained-monkey.org, linux-raid@vger.kernel.org, song@kernel.org, hch@infradead.org, buczek@molgen.mpg.de, guoqing.jiang@linux.dev, xni@redhat.com, himanshu.madhani@oracle.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, bruce.dubbs@gmail.com, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v2 00/14] Bug fixes and testing improvments
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-08-07 14:35, Jes Sorensen wrote:
> Applied,
> 
> I am traveling and brought a new laptop, without the SSH key I need to 
> push, so I'll push things next week when I get home.

Thanks!

Logan
