Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A094C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 14 Mar 2022 19:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244585AbiCNTxO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Mar 2022 15:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244741AbiCNTw1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Mar 2022 15:52:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6573FD83;
        Mon, 14 Mar 2022 12:51:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE301611BD;
        Mon, 14 Mar 2022 19:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBBEC340EE;
        Mon, 14 Mar 2022 19:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647287427;
        bh=On3lskfefDO7Bl1q7PKJQXQAMhTxwnHGKT6na9XT9Wo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WFZcNWXFGZVA+2W7kyzs6SFdlrv3FyV/aJpjGOYQrp3rgQAHpkzRjFdMvwqDhPEVY
         8HccX0Lo2E1PNfiZQDUrzkEZYvszKgIDh+jEv4UlieiUh562ltwNsZ+yC+z+A/sAvG
         VQMJafX4Ed9uPokPP2M97s8W6Z/uFiwrLEVIODiu9Lw4BvxBUz98r92nboGi0+u9DC
         rsyoWTTLz4oO2dWRjOaZxGA3OhCqhH9OiqCZtdX0G5qpVM+atFaGbdz5ZlHsYog415
         LYR+jbkEfGOWoZwkJxMlwjdHCgo0dnUlWfhid2a5xtgycNP4N1S4HQNjiP7N/dP0ey
         hYnS7fa2QRuvg==
Date:   Mon, 14 Mar 2022 19:50:25 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Avi Shchislowski <Avi.Shchislowski@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Manjong Lee <mj0123.lee@samsung.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "hch@lst.de" <hch@lst.de>, "kbusch@kernel.org" <kbusch@kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "song@kernel.org" <song@kernel.org>,
        "seunghwan.hyun@samsung.com" <seunghwan.hyun@samsung.com>,
        "sookwan7.kim@samsung.com" <sookwan7.kim@samsung.com>,
        "nanich.lee@samsung.com" <nanich.lee@samsung.com>,
        "woosung2.lee@samsung.com" <woosung2.lee@samsung.com>,
        "yt0928.kim@samsung.com" <yt0928.kim@samsung.com>,
        "junho89.kim@samsung.com" <junho89.kim@samsung.com>,
        "jisoo2146.oh@samsung.com" <jisoo2146.oh@samsung.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 2/2] block: remove the per-bio/request write hint.
Message-ID: <Yi+cgUXaSx+PN10B@gmail.com>
References: <CO3PR08MB797524ACBF04B861D48AF612DC0B9@CO3PR08MB7975.namprd08.prod.outlook.com>
 <e98948ae-1709-32ef-e1e4-063be38609b1@kernel.dk>
 <CO3PR08MB797562AAE72BC201EB951C6CDC0B9@CO3PR08MB7975.namprd08.prod.outlook.com>
 <d477c7bf-f3a7-ccca-5472-f9cbb05b83c1@kernel.dk>
 <c27a5ec3-f683-d2a7-d5e7-fd54d2baa278@acm.org>
 <PH0PR08MB7889642784B2E1FC1799A828DB0B9@PH0PR08MB7889.namprd08.prod.outlook.com>
 <ef77ef36-df95-8658-ff54-7d8046f5d0e7@kernel.dk>
 <bf221ef4-f4d0-4431-02f3-ef3bea0e8cb2@acm.org>
 <800fa121-5da2-e4c0-d756-991f007f0ad4@kernel.dk>
 <SN6PR04MB3872231050F8585FFC6824C59A0F9@SN6PR04MB3872.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR04MB3872231050F8585FFC6824C59A0F9@SN6PR04MB3872.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Mar 14, 2022 at 07:40:42AM +0000, Avi Shchislowski wrote:
>
> We also supports Samsung & Micron approach

Great, so send some patches upstream to have it be supported properly.

- Eric
