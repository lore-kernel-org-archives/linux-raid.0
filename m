Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D10EC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 10 Jan 2022 13:39:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiAJNjB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Jan 2022 08:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbiAJNjA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Jan 2022 08:39:00 -0500
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62D56C061748
        for <linux-raid@vger.kernel.org>; Mon, 10 Jan 2022 05:38:59 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc29a.ng.seznam.cz (email-smtpc29a.ng.seznam.cz [10.23.18.42])
        id 599ff56cf7097a0c5d8c935b;
        Mon, 10 Jan 2022 14:38:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1641821927; bh=LEN86bA+RNGuea+CycvggMw8fBtCoQbMlhNzwc/Fg1I=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type:Content-Transfer-Encoding:
         X-szn-frgn;
        b=llWrKnI8shCT4PzlhpeI4RL3bHv/9/phyvbd2NN7tifGXV4RQ6sZAWPEyYNGokR9F
         mbT+HtBlnRTUa6HR3+7XtBwFL13wWsBKzUwFIDyWtlSo61SWekjrQIEbykEzsQDdgL
         7WW2nt+wvsCLrDqZYhx5wmoD73QkMMNPUCedg7EU=
Received: from unknown ([::ffff:46.13.60.217])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Mon, 10 Jan 2022 14:38:42 +0100 (CET)
From:   =?utf-8?q?Jarom=C3=ADr_C=C3=A1p=C3=ADk?= <jaromir.capik@email.cz>
To:     "Wols Lists" <antlists@youngman.org.uk>
Cc:     <linux-raid@vger.kernel.org>
Subject: =?utf-8?q?Re=3A_Feature_request=3A_Add_flag_for_assuming_a_new_cl?=
        =?utf-8?q?ean_drive_completely_dirty_when_adding_to_a_degraded_raid5_arra?=
        =?utf-8?q?y_in_order_to_increase_the_speed_of_the_array_rebuild?=
Date:   Mon, 10 Jan 2022 14:38:42 +0100 (CET)
Message-Id: <KWj.44rc9.53XeO0rrYlI.1Xt3RY@seznam.cz>
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
        <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
Mime-Version: 1.0 (szn-mime-2.1.18)
X-Mailer: szn-ebox-5.0.95
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-szn-frgn: <b0fa5032-9f48-4971-8a5b-439c79319bf3>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Nope, I haven't read the code. I only see a low sync speed (fluctuating fr=
om 20
to 80MB/s) whilst the drives can perform much better doing sequential read=
ing
and writing (250MB/s per drive and up to 600MB/s all 4 drives in total).=

During the sync I hear a high noise caused by heads flying there and back =
and
that smells.
The chosen drives have poor seeking performance and small caches and are=

probably unable to reorder the operations to be more sequential. The whole=

solution is 'economic' since the organisation owning the solution is poor =
and
cannot afford better hardware.
That also means RAID6 is not an option. But we shouldn't search excuses wh=
at's
wrong on the chosen scenario when the code is potentially suboptimal :] We=
're
trying to make Linux better, right? :]

I'm searching for someone, who knows the code well and can confirm my find=
ings
or who could point me at anything I could try in order to increase the reb=
uild
speed. So far I've tried changing the readahead, minimum resync speed, str=
ipe
cache size, but it increased the resync speed by few percent only.

I believe I would be able to write my own userspace application for rebuil=
ding
the array offline with much higher speed ... just doing XOR of bytes at th=
e same
offsets. That would prove the current rebuild strategy is suboptimal.

Of course it would mean a new code if it doesn't work like suggested and I=
 know
it could be difficult and requiring a deep knowledge of the linux-raid cod=
e that
unfortunately I don't have.

Any chance someone here could find time to look at that?

Thank you,
Jaromir Capik


On 09/01/2022 14:21, Jarom=C3=ADr C=C3=A1p=C3=ADk wrote:

>> In case of huge arrays (48TB in my case) the array rebuild takes a coup=
le of
>> days with the current approach even when the array is idle and during t=
hat
>> time any of the drives could fail causing a fatal data loss.
>> 
>> Does it make at least a bit of sense or my understanding and assumption=
s
>> are wrong?
>
>It does make sense, but have you read the code to see if it already does =
it?
>And if it doesn't, someone's going to have to write it, in which case it =

>
>doesn't make sense, not to have that as the default.
>
>Bear in mind that rebuilding the array with a new drive is completely 
>
>different logic to doing an integrity check, so will need its own code, =

>
>so I expect it already works that way.
>
>
>I think you've got two choices. Firstly, raid or not, you should have 
>
>backups! Raid is for high-availability, not for keeping your data safe! =

>
>And secondly, go raid-6 which gives you that bit extra redundancy.
>Cheers,
>
>Wol
