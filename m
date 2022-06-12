Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBAFCCA473
	for <linux-raid@archiver.kernel.org>; Sun, 12 Jun 2022 17:53:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiFLRxo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 12 Jun 2022 13:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiFLRxc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 12 Jun 2022 13:53:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233C91D30B;
        Sun, 12 Jun 2022 10:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4D07B801BD;
        Sun, 12 Jun 2022 17:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B57C34115;
        Sun, 12 Jun 2022 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655056406;
        bh=FHOoI9Bvueryu9nc8DfiD0JvSgQ9coBdVoJ4gucyOLI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XQFyg3EqUKZRnNa3PuJ6j2YCNh39QrRoIxBTCyiYvqhfFhrorvd5IwaLORfMGesdy
         lNZwgoQ0YHdubJAUPMcfkR7cXV3VfwQWfsp7fiM8DkCdle/EXaTTTCtHmG2df/Bple
         rajymnAHsx+nYVK2N7aEX+iFQT3jdDLPQ78wBISKdW2ywTSlG6VfmDWI0L4f0B8Hkd
         pXhfHEUoJyu3Qc1W4YnnajvZh5IiAipCjM5cHhMG9weU9T0+woFAh/xo4gafmrXG8I
         2UDWsckSx6n4S7JLG+rjC1iJH0Z1LGdad7UAh3lJzQfvy8/YeuiO6RB6CDBZh3dXPL
         +asCGrP5VQKZw==
Date:   Sun, 12 Jun 2022 13:53:25 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        snitzer@kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        Donald Buczek <buczek@molgen.mpg.de>, agk@redhat.com
Subject: Re: [dm-devel] [PATCH AUTOSEL 5.18 35/68] md: don't unregister
 sync_thread with reconfig_mutex held
Message-ID: <YqYoFQ42N6YNlNnX@sashalap>
References: <20220607174846.477972-1-sashal@kernel.org>
 <20220607174846.477972-35-sashal@kernel.org>
 <f369ed06-d268-6fa9-f4aa-e9f5cd5ce53a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f369ed06-d268-6fa9-f4aa-e9f5cd5ce53a@linux.dev>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Jun 08, 2022 at 04:43:26PM +0800, Guoqing Jiang wrote:
>Hi,
>
>Pls drop this one from all stable kernel versions since it caused 
>regression.

Will do, thanks.

-- 
Thanks,
Sasha
