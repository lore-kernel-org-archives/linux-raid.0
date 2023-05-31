Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41FCBC77B7C
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 04:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbjEaE6g (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 00:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbjEaE6f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 00:58:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845DCEE;
        Tue, 30 May 2023 21:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19460636BB;
        Wed, 31 May 2023 04:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7155BC433AF;
        Wed, 31 May 2023 04:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685509113;
        bh=JBZOocixWDLgxHtO8LMBV75DV/IkdmBnKFJ284Ve6Ug=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NPRYthHFV5Q6hvYrOD3SuDJ7bc3jcwirwiEVUlFtev6MSaaABYammq+Cs/uY0FO2+
         vhBtr9eYwJ3UusESuVNNxH4jzwv4bmGi3n2ga+aQwysq5IoCZanBHAUOmVZoDthS2v
         MWZC+Cyot1N6yNLStBFyiY8AoWj7Q2T9lkJ+ZDOiQg3jALxHDgsLMtawH+N3PT9ePK
         eyL6em9yX50zt7h0E72+ENupjn+mfQwoS/Fyd1YuLD7fn4ly4rOsAqedCh2PPoNIn6
         FKJKhjoLtemhKv4H2GPulhB7WA8ULvz23yGSyJJCGpRqNsUfydJII11BqJ6LnyRxu5
         u1yL2U5/JtQxQ==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so6136020e87.3;
        Tue, 30 May 2023 21:58:33 -0700 (PDT)
X-Gm-Message-State: AC+VfDwQsj6b6oCu0sKfbjRQXVuKhNXql8mkOoe0OoQGdDjPrticKMo+
        vDN55QnrvjHNWSxyzkfiLzccalyuyA7+Vxg3oOw=
X-Google-Smtp-Source: ACHHUZ7XDiYWJcs+q0AXYFH83FpH+4XZaAkwQNLTh6knjyPLIO1LGIR2Y7lAqiqnrlvTJ8gMp4sK/wzuHD8SIBdPb68=
X-Received: by 2002:a2e:a28f:0:b0:2ad:9acb:4849 with SMTP id
 k15-20020a2ea28f000000b002ad9acb4849mr1778554lja.47.1685509111386; Tue, 30
 May 2023 21:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
 <c60c6f46b70c96b528b6c4746918ea87c2a01473.1685461490.git.johannes.thumshirn@wdc.com>
 <20230531042502.GM32705@lst.de>
In-Reply-To: <20230531042502.GM32705@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Tue, 30 May 2023 21:58:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW62vBccjUkCUmYr+OZSLgGozFzX4YyzP8OV+dvsLujCGg@mail.gmail.com>
Message-ID: <CAPhsuW62vBccjUkCUmYr+OZSLgGozFzX4YyzP8OV+dvsLujCGg@mail.gmail.com>
Subject: Re: [PATCH v6 15/20] md: raid1: check if adding pages to resync bio fails
To:     Christoph Hellwig <hch@lst.de>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        dm-devel@redhat.com, linux-raid@vger.kernel.org,
        Mike Snitzer <snitzer@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, gouhao@uniontech.com,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, May 30, 2023 at 9:25=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> To me these look like __bio_add_page candidates, but I guess Song
> preferred it this way?  It'll add a bit pointless boilerplate code,
> but I'm ok with that.

We had some discussion on this in v2, and decided to keep these
assert-like WARN_ON().

Thanks,
Song
