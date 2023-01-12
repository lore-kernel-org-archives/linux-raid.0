Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666BAC54EBE
	for <linux-raid@archiver.kernel.org>; Thu, 12 Jan 2023 19:12:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbjALTMn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Jan 2023 14:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240403AbjALTLx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 Jan 2023 14:11:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9FA14011
        for <linux-raid@vger.kernel.org>; Thu, 12 Jan 2023 10:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A51CACE1FA8
        for <linux-raid@vger.kernel.org>; Thu, 12 Jan 2023 18:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FB5C433F1
        for <linux-raid@vger.kernel.org>; Thu, 12 Jan 2023 18:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673549896;
        bh=GOTGac7jzkBq9m9manlIDsXasTqD7aG5YTFCBPqfMag=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=sdaMyuRAyB6vuO3qv3Q/MMO1g4nOBCIRwiZazh/hWCExBD0N866Dknei6/PZiOpfu
         QfnTSLW+B/5GDGLbQjM0tVLE2X+o62RvVq5X+Pl5Zmw/U1ZjhfrTt0S75G6Kr9KTmB
         7FQ7bSYBZXV6t9HjHO3JT2MVIvycgTH7aY8LQxWNBYygbHbjRZ5ckcrWbY3XxUfm6k
         OfWtk9W7Z5M9IRBrmzUXuea2yOWKo9SDPZi9FsLU0zc8dBhJYeHKBy9/ROhgwN+7TM
         TTrXnwiPMdbezL152GXTrPNNnPMnJB1AF2D3uY/YdJ66E3HezVh+Bv0TXQG25/a7Kk
         fuf81/0j3qrLg==
Received: by mail-lj1-f170.google.com with SMTP id f20so20325443lja.4
        for <linux-raid@vger.kernel.org>; Thu, 12 Jan 2023 10:58:16 -0800 (PST)
X-Gm-Message-State: AFqh2kphAJS/N6TcPNcb87hhSUEeBYbvPBWSJnLVo6OIOTL2gpGYwPv6
        CUyAaLebbW4hUjAUKtkG/2GJhG61PdR/AAecMSw=
X-Google-Smtp-Source: AMrXdXvXv5wjVpFK2yPNzbHNE0k565FUduol1nlcLwY0ipVvS8314wNwpVeD1IZAtx9b9xZDQeVoD3qPgfGKsMh1/vg=
X-Received: by 2002:a2e:9382:0:b0:284:b05a:9e82 with SMTP id
 g2-20020a2e9382000000b00284b05a9e82mr1118632ljh.479.1673549894840; Thu, 12
 Jan 2023 10:58:14 -0800 (PST)
MIME-Version: 1.0
References: <20230110014512.19233-1-adrianhuang0701@gmail.com> <20230110064800.GA10262@lst.de>
In-Reply-To: <20230110064800.GA10262@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 12 Jan 2023 10:58:02 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4qy42YikvoxsMMBz+wohhEzAfGbDB6VJak+gg_H09ocA@mail.gmail.com>
Message-ID: <CAPhsuW4qy42YikvoxsMMBz+wohhEzAfGbDB6VJak+gg_H09ocA@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: fix incorrect declaration about claim_rdev in md_import_device
To:     Christoph Hellwig <hch@lst.de>
Cc:     Adrian Huang <adrianhuang0701@gmail.com>,
        linux-raid@vger.kernel.org, Adrian Huang <ahuang12@lenovo.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 9, 2023 at 10:48 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Applied to md-fixes. Thanks!

Song
