Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94017C7EE23
	for <linux-raid@archiver.kernel.org>; Tue, 30 May 2023 05:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjE3Fpz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 May 2023 01:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjE3Fpy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 30 May 2023 01:45:54 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E14AB;
        Mon, 29 May 2023 22:45:51 -0700 (PDT)
X-QQ-mid: bizesmtp80t1685425279twgcuzx8
Received: from localhost.localdomain ( [113.200.76.118])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 30 May 2023 13:41:14 +0800 (CST)
X-QQ-SSF: 01400000000000C0G000000A0000000
X-QQ-FEAT: PS+4EKbh/3VZTNl+WF0Ulx8rF2kdMZTaIGg+lfwFXeZiDc6oH2S0wgU89BjFP
        rCqq6AvDHYPbw+HNpVuhqTmPHMwubMkdIo8LtPyCm9lFno97ZHDK7gsgMfm/tWhmaZ2KqG/
        YpaPLFcQpE8GFWE0zxBwJniQ5xRRRGfBgZwEpc6XQflGX5jfdtJccWzfV6SXeRqZ16CjQzq
        +aYhMM4S25LNNaWQjvaVCVhNFbLy5WHlBFFbl8eAIuv7paJPofUqWjW9FX/Xrs/JoAF66qs
        tg2DhrSPlive+B6sgkcJt4ukG0nOAbCVaEJ2K/PeKz3pY+ddJtByzHcuwh+ppXTJhzFPxiU
        sDtxJxIM12TvaZv+6UUWr8mUuZHZw==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13327520248541452959
From:   gouhao@uniontech.com
To:     johannes.thumshirn@wdc.com
Cc:     agruenba@redhat.com, axboe@kernel.dk, cluster-devel@redhat.com,
        damien.lemoal@opensource.wdc.com, damien.lemoal@wdc.com,
        dm-devel@redhat.com, hare@suse.de, hch@lst.de,
        jfs-discussion@lists.sourceforge.net, kch@nvidia.com,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-raid@vger.kernel.org,
        ming.lei@redhat.com, rpeterso@redhat.com, shaggy@kernel.org,
        snitzer@kernel.org, song@kernel.org, willy@infradead.org
Subject: Re:[PATCH v5 04/20] fs: buffer: use __bio_add_page to add single page to bio
Date:   Tue, 30 May 2023 13:41:12 +0800
Message-Id: <20230530054112.29389-1-gouhao@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230502101934.24901-5-johannes.thumshirn@wdc.com>
References: <20230502101934.24901-5-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz7a-0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


