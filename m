Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD328E7F124
	for <linux-raid@archiver.kernel.org>; Tue, 26 Sep 2023 20:27:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbjIZU2C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Sep 2023 16:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234911AbjIZU2B (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Sep 2023 16:28:01 -0400
Received: from mail.ultracoder.org (unknown [188.227.94.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A47912A
        for <linux-raid@vger.kernel.org>; Tue, 26 Sep 2023 13:27:53 -0700 (PDT)
Message-ID: <7c0bc9ff-767c-c1a7-49ab-37312a0fe803@ultracoder.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ultracoder.org;
        s=mail; t=1695760070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YOPBgMwKx+h+YpKL2ZjQpEHN9Z0g2fgJVUO8Rd+K6uI=;
        b=bdgaDpBGMKQtSIuWddScP0GPe3VDvlZyB/3127giQPXV5TNG2L3iXtYFr17NfjGBrP3iNi
        KEjLsCuF5bWvkzbZ36hKebjaATMnNPU/c21oFRDraOFu9yeqctbjgvkR5SMN+JQLRkFV3d
        an1QOC+TmQEuJMto0kCjfvoiL7khHKxhVsxKQ5viYgxlxdCjKbHQxGkMbeFbXDh20YqF8f
        Sek38Hn+HMsk4GxaVbRFXx4KIve/MuuyNGODmtp4LHwetV1e2UJExNxWbufO+BeRJEBGkF
        PggXb9S2ouDFh1y0JVjrxvykfh/ga01l+q8Pfmqr1MN00EAn7y6EZqFuSZOORg==
Date:   Tue, 26 Sep 2023 23:27:50 +0300
MIME-Version: 1.0
Subject: Re: fstrim on raid1 LV with writemostly PV leads to system freeze
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
 <6b7c6377-c4be-a1bc-d05d-37680175f84c@huaweicloud.com>
 <6a1165f7-c792-c054-b8f0-1ad4f7b8ae01@ultracoder.org>
 <d45ffbcd-cf55-f07c-c406-0cf762a4b4ec@huaweicloud.com>
 <a4d3f9b0-15d5-4a90-f2c1-cad633badbbf@ultracoder.org>
 <3bc0af74-95cd-e175-830c-6030a768e64f@huaweicloud.com>
Content-Language: ru-RU, en-US
From:   Kirill Kirilenko <kirill@ultracoder.org>
In-Reply-To: <3bc0af74-95cd-e175-830c-6030a768e64f@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 26.09.2023 16:21 +0300, Yu Kuai wrote:
> This means cpu is busy with something, in this case you must use top or
> perf to figure out what all your cpus are doing, probably issue io and
> handle io interrupt.

OK, here is the last output of 'perf top -d 1' before system froze:

4.00%  [kernel]  ledtrig_disk_activity
3.86%  [kernel]  led_trigger_blink_oneshot
1.93%  [kernel]  read_tsc
1.68%  perf      hist_entry__sort
1.62%  [kernel]  menu_select
1.57%  [kernel]  psi_group_change
1.19%  [kernel]  native_sched_clock
0.96%  [kernel]  scsi_complete
0.94%  [kernel]  __raw_spin_lock_irqsave
0.80%  perf      perf_hpp__is_dynamic_entry
...

And here is the last output of 'top':

load average: 1.48, 0.90, 0.38
%Cpu(s): 0.1 us, 0.1 sy, 0.0 ni, 93.5 id, 6.3 wa, 0.0 hi, 0.1 si, 0.0 st
MiB Mem:  32005.3 total, 29138.3 free, 1327.0 used,   1540.0 buff/cache
MiB Swap: 16382.0 total, 16382.0 free,    0.0 used.  30244.5 avail Mem
S %CPU COMMAND
S 0.7  [mdX_raid1]
S 0.7  cinnamon --replace
I 0.3  [kworker/u64:2-events_unbound]
I 0.3  [kworker/u64:6-events_freezable_power_]
S 0.3  [gfx_low]
S 0.3  /usr/bin/containerd
S 0.3  /usr/lib/xorg/Xorg -core :0 ...
S 0.3  /usr/libexec/gnome-terminal-server
R 0.3  top
D 0.3  fstrim /home
...

I think, there are only two possibilities: either CPU is not that busy,
or it gets busy very quickly, so we can not see it like that. I have no
experience in kernel debugging. Maybe someone knows, how I can get
more accurate data when system freezes?

On 26.09.2023 16:21 +0300, Yu Kuai wrote:
> I'm not sure what 'disk activity indicator goes off' means

It means, the LED on my computer case, indicating disk activity, goes off.
According to 'perf' output, LED control is the largest contributor to
CPU load. :)
