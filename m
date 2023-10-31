Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E720C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 09:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343875AbjJaJ3m (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Oct 2023 05:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343852AbjJaJ3k (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Oct 2023 05:29:40 -0400
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38749C1
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 02:29:38 -0700 (PDT)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4SKPww4Lzlz9QyY
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 20:29:36 +1100 (AEDT)
Received: from [IPV6:2405:6e00:494:92f5:21b:21ff:fe3a:5672] (unknown [IPv6:2405:6e00:494:92f5:21b:21ff:fe3a:5672])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4SKPww1TGxz9QyP
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 20:29:36 +1100 (AEDT)
Message-ID: <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
Date:   Tue, 31 Oct 2023 20:29:14 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   eyal@eyal.emu.id.au
Subject: Re: problem with recovered array
To:     linux-raid@vger.kernel.org
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
Content-Language: en-US
In-Reply-To: <ZUByq7Wg-KFcXctW@fisica.ufpr.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 31/10/2023 14.21, Carlos Carvalho wrote:
> Roger Heflin (rogerheflin@gmail.com) wrote on Mon, Oct 30, 2023 at 01:14:49PM -03:
>> look at  SAR -d output for all the disks in the raid6.   It may be a
>> disk issue (though I suspect not given the 100% cpu show in raid).
>>
>> Clearly something very expensive/deadlockish is happening because of
>> the raid having to rebuild the data from the missing disk, not sure
>> what could be wrong with it.
> 
> This is very similar to what I complained some 3 months ago. For me it happens
> with an array in normal state. sar shows no disk activity yet there are no
> writes to the array (reads happen normally) and the flushd thread uses 100%
> cpu.
> 
> For the latest 6.5.* I can reliably reproduce it with
> % xzcat linux-6.5.tar.xz | tar x -f -
> 
> This leaves the machine with ~1.5GB of dirty pages (as reported by
> /proc/meminfo) that it never manages to write to the array. I've waited for
> several hours to no avail. After a reboot the kernel tree had only about 220MB
> instead of ~1.5GB...

More evidence that the problem relates to the cache not flushed to disk.

If I run 'rsync --fsync ...' it slows it down as the writing is flushed to disk for each file.
But it also evicts it from the cache, so nothing accumulates.
The result is a slower than otherwise copying but it streams with no pauses.

It seems that the array is slow to sync files somehow. Mythtv has no problems because it write
only a few large files. rsync copies a very large number of small files which somehow triggers
the problem.

This is why my 'dd if=/dev/zero of=file-on-array' goes fast without problems.

Just my guess.

BTW I ran fsck on the fs (on the array) and it found no fault.

-- 
Eyal at Home (eyal@eyal.emu.id.au)

