Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2CAEC433FE
	for <linux-raid@archiver.kernel.org>; Fri, 21 Oct 2022 11:51:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJULv4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Oct 2022 07:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiJULvz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Oct 2022 07:51:55 -0400
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D13924B337
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 04:51:54 -0700 (PDT)
Received: by mail-ua1-x92c.google.com with SMTP id i16so2251460uak.1
        for <linux-raid@vger.kernel.org>; Fri, 21 Oct 2022 04:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6kWyDVwGOCOJvN9GWcgaDEQaOVNt1oKvYS0iumVm3ek=;
        b=GReKr6sa9BNdXUL2rfV3KHZucbK+ZeowOQIvbKK0JvCSqEdM5ufOMcmxE85g0t7Blr
         3lXfN0aqTbOMBzCHvCqDPVTs+p0r4dsd7sSWdJ+Jt/UbJiRxlkVBmyYTV6VqXT7f6foi
         2siGcvT7AhJey2vgf2QDTnfEeGsa9n6+rpGm9DH6d9zkdoLEPto5CpzjUkI5jaS3QMUK
         XMzsnOjWvjgyQRe8RAZHhur90RSsTFjCQm6V38xGpA08PLea7/phZdYszUxCdKsJqKUB
         sioxZ0034Iv5VzvtQ8KH/Kepz3xSfJwbzHkl/Eek+XI00mw9Jx3KpvvAp3C6X437lBBC
         tJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6kWyDVwGOCOJvN9GWcgaDEQaOVNt1oKvYS0iumVm3ek=;
        b=Oos3BGNel2jWrBzjU7b2m2h+PIRUYxkl7px6l6STjWb/4TdZ/z5MZvWRx+guTnlfwf
         wAVDl26KLbsCahAH7MPnVsWo6DlcXDw0yBP++fecHciQSsbWkUJKGxTkA5OFq5ILed+g
         h2rrMW/oD6mQvDE+2rkKjKHV5cta/FxVzUwGbVYtLhc1eYE6FLLtuq1WX0bE6MoASbhT
         0FbIAfEkFLx7CFkwOb/WX5R5EYnRwWkET96Bi8GXqgcyNkHp4Tei+/ZttjpsHdPQNxDg
         gItRn4SB5QxiqoRu/cgDTxIGorS6XVmp/1WqZJmRovCdWIOgKaKQONF5KMEXaUOx3i4d
         KmPw==
X-Gm-Message-State: ACrzQf0sL5EA0BMDXCetwrZHj9jVJujhDmnxtUb3rvan6bc/KRqhxmQx
        o1qfs6iL+dp3JyuhwjxYN1j8Rr7uoNR1wQm5WFRoR8ko
X-Google-Smtp-Source: AMsMyM6hyo+9TCdAuQFWDSLyAqHq7bRvit6aMhrJ1P+4ujZT5pLJrNsC/Git3mX5jZGnWWgth3Ww2C//dJhOiTf5PH8=
X-Received: by 2002:ab0:25d4:0:b0:3c1:c353:31cb with SMTP id
 y20-20020ab025d4000000b003c1c35331cbmr12548896uan.63.1666353112720; Fri, 21
 Oct 2022 04:51:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAEQ-dADdRd91GBkTzVU0AQiXQ4tLitYsU2uLziWOi=hLtaBK0w@mail.gmail.com>
 <e9feaefd-9ddb-c07a-86b8-3640ca4201af@thelounge.net> <7ca2b272-4920-076f-ecaf-5109db0aae46@youngman.org.uk>
 <CAAMCDef4bGs_LnbxEie=2FkxD6YJ_A4WFzW8c647k9MNLGoY3A@mail.gmail.com>
 <CAEQ-dAAYRAg-t3ve9RJV-vJhzqMSe7YOw2bwJVJ_vk0BDp7NZw@mail.gmail.com>
 <20221021001405.2uapizqtsj3wxptb@bitfolk.com> <6c31fc94-b70e-88c5-205a-efff32baf594@plouf.fr.eu.org>
 <20221021105107.nhihftkjck74jg6i@bitfolk.com>
In-Reply-To: <20221021105107.nhihftkjck74jg6i@bitfolk.com>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 21 Oct 2022 06:51:41 -0500
Message-ID: <CAAMCDec5k2AvTik6SA_3c48pfH+VxAi9cRb4Qj-xpcAAcOpp0g@mail.gmail.com>
Subject: Re: Performance Testing MD-RAID10 with 1 failed drive
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It is likely much simpler.

Using a 2 disks raid 1 array with 100 reads iops and 100 write iops to
the filesystem you would see this with 2 disks:   150 iops per disk
(100 writes + 50 reads), but with one disk only in the raid you see
200 iops/disk (100 reads+100writes) and at that 7200 rpm spinning
disks would be overcapacity. Now with 8 disks the numbers scale up,
but the general idea is still the same.  Once a disk fails then all of
the reads it was handling have to go to the single remaining disk and
that read load could result in that remaining disk not being able to
keep up.

The original poster needs to get sar or iostat stat to see what the
actual io rates are, but if they don't understand what the spinning
disk array can do fully redundant and with a disk failed it is not
unlikely that the IO load is higher than a can be sustained with a
single disk failed.

On Fri, Oct 21, 2022 at 6:34 AM Andy Smith <andy@strugglers.net> wrote:
>
> Hello,
>
> On Fri, Oct 21, 2022 at 10:15:42AM +0200, Pascal Hambourg wrote:
> > Le 21/10/2022 =C3=A0 02:14, Andy Smith a =C3=A9crit :
> > > Perhaps you could use dm-dust to make an unreliable block device
> > > from a real device?
> >
> > That seems uselessly complicated to me.
>
> Well I too do not understand why OP can't just fail one existing
> device, but it seemed important to them to experience actual errors
> and have it kicked out for that. A half way measure might be the
> offline / delete poking I mentioned in /sys/block.
>
> *shrug*
>
> Cheers,
> Andy
>
> --
> https://bitfolk.com/ -- No-nonsense VPS hosting
