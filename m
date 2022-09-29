Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17145C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 29 Sep 2022 13:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiI2NZb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Sep 2022 09:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiI2NZH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Sep 2022 09:25:07 -0400
X-Greylist: delayed 2597 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 29 Sep 2022 06:25:05 PDT
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0F53FA1B
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 06:25:03 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 28TCffSl025327
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 29 Sep 2022 13:41:42 +0100
From:   Nix <nix@esperi.org.uk>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
References: <87o7xmsjcv.fsf@esperi.org.uk>
        <d28a695e-1958-d438-b43d-65470c1bbe7a@youngman.org.uk>
        <87bktjpyna.fsf@esperi.org.uk>
        <2a0119a2-814f-d61b-cf82-b446c453e6dc@youngman.org.uk>
        <875yjpo56x.fsf@esperi.org.uk>
        <CAAMCDect7m24tQaDZ7dqv+En2LveaLfOtTgYNJu5G1jtzVmbUg@mail.gmail.com>
Emacs:  because extension languages should come with the editor built in.
Date:   Thu, 29 Sep 2022 13:41:41 +0100
In-Reply-To: <CAAMCDect7m24tQaDZ7dqv+En2LveaLfOtTgYNJu5G1jtzVmbUg@mail.gmail.com>
        (Roger Heflin's message of "Fri, 22 Jul 2022 06:58:09 -0500")
Message-ID: <878rm2fj3u.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1481; Body=3 Fuz1=3 Fuz2=3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22 Jul 2022, Roger Heflin verbalised:

> On Fri, Jul 22, 2022 at 5:11 AM Nix <nix@esperi.org.uk> wrote:
>>
>> On 20 Jul 2022, Wols Lists outgrape:
>>
>> > On 20/07/2022 16:55, Nix wrote:
>> >> [    9.833720] md: md126 stopped.
>> >> [    9.847327] md/raid:md126: device sda4 operational as raid disk 0
>> >> [    9.857837] md/raid:md126: device sdf4 operational as raid disk 4
>> >> [    9.868167] md/raid:md126: device sdd4 operational as raid disk 3
>> >> [    9.878245] md/raid:md126: device sdc4 operational as raid disk 2
>> >> [    9.887941] md/raid:md126: device sdb4 operational as raid disk 1
>> >> [    9.897551] md/raid:md126: raid level 6 active with 5 out of 5 devices, algorithm 2
>> >> [    9.925899] md126: detected capacity change from 0 to 14520041472
>> >
>> > Hmm.
>> >
>> > Most of that looks perfectly normal to me. The only oddity, to my eyes, is that md126 is stopped before the disks become
>> > operational. That could be perfectly okay, it could be down to a bug, whatever whatever.
>>
>> Yeah this is the *working* boot. I can't easily get logs of the
>> non-working one because, well, no writable filesystems and most of the
>> interesting stuff scrolls straight off the screen anyway. (It's mostly
>> for comparison with the non-working boot once I manage to capture that.
>> Somehow. A high-speed camera on video mode and hand-transcribing? Uggh.)
>
> if you find the partitions missing if you initrd has kpartx on it that
> will create the mappings.
>
>   kpartx -av <device>

I may have to fall back to that, but the system is supposed to be doing
this for me dammit! :)

The initrd is using busybox 1.30.1 mdev and mdadm 4.0 both linked
against musl -- if this has suddenly broken, I suspect a lot of udevs
have similarly broken. But these are both old, upgraded only when
essential to avoid breaking stuff critical for boot (hah!): upgrading
all of these is on the cards to make sure it's not something fixed in
the userspace tools...

(Not been rebooting because of lots of time away from home: now not
rebooting because I've got probable flu and can't face it. But once
that's over, I'll attack this.)

> I wonder if it is some sort of module loading order issue and/or
> build-in vs module for one or more of the critical drives in the
> chain.

Definitely not! This kernel is almost totally non-modular:

compiler@loom 126 /usr/src/boost% cat /proc/modules 
vfat 20480 1 - Live 0xffffffffc0176000
fat 73728 1 vfat, Live 0xffffffffc015c000

That's *it* for the currently loaded modules (those are probably loaded
because I built a test kernel and had to mount the EFI boot fs to
install it, which is not needed during normal boots because the
initramfs is linked into the kernel image).

-- 
NULL && (void)
