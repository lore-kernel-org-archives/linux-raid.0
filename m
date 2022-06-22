Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB1C7C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 22 Jun 2022 02:37:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355482AbiFVChp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Jun 2022 22:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiFVCho (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 21 Jun 2022 22:37:44 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033ED31220;
        Tue, 21 Jun 2022 19:37:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1655865454;
        bh=ZYmy+gYNPHc14IB9uGAmLHWZKGdmbfK5J4VuU0lNF54=;
        h=X-UI-Sender-Class:Date:To:References:From:Subject:In-Reply-To;
        b=f1SgIT2iUfgK6JGidPc7x5swAWtiCdhwcCIxLQXex6dQXJDGMnkl7phfhga1TL7Nf
         kfNUM4YRy09UqrBzotPExrAmUBlt7HyIVSxURDZSd4AkUIjsnO0rXWlPgeaE5gs9U0
         +V3FMee13nztLIH5LeN5k3EpJ07VuPvCRyCHghdw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1MEFzx-1nwSNc0Xht-00AGB9; Wed, 22
 Jun 2022 04:37:34 +0200
Message-ID: <d15f352d-41b8-8ade-4724-8370ef17db8d@gmx.com>
Date:   Wed, 22 Jun 2022 10:37:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Doug Ledford <dledford@redhat.com>,
        Wols Lists <antlists@youngman.org.uk>,
        linux-raid@vger.kernel.org,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        NeilBrown <neilb@suse.com>
References: <d4163d9f-8900-1ec1-ffb8-c3834c512279@gmx.com>
 <63a9cfb7-4999-d902-a7df-278e2ec37593@youngman.org.uk>
 <1704788b-fb7d-b532-4911-238e4f7fd448@gmx.com>
 <06365833-bd91-7dcf-4541-f8e15ed3bef2@youngman.org.uk>
 <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Subject: Re: About the md-bitmap behavior
In-Reply-To: <87cb53c4f08cc7b18010e62b9b3178ed70e06e8d.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3Jp0t3SNb5hovnXTWcX0Y75lNujLSTLUMhszvt05CUtW0LPK5FN
 wgWtuV9B8yjedzRpMicYZ6nmcTkvKCvJlAnHAl3TRvSz3WElQjOq2/ufR4WBSktr0cq4b3R
 dqklbyb6nyyFX0YiR8oVCsjI5neUuo3r7EcJi7njQJL/oLgdRWmWMbjaTtuwqI8NLdVUMY+
 aNokqKBv9cZMSb54Dt8Zw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:WjMGLs+vJDU=:+G9gRlgq924fxm6CLceAx4
 alNEP4MJLH0VdlshdkD1AoWvYSjdo9fG4myQpLzSWPk3kLCeWt1gX2X2B5wc63FdXO8Ud7PYe
 4JaHYABWPzrshzj2vqr/CVGRmVSXz4HQfDsUyjrDXSr2chzKy88CbqytNOMukWxNm1ym254Fi
 hUyJdD2ci92f3Lkjax4y2HqQZ0RzpIZHqIC0Qy+vppR6oATC5hPVgmp6LTzYFzeLPEuQDhHtR
 KKM/F3dUSqHwBj1J97udoIuv3bQ3rWb1F/WmcKqR06lPXNBR7vsyVhcr+cMHnT27XECbOVWhL
 QNBcwpivYpW5OFPnzSPY2S79lhX4ae3PiitFxTJ6r6+XZcjHJ09OMr6AJdILgq7V5u1iZ1F3J
 AT2foyPDHIm1/erYGkDzVDQEIx1lmyd9i8w7YnIepiScYeq4ywFcgIATBoGtbIKK+9SY/dibZ
 IIxY7SBGStOUqNVqitdIxR8wg8jXPMP2rsx398UFotl3KQGfmPb+V/OfuqqTHhk1rh3gzNOiq
 1nPqowmMRBJctrDmQlFBphPRNu/ALBvMJKRbs6IGGoiJaLfn/Xb2wMUOtdPzEiAALqTdNgBEh
 MTiwa+1oVFN/lJ7HA6LKpPERuNeYZoy6HY7dHy18TK3fsLqTr+00RxleJcfs1wG+Txr+K2pv6
 CmUgEiND4kBuUbI8u50bAArUFzvCLIrt/TQWYIVua2qaxu3K8n3vfsnpIqJZ8z821Sq0BSNkP
 9PP12CO1Fz49miZ+mD/ifjnZwbNmeA2etRtnP62MROm87bs9/m78H20+Ug1Cu5ahoJ2eY1Umx
 HHdonOlNHFj5qXkIuJbCpF9eNOk/elwu1rtbDyzETqOe+wq87WN5f+BhOQKb11a8XAMSBNm5f
 hKbBKMEwFsi5+1uFHw6/b4eJ2FBfLbGEv+LVVGvRG5kbvLqJKg9DXT88jIBDE23LZA1oFWNGZ
 X0QLzjGVEzEp85hcL8dy80I2fkGxVj6HaQYaYJ+30MiszqTIJZio14EuekvK8nJkvMtHBHI18
 qXbVvK1O3gb8Kj0N7361dDXzGIP4w0oKNJBbEwBO2DZKf22u03KiH0xCMMmsirnviz+gA6REb
 l/JR0uCLCzw2lWmPAl9WLJzp8ARkSD3932OGhscizjya3CbTZqHfC22yA==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022/6/22 10:15, Doug Ledford wrote:
> On Mon, 2022-06-20 at 10:56 +0100, Wols Lists wrote:
>> On 20/06/2022 08:56, Qu Wenruo wrote:
>>>> The write-hole has been addressed with journaling already, and
>>>> this will
>>>> be adding a new and not-needed feature - not saying it wouldn't be
>>>> nice
>>>> to have, but do we need another way to skin this cat?
>>>
>>> I'm talking about the BTRFS RAID56, not md-raid RAID56, which is a
>>> completely different thing.
>>>
>>> Here I'm just trying to understand how the md-bitmap works, so that
>>> I
>>> can do a proper bitmap for btrfs RAID56.
>>
>> Ah. Okay.
>>
>> Neil Brown is likely to be the best help here as I believe he wrote a
>> lot of the code, although I don't think he's much involved with md-
>> raid
>> any more.
>
> I can't speak to how it is today, but I know it was *designed* to be
> sync flush of the dirty bit setting, then lazy, async write out of the
> clear bits.  But, yes, in order for the design to be reliable, you must
> flush out the dirty bits before you put writes in flight.

Thank you very much confirming my concern.

So maybe it's me not checking the md-bitmap code carefully enough to
expose the full picture.

>
> One thing I'm not sure about though, is that MD RAID5/6 uses fixed
> stripes.  I thought btrfs, since it was an allocation filesystem, didn't
> have to use full stripes?  Am I wrong about that?

Unfortunately, we only go allocation for the RAID56 chunks. In side a
RAID56 the underlying devices still need to go the regular RAID56 full
stripe scheme.

Thus the btrfs RAID56 is still the same regular RAID56 inside one btrfs
RAID56 chunk, but without bitmap/journal.

>  Because it would seem
> that if your data isn't necessarily in full stripes, then a bitmap might
> not work so well since it just marks a range of full stripes as
> "possibly dirty, we were writing to them, do a parity resync to make
> sure".

For the resync part is where btrfs shines, as the extra csum (for the
untouched part) and metadata COW ensures us only see the old untouched
data, and with the extra csum, we can safely rebuild the full stripe.

Thus as long as no device is missing, a write-intent-bitmap is enough to
address the write hole in btrfs (at least for COW protected data and all
metadata).

>
> In any case, Wols is right, probably want to ping Neil on this.  Might
> need to ping him directly though.  Not sure he'll see it just on the
> list.
>

Adding Neil into this thread. Any clue on the existing
md_bitmap_startwrite() behavior?

Thanks,
Qu
