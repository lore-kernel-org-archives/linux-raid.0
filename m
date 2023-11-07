Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E367C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 19:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjKGTdj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 14:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjKGTdi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 14:33:38 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CB0184
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 11:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=03eJUrS1Rn3ozT4dUMaym3rE1tE+tHLAqzryylyZl6k=; b=Xaf043fxUK0mvs6uWkDwS6hVYI
        kGqAxtPV72jAnQhrau8DfXwL2t5d7eRu84ls+sWwfmmdqpDEIMzx0vvb45bqfFQqy6HoYwgL/z7uz
        1O/zfaY0Q9NhkZaGjIPPFQTzAUCsAMUJkDgbqbU54c61BoNuUonbbBtJ+KCIbnmyoKajh8xfAWMKM
        Pra33Q00PxRYv9S8LdW66neyho4sElX0jgPQeQ+kgPKQTj0nWTM9nyUJRFWqvw/bRTMxz4jZnvTo7
        jQcEUHHojzZhRakE001T6bBrpxwfK7/VOuV9Qd8iBGWNTKFx4WHz2ef/uhEG/BrxiCA3JRq9qM5Ym
        gG5jwtOA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1r0RpM-00HDJU-76; Tue, 07 Nov 2023 12:33:33 -0700
Message-ID: <9b95971b-ac76-46d4-83b8-aa1f67c6c0c9@deltatee.com>
Date:   Tue, 7 Nov 2023 12:33:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-CA
To:     Junxiao Bi <junxiao.bi@oracle.com>, linux-raid@vger.kernel.org
Cc:     song@kernel.org, yukuai1@huaweicloud.com
References: <20231107175736.47522-1-junxiao.bi@oracle.com>
 <20231107175736.47522-2-junxiao.bi@oracle.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20231107175736.47522-2-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: junxiao.bi@oracle.com, linux-raid@vger.kernel.org, song@kernel.org, yukuai1@huaweicloud.com
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 2/2] md: bypass block throttle for superblock update
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2023-11-07 10:57, Junxiao Bi wrote:
> commit 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
> introduced a hung bug and got reverted in last patch, since the issue
> that commit is fixing is due to md superblock write is throttled by wbt,
> to fix it, we can have superblock write bypass block layer throttle.
> 
> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
> Suggested-by: Yu Kuai <yukuai1@huaweicloud.com>
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>

This makes sense to me. However, I haven't looked at that bug in a long
time though and I haven't tested the proposed solution to ensure the bug
is indeed fixed.

Would it not make sense to have the fixing commit first before the
revert? So there isn't a spot in the history with a known bug?

Besides that,

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Thanks!

Logan
