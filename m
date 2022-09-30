Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA0CC433FE
	for <linux-raid@archiver.kernel.org>; Fri, 30 Sep 2022 15:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbiI3Pju (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Sep 2022 11:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiI3Pjp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Sep 2022 11:39:45 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8164D62F9
        for <linux-raid@vger.kernel.org>; Fri, 30 Sep 2022 08:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=b/zUvCPf93iA4Zp0dGLJVObaAaZouaXd1Af16vheNEw=; b=HkxUZ9xwwLY2Fz7w7OQZ0cfrqo
        CZ1/Owe0zvXYvpL0FbZKdN1c67ThNgzD45F57OUaCbaTusOHxxKfPL6KalYrfjIJLV6bK90LwcYtu
        c2rJ9v6LGZlZEv+ZvupSNlKABAMT97ng9vWZLF73AouIrpaTL7T/qIc0JmZIaHgAw65H2MyRsDiAM
        A+Bnb8XCiGeI+zY7/ffq5+3JdhHwLG3SSd0bJ7C48JQPWr+GxfiVxDFLOcb34ZT29CR+D/Xs1sxe1
        v3RZQO414eNiLujYioulZunVt/HmyDKEZMTB2Cs9MIhfj8naFdrz0Ub3S0Z+S4BRQWW3sT3OTrSOm
        mrjSk2Gw==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oeI70-00EZhg-72; Fri, 30 Sep 2022 09:39:38 -0600
Message-ID: <a10ddcc9-e081-abfa-2fef-671f6093ec59@deltatee.com>
Date:   Fri, 30 Sep 2022 09:39:37 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Content-Language: en-CA
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220921204356.4336-1-logang@deltatee.com>
 <CALTww29fH+pa=-Pzd3anEKh49fmvc9EGmL52QGo1GrQEUGsf5g@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CALTww29fH+pa=-Pzd3anEKh49fmvc9EGmL52QGo1GrQEUGsf5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: xni@redhat.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v3 0/7] Write Zeroes option for Creating Arrays
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-29 23:26, Xiao Ni wrote:
> Hi Logan
> 
> I like this idea, but I have a question. If we do discard against the
> member disks
> and then creating raid device with --assume-clean, it should work with the same
> result. The reason that you add --write-zero is for automatic doing this?

Yes, that is correct.

Logan
