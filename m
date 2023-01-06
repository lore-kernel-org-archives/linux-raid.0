Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 525E0C4708E
	for <linux-raid@archiver.kernel.org>; Fri,  6 Jan 2023 01:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbjAFBCP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Jan 2023 20:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbjAFBB6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 Jan 2023 20:01:58 -0500
Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A73353734
        for <linux-raid@vger.kernel.org>; Thu,  5 Jan 2023 17:01:57 -0800 (PST)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 3302B2920D;
        Thu,  5 Jan 2023 20:01:56 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 9DE40A823C; Thu,  5 Jan 2023 20:01:55 -0500 (EST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <25527.29443.610761.668848@quad.stoffel.home>
Date:   Thu, 5 Jan 2023 20:01:55 -0500
From:   "John Stoffel" <john@stoffel.org>
To:     Liam Zeng <zqwliam@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [bug] Hi, need your help about raid1 causing kernel panic!
In-Reply-To: <CAMmbgcZADtyYp0xsu7qtiXL7hNZNex-OumCf+QFj81ZF9ZfYsw@mail.gmail.com>
References: <CAMmbgcZADtyYp0xsu7qtiXL7hNZNex-OumCf+QFj81ZF9ZfYsw@mail.gmail.com>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Liam" == Liam Zeng <zqwliam@gmail.com> writes:

> Hope you kindly forgive my troubles. I have worked with a bug for
> several days, and I really need your help, even a kind
> encouragement.

You need to provide more details.  What is your disk setup, what is
your OS base, etc.  

> here's some informations
> kernel version: 5.10.107

Is this is a vendor kernel or your own self-compiled one?  And if so,
can you move to the latest 6.x kernel instead?  

> cpu arch: arm64

> the system install on /dev/md9, which make up of raid1 of two disks;

More details on this setup.  Type of disks, their connectivity to the
system, etc. 

> the bug: every time I transfer files (50G file, using samba or ftp),
> the system will break down.

Does it break if you copy the file on the system?  Do you have enough
disk space to copy a 10g file from one directory to another on the
same RAID1 setup?  

Which filesystem are you using?

> I have not modified any code of md.

Good to know.

> And the attachment is the log.

Sorry, I'm not going to bother decoding it.  Just attach it as plain
text instead please.  


> I would appreciate any reply!
> [DELETED ATTACHMENT kernel_panic_log, Untyped binary data]
