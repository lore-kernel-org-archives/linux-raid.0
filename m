Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12BEC4332F
	for <linux-raid@archiver.kernel.org>; Wed,  1 Nov 2023 10:30:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbjKAKah (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Nov 2023 06:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbjKAKae (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Nov 2023 06:30:34 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55FBDE
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 03:30:31 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-7a66ff282baso18638739f.0
        for <linux-raid@vger.kernel.org>; Wed, 01 Nov 2023 03:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698834631; x=1699439431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZJvUEik/ZjP/wNjcVaL22L1jVXBjO7Qc6sneDMJbzU0=;
        b=TffHzlbF5IkeXDZbM6Xa/DE/1htrXMVIYyv2LYWyp6rZBF1u0urlaeb7THyO3ycnuy
         RKVz3AnlkxSmZgtwr6N+5qP3Eu46px3uaB4g5Jf2BCvJOuESs+BmFr7bByhHui/tiSpu
         pHjz54GlSbFgvF6HS+Hu29I9Nr7wlV5OemWQFuij1zO8lfJy0IvY62R4dTJN2zbczM+d
         ClelEBgv1TeiLjP0TH4hth4gyxb4DOCPpmQI4Fu+HuN2GIKINOvLjVrEEWX0Adx8Y/oD
         3wsJ2YvdIBcsp2PES+qUC1XPI66LUgiEzXcRFafYBvhKi686bCVx/17T48LyjD7ad3Ti
         06qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698834631; x=1699439431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZJvUEik/ZjP/wNjcVaL22L1jVXBjO7Qc6sneDMJbzU0=;
        b=mGOpbOgXkp2vpkO7BLOJGLWUkxUF+dZnlrod7bXPikwOF0IWR+NUbtreWiAt38F0Sc
         GI2PDwWQPUO0TB0s1a0WwtYo3CCrr951j8j1MuuPpr54uWgJaSj8Q4a8LrVfQs/YLqnE
         CAmuV7Mt+8PFa5uULlsmqlhhXpiG1qY2pRDrI4BQ7RPSzRyn051zvALh2Nsv+oS2samS
         MfbdRwGKYCcGViv7jXOO0i7Vuxu070t2FAoQimLnf/Y+z7eFOPT1LYk9th/P2EbsGnFN
         d3vwXOHODZR10846PLwuFuQpgTQ46/8tr7gciobgW4Sj9p3NFedQAJxbnFshMO+Okjz3
         pF6A==
X-Gm-Message-State: AOJu0Yz2iNlPV9NpW6ZBkwKAA6AFMDA3mf/UEywtqIESkNOmFFBnfZRr
        9JHTIXYOUGfDXremlYSU126XY5MiQRqQD/7uuuJ6AsLy
X-Google-Smtp-Source: AGHT+IHO/r6tVKPX7ZSXMY4vEW/rAfhpxpMyB8f7sh/sgENI7sACYkyZ2LoqnEOxSIkdxK58Ntg7cT7xiN9DK792M48=
X-Received: by 2002:a05:6602:3a06:b0:7ac:ccd9:da93 with SMTP id
 by6-20020a0566023a0600b007acccd9da93mr2420530iob.0.1698834630966; Wed, 01 Nov
 2023 03:30:30 -0700 (PDT)
MIME-Version: 1.0
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br> <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com> <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au>
In-Reply-To: <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 1 Nov 2023 05:30:19 -0500
Message-ID: <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
Subject: Re: problem with recovered array
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Did you check with iostat/sar?    (iostat -x 2 5).  The md
housekeeping/background stuff does not show on the md device itself,
but it shows on the underlying disks.

It might also be related the the bitmap keeping track of how far the
missing disk is behind.

Small files are troublesome.    A tiny file takes several reads and writes.

I think the bitmap is tracking how many writes need to be done on the
missing disk, and if so then until the new disk gets put back will not
start cleaning up.


On Tue, Oct 31, 2023 at 4:40=E2=80=AFPM <eyal@eyal.emu.id.au> wrote:
>
> On 31/10/2023 21.24, Roger Heflin wrote:
> > If you directory entries are large (lots of small files in a
> > directory) then the recovery of the missing data could be just enough
> > to push your array too hard.
>
> Nah, the directory I am copying has nothing really large, and the target =
directory is created new.
>
> > find /<mount> -type d -size +1M -ls     will find large directories.
> >
> > do a ls -l <largedirname> | wc -l and see how many files are in there.
> >
> > ext3/4 has issues with really big directories.
> >
> > The perf top showed just about all of the time was being spend in
> > ext3/4 threads allocating new blocks/directory entries and such.
>
> Just in case there is an issue, I will copy another directory as a test.
> [later] Same issue. This time the files were Pictures, 1-3MB each, so it =
went faster (but not as fast as the array can sustain).
> After a few minutes (9GB copied) it took a long pause and a second kworke=
r started. This one gone after I killed the copy.
>
> However, this same content was copied from an external USB disk (NOT to t=
he array) without a problem.
>
> > How much free space does the disk show in df?
>
> Enough  room:
>         /dev/md127       55T   45T  9.8T  83% /data1
>
> I still suspect an issue with the array after it was recovered.
>
> A replated issue is that there is a constant rate of writes to the array =
(iostat says) at about 5KB/s
> when there is no activity on this fs. In the past I saw zero read/write i=
n iostat in this situation.
>
> Is there some background md process? Can it be hurried to completion?
>
> > On Tue, Oct 31, 2023 at 4:29=E2=80=AFAM <eyal@eyal.emu.id.au> wrote:
> >>
> >> On 31/10/2023 14.21, Carlos Carvalho wrote:
> >>> Roger Heflin (rogerheflin@gmail.com) wrote on Mon, Oct 30, 2023 at 01=
:14:49PM -03:
> >>>> look at  SAR -d output for all the disks in the raid6.   It may be a
> >>>> disk issue (though I suspect not given the 100% cpu show in raid).
> >>>>
> >>>> Clearly something very expensive/deadlockish is happening because of
> >>>> the raid having to rebuild the data from the missing disk, not sure
> >>>> what could be wrong with it.
> >>>
> >>> This is very similar to what I complained some 3 months ago. For me i=
t happens
> >>> with an array in normal state. sar shows no disk activity yet there a=
re no
> >>> writes to the array (reads happen normally) and the flushd thread use=
s 100%
> >>> cpu.
> >>>
> >>> For the latest 6.5.* I can reliably reproduce it with
> >>> % xzcat linux-6.5.tar.xz | tar x -f -
> >>>
> >>> This leaves the machine with ~1.5GB of dirty pages (as reported by
> >>> /proc/meminfo) that it never manages to write to the array. I've wait=
ed for
> >>> several hours to no avail. After a reboot the kernel tree had only ab=
out 220MB
> >>> instead of ~1.5GB...
> >>
> >> More evidence that the problem relates to the cache not flushed to dis=
k.
> >>
> >> If I run 'rsync --fsync ...' it slows it down as the writing is flushe=
d to disk for each file.
> >> But it also evicts it from the cache, so nothing accumulates.
> >> The result is a slower than otherwise copying but it streams with no p=
auses.
> >>
> >> It seems that the array is slow to sync files somehow. Mythtv has no p=
roblems because it write
> >> only a few large files. rsync copies a very large number of small file=
s which somehow triggers
> >> the problem.
> >>
> >> This is why my 'dd if=3D/dev/zero of=3Dfile-on-array' goes fast withou=
t problems.
> >>
> >> Just my guess.
> >>
> >> BTW I ran fsck on the fs (on the array) and it found no fault.
> >>
> >> --
> >> Eyal at Home (eyal@eyal.emu.id.au)
> >>
>
> --
> Eyal at Home (eyal@eyal.emu.id.au)
>
