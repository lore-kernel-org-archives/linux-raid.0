Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26F2FC4332F
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 19:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjJaTUT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Oct 2023 15:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjJaTUT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Oct 2023 15:20:19 -0400
Received: from hoggar.fisica.ufpr.br (hoggar.fisica.ufpr.br [IPv6:2801:82:80ff:7fff::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A35991
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 12:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=fisica.ufpr.br;
        s=201705; t=1698780006;
        bh=lMTpwRuiqr52tKBJEqaeB8vOTYcnzk/9pioa6S7JgiM=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=NKtZSnYkYIW3/4ZTJ9HqpxVj2eqBixiZ/I2CZH3usxWk0J78U36GuHzTm00GhLA1c
         g0APwjcOPDCVBTMcY3ldSxar/H1U0r7WoWg112RZgNcXO7vAwiqHn95wV0IDTF+UnD
         SbPEuFUjv8hKq5J1hNt3KhyAOpg0f10jhw+j0YxB+VINAC3g4rsaWAGcM2AIQMjV+t
         O7+8ljO2fxQUip2u3WHqY/tbPw+TEtgr+307aJDWcTmHmrncnqWVuTMCgp9l/3k9wi
         t4LQkvfUJFfEl/UR+oUUB+DAImjNk8+4bMHJj8K7QVBCiiC8tFs8VqN7bl5sAeV4MY
         tqGd6H2uN74CQ==
Received: by hoggar.fisica.ufpr.br (Postfix, from userid 577)
        id D021436202D3; Tue, 31 Oct 2023 16:20:06 -0300 (-03)
Date:   Tue, 31 Oct 2023 16:20:06 -0300
From:   Carlos Carvalho <carlos@fisica.ufpr.br>
To:     linux-raid@vger.kernel.org
Subject: Re: problem with recovered array
Message-ID: <ZUFTZnuylkjHNeHu@fisica.ufpr.br>
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
 <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <ZUD1axirvgJVdG2-@fisica.ufpr.br>
 <CAAMCDed1HMxPzRoikxM9L-zi8m4FvGWDg=jXL=NevZ+tkwiogA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAMCDed1HMxPzRoikxM9L-zi8m4FvGWDg=jXL=NevZ+tkwiogA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Roger Heflin (rogerheflin@gmail.com) wrote on Tue, Oct 31, 2023 at 11:19:24AM -03:
> You might also want to look at the io for the sd* devices under the md
> device as that would show what MD is doing under the covers to make
> the io happen (sar and/or iostat).

Exactly. Guess what disks are doing? Nothing! That's the whole point. The
kernel becomes unable to send writes to the disks and the flushd thread remains
using 100% cpu.

Again: this is not an excess of writes that the array cannot cope with. On the
contrary, it's an absence of writes.
