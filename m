Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D17CC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 12:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344309AbjJaMjT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Oct 2023 08:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344293AbjJaMjS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Oct 2023 08:39:18 -0400
Received: from hoggar.fisica.ufpr.br (hoggar.fisica.ufpr.br [IPv6:2801:82:80ff:7fff::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9147BB
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 05:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=fisica.ufpr.br;
        s=201705; t=1698755947;
        bh=3xR9Mrez8Sfb06GBDqAAJwQIJBA+u1YvBhd3J1ycphY=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=HTkX5qG5cBMYBHo0DvlDMlz4vN42tTW3kGgYLeDFtViRpMv6X8iQruX6hv5cm4055
         eLNlp7dmPuojTkhOsnb6nYHInVzxyhJBRtqvV5zv/+3ZJzpx1ZZfSq3DJCvuXD8F4Q
         uO+aMKDudn1GSHrY0YATGc5Q3MeafDTVqRmhU/fm468ReSdkwQfJZMXT8ap7RjNYJh
         AZFAOB4MB4vDYDOW4tfLtFoHHb0uajFKjR3/FpDR9MHpp7+rPnpuTy2sGABkZfSqRN
         WPOOCdee0t6vN6HKjcgrFhCk1oMDb9bTt8AuR5+0/GZ8HuD+db9e6LLdh1dhXULJE3
         gjSo8wly8HUdw==
Received: by hoggar.fisica.ufpr.br (Postfix, from userid 577)
        id 80A8736202D3; Tue, 31 Oct 2023 09:39:07 -0300 (-03)
Date:   Tue, 31 Oct 2023 09:39:07 -0300
From:   Carlos Carvalho <carlos@fisica.ufpr.br>
To:     linux-raid@vger.kernel.org
Subject: Re: problem with recovered array
Message-ID: <ZUD1axirvgJVdG2-@fisica.ufpr.br>
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
 <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

eyal@eyal.emu.id.au (eyal@eyal.emu.id.au) wrote on Tue, Oct 31, 2023 at 06:29:14AM -03:
> More evidence that the problem relates to the cache not flushed to disk.

Yes.

> It seems that the array is slow to sync files somehow. Mythtv has no problems because it write
> only a few large files. rsync copies a very large number of small files which somehow triggers
> the problem.

Mee too. Writing few files works fine, the problem happens when many files need
flushing. That's why expanding the kernel tree blocks the machine. After many
hours it either crashes or I have to do a hard reboot because all service
stops.

It also happens with 6.1 but 6.5 is a lot more susceptible. Further, the longer
the uptime the more prone to deadlock the machine becomes...
