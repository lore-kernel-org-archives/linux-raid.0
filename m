Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E932C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jan 2022 12:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbiAKMTC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jan 2022 07:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239606AbiAKMTB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jan 2022 07:19:01 -0500
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72DF7C06173F
        for <linux-raid@vger.kernel.org>; Tue, 11 Jan 2022 04:19:00 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc30a.ko.seznam.cz (email-smtpc30a.ko.seznam.cz [10.53.18.44])
        id 3975b44b97e33b2b3d66d27c;
        Tue, 11 Jan 2022 13:18:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1641903528; bh=dnGlxFmSTzrZ0MEPEbCJho8hjZ8vf+woWqqPlJfM1xk=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type:Content-Transfer-Encoding:
         X-szn-frgn:X-szn-frgc;
        b=lTVMU2HCCySAXPqfKGzkSkp4AoEsFIBANH8DDAY/XX8WfEWxoOX5qLwgzjxbYE7kk
         wzhiLlTb2AvF6FW0/FZkZhQ6jHQ+ZpVp+99vqC4ywXFdHQZsBZLlIjkR54AZGWWTSM
         OvchP8i+J0zcCVJy/hgEU+2K+5kaCc3q+g89cpI0=
Received: from unknown ([::ffff:46.13.60.217])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Tue, 11 Jan 2022 13:18:44 +0100 (CET)
From:   =?utf-8?q?Jarom=C3=ADr_C=C3=A1p=C3=ADk?= <jaromir.capik@email.cz>
To:     "Wols Lists" <antlists@youngman.org.uk>
Cc:     <linux-raid@vger.kernel.org>
Subject: =?utf-8?q?Re=3A_Feature_request=3A_Add_flag_for_assuming_a_new_cl?=
        =?utf-8?q?ean_drive_completely_dirty_when_adding_to_a_degraded_raid5_arra?=
        =?utf-8?q?y_in_order_to_increase_the_speed_of_the_array_rebuild?=
Date:   Tue, 11 Jan 2022 13:18:44 +0100 (CET)
Message-Id: <KXX.44rdc.4OoMauRKn6c.1XtNMa@seznam.cz>
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
        <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
        <KWj.44rc9.53XeO0rrYlI.1Xt3RY@seznam.cz>
        <509c1c25-afd0-2a65-c5e9-cc0d980ebb3a@youngman.org.uk>
Mime-Version: 1.0 (szn-mime-2.1.18)
X-Mailer: szn-ebox-5.0.95
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-szn-frgn: <a07bdebf-276f-45f7-a37d-ad0e0cffd5f4>
X-szn-frgc: <0>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


>> Nope, I haven't read the code. I only see a low sync speed (fluctuating=
 from 20
>> to 80MB/s) whilst the drives can perform much better doing sequential r=
eading
>> and writing (250MB/s per drive and up to 600MB/s all 4 drives in total)=
.
>> During the sync I hear a high noise caused by heads flying there and ba=
ck and
>> that smells.
>
>Okay, so read performance from the array is worse than you would expect =

>from a single drive. And the heads should not be "flying there and back" =

>- they should just be streaming data. That's actually worrying - a VERY =

>plausible explanation is that your drives are on the verge of failure!!=


Nope, the drives are new and OK ... of course I did a ton of tests
and the SMART is looking good ... no reallocated sectors, no pending secto=
rs
and the array now (after the rebuild) works at the expected speed and
without noise ... just the resync was a total disaster.

>> The chosen drives have poor seeking performance and small caches and ar=
e
>> probably unable to reorder the operations to be more sequential. The wh=
ole
>> solution is 'economic' since the organisation owning the solution is po=
or and
>> cannot afford better hardware.
>
>The drives shouldn't need to reorder the operations - a rebuild is an 
>exercise in pure streaming ... unless there are so many badblocks the 
>whole drive is a mess ...

Yeah, I would expect that as well, but the reality was different.
As stated above, the drives are perfectly healthy.

>> That also means RAID6 is not an option. But we shouldn't search excuses=
 what's
>> wrong on the chosen scenario when the code is potentially suboptimal :]=
 We're
>> trying to make Linux better, right? :]
>> 
>> I'm searching for someone, who knows the code well and can confirm my f=
indings
>> or who could point me at anything I could try in order to increase the =
rebuild
>> speed. So far I've tried changing the readahead, minimum resync speed, =
stripe
>> cache size, but it increased the resync speed by few percent only.
>
>Actually, you might find (counter-intuitive though it sounds) REDUCING =

>the max sync speed might be better ... I'd guess from what you say, 
>about 60MB/s.
>The other thing is, could you be confusing MB and Mb? Three 250Mb drives =

>would peak at about 80MB.

Nope, all units were Bytes.

>> The thing that worries me is your reference to repeated seeks. That 
>> should NOT be happening. Unless of course the system is in heavy use at=
 
>> the same time as the rebuild.

Nope, the MD device was NOT mounted and no process was touching it.
In case of this cheap HW I suspect a firmware bug in the SATA bridge, trig=
gering
the issue somehow and therefore I'd like to focus on the second and better=
 HW
I mentioned in my previous email addressed to Roger, where I hear no stran=
ge sounds,
but still, the resync speed is far below my expectations and as far as I c=
an remember
I was never really satisfied with the RAID5 sync speed.

The assembled array can do over 700MB/s when I temporarilly freeze the syn=
c,
but the sync speed is 100MB/s only ... why so?
Again, the MD device is completely idle ... not mounted and no process is =
touching it.

---
/dev/md3:
 Timing cached reads:   22440 MB in  1.99 seconds =3D 11285.30 MB/sec
 HDIO_DRIVE_CMD(identify) failed: Inappropriate ioctl for device
 Timing buffered disk reads: 2144 MB in  3.00 seconds =3D 713.91 MB/sec
---
Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] [raid=
0] [raid10] 
md3 : active raid5 sdi1[5] sdl1[6] sdk1[4] sdj1[2]
      46877237760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] =
[UUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>..]  resync =
=3D 93.6% (14637814004/15625745920) finish=3D161.8min speed=3D101758K/sec=

      bitmap: 5/59 pages [20KB], 131072KB chunk
---

So, what's wrong on this picture?

Thx,
Jaromir.
