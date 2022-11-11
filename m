Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40920C4332F
	for <linux-raid@archiver.kernel.org>; Fri, 11 Nov 2022 15:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiKKPNy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Nov 2022 10:13:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbiKKPN0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 11 Nov 2022 10:13:26 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09AFAD2F6
        for <linux-raid@vger.kernel.org>; Fri, 11 Nov 2022 07:10:51 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id y16so6825941wrt.12
        for <linux-raid@vger.kernel.org>; Fri, 11 Nov 2022 07:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2trOvj/3SfcG+oOdNg6hiro9gUpItBxGO0yqCGKuhoU=;
        b=EW9xRvLROo56fLX2norQE52Xptt5IDbe7hguoSea65gr24ZvRNR8McwlWVn7XcV65O
         jR4BWmKCAKus6pmGWZb8UcuHgJT51IHupTTM+VrwX4nwVwcILLq6G20TKMKudQNetay4
         VNBTHQErmn9n9fNeK0q2rlx4qvG0ZRP1D02IR0J+3Yd8ZOvaVpO3wyT7vcfVpp8AvBVg
         RAbm2f3oop3NIT+U92yVUNjdX8W6kocwi5jafD1o/1x2bbPN5jdwZnw8mrURaupkGK1q
         yrpphDkre9DVVCqZb3lgVcs35C+jmFp63OVUTkq7xARMu7SeceRXsSkYFxzbihwtRm17
         tbog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:date:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2trOvj/3SfcG+oOdNg6hiro9gUpItBxGO0yqCGKuhoU=;
        b=T3YatGcPqpvzHzUyDmnV02dJG4FTEUwosDZOc2DtJouvOTk/S2IMXQbbg19zxMc8k/
         vc5vrhSvqBFM6VxJ8tIu5ngESwbP2N7xioKxXWH6fklOqOgIauPDG8d1a9TADSnWykGv
         zwW975EEm+6rZmavi1q79LDQDOXGBLuxmAolDlZRZuEd5l+SdZZMfTUDWUtWH0Sf0qGY
         C01JL0b1ZUUiZtOb7f7/HVI8A08P7L1JRdP0zz1KKGbOjZTHuaFlzG5hOV9B1A/sDTpM
         qCU7qJPTdzdm8YNSiYI+jN2JM8daIo71dqQqJk9ne1Feop+UN4tpM28EjjDm4ypgJLu+
         Nzmg==
X-Gm-Message-State: ANoB5plFEV6dL7mLpVgQ3wiEQ+YNX0MoyXe+ztUY/tVd8r8wYojqCV6a
        u0zYbdMVrhr2nObOPVhdu5VsnzgAOWc=
X-Google-Smtp-Source: AA0mqf46iE+69J2YAl1A2jTu88SQG9WeBpTstz+2LK4yk6s2GVrTbODbVw/KvkvcT16nqN4KmtMSrQ==
X-Received: by 2002:a5d:550a:0:b0:236:cfcf:8e78 with SMTP id b10-20020a5d550a000000b00236cfcf8e78mr1567165wrv.614.1668179449474;
        Fri, 11 Nov 2022 07:10:49 -0800 (PST)
Received: from Debian-Ideapad-WilsonJ.lan ([213.31.80.11])
        by smtp.gmail.com with ESMTPSA id y13-20020a5d620d000000b0022cce7689d3sm2640242wru.36.2022.11.11.07.10.48
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 07:10:48 -0800 (PST)
Message-ID: <64eabe28c77a488e3c36839b7614770f9be7d389.camel@gmail.com>
Subject: Kernel crash, possibly raid, and dump but no log available as
 shutdown.
From:   Wilson Jonathan <i400sjon@gmail.com>
To:     linux-raid@vger.kernel.org
Date:   Fri, 11 Nov 2022 15:10:47 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.1-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I have been suffering from a crash and dump for some time now when
shutting down my AMD Threadripper TR4 system.

I think, but am not entirely sure, that the issue is with software
raid.

The system does its usual shut down tasks and then somewhere between
shutting down the virtual machines (none of which were running/had been
started) and the disks doing their shutdowns (not sure what to call it,
but its nearly the last thing that happens before power off but it
mentions each disk) I get a crash dump to the console.

The only camera I have is on a really cheap phone, and its so bad that
I can't pause the scrolling video (or the video is out of focus because
it loses focus when the screen blanks before the output) to see what
the error messages are because its just a blur.

Is there anyway to get/print/transmit the log in real time to some
external "thing" such as another pc on the network as by the time the
crash happens the array (with the log files) must be down because there
is nothing in the log files. No errors, shutdown messages, or shutdown
log (is there even such a thing as a shutdown log?).

Normally when something like this happens (which is increasingly rare)
I just let it ride and usualy some new kernel eventually fixes it. The
problem doesn't seem to corrupt anything so where ever the issue is
(mdadm or otherwise) its not a huge deal... just I'd like it to stop
because I hate seeing the crash dump and thinking "oh, there it goes
again".=C2=A0

This has been happening for at least 6-12 months (give or take) so its
a long standing issue. (PS its debian testing/bookworm but the same
issue happened with bullseye.)

I guess if there is no such thing as re-directing the output to a
network device, is it possible to move the log files to a non-raid
device or an external usb? Does debian even have a shutdown log file?

Thanks in advance, Jon.
