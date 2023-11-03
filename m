Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EF3C4332F
	for <linux-raid@archiver.kernel.org>; Fri,  3 Nov 2023 15:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343579AbjKCP5Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Nov 2023 11:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjKCP5Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Nov 2023 11:57:24 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D53D111
        for <linux-raid@vger.kernel.org>; Fri,  3 Nov 2023 08:57:22 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7a692658181so71722539f.1
        for <linux-raid@vger.kernel.org>; Fri, 03 Nov 2023 08:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699027041; x=1699631841; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f91sMQ0X2yCmqZzJX4QJ8iyVzESaa9VIgckACYmMKLg=;
        b=SYnZehvadV1DD1xEiyOopfoFLFIXXFb3YMIuUYVVMh5HxzpI60LaFyKycyS6vgpBay
         Qv4bMfEzfB77hdoz0FNQyyxECEeD5ujzjNPSpQueQ+VRUX7yIiPeKjdnmV349YEnUxhK
         Id8IeVw6PLMwyIP3Q3cTInFOujHEWtiQfhOSe9YVP5g2mZFFaaW2uDS2aSjxaMMW6vbO
         s+SFCT/14Jh8mbIj9Ct/C4CX59TwGaiItkhBU0jUpDAQdhqlq+YYdltOBRMlkjUo2l07
         QUbeaJ40PTqcVDnc19Eshi2neIuULRJRrgX6pphMD0F6RImNL70aefdeSKvVeIRpxpBv
         0vJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699027041; x=1699631841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f91sMQ0X2yCmqZzJX4QJ8iyVzESaa9VIgckACYmMKLg=;
        b=uolC9+UwrKT0u64SWtZDD3qrmCDurrAEB52AbcbL8+G82xYq9u0+A+dsrqSs40gR0U
         1PKxh62lQ4LD8Owsgv+KWhA1d7+prFIHS4/vnyqjnTQ2Yyk3TvkrhPX39P6nnKy7bcOD
         fpq7pMph0TPUgIkwliG9rZ+eil51ExasnWDRlqQzO53uzzQeMGsxGe/oM32EBx6ZtCpH
         XuyDg0OcmYCRKyClOQ6aCKKHMOQNpJc+VAh/6hAeZ053LST5G1VPS0+QrkPPES+fjnpH
         /a07rhYrFRNoattEWCBbyDj+vw1259XvJJhzAESe7OSaCCtVBH9nV7ecHCTno+AxAB9m
         dWwg==
X-Gm-Message-State: AOJu0YwtbPoxiTfb5OTYCh5l7KjFNiyVKimE7Hbp9XQoSuB7F7SlGkLb
        dLiw/Cu/u++z/vhCE6zu+pllTJiuEluwD+odCuAQsXCLwe0=
X-Google-Smtp-Source: AGHT+IGdq9e4CgNm5Kw+9tEUWnpnVDuBTw+T/aJwDhzgQUeArl23wOlDa+qWoIeEucAff4YJ215JZM18cetGOd/q9Kk=
X-Received: by 2002:a05:6602:2a4d:b0:7a9:4268:fc26 with SMTP id
 k13-20020a0566022a4d00b007a94268fc26mr30017939iov.10.1699027041357; Fri, 03
 Nov 2023 08:57:21 -0700 (PDT)
MIME-Version: 1.0
References: <87273fc6-9531-4072-ae6c-06306e9a269d@eyal.emu.id.au>
 <CAAMCDecjCJz3qPve-54wpd_eX3dTgLYrMVupX6i3JNfBq2mNPw@mail.gmail.com>
 <ZUByq7Wg-KFcXctW@fisica.ufpr.br> <577244fc-f43a-4e1f-bf34-d1c194fd90b4@eyal.emu.id.au>
 <CAAMCDedPoNcdacRHNykOtG0yw4mDV3WFpowU1WtoQJgdNAKjDg@mail.gmail.com>
 <0dc5a117-97be-4ed1-9976-1f754a6abf91@eyal.emu.id.au> <CAAMCDecobWVOxGOxFt47Y4ZC2JCNVH1T2oQ8X=6BHOz9PemNEQ@mail.gmail.com>
 <37b6265a-b925-4910-b092-59177b639ca9@eyal.emu.id.au> <CAAMCDefUcuz2Nzh7AvP9m50uq86ZBK3AhEAEynVG_mmmY_f0jQ@mail.gmail.com>
 <ZUNfK1jqBNsm97Q-@vault.lan> <ZUUA2U88VsGqGDmj@fisica.ufpr.br>
