Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB44C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 15 Dec 2021 16:45:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244972AbhLOQp7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Dec 2021 11:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhLOQp6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Dec 2021 11:45:58 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80742C061574
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 08:45:58 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id q14so22391496qtx.10
        for <linux-raid@vger.kernel.org>; Wed, 15 Dec 2021 08:45:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JKYwOuiD5aSSKclu6WANgCs8Yzk6v+1DTaFFtROAqfo=;
        b=a2t9DvC4llNRUgfY1p+MnTvBR71/MpxcQGdKn6DcrkjtfULmzdcYJ11h11HD2LEMFh
         GxKY14ZCUveWMitaA43ioJmL3lxNNf2CGvVLsdNXfizZChMuzAKiwZNyFjRDVulA5JxD
         MQ6AnE8raXKoNprZX8Qr7vlm/dM07LaZtseUAM24IpUW/daGodtw7nU0Z3P8ls0Sn8FE
         oUsL8YyTvIJyJwm1avlU5PuXkJ6SWTrz70jXAn2g/UfbiTNKk87PtVQkcqJPnyjxhycO
         tRHZA1jkAI0XG7CzmwSEfb0rXUcsCM8jIe+85JoTbjiaG8aDwgmR9isOX+DN8HfzENXt
         bEng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JKYwOuiD5aSSKclu6WANgCs8Yzk6v+1DTaFFtROAqfo=;
        b=p/xe5TAZ6tyczlA/CnpHb9RvqODy6MZ6fSf7hqhq5uk9a2aQP7B4Pq5rfhxz58iwpX
         Id5g0SMBu+mxrKJQx3kgeOFJ6PmgJHYWeVuwdDfHAE0sezkTQ4pplfrkxeq6u+BD8W+n
         69ZHcNjBO3OtrkC0C7dTLumLRBHdTzxpaDWrx6h8CtJghvQ93KnsyLmFC1mIlFVO52+o
         oKNpH38xzozlcBVe6zT8oMcq6UBQLSHCj9j4eYwdKatTf19gO9ReLL7EmuGdKSIQatOf
         oSfGkuMkPfEgywkDGHk4pgj1VIFSpmkx8BUGYVZ8NmG5NpN3wXuTHPQaVNVubD2BtuLL
         7bQg==
X-Gm-Message-State: AOAM533SdOsN8KP/xIR20adxSw2K7djtTtvEWeMqUeWdaLGpXtiO4iq0
        ActQNsQ3a6wQs5r2ifmFpzV20MMopi7h2yk+NRqNY8sX
X-Google-Smtp-Source: ABdhPJzlHqMB0ITdNR7NQIUd4gUtDXDfmxgov72llYL6wPpYA0uJCw88Wrsd4hMYL62tVWf1xeyDVGnV1iznpNPiDWU=
X-Received: by 2002:ac8:7f4b:: with SMTP id g11mr1691398qtk.4.1639586757637;
 Wed, 15 Dec 2021 08:45:57 -0800 (PST)
MIME-Version: 1.0
References: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
In-Reply-To: <d8a0d8c9-f8cc-a70a-03a0-aae2fd6c68c2@youngman.org.uk>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 15 Dec 2021 10:45:46 -0600
Message-ID: <CAAMCDeekr+a6e7BwyF9b=n49X6YgqUWBc8UtAyZkjFcHBnbyRQ@mail.gmail.com>
Subject: Re: Debugging system hangs
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If you cannot login to the machine via ssh, also try pinging it.  If
ping works but ssh does not either ssh died, or the machine is paging
so heavily that user space cannot respond in a reasonable time.

If the disk were an issue there should be messages about something in
the disk layer timing out, but it sounds like there aren't any of
those sorts of messages.  If it was a controller hardware/pci slot/hw
issue that will in some cases cause an immediate power cycle and boot
back up.

You might also configure kdump, there should be doc's someplace on
configuring it for your distribution, once configured then test it
with "echo c > /proc/sysrq-trigger" and that should crash the machine
and leave you with a kernel core dump + dmesg from the time of the
crash.   Also if kdump is configured and working it will crash/dump
memory and typically boot back up automatically.

On Wed, Dec 15, 2021 at 3:54 AM Wols Lists <antlists@youngman.org.uk> wrote:
>
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
>
> Cheers,
> Wol
