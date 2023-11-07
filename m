Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BD5C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 20:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbjKGUxl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 15:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233924AbjKGUxk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 15:53:40 -0500
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 507B310CC
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 12:53:38 -0800 (PST)
Received: from lists.tip.net.au (pasta.tip.net.au [IPv6:2401:fc00:0:129::2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SQ0ms3QhCz9QS8;
        Wed,  8 Nov 2023 07:53:33 +1100 (AEDT)
Received: from [IPV6:2405:6e00:4ed:cdf7:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:4ed:cdf7:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SQ0kv6C5Wz9RQn;
        Wed,  8 Nov 2023 07:51:51 +1100 (AEDT)
Message-ID: <adfe10d5-84c5-49d4-8884-e9469ace6101@eyal.emu.id.au>
Date:   Wed, 8 Nov 2023 07:51:47 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issues restoring a degraded array
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <CAE1wYva7ArH+=okXPWBG7r7EYj-3_Ph3OM3OXHvGLEHOp+tK-A@mail.gmail.com>
Cc:     Lane Brooks <lane@brooks.nu>
From:   eyal@eyal.emu.id.au
In-Reply-To: <CAE1wYva7ArH+=okXPWBG7r7EYj-3_Ph3OM3OXHvGLEHOp+tK-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 08/11/2023 02.14, Lane Brooks wrote:
> I have a 14 drive RAID5 array with 1 spare. Each drive is a 2TB SSD.
> One of the drives failed. I replaced it, and while it was rebuilding,

Did this stop the rebuilding?

> one of the original drives experienced some read errors and seems to
> have been marked bad. I have since cloned that drive (first using dd

What does "marked bad" mean?
What does 'cat /proc/mdstat' show?

> and the nddrescue), and it clones without any read errors. I think the
> read errors were coming from a faulty SATA cable.
> But now when I run the 'mdadm --assemble --scan' command, I get:
> mdadm: failed to add /dev/sdi to /dev/md/0: Invalid argument
> mdadm: /dev/md/0 assembled from 12 drives and 1 spare - not enough to
> start the array while not clean - consider --force
> mdadm: No arrays foudn in config file or automatically
> 
> The sdi drive is the cloned drive. My googling for the "Invalid
> argument" error have come up dry. Both the original and the cloned
> drive give the same error.

Check the system log. Also, it is possible that the disk now has a different name so make sure it
really is /dev/sdi by examining the serial number. You can look at /dev/disk/by-id to see what it is called now.

HTH

> If I try the --force, I get the same Invalid argument error but also a
> 'not enough operational devices (2/14 failed).
> 
> Any suggestions on how to recover from this situation?
> 
> Lane

-- 
Eyal at Home (eyal@eyal.emu.id.au)

