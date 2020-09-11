Return-Path: <SRS0=sV2i=CU=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A5CC43461
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 20:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 369A22083E
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 20:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aim.com header.i=@aim.com header.b="Y2acIFtF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgIKUO6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Sep 2020 16:14:58 -0400
Received: from sonic305-22.consmr.mail.ne1.yahoo.com ([66.163.185.148]:42203
        "EHLO sonic305-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725787AbgIKUO4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 11 Sep 2020 16:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aim.com; s=a2048; t=1599855294; bh=2GWkQFcW/OAu1YZn7M5fvuzN4cFJPghnsNj69+fkccI=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=Y2acIFtFC8J9bb0x9KryjsjG2tMoVbmp/FitOT6Kzr0h9sYPcLmzMhW4g1mV30y1g7Z4Ly8nP/nTLLAktjDHj41hzBrXE1xazXdRyMe0BXSk7x9ZpxPgcdao7qTjon7Dge+HbV1lzh9vPubZMWLWDe8BJVqAz/z/BHVG19BuR0oPCKBKG5YmaJTqvXpZ5GItTY1bkMmUqPjppMUZa7XwkqvNY8ULHX5ClPGhDqQl25INkPCCUCBl1XwjFy5EgqRJmUl4vI5d0MFD+NFHweYmuTMc/4LOE9ctt0agvVeGj8G0fhNmJFmx/ohGCqaSAiwsrZGEDZTzkJl1lt25gzosVQ==
X-YMail-OSG: V5H9FXIVM1mfFIgKZr7d9fAP7wj.YyDBhFv9dQJZFTCTGR81tEN8bC4HFipTNQD
 6hXGPKgrPgwBpw.CLbZLRrZTtmw1O17fThHA3fIQOBUH.50aherpqC7y6zQOH2Ww.JQCHSgCko9b
 GB6OPrtWlRWKN5pb7XgId23ONzNcYHHoJ6hsfOWR6iDBGHT4GPIrm9wS7J94tEND8bgdIi8RA9lJ
 ellBqwv.pPkFJaslWFenBw8vJCtzHIMIuU9HIRwoII_CbszIzFskD82PTpTAST6UpntXq0F8Ylb_
 DGiXUJsjgsj.THJp21496R1KnkRS2ljjgZM_jt193cnTQGRge4LijsXhY59dfPqaGisL1g1kmvz2
 g4SRuOFSNwQoYk91Hh4MDWqPy4bV3j45TySxYgj74HSexMq14OTygbPz8g_HLpryUhwbLDcXhoNh
 x3zyPiI_G2LWzwEySdZOASkBfjmRbq0ahzKRL8l.l577YJ6AuE1_xKyZB2dAhWqzKt5AbPC_RSF1
 qNJoPErFzekYj0f6utjS.l_sydQyUTBgtx6GSIzh.c6wQ9_tkfEKJBk2qYn8FZPO17S8pKzuwVh4
 xLYKP6q72NqS6rfwNhN5pUIETdQ6eniUtb8J7sOFG8hOTjUiAQ83N.TbaLbgPmAmMXT.t1sY17eu
 6oXCCNPQIjA2TnRMcWrM1wXKA1zWdpXN94aHMX6DYf8RBs7XfTLC0f0ed3suEwBaeMyIGwcyIsto
 KU7BL5..btHyxzA1mvYScoD9.ahf3sg9VmV8xX03ybCGem5XtHv8ljdvgLyNPFjs_jLUrm5tpos9
 Kmgp0tVzpjKNlTkFdiS13FrnXso0t16UYZadRhNA3yK1HQnh9zJLzzlBYgzgvMeA1u.T953eBvlB
 dBqD5phQ2LtW_WvUagn4npqP2mlNwmJ3HvW5SLH3l3pC6fbeLgxZIlsfWDpx7DyN0h9tHx6ovJ4n
 RlaHVP9ogNjHG1CqbHKphD88lgmO7nDEgbJHzgeZCQ3IB.CftvnV3Oe8G4mVzUjmBBCu7xrBkuC9
 ao3BhR9VWkZB.pIclNb5XggnG3.G.lhBRKtneR5.rrShB8TuyGFhGYHG.MA6JEHIjzMonSd3WDVw
 SPMRkriq86Zb.gXm8gMD4LLDxLM44Zf.Clf2LpEeYI12Emx0vCHxLHKRqKRSHTeWJ68nB86U07Gh
 Q6BCK.YuIMlaa8zKKnh2KUQ8qRv8in31V1xMl6vfacfjqQlBiyleT43uU_oNTGSp4Eyz42c7Eomp
 grXcPVLzo9rOF5chpLo0e1RNnTNhcPkI5kDcT_J93E24X0V7XbIJ6yXJcb59fwf7wMFltCA4LXwo
 CgifHilW2UAQeVC4XH_UM9I.rY3aGFcakB2dl7lxsLIYywOOJX7VtA3XVNwnSxlAmj0bkRv5hIbE
 IHIPhA4Ug1cBkiyNqLw3VZxTiBSRDnFPUJKH8GjOui_ZfwmN8kVnw9h_0NUGUwlCjhWQKEOMHVpD
 8.cPNfixtdTT9DgdYguxLGnXK90wJibKyeys3Mc6XabKQ6pHdKCsJVxPfGQFPN7sUnIPu
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Fri, 11 Sep 2020 20:14:54 +0000
Received: by smtp419.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 48a153cb80ddf09ea63122c41c31c1ff;
          Fri, 11 Sep 2020 20:14:53 +0000 (UTC)
Subject: Re: Linux raid-like idea
To:     antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
 <5F54146F.40808@youngman.org.uk>
 <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
 <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
From:   Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Autocrypt: addr=brianvanderburg2@aim.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
Date:   Fri, 11 Sep 2020 16:14:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.16583 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 9/11/20 3:16 PM, antlists wrote:
> Yes it is a bit like raid-4 since the data and parity disks are
>> separated.=C2=A0 In fact the idea could be better called a parity back=
ed
>> collection of independently accessed disks. While you would not get th=
e
>> advantage/performance increase of reads/writes going across multiple
>> disks, the idea is primarily targeted to read-heavy applications, so i=
n
>> a typical use, read performance should be no worse than reading direct=
ly
>> from a single un-raided disk, except in case of a disk failure where t=
he
>> parity is being used to calculated a block read on a missing disk.
>> Writes would have more overhead since they would also have to
>> calculate/update parity.
>
> Ummm...
>
> So let me word this differently. You're looking at pairing disks up,
> with a filesystem on each pair (data/parity), and then using mergefs
> on top. Compared with simple raid, that looks like a lose-lose
> scenario to me.
>
> A raid-1 will read faster than a single disk, because it optimises
> which disk to read from, and it will write faster too because your
> typical parity calculation for a two-disk scenario is a no-op, which
> might not optimise out.


Not exactly.=C2=A0 You can do a data + parity, but you could also do a da=
ta +
data + parity or a data + data + data + parity.=C2=A0 Or with more than o=
ne
parity disk data + data + data + data +parity + parity, etc.

Best viewed in a fixed-width font, and probably make more sense read
from the bottom up:


=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /data
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
=C2=A0=C2=A0=C2=A0 / mergerfs=C2=A0 \
=C2=A0=C2=A0 /=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 \
/pool1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /pool2=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /pool3 (or /home or /usr/local, etc)=

=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
The filesystem built upon the /dev/frX devices can be used however the
user wants.
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
----------------------------------------
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
ext4 (etc)=C2=A0=C2=A0=C2=A0=C2=A0 ext4(etc)=C2=A0=C2=A0=C2=A0 (ext4/etc,=
 could in theory even have
multiple partitions then filesystems)
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
Each exposed block device /dev/frX can have a filesystem/partition table
placed on it, which is placed onto the single mapped disk.
Any damage/issues on one data disk would not affect the other data disks
at all.=C2=A0 However, since the collection of data disks also has parity=
 for
them,
damage to a data disk can be restored from the parity and other data
disks.=C2=A0 If, during restore, something prevents the restore, then onl=
y
the bad
data disks have an issue, the other data disks would still be fully
accessible, and any filesystem on them still intact since the entire
filesystem
from anything on /dev/fr0 would be only on /dev/sda1, and so on.
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
----------------------------------------
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
/dev/fr0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /dev/fr1=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 /dev/fr2
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
Individual data disks are passed through as fully exposed block devices,
minus any overhead for information/data structures for the 'raid'.
A block X on /dev/fr0 maps to block X + offset on /dev/sda1 and so on
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
Raid/parity backed disk layer (data: /dev/sda1=3D/dev/fr0,
/dev/sdb1=3D/dev/fr1, /dev/sdc1=3D/dev/fr2, parity: /dev/sdd1)
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |
-----------------------------------------------------
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |
/dev/sda1=C2=A0=C2=A0=C2=A0 /dev/sdb1=C2=A0=C2=A0=C2=A0=C2=A0 /dev/sdc1=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 /dev/sdd1 (parity)



So basically at the raid (or parity backed layer), multiple disks and
not just a single disk, can be backed by the parity disk (ideally
support for more than on parity disk as well)=C2=A0 Only difference is,
instead of joining the disks as one block device /dev/md0, each data
disk gets its own block device and so has it's own filesystem(s) on it
independently of the other disks.=C2=A0 A single data disk can be removed=

entirely, taken to a different system, and still be read (would need to
do losetup with an offset to get to the start of the
filesystem/partition table though), and the other data disks would still
be readable on the original system.=C2=A0 So any total loss of a data dis=
k
would not affect the other data disks files.=C2=A0 In this example, /data=

could be missing some files if /pool1 (/dev/sda1) died, but the files on
/pool2 would still be entirely accessible as would any filesystem from
/dev/sdc1.=C2=A0 There is no performance advantage to such a setup. The
advantage is that should something real bad happen and it become
impossible to restore some data disk(s), the other disk(s) are still
accessible.

Read from /dev/fr0 =3D read from /dev/sda1 (adjusted for any overhead/hea=
ders)
Read from /dev/fr1 =3D read from /dev/sdb1 (adjusted for any overhead/hea=
ders)
Read from /dev/fr2 =3D read from /dev/sdc1 (adjusted for any overhead/hea=
ders)
Write to /dev/fr0 =3D write to /dev/sda1 ((adjusted for any
overhead/headers) and parity /dev/sdd1
Write to /dev/fr1 =3D write to /dev/sdb1 ((adjusted for any
overhead/headers) and parity /dev/sdd1
Write to /dev/fr2 =3D write to /dev/sdc1 ((adjusted for any
overhead/headers) and parity /dev/sdd1

Read from /dev/fr0 (/dev/sda1 missing) =3D read from parity and other
disks, recalculate original block)
During rebuild, /dev/sdd dies as well (unable to rebuild from parity now
since /dev/sda and /dev/sdd are missing)
=C2=A0=C2=A0=C2=A0 Lost: /dev/sda1
=C2=A0=C2=A0=C2=A0 Still present: /dev/sdb1 -- some files from the pool w=
ill be missing
since /pool1 is missing but the files on /pool2 are still present in
their entirety
=C2=A0=C2=A0=C2=A0 Still present: /pool3 (or /home or /usr/local, etc, wh=
atever
/dev/fr2 was used for)

>>
>>> Personally, I'm looking at something like raid-61 as a project. That
>>> would let you survive four disk failures ...
>>
>> Interesting.=C2=A0 I'll check that out more later, but from what it se=
ems so
>> far there is a lot of overhead (10 1TB disks would only be 3TB of data=

>> (2x 5 disk arrays mirrors, then raid6 on each leaving 3 disks-worth of=

>> data).=C2=A0 My currently solution since I'ts basically just storing b=
ulk
>> data, is mergerfs and snapraid, and from the documents of snapraid, 10=

>> 1TB disks would provide 6TB if using 4 for parity.=C2=A0 However it's =
parity
>> calculations seem to be more complex as well.
>
> Actually no. Don't forget that, as far as linux is concerned, raid-10
> and raid-1+0 are two *completely* *different* things. You can raid-10
> three disks, but you need four for raid-1+0.
>
> You've mis-calculated raid-6+1 - that gives you 6TB for 10 disks (two
> 3TB arrays). I think I would probably get more with raid-61, but every
> time I think about it my brain goes "whoa!!!", and I'll need to start
> concentrating on it to work out exactly what's going on.

That's right, I get the various combinations confused.=C2=A0 So does raid=
61
allow for losing 4 disks in any order and still recovering? or would
some order of disks make it where just 3 disks lost and be bad?
Iinteresting non-the-less and I'll have to look into it.=C2=A0 Obviously =
it's
not intended to as a replacement for backing up important data, but, for
me any way, just away to minimize loss of any trivial bulk data/files.

It would be nice if the raid modules had support for methods that could
support a total of more disks in any order lost without loosing data.=C2=A0=

Snapraid source states that it uses some Cauchy Matrix algorithm which
in theory could loose up to 6 disks if using 6 parity disks, in any
order, and still be able to restore the data.=C2=A0 I'm not familiar with=
 the
math behind it so can't speak to the accuracy of that claim.

>> This is actually the main purpose of the idea.=C2=A0 Due to the data o=
n the
>> disks in a traditional raid5/6 being mapped from multiple disks to a
>> single logical block device, and so the structures of any file systems=

>> and their files scattered across all the disks, losing one more than t=
he
>> number of available lost disks would make the entire filesystem(s) and=

>> all files virtually unrecoverable.
>
> But raid 5/6 give you much more usable space than a mirror. What I'm
> having trouble getting to grips with in your idea is how is it an
> improvement on a mirror? It looks to me like you're proposing a 2-disk
> raid-4 as the underlying storage medium, with mergefs on top. Which is
> effectively giving you a poorly-performing mirror. A crappy raid-1+0,
> basically.

I do apologize it seems I'm having a little difficulty clearly
explaining the idea.=C2=A0 Hopefully the chart above helps explain it bet=
ter
than I have been.=C2=A0 Imagine raid 5 or 6, but with no striping (so the=

parity goes on their own disks), and the data disks passed through as
their down block devices each.=C2=A0 You lose any performance benefits of=
 the
striping of data/parity, but the data stored on any data disk is only on
that data disk, and same for the others, so losing all parity and a data
disk, would not lose the data on the other data disks.

>>
>> By keeping each data disk separate and exposed as it's own block devic=
e
>> with some parity backup, each disk contains an entire filesystem(s) on=

>> it's own to be used however a user decides.=C2=A0 The loss of one of t=
he
>> disks during a rebuild would not cause full data loss anymore but only=

>> of the filesystem(s) on that disk.=C2=A0 The data on the other disks w=
ould
>> still be intact and readable, although depending on the user's usage,
>> may be missing files if they used a union/merge filesystem on top of
>> them.=C2=A0 A rebuild would still have the same issues, would have to =
read
>> all the remaining disks to rebuild the lost disk.=C2=A0 I'm not really=
 sure
>> of any way around that since parity would essentially be calculated as=

>> the xor of the same block on all the data disks.
>>
> And as I understand your setup, you also suffer from the same problem
> as raid-10 - lose one disk and you're fine, lose two and it's russian
> roulette whether you can recover your data. raid-6 is *any* two and
> you're fine, raid-61 would be *any* four and you're fine.

Not exactly.=C2=A0 Since the data disks are passed through as individual
block devices instead of 'joined' into a single block device, if you
lose one disk (assuming only one disk of parity) then you are fine. If
you lose two, then you've only lost the data on the lost data disk. The
other data disks would still have their in-tact filesystems on them.=C2=A0=

Depending on how they are used, some files may be missing. IE a mergerfs
between two mount points would be missing any files on the lost mount
point, but the other files would still be accessible.


It may or may not (leaning more to probably not) have any use. I'm
hoping from the above at least the idea is better understood.=C2=A0 I do
apologize if it's still not clear/


Thanks,


Brian Vanderburg II