In-Reply-To: <ZUUA2U88VsGqGDmj@fisica.ufpr.br>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Fri, 3 Nov 2023 10:57:10 -0500
Message-ID: <CAAMCDec-=vwLJhpi4VfCXdgGactYWeidqmV=VPphGE6eEUxUQg@mail.gmail.com>
Subject: Re: problem with recovered array
To:     Carlos Carvalho <carlos@fisica.ufpr.br>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Nov 3, 2023 at 9:17=E2=80=AFAM Carlos Carvalho <carlos@fisica.ufpr.=
br> wrote:
>
> Johannes Truschnigg (johannes@truschnigg.info) wrote on Thu, Nov 02, 2023=
 at 05:34:51AM -03:
> > for the record, I do not think that any of the observations the OP made=
 can be
> > explained by non-pathological phenomena/patterns of behavior. Something=
 is
> > very clearly wrong with how this system behaves (the reported figures d=
o not
> > at all match the expected performance of even a degraded RAID6 array in=
 my
> > experience) and how data written to the filesystem apparently fails to =
make it
> > into the backing devices in acceptable time.
> >
> > The whole affair reeks either of "subtle kernel bug", or maybe "subtle
> > hardware failure", I think.
>
> Exactly. That's what I've been saying for months...
>
> I found a clear comparison: expanding the kernel tarball in the SAME MACH=
INE
> with 6.1.61 and 6.5.10. The raid6 array is working normally in both cases=
. With
> 6.1.61 the expansion works fine, finishes with ~100MB of dirty pages and =
these
> are quickly sent to permanent storage. With 6.5.* it finishes with ~1.5GB=
 of
> dirty pages that are never sent to disk (I waited ~3h). The disks are idl=
e, as
> shown by sar, and the kworker/flushd runs with 100% cpu usage forever.
>
> Limiting the dirty*bytes in /proc/sys/vm the dirty pages stay low BUT tar=
 is
> blocked in D state and the tarball expansion proceeds so slowly that it'd=
 take
> days to complete (checked with quota).
>
> So 6.5 (and 6.4) are unusable in this case. In another machine, which doe=
s
> hundreds of rsync downloads every day, the same problem exists and I also=
 get
> frequent random rsync timeouts.
>
> This is all with raid6 and ext4. One of the machines has a journal disk i=
n the
> raid and the filesystem is mounted with nobarriers. Both show the same
> behavior. It'd be interesting to try a different filesystem but these are
> production machines with many disks and I cannot create another big array=
 to
> transfer the contents.

My array is running 6.5 + xfs, and mine all seems to work normally
(speed wise).  And in the perf top call he ran all of the busy
kworkers were ext4* calls spending a lot of time doing various
filesystem work.

I did find/debug a situation where dumping the cache caused ext4
performance to be a disaster (large directories, lots of files).  It
was tracked back to ext4 relies on the Buffers:  data space in
/proc/meminfo for at least directory entry caching, and that if there
were a lot of directories and/or files in directories that Buffer:
getting dropped and/or getting pruned for any some reason caused the
fragmented directory entries to have to get reloaded from a spinning
disk and require the disk to be seeking for  *MINUTES* to reload it
(there were in this case several million files in a couple of
directories with the directory entries being allocated over time so
very likely heavily fragmented).

I wonder if there was some change with how Buffers is
used/sized/pruned in the recent kernels.   The same drop_cache on an
XFS filesystem had no effect that I could identify and doing a ls -lR
on a big xfs filesystem does not make Buffers grow, but doing the same
ls -lR against an ext3/4 makes Buffers grow quite a bit (how much
depends on how many files/directories are on the filesystem).

He may want to monitor buffers (cat /proc/meminfo | grep Buffers:) and
see if the poor performance correlates with Buffers suddenly being
smaller for some reason.
