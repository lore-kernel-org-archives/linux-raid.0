Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC9AC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 14 Dec 2021 17:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbhLNRrG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Dec 2021 12:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbhLNRrE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Dec 2021 12:47:04 -0500
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C557DC061574
        for <linux-raid@vger.kernel.org>; Tue, 14 Dec 2021 09:47:03 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id B5C2F5F3;
        Tue, 14 Dec 2021 17:46:59 +0000 (UTC)
Date:   Tue, 14 Dec 2021 22:46:58 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Debugging system hangs
Message-ID: <20211214224658.26cea5a0@nvm>
In-Reply-To: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 14 Dec 2021 15:54:50 +0000
Wols Lists <antlists@youngman.org.uk> wrote:

> Don't know if this is off-topic or not, seeing as my system is very much 
> reliant on raid ...
> 
> But basically I'm seeing the system just stop responding. Typically it's 
> in screensaver mode, I've got a blank screen, and it won't wake up. (I 
> used to think it was something to do with Thunderbird, it mostly 
> happened while TB was hammering the system, but no ...)
> 
> Today, I had it happen while the system was idle but not in screensaver, 
> I run xosview, and everything was clearly frozen - including xosview.
> 
> As you might know, my stack is ext4 over lvm (over raid over 
> dm-integrity for /home) over spinning rust.
> 
> And I run gentoo/systemd - currently on the latest stable kernel afaik, 
> 5.10.76-gentoo-r1 SMP x86_64.
> 
> Any advice on how to debug a hang - basically I need something that'll 
> just sit there so when it crashes (and I press the reset button to 
> recover) I'll have some sort of trace. It would be nice to prove it's 
> not the disk stack at fault ...
> 
> Obviously, "set these options in the kernel" won't faze me ...

Set up "netconsole":
https://www.kernel.org/doc/html/latest/networking/netconsole.html
https://wiki.ubuntu.com/Kernel/Netconsole

-- 
With respect,
Roman
