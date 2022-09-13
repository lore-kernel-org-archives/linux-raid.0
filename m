Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A3DC54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 17:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiIMROC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 13:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbiIMRNc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 13:13:32 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F169674F
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 09:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=NOG8GVF1ChlhrvX3zIYUlC9Qd3IHqr+qX9dV2D2DJ5Q=; b=Y7YVbEKt20M1DuY7lTXxAwHIXK
        xg0FaI6m9qwt+Yi7PVtkEd5o3T7U3Fr/noOvdF7vKFG9vAnLuwq2XPYzQzutx3HfRFWg3S+cgxCGJ
        +aPTWQnn0TngnyeWedFw04A/l8hjZO8bSk5KIjBWkKJimvcrSNyc3uuDApi/8KYn2lt2DGxQhhIsv
        lZVLBiDIrb2DmTDvAzJUGyqrQs8Cp4K2JkxdnGJbbUd26bNMacomTO7fLYBfAuUSLxCrKqlzwD5ca
        BAldXiR/PffpIlPdKJkUWPA/i0qjbFYYlHK/usCzIU/7p0et8CFRayImimThdhwLkwdI5s1obA0An
        cScGp1lA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oY7zk-000puu-A6; Tue, 13 Sep 2022 09:38:41 -0600
Message-ID: <64d4b251-c10f-aac1-0ba6-fa1e2b30792f@deltatee.com>
Date:   Tue, 13 Sep 2022 09:38:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-CA
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220908230847.5749-1-logang@deltatee.com>
 <yq1fsgwbijv.fsf@ca-mkp.ca.oracle.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <yq1fsgwbijv.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: martin.petersen@oracle.com, linux-raid@vger.kernel.org, jes@trained-monkey.org, guoqing.jiang@linux.dev, xni@redhat.com, mariusz.tkaczyk@linux.intel.com, colyli@suse.de, chaitanyak@nvidia.com, jm@chia.net, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH mdadm v2 0/2] Discard Option for Creating Arrays
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-09-12 11:40, Martin K. Petersen wrote:
>> Because write-zero requests may be slow and most (but not all) discard
>> requests read back as zeros, this work uses only discard requests.
> 
> REQ_OP_WRITE_ZEROES will pick the most optimal way to guarantee that all
> blocks in the requested range will return zeroes for subsequent reads.

Makes sense to me. I wanted to use WRITE_ZEROS but was disappointed in
the performance even on the nvme drive we tested. I'll respin this to
use WRITE_ZEROS and maybe we can do some investigation on more NVMe
drives to see if more of them might do it efficiently.

Thanks,

Logan
