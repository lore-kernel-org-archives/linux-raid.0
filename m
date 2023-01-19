Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60EF5C38142
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 17:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbjASRkP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 12:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjASRkK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 12:40:10 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB8A5421A
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 09:40:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=cFFhbfQAhvp7r5+sgqB6O4FAQoii1cwjUZUchw/hxvs=; b=qU8jIlMQ3a7+yxefb7yFA9/h7d
        T5ldxiM9o0X17Mvw5wmaM4x5/y8s5CyIcY8sxI9FDVzOJ3SSr6L4k8+s5DCl6nZNWYPrdx6+qpsZU
        bwLrBpX95yuBYYPFE5amBH0GeJfAtvJUOewuZse8KFDTq4HoTUHP+QDpQJ9+bwdDqRkiL6ohAl2uK
        143Fj2lJqE20cYZkE2nhBljwZl58rjkaZuEAkB6kWtDiOBlNbFvSRZwhDAz9ZDJFKx2LBa6DXrEkV
        fLLA5AuO11UDvHVpQIPdsVPug3lXn206ySzJZsFR4r5qxt4dW+9mfSERr2/Iuz8HzvCXNmq95o8pP
        c+rfujUA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1pIYtK-001gfz-Ek; Thu, 19 Jan 2023 10:39:59 -0700
Message-ID: <753b5edc-9a34-dce3-051d-514f8d43f3cd@deltatee.com>
Date:   Thu, 19 Jan 2023 10:39:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-CA
To:     Xiao Ni <xni@redhat.com>, Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20221123190954.95391-1-logang@deltatee.com>
 <CALTww2_veP=bkpz5Z03VjmF=0dH-D9WqD2+K5A9cBiK5Pb-USg@mail.gmail.com>
 <85822a83-f4cc-b699-d589-b6c5590b3f98@redhat.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <85822a83-f4cc-b699-d589-b6c5590b3f98@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: xni@redhat.com, jes@trained-monkey.org, linux-raid@vger.kernel.org, guoqing.jiang@linux.dev, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v6 0/7] Write Zeroes option for Creating Arrays
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023-01-06 00:53, Xiao Ni wrote:
> Hi Jes
> 
> Just a reminder about this series of patches.

Any progress on this? Should I resend it? I haven't heard much feedback
in a while.

Thanks,

Logan
