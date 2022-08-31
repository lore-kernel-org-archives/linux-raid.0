Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C15ECAAD4
	for <linux-raid@archiver.kernel.org>; Wed, 31 Aug 2022 20:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiHaUhu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 Aug 2022 16:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiHaUht (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 Aug 2022 16:37:49 -0400
Received: from mail.stoffel.org (li1843-175.members.linode.com [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD66E3983
        for <linux-raid@vger.kernel.org>; Wed, 31 Aug 2022 13:37:48 -0700 (PDT)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 429BE229F4;
        Wed, 31 Aug 2022 16:37:47 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 9BAB7A7E3F; Wed, 31 Aug 2022 16:37:46 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <25359.50842.604856.467479@quad.stoffel.home>
Date:   Wed, 31 Aug 2022 16:37:46 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Peter Sanders <plsander@gmail.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Eyal Lebedinsky <fedora@eyal.emu.id.au>,
        linux-raid@vger.kernel.org
Subject: Re: RAID 6, 6 device array - all devices lost superblock
In-Reply-To: <CAKAPSkKQA3cV1rcj9cNrdKorOOqyjHf_4BCLxbEx8ibusJP5nA@mail.gmail.com>
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
        <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk>
        <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
        <4a414fc6-2666-302f-8d3d-08eb7a2986fc@turmel.org>
        <CAKAPSkJAQYsec-4zzcePbkJ7Ee0=sd_QvHj4Stnyineq+T8BXw@mail.gmail.com>
        <25355.47062.897268.3355@quad.stoffel.home>
        <ee66bcbe-0a9b-57a6-439f-72cc46debe48@turmel.org>
        <25355.50871.743993.605394@quad.stoffel.home>
        <CAKAPSkLQ4K1R_aD1=iURTFQmm_DXDMr=wx+VDET7DOUy+6Zp_Q@mail.gmail.com>
        <25357.13191.843087.630097@quad.stoffel.home>
        <1d978f6c-e1cc-e928-efc5-11ff167938b1@eyal.emu.id.au>
        <CAKAPSkJhf8hWGTQiCne6BnMPYoum4hJT3diz9U1FGAfq=_N-nA@mail.gmail.com>
        <CAKAPSkK1bTf+7GOxmB-odjr2zej6XBCT_VGhfNC1KnSXZHjeRw@mail.gmail.com>
        <8e994200-146e-61ce-bb4a-f7f111f47b10@youngman.org.uk>
        <CAKAPSkKQA3cV1rcj9cNrdKorOOqyjHf_4BCLxbEx8ibusJP5nA@mail.gmail.com>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:

> encountering a puzzling situation.
> dmsetup is failing to return.

I don't think you need to use dmsetup in your case, but can you post
*all* the commands you ran before you got to this point, and the
output of 

       cat /proc/mdstat

as well?  Thinking on this some more, you might need to actually also
add:

	--assume-clean

to the 'mdadm create ....' string, since you don't want it to zero the
array or anything.  

Sorry for not remembering this at the time!

So if you can, please just start over from scratch, showing the setup
of the loop devices, the overlayfs setup, and the building the RAID6
array, along with the cat /proc/mdstat after you do the initial build.

John

P.S.  For those who hated my email citing tool, I pulled it out for
now.  Only citing with > now.  :-)

> root@superior:/mnt/backup# dmsetup status
> sdg: 0 5860533168 snapshot 16/8388608000 16
> sdf: 0 5860533168 snapshot 16/8388608000 16
> sde: 0 5860533168 snapshot 16/8388608000 16
> sdd: 0 5860533168 snapshot 16/8388608000 16
> sdc: 0 5860533168 snapshot 16/8388608000 16
> sdb: 0 5860533168 snapshot 16/8388608000 16

> dmsetup remove sdg  runs for hours.
> Canceled it, ran dmsetup ls --tree and find that sdg is not present in the list.

> dmsetup status shows:
> sdf: 0 5860533168 snapshot 16/8388608000 16
> sde: 0 5860533168 snapshot 16/8388608000 16
> sdd: 0 5860533168 snapshot 16/8388608000 16
> sdc: 0 5860533168 snapshot 16/8388608000 16
> sdb: 0 5860533168 snapshot 16/8388608000 16

> dmsetup ls --tree
> root@superior:/mnt/backup# dmsetup ls --tree
> sdf (253:3)
>  ├─ (7:3)
>  └─ (8:80)
> sde (253:1)
>  ├─ (7:1)
>  └─ (8:64)
> sdd (253:2)
>  ├─ (7:2)
>  └─ (8:48)
> sdc (253:0)
>  ├─ (7:0)
>  └─ (8:32)
> sdb (253:5)
>  ├─ (7:5)
>  └─ (8:16)

> any suggestions?



> On Tue, Aug 30, 2022 at 2:03 PM Wols Lists <antlists@youngman.org.uk> wrote:
>> 
>> On 30/08/2022 14:27, Peter Sanders wrote:
>> >
>> > And the victory conditions would be a mountable file system that passes a fsck?
>> 
>> Yes. Just make sure you delve through the file system a bit and satisfy
>> yourself it looks good, too ...
>> 
>> Cheers,
>> Wol
