Return-Path: <SRS0=4oqD=CO=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8481C43461
	for <linux-raid@archiver.kernel.org>; Sat,  5 Sep 2020 21:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BEA320760
	for <linux-raid@archiver.kernel.org>; Sat,  5 Sep 2020 21:48:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aim.com header.i=@aim.com header.b="BoKA7kUO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbgIEVsA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 5 Sep 2020 17:48:00 -0400
Received: from sonic317-33.consmr.mail.ne1.yahoo.com ([66.163.184.44]:44211
        "EHLO sonic317-33.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728103AbgIEVr4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 5 Sep 2020 17:47:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aim.com; s=a2048; t=1599342474; bh=sujboDwurgHUeq9JpWgO25fhgwoWuSxnrFqgwogiXOc=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=BoKA7kUO0rpeRBSRZ67av2v3JCdZNCC6oO2txzpTRGH5VOh1lEvu9aBV6+YBz4FYrs6OmZ1zftULRD1UYgOChUevVrjSiXrwCrybeI8mWHjsBkyl35JQeoKUXz5DuL1aKBwAUkxjDtbyELFiJV0SC5ylc/h+0Unm/JQeMAsuriHhyDLTmPVLoHgsh/0n5jjxuZ+XO+7aiuHPLH188bnyYCDJfN55wDz8rLI34b6GGzNG5QP1z776k4huYLBpGAVUUdQa/pAxbD97tcmte68eFLJGNNqXE2B2miim69e3u+b38r5HSCiTnUjsXZubZRFl8zNx1AtkhrqYICs4vfyomw==
X-YMail-OSG: D7p_7PIVM1l9PSvBFHM0CX16zG1TGxUAwj5TjGeqjzHPbius_4lDucVxZMrwT5a
 kqfO51jlK0hw7BNrbcK3AFNpR_JQFyRzZtzx6GG32XNvALeVpELFWrsUnYBmHzowBBXuT_EkdJHV
 BRncS9VgRD4eYiYfuGCcCVu6E_LFW733A54hgpheP5UU0.LGiUiHbM9JAxKHTTqEFKwqTIP8eTpJ
 yw.dUoftz1PUpa47FN_2TzEXCGqh.9s8_EbF3dFxnDKKVTiVrZgQBhf0.l2vwFIipW.NTgOYIPEb
 eZuoJBwby3wlw8eNbTsJYKOtnVE45osUZWa2lmlgSSHBWAXLJm7K41F7jHnt2JNNqG0nHKPNuMHq
 U9Daqnotyz_5ovy6vrj1lUtxtWkr16q9.emZifKKelcaYDIyFrPOoYLH.LKMiJLOGHG3uZbbjJz9
 mRKcHY1KwfIXx.ypn5w.91pPUw8sfLOUUbHLmg2gAS_lB8RYBHxWs_l9ON_HiCMHlS45ji7.6h3Q
 FjtXIR6rkUyN50.DlcwE2upBbAdbgX1xslHe8sPPQbnzoIWD7COHLs4kxznMQZwFRM58sJZxHtNl
 6Lwt778vTAG.yFw2A0WnSlN9Il0zZnPn0rlCHYbGst5.GReYRKzDbK1DLzd4au2JRdUQFgMB0UOG
 1Ujv7iJ2zz9aO1uYS0RKGQdo0DcYBxcH4qzaxBudLyYXmUgxZJe3v2SooXW.uEafOiGJ0NKz9McG
 Hn2Q5xq9PO53AtjtOHIWbpQd1D9bF7rEpTRTlhpP5OmIZ3d9fuM38zb57LAG792op24g.QZbtD8V
 WNhGB.mzKH7dxgll.UarxiA_1mxWWUAWsbfiHPBtHDcMDhjEgt7xrUWXWWRzl3qMJI8zVqPRCRFx
 QjMMf2QnI852ddnP9L2M963QlRaparBgjT3WrWjgFZYFSTLTGoTb1Edn5WDPoThFuxL4vRf_ZnrY
 6mVRpi_3eELg.qaYmItfUV7EQVtD4ZyW4phJCaaE9mV0YssoxffGG_hYaD2bmYCuyqHoxumY1evR
 ujQtZz7RYxo9j6sB03Z2ZvrX0fKUdbI4SL4DXjeIwWHTGyZoB.hUPiAkJ30_GK8_AkJsia8B415c
 NA0g9aWOoR4YiLQlkQVQKpVi0HXFZMydEQXPliygRyzcDuwvSw059oKCZ372YdHqvwmwbftPhxEV
 _fXLncdFBctU3FZiSmC0M88dsHch0bf9tSjBwLPdq1RXkptBGxtwmJkUMsEEkjXz98ufvgqyysxY
 pZo4Z7rh9yhuhjpb9rpKdFY8Hoj2DMRC9NuIP.2TsnBb8EAvPJS6RYaneeOTeO3AGrLSlJjh0JFH
 MU8avBtTKHddjon2FgVoKDIBB3layUrsxTs8_PbUV9IOlYOfsyohp3FdPByQL1Lv8L0fxUgTRNK6
 .zaXcLWKPSjvPd0TPg8ms59M243iWVqphEjk0pcUVurpL6q4eHKl.ej7JoaJ58Q2HgYkktfBevLT
 HP.fLDhw.d63hfdkB8r4IIzVBJRJufWCVbsiYJqVMsfEDlw8N6bFwao1AjTY-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Sat, 5 Sep 2020 21:47:54 +0000
Received: by smtp401.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID c24b62ede83456c276e433679680cb82;
          Sat, 05 Sep 2020 21:47:52 +0000 (UTC)
Subject: Re: Linux raid-like idea
To:     antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
From:   Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Autocrypt: addr=brianvanderburg2@aim.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
Date:   Sat, 5 Sep 2020 17:47:50 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.16565 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The idea is actually to be able to use more than two disks, like raid 5
or raid 6, except with parity on their own disks instead of distributed
across disks, and data kept own their own disks as well.=C2=A0 I've used
SnapRaid a bit and was just making some changes to my own setup when I
got the idea as to why something similar can't be done in block device
level, but keeping one of the advantages of SnapRaid-like systems which
is if any data disk is lost beyond recovery, then only the data on that
data disk is lost due to the fact that the data on the other data disks
are still their own complete filesystem, and providing real-time updates
to the parity data.


So for instance

/dev/sda - may be data disk 1, say 1TB

/dev/sdb - may be data disk 2, 2TB

/dev/sdc - may be data disk 3, 2TB

/dev/sdd - may be parity disk 1 (maybe a raid-5-like setup), 2TB

/dev/sde - may be parity disk 2 (maybe a raid-6-like setup), 2TB


The parity disks must be larger than the largest data disks. If a given
block is not present on a data disk (due to it being smaller than the
other data disks) it is computed as all zeroes. So the parity for
position 1.5TB would use zeros from /dev/sda and whatever the block is
from /dev/sdb and /dev/sdc

In normal raid 5/6, this would only expose a single logical block device
/dev/md0 and the data and parity would distributed across the disks.=C2=A0=
 If
any data disk is lost without any parity, it's not possible to recover
any data since the blocks are scattered across all disks.=C2=A0 What good=
 is
any file if it is missing every other third block?=C2=A0 Even trying to
figure out the files would be virtually impossible since even the
structures of any filesystem and everything else on /dev/md0 is also
distributed.


My idea is basically, instead of exposing a single logical block device
that is the 'joined' array, each data disk would be exposed as its own
logical block device. /dev/sda1 may be exposed as /dev/fr1 (well, some
better name), /dev/sdb1 as /dev/fr2, /dev/sdc1 as /dev/fr3, the parity
disks would not be exposed as a logical block device.=C2=A0 The blocks wo=
uld
essentially be a 1-1 identity between /def/fr1 and /dev/sda1 and so on
except a small header on /dev/sda, so block 0 on /dev/fr1 may actually
be block 8 on /dev/sda.=C2=A0 If any single disk were ever removed from t=
he
array, the full data on it could still be accessed via losetup with an
offset, and any file systems that were built on it could be read
independently from any of the other data disks.

The difference from traditional raid is that, if every disk somehow got
damaged beyond recovery excepted for /dev/sda, it would still be
possible to recover whatever data was on that disk since it was exposed
to the system as its own block device, with an entire filesystem on it.
The same with /dev/sdb and /dev/sdc. Any write to any of the data block
devices would automatically also write parity.=C2=A0 Any read from any da=
ta
block device if it is failed would recompute from available parity in
real time, except with degraded performance.=C2=A0 The file systems creat=
ed
on the exposed logical block devices could be used however the user sees
fit, maybe related such as a union/merge pool file system, or unrelated
such as /home on the /dev/fr1 filesystem and /usr/local on /dev/fr2.
There would be no read/write performance increase, since reads from the
a single logical block device maps to the same physical device.=C2=A0 But=

there would be the typical redundancy of raid, and if during any
recovery/rebuild another disk fails which would prevent the recovery of
the data, only the data on the lost data disks is gone.


Thanks,


Brian Vanderburg II


On 8/28/20 11:31 AM, antlists wrote:
> On 24/08/2020 18:23, Brian Allen Vanderburg II wrote:
>> Just an idea I wanted to put out there to see if there were any
>> merit/interest in it.
>
> I hate to say it, but your data/parity pair sounds exactly like a
> two-disk raid-1 mirror. Yes, parity !=3D mirror, but in practice I thin=
k
> it's a distinction without a difference.
>
> Cheers,
> Wol

