Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC578C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  1 Nov 2023 14:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344282AbjKAO3k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Nov 2023 10:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbjKAO3j (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Nov 2023 10:29:39 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B464A10C
        for <linux-raid@vger.kernel.org>; Wed,  1 Nov 2023 07:29:36 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7a69a1b51baso21719639f.1
        for <linux-raid@vger.kernel.org>; Wed, 01 Nov 2023 07:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698848976; x=1699453776; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V3eN/jvd9x1KysCMs6b/iM0IwUIx0p2Bvn3f4F+c8o0=;
        b=kRfvAwVVoMyDknlcJ8Qx5izDsDV5S+Ma5a/4SodxxZkD+izf/GXKniVB+vXj2JZbz0
         YwDZoiD090aL8h3xAwh0jWKN9F5cjAJgofFZ76Sunp0VBrxTXATGwTeVCltAqwC7Fj3w
         f8seXVn7bBWzOvolDv2NFeE9qKIwjL0LRiU7IxLiGFI9TsyEBtmUG17FGE1+OgSelAG4
         4eVgeqp5a386UkrB7PKpB0tgHlFi0awavnLe+8nyeYZDAwJw7go4raupdmR7uFjXp9bu
         X3NAxjzWCTxJZBwlYCqhDQFi3dPUof/vPgxGJn0ZdG6ay+zZ7EO3Zkw9ddBfuCDFrJUJ
         mmHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698848976; x=1699453776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V3eN/jvd9x1KysCMs6b/iM0IwUIx0p2Bvn3f4F+c8o0=;
        b=CU1HwkwiMevDRazg+i9+wY74Nh6CVzXiBTpQmXlfT2u1zb/DE9oDSslurcOXAfs992
         7oYl/dYOt7DFSUaj3p+IB3rZmvCyS2I1QWL1g+i7MDbnbKHxR8vSj9W/1knWCoqLwzSZ
         UR/DcFIXLQHRaUeH2rVk4zxRZ+6J/oT0Ii0NxDcGsLg1SoAZJdlxBsW+MFfq5N+2ci60
         ajf2mrxx3YIx0sE6wovHLkfp0aTHxjMqw1yojdPzoEZfklmokG1ANTXZZ+jTcbsKg5AK
         s5nAHoduwWcNFtal2Y09N0XCDMOrKSWi1w6PJGnkq5gfSh8Nk3RK3UU5updGoSq6AHr6
         cVNw==
X-Gm-Message-State: AOJu0YwiOawHmOKM+PzQEZMqeMrq9KqZiKa9oIubwhRsw0g16JxzOAtU
        ZPGC9Ap3tnmwe7vGwbBqyNiwSYpqjVNC/XiJF4CaLjK8wFo=
X-Google-Smtp-Source: AGHT+IFLPYLHENk3IBV++/okrMGvD14URv9BoTzNXJWSQgJxNKSWE794nXdn+7QNpx2tCzR2gndSE2zNgE3f62zb5qA=
X-Received: by 2002:a05:6e02:3712:b0:358:219:bfb0 with SMTP id
 ck18-20020a056e02371200b003580219bfb0mr3519223ilb.11.1698848975885; Wed, 01
 Nov 2023 07:29:35 -0700 (PDT)
MIME-Version: 1.0
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br> <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au> <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
 <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au>
In-Reply-To: <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Wed, 1 Nov 2023 09:29:25 -0500
Message-ID: <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
Subject: Re: problem with recovered array
To:     eyal@eyal.emu.id.au
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Did you test writing on the array?    And if you did test it did you
use a big enough file and/or bypass/disable cache?  Having the default
dirty* settings high/default it can cache up to 20% of RAM (without
writing it to disk).  Raid5/6 writing is much slower than reads.  If
you have a single raid5/6 array of spinning disks I would be surprised
if it was able to sustain anything close to 175MB/sec.     Mine
struggles to sustain even 100MB/sec on writes.

But (with my 3M/5Mbyte _bytes setting (lets the cache work, but
prevents massive amounts of data in cache).
vm.dirty_background_bytes =3D 3000000
vm.dirty_bytes =3D 5000000
dd if=3D/dev/zero bs=3D256K of=3Dtestfile.out count=3D4000 status=3Dprogres=
s
501481472 bytes (501 MB, 478 MiB) copied, 8 s, 62.5 MB/s^C
2183+0 records in
2183+0 records out
572260352 bytes (572 MB, 546 MiB) copied, 8.79945 s, 65.0 MB/s

Using the fedora default:
vm.dirty_background_ratio =3D 20
vm.dirty_ratio =3D 20
dd if=3D/dev/zero bs=3D256K of=3Dtestfile.out count=3D4000 status=3Dprogres=
s
4000+0 records in
4000+0 records out
1048576000 bytes (1.0 GB, 1000 MiB) copied, 0.687841 s, 1.5 GB/s

Note that on the 2nd test writing was still happening for the next
5-8seconds after it exited, giving an appearance of being much faster
than it is.  As the test size is increased the speed gets lower as
more of the data has to get written.  On my system with the fedora
default settings (64G ram) with a 16G file I am still getting
300MB/sec even though the underlying array can only really do around
70-100MB/sec.

Raid5/6 typically breaks down to about the write rate of a single disk
because of all of the extra work that has to be done for raid5/6 to
work.

Do you happen to know how fragmented the 8gb vm file is?   (filefrag
<filename>).   each fragment requires a separate several ms seek.

On Wed, Nov 1, 2023 at 8:08=E2=80=AFAM <eyal@eyal.emu.id.au> wrote:
>
> On 01/11/2023 21.30, Roger Heflin wrote:
> > Did you check with iostat/sar?    (iostat -x 2 5).  The md
> > housekeeping/background stuff does not show on the md device itself,
> > but it shows on the underlying disks.
>
> Yes, I have iostat on both the md device and the components and I see spa=
rse activity on both.
>
> > It might also be related the the bitmap keeping track of how far the
> > missing disk is behind.
>
> This may be the case. In case the disk is re-added it may help to know th=
is,
> but if a new disk is added then the full disk will be recreated anyway.
>
> > Small files are troublesome.    A tiny file takes several reads and wri=
tes.
>
> Yes, but the array is so fast that this should not be a problem.
> The rsync source is 175MB/s and the target array is 800MB/s so I do not
> see how the writing can slow the copy.
>
> In one case I (virsh) saved a VM, which created one 8GB file, which took
> many hours to be written.
>
> > I think the bitmap is tracking how many writes need to be done on the
> > missing disk, and if so then until the new disk gets put back will not
> > start cleaning up.
> >
> >
> > On Tue, Oct 31, 2023 at 4:40=E2=80=AFPM <eyal@eyal.emu.id.au> wrote:
> >>
> >> On 31/10/2023 21.24, Roger Heflin wrote:
> >>> If you directory entries are large (lots of small files in a
> >>> directory) then the recovery of the missing data could be just enough
> >>> to push your array too hard.
> >>
> >> Nah, the directory I am copying has nothing really large, and the targ=
et directory is created new.
> >>
> >>> find /<mount> -type d -size +1M -ls     will find large directories.
> >>>
> >>> do a ls -l <largedirname> | wc -l and see how many files are in there=
.
> >>>
> >>> ext3/4 has issues with really big directories.
> >>>
> >>> The perf top showed just about all of the time was being spend in
> >>> ext3/4 threads allocating new blocks/directory entries and such.
> >>
> >> Just in case there is an issue, I will copy another directory as a tes=
t.
> >> [later] Same issue. This time the files were Pictures, 1-3MB each, so =
it went faster (but not as fast as the array can sustain).
> >> After a few minutes (9GB copied) it took a long pause and a second kwo=
rker started. This one gone after I killed the copy.
> >>
> >> However, this same content was copied from an external USB disk (NOT t=
o the array) without a problem.
> >>
> >>> How much free space does the disk show in df?
> >>
> >> Enough  room:
> >>          /dev/md127       55T   45T  9.8T  83% /data1
> >>
> >> I still suspect an issue with the array after it was recovered.
> >>
> >> A replated issue is that there is a constant rate of writes to the arr=
ay (iostat says) at about 5KB/s
> >> when there is no activity on this fs. In the past I saw zero read/writ=
e in iostat in this situation.
> >>
> >> Is there some background md process? Can it be hurried to completion?
> >>
> >>> On Tue, Oct 31, 2023 at 4:29=E2=80=AFAM <eyal@eyal.emu.id.au> wrote:
> >>>>
> >>>> On 31/10/2023 14.21, Carlos Carvalho wrote:
> >>>>> Roger Heflin (rogerheflin@gmail.com) wrote on Mon, Oct 30, 2023 at =
01:14:49PM -03:
> >>>>>> look at  SAR -d output for all the disks in the raid6.   It may be=
 a
> >>>>>> disk issue (though I suspect not given the 100% cpu show in raid).
> >>>>>>
> >>>>>> Clearly something very expensive/deadlockish is happening because =
of
> >>>>>> the raid having to rebuild the data from the missing disk, not sur=
e
> >>>>>> what could be wrong with it.
> >>>>>
> >>>>> This is very similar to what I complained some 3 months ago. For me=
 it happens
> >>>>> with an array in normal state. sar shows no disk activity yet there=
 are no
> >>>>> writes to the array (reads happen normally) and the flushd thread u=
ses 100%
> >>>>> cpu.
> >>>>>
> >>>>> For the latest 6.5.* I can reliably reproduce it with
> >>>>> % xzcat linux-6.5.tar.xz | tar x -f -
> >>>>>
> >>>>> This leaves the machine with ~1.5GB of dirty pages (as reported by
> >>>>> /proc/meminfo) that it never manages to write to the array. I've wa=
ited for
> >>>>> several hours to no avail. After a reboot the kernel tree had only =
about 220MB
> >>>>> instead of ~1.5GB...
> >>>>
> >>>> More evidence that the problem relates to the cache not flushed to d=
isk.
> >>>>
> >>>> If I run 'rsync --fsync ...' it slows it down as the writing is flus=
hed to disk for each file.
> >>>> But it also evicts it from the cache, so nothing accumulates.
> >>>> The result is a slower than otherwise copying but it streams with no=
 pauses.
> >>>>
> >>>> It seems that the array is slow to sync files somehow. Mythtv has no=
 problems because it write
> >>>> only a few large files. rsync copies a very large number of small fi=
les which somehow triggers
> >>>> the problem.
> >>>>
> >>>> This is why my 'dd if=3D/dev/zero of=3Dfile-on-array' goes fast with=
out problems.
> >>>>
> >>>> Just my guess.
> >>>>
> >>>> BTW I ran fsck on the fs (on the array) and it found no fault.
> >>>>
> >>>> --
> >>>> Eyal at Home (eyal@eyal.emu.id.au)
> >>>>
> >>
> >> --
> >> Eyal at Home (eyal@eyal.emu.id.au)
> >>
>
> --
> Eyal at Home (eyal@eyal.emu.id.au)
>
