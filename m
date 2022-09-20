Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424EAC6FA82
	for <linux-raid@archiver.kernel.org>; Tue, 20 Sep 2022 01:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiITB3c (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Sep 2022 21:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiITB3a (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Sep 2022 21:29:30 -0400
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10C06B72;
        Mon, 19 Sep 2022 18:29:29 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id A36851E80D23;
        Tue, 20 Sep 2022 09:26:23 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8lF-SrDgcvAz; Tue, 20 Sep 2022 09:26:21 +0800 (CST)
Received: from nfschina.com.localdomain (unknown [219.141.250.2])
        (Authenticated sender: zhounan@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 00D1C1E80D17;
        Tue, 20 Sep 2022 09:26:20 +0800 (CST)
From:   Zhou nan <zhounan@nfschina.com>
To:     song@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        zhounan@nfschina.com
Subject: Re: [PATCH] dm: Fix spelling mistake in comments
Date:   Mon, 19 Sep 2022 21:28:47 -0400
Message-Id: <20220920012848.84461-1-zhounan@nfschina.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <CAPhsuW64vLfGUGOPjnQx-D7=qh7yFL=yvfWUTPn7teCegLeZaQ@mail.gmail.com>
References: <CAPhsuW64vLfGUGOPjnQx-D7=qh7yFL=yvfWUTPn7teCegLeZaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thank you for your suggestion and I will send a fixed version again.

