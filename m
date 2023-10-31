Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B246C4332F
	for <linux-raid@archiver.kernel.org>; Tue, 31 Oct 2023 10:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343640AbjJaKYb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Oct 2023 06:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbjJaKYa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Oct 2023 06:24:30 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8E383
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 03:24:27 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-3592fadbd7eso3225235ab.0
        for <linux-raid@vger.kernel.org>; Tue, 31 Oct 2023 03:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698747867; x=1699352667; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBMEOy6tL2QLP8+UgkbSXWwKG8rROUuod1Uxi71aohQ=;
        b=jWDot4Xqt1cXy81klya8R0Sx9FFQ+x3GdNd0JRquob6CvPQrDGdJHIWANqLtZD/xGL
         RgWGaop6PvzSpTse8W1rl+IeBAceGzMlOB/Xcr4Fu2to6UePYhgtnYP3AMgtL4DHjvOh
         zNVriAZntVu3B/9G9ofancJ4npNxy7a6Ss4VtK7rpxgjIf16pnleeLeY5DwQ612piAZl
         uUJ0BgXX4aDWDqxBan5x/O3fDMi/SbAz4QqHrmNyMbuhOatprJUMgiK0mFZ1NKh0S2Ch
         ZREGkOdjt1sY4+Mphr5jSCS0izrXMDxvcYaorFyhKJjVWdmYDzbLiNO/pMFywWY1DRmU
         9XJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698747867; x=1699352667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBMEOy6tL2QLP8+UgkbSXWwKG8rROUuod1Uxi71aohQ=;
        b=VOKdYU5JHmyTdnM7uUScppZX7+QIFWOX8w0PwtjLpuUqONjGiGQ6LygBYkvkxyrhDd
         07hixmYqRQ/+aUVQTCeOIM787B4tFaK41NctWnsxN76YPcoq1G7j7B5v3L17XbPV/u4V
         l68md+j4ySJszjBY4tVEFQ28WDD9k6fNsr9SY0pGvhiPG8780b/wi05OmavZI9RNvXGa
         dcqFIHqpEPjereLP+xUxPXcDc6nOLnbEuM5aqWroG5dKjWtkydSFQx8L9sgJcpaJ07jw
         /9JA3MMn+dSnQ9asYo0s4fCtkgHpnLM199cWETUMkZudlkAmANtM7hiRe7eTJNQQxOG8
         GM2A==
X-Gm-Message-State: AOJu0Yydv7tEAKyVjLzZ3NbV3mlSVVxAcP5qScfVRBlm3d3oa12Ok0TM
        H+FBNkdvJmyvT8erCI3f1Wxr7RViLBzjQlueSFN8j8T+HLY=
X-Google-Smtp-Source: AGHT+IHmj2Mb50o+a6LlSPJ4AZ9DgisLzP6ofXPMUJmAyHG3uCwss8DsQFHsxj/+3CdJM47eYJsw7M8J/CejWODrqoQ=
X-Received: by 2002:a05:6e02:20e6:b0:357:a5cc:de86 with SMTP id
 q6-20020a056e0220e600b00357a5ccde86mr17091267ilv.23.1698747866705; Tue, 31
 Oct 2023 03:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br> <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
In-Reply-To: <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 31 Oct 2023 05:24:15 -0500
Message-ID: <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
Subject: Re: problem with recovered array
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If you directory entries are large (lots of small files in a
directory) then the recovery of the missing data could be just enough
to push your array too hard.

find /<mount> -type d -size +1M -ls     will find large directories.

do a ls -l <largedirname> | wc -l and see how many files are in there.

ext3/4 has issues with really big directories.

The perf top showed just about all of the time was being spend in
ext3/4 threads allocating new blocks/directory entries and such.

How much free space does the disk show in df?


On Tue, Oct 31, 2023 at 4:29=E2=80=AFAM <eyal@eyal.emu.id.au> wrote:
>
> On 31/10/2023 14.21, Carlos Carvalho wrote:
> > Roger Heflin (rogerheflin@gmail.com) wrote on Mon, Oct 30, 2023 at 01:1=
4:49PM -03:
> >> look at  SAR -d output for all the disks in the raid6.   It may be a
> >> disk issue (though I suspect not given the 100% cpu show in raid).
> >>
> >> Clearly something very expensive/deadlockish is happening because of
> >> the raid having to rebuild the data from the missing disk, not sure
> >> what could be wrong with it.
> >
> > This is very similar to what I complained some 3 months ago. For me it =
happens
> > with an array in normal state. sar shows no disk activity yet there are=
 no
> > writes to the array (reads happen normally) and the flushd thread uses =
100%
> > cpu.
> >
> > For the latest 6.5.* I can reliably reproduce it with
> > % xzcat linux-6.5.tar.xz | tar x -f -
> >
> > This leaves the machine with ~1.5GB of dirty pages (as reported by
> > /proc/meminfo) that it never manages to write to the array. I've waited=
 for
> > several hours to no avail. After a reboot the kernel tree had only abou=
t 220MB
> > instead of ~1.5GB...
>
> More evidence that the problem relates to the cache not flushed to disk.
>
> If I run 'rsync --fsync ...' it slows it down as the writing is flushed t=
o disk for each file.
> But it also evicts it from the cache, so nothing accumulates.
> The result is a slower than otherwise copying but it streams with no paus=
es.
>
> It seems that the array is slow to sync files somehow. Mythtv has no prob=
lems because it write
> only a few large files. rsync copies a very large number of small files w=
hich somehow triggers
> the problem.
>
> This is why my 'dd if=3D/dev/zero of=3Dfile-on-array' goes fast without p=
roblems.
>
> Just my guess.
>
> BTW I ran fsck on the fs (on the array) and it found no fault.
>
> --
> Eyal at Home (eyal@eyal.emu.id.au)
>
