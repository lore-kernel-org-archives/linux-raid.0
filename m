Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F654C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 22 Jul 2022 09:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiGVJqJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Jul 2022 05:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236594AbiGVJpu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Jul 2022 05:45:50 -0400
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1DAB8515
        for <linux-raid@vger.kernel.org>; Fri, 22 Jul 2022 02:41:14 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 26M9fABE009881
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 22 Jul 2022 10:41:11 +0100
From:   Nix <nix@esperi.org.uk>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
References: <87o7xmsjcv.fsf@esperi.org.uk>
        <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
        <87bktjpyna.fsf@esperi.org.uk>
        <2a0119a2-814f-d61b-cf82-b446c453e6dc@youngman.org.uk>
Emacs:  well, why *shouldn't* you pay property taxes on your editor?
Date:   Fri, 22 Jul 2022 10:41:10 +0100
In-Reply-To: <2a0119a2-814f-d61b-cf82-b446c453e6dc@youngman.org.uk> (Wols
        Lists's message of "Wed, 20 Jul 2022 19:32:22 +0100")
Message-ID: <875yjpo56x.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1480; Body=2 Fuz1=2 Fuz2=2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20 Jul 2022, Wols Lists outgrape:

> On 20/07/2022 16:55, Nix wrote:
>> [    9.833720] md: md126 stopped.
>> [    9.847327] md/raid:md126: device sda4 operational as raid disk 0
>> [    9.857837] md/raid:md126: device sdf4 operational as raid disk 4
>> [    9.868167] md/raid:md126: device sdd4 operational as raid disk 3
>> [    9.878245] md/raid:md126: device sdc4 operational as raid disk 2
>> [    9.887941] md/raid:md126: device sdb4 operational as raid disk 1
>> [    9.897551] md/raid:md126: raid level 6 active with 5 out of 5 devices, algorithm 2
>> [    9.925899] md126: detected capacity change from 0 to 14520041472
>
> Hmm.
>
> Most of that looks perfectly normal to me. The only oddity, to my eyes, is that md126 is stopped before the disks become
> operational. That could be perfectly okay, it could be down to a bug, whatever whatever.

Yeah this is the *working* boot. I can't easily get logs of the
non-working one because, well, no writable filesystems and most of the
interesting stuff scrolls straight off the screen anyway. (It's mostly
for comparison with the non-working boot once I manage to capture that.
Somehow. A high-speed camera on video mode and hand-transcribing? Uggh.)

-- 
NULL && (void)
