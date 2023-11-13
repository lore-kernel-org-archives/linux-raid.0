Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B67C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 09:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjKMJ7C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Nov 2023 04:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbjKMJ7A (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Nov 2023 04:59:00 -0500
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A0C10D2
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 01:58:56 -0800 (PST)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4STPyl3yBsz9R67
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 20:58:55 +1100 (AEDT)
Received: from [192.168.2.7] (unknown [101.115.9.238])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4STPyl3JTPz9Qyl
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 20:58:55 +1100 (AEDT)
Message-ID: <09d9848d-8ef4-488c-8719-7ad451c9e36b@eyal.emu.id.au>
Date:   Mon, 13 Nov 2023 20:58:55 +1100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: extremely slow writes to array [now not degraded]
Content-Language: en-US
To:     linux-raid@vger.kernel.org
References: <eb9a7323-f955-4b1c-b1c4-7f0723078c42@eyal.emu.id.au>
 <e25d99ef-89e2-4cba-92ae-4bbe1506a1e4@eyal.emu.id.au>
 <CAAMCDedC-Rgrd_7R8kpzA5CV1nA_mZaibUL7wGVGJS3tVbyK=w@mail.gmail.com>
 <1d0fb40a-1908-4b5e-9856-a5b79eafdc9c@eyal.emu.id.au>
 <ZVHIPNwC2RKTVmok@vault.lan>
 <182d07c8-a76e-430d-90e8-6df8c1f1c54d@eyal.emu.id.au>
 <ZVHqbnFRU4bXBDNQ@vault.lan>
 <60e4892e-f6b3-4f0a-956d-09555d8ee147@eyal.emu.id.au>
From:   eyal@eyal.emu.id.au
In-Reply-To: <60e4892e-f6b3-4f0a-956d-09555d8ee147@eyal.emu.id.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13/11/2023 20.36, eyal@eyal.emu.id.au wrote:
> On 13/11/2023 20.20, Johannes Truschnigg wrote:
>> Interesting data; thanks for providing it. Unfortunately, I am not familiar
>> with that part of kernel code at all, but there's two observations that I can
>> contribute:

[trimmed]

>> [0]: https://bugzilla.kernel.org/show_bug.cgi?id=217965

Reading this bugzilla, an extra info bit. This has not changed for years (I have daily records).

$ mount|grep data1
/dev/md127 on /data1 type ext4 (rw,noatime,stripe=640)

$ grep data1 /etc/fstab
UUID=xxxxxxxxxxxxxxxxxxxxxx /data1 ext4   noatime 0 0

-- 
Eyal at Home (eyal@eyal.emu.id.au)

