Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90603C4332F
	for <linux-raid@archiver.kernel.org>; Mon, 13 Nov 2023 10:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjKMKcH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 13 Nov 2023 05:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjKMKcF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 13 Nov 2023 05:32:05 -0500
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8527D75
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 02:32:01 -0800 (PST)
Received: from lists.tip.net.au (pasta.tip.net.au [203.10.76.2])
        by mailhost.tip.net.au (Postfix) with ESMTP id 4STQhw3dbvz9R67
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 21:32:00 +1100 (AEDT)
Received: from [192.168.2.7] (unknown [101.115.9.238])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mailhost.tip.net.au (Postfix) with ESMTPSA id 4STQhw2pbFz9Qyl
        for <linux-raid@vger.kernel.org>; Mon, 13 Nov 2023 21:32:00 +1100 (AEDT)
Message-ID: <f2a9c674-608a-4796-a885-f5313de940cc@eyal.emu.id.au>
Date:   Mon, 13 Nov 2023 21:31:58 +1100
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
 <09d9848d-8ef4-488c-8719-7ad451c9e36b@eyal.emu.id.au>
 <ZVH13JX6q-5CsQNN@vault.lan>
From:   eyal@eyal.emu.id.au
In-Reply-To: <ZVH13JX6q-5CsQNN@vault.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13/11/2023 21.09, Johannes Truschnigg wrote:
> On Mon, Nov 13, 2023 at 08:58:55PM +1100, eyal@eyal.emu.id.au wrote:
>> [trimmed]
>>>> [0]: https://bugzilla.kernel.org/show_bug.cgi?id=217965
>>
>> Reading this bugzilla, an extra info bit. This has not changed for years (I have daily records).
>>
>> $ mount|grep data1
>> /dev/md127 on /data1 type ext4 (rw,noatime,stripe=640)
> 
> Yeah, afaiui, one of the theories in the bug suggests that a recently
> introduced block allocation improvement made matters worse for any kind of
> stride/stripe setting <> 0. So if you dial your kernel version back to before
> that was made (6.4 seems to be unaffacted, iirc), you will probably regain the
> performance loss you observe and reported here on list.
> 
> FWIW, I briefly played around with an artificial dataset on tmpfs-backed loop
> devices configured in RAID5 where I was (re)setting the superblock-configured
> stride-setting, and did not lose any data by toggling it between 0 and
> <some_other_value> (256 in my case) multiple times. So I would assume that to
> be a safe operation in principle ;)

I hear you but I am not brave enough :-(

I will avoid these huge copies and live with this problem(*1), expecting this will be fixed in a few weeks.
maybe even in 3.7? I will follow the bugzilla.

Still Thanks, I now feel that there is hope.

(*1) Most of the time this issue does not bite, and I may have had it for some time until I
took a closer look while dealing with a few raid disk replacements and noticed.

-- 
Eyal at Home (eyal@eyal.emu.id.au)

