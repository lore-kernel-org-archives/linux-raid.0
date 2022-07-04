Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE2CC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Jul 2022 17:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiGDRzV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Jul 2022 13:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiGDRzR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Jul 2022 13:55:17 -0400
X-Greylist: delayed 540 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 04 Jul 2022 10:55:12 PDT
Received: from zimbra.karlsbakk.net (zimbra.karlsbakk.net [IPv6:2a0a:51c0:0:1f:4ca5::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECE6D13F
        for <linux-raid@vger.kernel.org>; Mon,  4 Jul 2022 10:55:12 -0700 (PDT)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 28EFF3C1DD7;
        Mon,  4 Jul 2022 19:46:08 +0200 (CEST)
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10032)
        with ESMTP id PnkE36TQJ-oD; Mon,  4 Jul 2022 19:46:04 +0200 (CEST)
Received: from localhost (localhost.localdomain [IPv6:::1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id B54B13C1E37;
        Mon,  4 Jul 2022 19:46:04 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.10.3 zimbra.karlsbakk.net B54B13C1E37
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karlsbakk.net;
        s=1DC131FE-D37A-11E7-BD32-3AD4DFE620DF; t=1656956764;
        bh=5CmxWQwz3IatroGvv99NBAuFi2Z0sMumgOGzqDM+U44=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=iI77+971thRCxBp0LBD6miiRYSLKQ9ef+BtwWHeoUBPWwROG5wA5VCMSSEb/V3bde
         sNsQkbCKdVpRRyf+Whq5xkjDpSqgErkFml4icE7dZRm3hyYDx7IGsB1CGo2a0pxD8V
         QqxfqmuBE7pr3KN+C+2woJTyc8qVtjA6LliwgCBg+mxQIV5NBChPfcrvgAJOAbW4gF
         Hp/qXsRO1aPe+XnQ6LyljWULPcHO3r1lv9KdM4CnkWyrkOM4V8P8D4f/e+oE8JtyJl
         4W6V0lQPp26/5VhkS7GAD7WAlJCwsCj/cmyOBiu8n5nr4c+9JOWwpG2Sqn72XXOeTd
         GXChbqVd6VAqA==
X-Virus-Scanned: amavisd-new at zimbra.karlsbakk.net
Received: from zimbra.karlsbakk.net ([IPv6:::1])
        by localhost (zimbra.karlsbakk.net [IPv6:::1]) (amavisd-new, port 10026)
        with ESMTP id 0yqkkRt3HxqM; Mon,  4 Jul 2022 19:46:04 +0200 (CEST)
Received: from zimbra.karlsbakk.net (localhost.localdomain [127.0.0.1])
        by zimbra.karlsbakk.net (Postfix) with ESMTP id 5222C3C1DD7;
        Mon,  4 Jul 2022 19:46:04 +0200 (CEST)
Date:   Mon, 4 Jul 2022 19:46:03 +0200 (CEST)
From:   Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To:     Von Fugal <von@fugal.net>
Cc:     Linux Raid <linux-raid@vger.kernel.org>
Message-ID: <1301857800.5153909.1656956763346.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <CAJ1ZTG58jxn8R7_U88sk+nBF=yrO=wdRBU5pua=FL45N6DOT4g@mail.gmail.com>
References: <CAJ1ZTG5ornHW87Kis8G3aw0N6Ww+7=JEOdeCdwevoMApcVR-NA@mail.gmail.com> <CAJ1ZTG58jxn8R7_U88sk+nBF=yrO=wdRBU5pua=FL45N6DOT4g@mail.gmail.com>
Subject: Re: Help recovering a RAID5, what seems to be a strange state
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2001:700:700:403::10be]
X-Mailer: Zimbra 8.8.10_GA_3801 (ZimbraWebClient - FF102 (Mac)/8.8.10_GA_3786)
Thread-Topic: Help recovering a RAID5, what seems to be a strange state
Thread-Index: qWB5RR6xRCxtJ09gZnl4kyThYxGAeA==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Have you tried to do a resync or repair of the raid? I've written a bit abo=
ut that here

https://wiki.karlsbakk.net/index.php/Roy's_notes#Resync

I'd suggest 'repair', since that tends to fix things.

PS: If you don't have a backup, make one first. NEVER beleive a raid is bac=
kup, please ;)

Vennlig hilsen

roy
--=20
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =C3=
=AD snj=C3=B3 rita.

----- Original Message -----
> From: "Von Fugal" <von@fugal.net>
> To: "Linux Raid" <linux-raid@vger.kernel.org>
> Sent: Monday, 4 July, 2022 19:41:27
> Subject: Re: Help recovering a RAID5, what seems to be a strange state

> I did get the array to reassemble. It's still strange to me having all
> devices removed, but then listed again. Incremental adds always
> resulted in the bad state, but what finally assembled the array was
> "mdadm -A --force /dev/md51" started from the array stopped and
> without any incremental adds.
>=20
> It's still doing recovery but it looks good. I may follow up on this
> thread again if it goes south.
>=20
> Cheers!
>=20
> On Sun, Jul 3, 2022 at 3:57 PM Von Fugal <von@fugal.net> wrote:
>>
>> Tl;Dr version:
>> I restored partition tables with different end sectors initially.
>> Started raids to ill effect. Restored correct partition tables and
>> things seemed OK but degraded until they weren't.
>>
>> Current state is 3 devices with the same event numbers, but the raid
>> is "dirty" and cannot start degraded *and* dirty. I know the array
>> initially ran with sd[abd]4 and I added the "missing" sdc4 whence it
>> did something strange while attempting to resync.
>>
>> sdc4 is now a "spare" but cannot be added after an attempted
>> incremental run with the other 3. Either way, after trying to run the
>> array, the table from 'mdadm -D' looks similar to this:
>>
>>     Number   Major   Minor   RaidDevice State
>>        -       0        0        0      removed
>>        -       0        0        1      removed
>>        -       0        0        2      removed
>>        -       0        0        3      removed
>>
>>        -       8       52        2      sync   /dev/sdd4
>>        -       8       36        -      spare   /dev/sdc4
>>        -       8       20        0      sync   /dev/sdb4
>>        -       8        4        1      sync   /dev/sda4
>>
>> Long story version follows
>>
>> I have 4 drives partitioned into different raid types. partition 4 is
>> a raid5 across all 4 drives. For some reason my gpt partition tables
>> were all wiped, and I suspect benchmarking with fio (though I only
>> ever gave it an lvm volume to operate on). I boot systemrescuecd and
>> testdisk finds the original partitions so I tell it to restore those.
>> So far seems good. I start assembling some arrays, others don't work
>> yet. lvm is starting to show contents it finds in the so far assembled
>> arrays (this is still within systemrescuecd).
>>
>> Investigating the unassembled arrays, dmesg is complaining about the
>> array size changed. I find a suggestion to use "-U devicesize". I
>> believe this was my first mistake. The arrays assemble but lvm hangs
>> indefinitely at this point.
>>
>> I desperately search for any info I have on the partitions and arrays
>> and I find a spreadsheet on my laptop that contains meticulous
>> partition detail. I find that some of the partition ends leave a gap
>> before the next partition begins. Whatever. I fix the partition
>> tables. This time, all the arrays assemble and lvm is happy!! YES.
>>
>> However each array has one missing partition member and it's not the
>> same disk on each. That's strange. However my server is running. I'm
>> able to boot it normally and homeassistant is back up. I then re-add
>> each missing partition to each array (I believe this was my second
>> mistake). I go to bed while it reconstructs.
>>
>> In the morning, the array it was reconstructing is back into pending,
>> the raid5 array in question is inactive, and it's reconstructing
>> something else. I remove each partition that I previously added to
>> each array (although the array in question doesn't even let me do
>> this) . I stop the array in question and zero the superblock of the
>> partition I wanted to remove. I zero the superblocks on each other
>> partition removed. I then re-add each partition to each array and let
>> them resync. I now have 3 out of 5 fully operational, one more resync
>> in progress.
>>
>> But my array in question is still kinda hosed. Here's where it's
>> strange. Rather than explain everything, here's the status from the
>> devices (mdadm -E) and the array (mdadm -D).
>> https://pastebin.com/Gyj8d7Z7
>>
>> Note the table at the end of mdadm -D (end of the paste). It shows
>> four devices "removed", then a gap, then 3 devices as 'sync' . If I
>> incrementally add the drives it shows a "normal" table. Until I try
>> --run, then it shows the odd table. If I add --incremental 3 drives
>> (not the 'spare') then run, it shows the pasted table. If I try to add
>> the fourth (spare) it says "ADD_NEW_DISK not supported" in dmesg. If I
>> add 3 drives including the 'spare' it's the same behavior otherwise,
>> but adding the fourth drive complains that it can only add it as a
>> spare, and I must use force-spare to add it (I suspect this would be
>> my 3rd mistake if I did it).
>>
>> I think I can force run this array with sd[abd]4 but the normal
>> commands give errors when trying to do so. What's also strange is that
>> devices sd[abd]4 all have the same event count, yet trying to start
>> the array results in "cannot start dirty degraded array".
>=20
>=20
>=20
> --
> You keep up the good fight just as long as you feel you need to.
> -- Ken Danagger
