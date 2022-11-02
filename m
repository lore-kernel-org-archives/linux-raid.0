Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14261C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  2 Nov 2022 02:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiKBCRW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Nov 2022 22:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiKBCRV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 1 Nov 2022 22:17:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D831F2C5
        for <linux-raid@vger.kernel.org>; Tue,  1 Nov 2022 19:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667355382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jWgA/j6CMHMMP5TuMJNXbPgOIIF0ZwJaJ0LAlcLgDGU=;
        b=ZzM0zhoJW3cWHJYevFVHVLFARTPbyVpo02CUnYPCeTV0jz+6WTx4XaJUn62Wb+yvk66+z+
        6fTaXHboIXi2+xwMpjDJKgbbgHDPTX8oYCgVb1d837RigFuh3qi4+HmBbucQXkyrqaaWbR
        fCpIABQaKVoDyzxOe6D0Q8fxuxNLIXQ=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-477-lNNYKfpnM8-FD3YeOrJ8rg-1; Tue, 01 Nov 2022 22:16:20 -0400
X-MC-Unique: lNNYKfpnM8-FD3YeOrJ8rg-1
Received: by mail-vk1-f198.google.com with SMTP id d137-20020a1fb48f000000b003b81c572136so1965783vkf.9
        for <linux-raid@vger.kernel.org>; Tue, 01 Nov 2022 19:16:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jWgA/j6CMHMMP5TuMJNXbPgOIIF0ZwJaJ0LAlcLgDGU=;
        b=wfl6dtf3zcDp66wCs57wcrlk/2ivDU94jhVdxvZYta7dtZMrGs9Gv3BtVS4W0Rq9w/
         Uz8pSn/+WB4tN3QIncdKxA35qyf1FsBYM+1aZDZkSr7G3UcDEq8lCknw5W+PS9uEtiml
         TvpKPKfEqhUaBA1RHv+uENHUlVwILrtAn6rYtePVunvU1VGFLUYuFLptoL0JOiQgVwLR
         AqGE5hH7HilUGziAiypO4oCmc+w322HUUNfTvb4aYpDi+KyCUSas4rQ4d28v4/6OKK8/
         uKAfcjDR9R+/5bbYeqtgg3CIbjNCbWcl2vJBiX/rYk8BNsYZOIOlFK+mmYD9FG4ObEu1
         FzrQ==
X-Gm-Message-State: ACrzQf33XAoTg27pKNpvHxxDgH6vpKHwkiOLOJ6oqR/XKHSdVqF9+dDK
        Ua3WDY4Sv3wEtQdDHAF1iCNFSuNvGS1lgeaenpBYgCKuGn53yDazjMLVRrBS+74W6R3vu80yrMi
        hGsABmaS8cs5411Y2TvNQIkhOfXcec9+YjomHAw==
X-Received: by 2002:ab0:1c52:0:b0:401:762b:f888 with SMTP id o18-20020ab01c52000000b00401762bf888mr7292088uaj.57.1667355380281;
        Tue, 01 Nov 2022 19:16:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM57KbOE3rA1HeNUHhHndiAHiRAF0EDvXD5WtdLaTIkBFIOzWpY1OD7/GimbIvIsMA6qeZeIazu/mgJxEvAfdbc=
X-Received: by 2002:ab0:1c52:0:b0:401:762b:f888 with SMTP id
 o18-20020ab01c52000000b00401762bf888mr7292081uaj.57.1667355380066; Tue, 01
 Nov 2022 19:16:20 -0700 (PDT)
MIME-Version: 1.0
References: <20221102020730.23815-1-xni@redhat.com>
In-Reply-To: <20221102020730.23815-1-xni@redhat.com>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Wed, 2 Nov 2022 10:16:09 +0800
Message-ID: <CAFj5m9K8DiVz+KEOpO9NzYgjT=86NaFUOcZmL7eV0_5ni8_BQw@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] md/raid0, raid10: Don't set discard sectors for
 request queue
To:     Xiao Ni <xni@redhat.com>
Cc:     song@kernel.org, yi.zhang@redhat.com, ncroxon@redhat.com,
        linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 2, 2022 at 10:07 AM Xiao Ni <xni@redhat.com> wrote:
>
> It should use disk_stack_limits to get a proper max_discard_sectors
> rather than setting a value by stack drivers.
>
> And there is a bug. If all member disks are rotational devices,
> raid0/raid10 set max_discard_sectors. So the member devices are
> not ssd/nvme, but raid0/raid10 export the wrong value. It reports
> warning messages in function __blkdev_issue_discard when mkfs.xfs
> like this:
>
> [ 4616.022599] ------------[ cut here ]------------
> [ 4616.027779] WARNING: CPU: 4 PID: 99634 at block/blk-lib.c:50 __blkdev_issue_discard+0x16a/0x1a0
> [ 4616.140663] RIP: 0010:__blkdev_issue_discard+0x16a/0x1a0
> [ 4616.146601] Code: 24 4c 89 20 31 c0 e9 fe fe ff ff c1 e8 09 8d 48 ff 4c 89 f0 4c 09 e8 48 85 c1 0f 84 55 ff ff ff b8 ea ff ff ff e9 df fe ff ff <0f> 0b 48 8d 74 24 08 e8 ea d6 00 00 48 c7 c6 20 1e 89 ab 48 c7 c7
> [ 4616.167567] RSP: 0018:ffffaab88cbffca8 EFLAGS: 00010246
> [ 4616.173406] RAX: ffff9ba1f9e44678 RBX: 0000000000000000 RCX: ffff9ba1c9792080
> [ 4616.181376] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ba1c9792080
> [ 4616.189345] RBP: 0000000000000cc0 R08: ffffaab88cbffd10 R09: 0000000000000000
> [ 4616.197317] R10: 0000000000000012 R11: 0000000000000000 R12: 0000000000000000
> [ 4616.205288] R13: 0000000000400000 R14: 0000000000000cc0 R15: ffff9ba1c9792080
> [ 4616.213259] FS:  00007f9a5534e980(0000) GS:ffff9ba1b7c80000(0000) knlGS:0000000000000000
> [ 4616.222298] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4616.228719] CR2: 000055a390a4c518 CR3: 0000000123e40006 CR4: 00000000001706e0
> [ 4616.236689] Call Trace:
> [ 4616.239428]  blkdev_issue_discard+0x52/0xb0
> [ 4616.244108]  blkdev_common_ioctl+0x43c/0xa00
> [ 4616.248883]  blkdev_ioctl+0x116/0x280
> [ 4616.252977]  __x64_sys_ioctl+0x8a/0xc0
> [ 4616.257163]  do_syscall_64+0x5c/0x90
> [ 4616.261164]  ? handle_mm_fault+0xc5/0x2a0
> [ 4616.265652]  ? do_user_addr_fault+0x1d8/0x690
> [ 4616.270527]  ? do_syscall_64+0x69/0x90
> [ 4616.274717]  ? exc_page_fault+0x62/0x150
> [ 4616.279097]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [ 4616.284748] RIP: 0033:0x7f9a55398c6b
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> Reported-by: Yi Zhang <yi.zhang@redhat.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

