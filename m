Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3BEBC433C1
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 17:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 975C46196E
	for <linux-raid@archiver.kernel.org>; Mon, 22 Mar 2021 17:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhCVRkF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Mar 2021 13:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhCVRjm (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 22 Mar 2021 13:39:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D518B6196E;
        Mon, 22 Mar 2021 17:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616434782;
        bh=UHcNT/4il5tW9mXoc6ARPr050wPN1fj+Adjar4kkzQ8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eWfsJUJEs/trJlTX/faIgFkAz6YcDAWG330R2dk4YtY9La66+aH9KHuPsP7wRxW6u
         oYWGEnRfBbCRwR8ceew7F7OWv8Ev473MWWgCXY76dBEQslXpM8c0P/r3G+Beux8R8j
         lUcIbIo5RqAfj634EBAF39+WX0jL92LN2Gd+jmx4pX9qEA/YsHtOkwxwcjV2iyawpC
         XtrA21jFeJgT8/z1SW4aJljKOZdCumzLVOn4rzMMSwQxztrYeuYpNEhhABwi//cmiR
         J0ZKtbODXsEuTZ8VR4706BkwEkd+jYHs/8FoTOx0upF0cK63NR6dWJRASXpbtnMK/3
         RYGFSSnwwVg1Q==
Received: by mail-lf1-f43.google.com with SMTP id b83so22573327lfd.11;
        Mon, 22 Mar 2021 10:39:41 -0700 (PDT)
X-Gm-Message-State: AOAM532Cml84bqRA5c7IugNaub8JAqP+SjW23I3ZksNIFtSN/kseFKC0
        FqHrTLRPLxgKjJa3H9+BkH0fWksOGmHrSt6nFbg=
X-Google-Smtp-Source: ABdhPJxdclH7/avq0aq5xv5V9fgj0Lg9SK6yFk0d3yqRW3mIZTfJHoz5zEgQOMqu8Ieb/eiGxgvTentXZJYdPZ9HgxU=
X-Received: by 2002:ac2:5dcf:: with SMTP id x15mr260735lfq.176.1616434780144;
 Mon, 22 Mar 2021 10:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210317140439.9499-1-jglauber@digitalocean.com>
In-Reply-To: <20210317140439.9499-1-jglauber@digitalocean.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 22 Mar 2021 10:39:29 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6S7NOu-U+m9Cxt4gf3NLFZocHqB3eV_rgnoeVnxeCTfQ@mail.gmail.com>
Message-ID: <CAPhsuW6S7NOu-U+m9Cxt4gf3NLFZocHqB3eV_rgnoeVnxeCTfQ@mail.gmail.com>
Subject: Re: [PATCH] md: Fix missing unused status line of /proc/mdstat
To:     Jan Glauber <jglauber@digitalocean.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Mar 17, 2021 at 7:05 AM Jan Glauber <jglauber@digitalocean.com> wrote:
>
> Reading /proc/mdstat with a read buffer size that would not
> fit the unused status line in the first read will skip this
> line from the output.
>
> So 'dd if=/proc/mdstat bs=64 2>/dev/null' will not print something
> like: unused devices: <none>
>
> Don't return NULL immediately in start() for v=2 but call
> show() once to print the status line also for multiple reads.
>
> Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
> Signed-off-by: Jan Glauber <jglauber@digitalocean.com>

Applied to md-next. Thanks!
Song
