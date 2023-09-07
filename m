Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E69EC8741
	for <linux-raid@archiver.kernel.org>; Thu,  7 Sep 2023 15:47:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235286AbjIGPrL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 7 Sep 2023 11:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239158AbjIGPi0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 7 Sep 2023 11:38:26 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24814210B
        for <linux-raid@vger.kernel.org>; Thu,  7 Sep 2023 08:37:09 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-31c479ede21so1099819f8f.2
        for <linux-raid@vger.kernel.org>; Thu, 07 Sep 2023 08:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694100997; x=1694705797; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GTBDC0NtQ86OlxmzNZkq0p3yRwTevFGZ90eicV4tpVs=;
        b=rjs77/kmbPTxtGgDw1u8YxjKB2jhAQJcpk5VkKz6pB1VRR8JyuV51FO3VE/18xNKSA
         j1m6YErMPJhgsDSR+iGrgoe9eggW0Lu9dvzwCjCVfOU996sUhU0MNjgz7hClvvsbHdXE
         Rt8TmQ7CQjDJhuYfoMAhNlZlw8ypk+1YlXmCd6JYmFAYdQWSKj2IqZq+Ya9FyFedxDYZ
         axvEN4EuPb+BDbpGDb8TrmC4pV50eeVN6w2tX/wbfQFSSA/CJKv16cV/QPdRpZPR3d4r
         wyrMTX3LvstzUVYv2uafobz3v+Zw+CCRPs/0fx/JGttX/psdIJkV/Ewiv5EksS+jqdZd
         HmNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694100997; x=1694705797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GTBDC0NtQ86OlxmzNZkq0p3yRwTevFGZ90eicV4tpVs=;
        b=DkMzBf4xsu/JqZFNgRjgAez+/BoUDb5xH+Y5oW4I0gh3epWnlDx7lZvKNUX08mdIHt
         aSjEJbRrCWnnkFJZ0+G2G48UA3e56c7USyZZ2m/N5D8Xnhc+09y+vCEVN37x+6d0Pk6E
         iFGdYXcGt+uPW/zbs7PQAGSzwve5TUCrl6kUVOSN4MLlLH+HdVU/KtLR09b0ap/P4YsD
         PZJPk50pK+yTH3r0S+23lY2cxQngGTk1Z78ZwfLIFOseB4DSQNBgvZnpnkWfK9LmUhoS
         wTrKNwyDlbTmPwXwp09Ig3yS50+7n16r5n2lVnMmwVbvxo1K2h/z3MLUS+FN6BFFdDta
         Syuw==
X-Gm-Message-State: AOJu0YwtpQwEwTefXAqgpEO45tb9lHRlfK13uRkFEgD92YXu0Zx9gA0P
        +vB37OoQciFI7s1E1QV1mAEDFRVWNiCSZYlB3zuILW/9l+hyDA==
X-Google-Smtp-Source: AGHT+IGZZBZjOZiibbT6zP5QW/5w+3Cg4dcRVzZfr/twCorcJ3RKfYjJvqs4xWLT7dOI/erdqu4ev0psZkkbsOcOiSg=
X-Received: by 2002:a05:6512:104a:b0:4fe:8c1d:9e81 with SMTP id
 c10-20020a056512104a00b004fe8c1d9e81mr5771001lfb.36.1694086213514; Thu, 07
 Sep 2023 04:30:13 -0700 (PDT)
MIME-Version: 1.0
References: <CAGqmV7ojxmsMVStS2LWzfeN+A565z4U=d9kUBUnAfCGq5TGtsw@mail.gmail.com>
 <c22e4c16-ad15-b358-ac42-778675aeb5ad@huaweicloud.com>
In-Reply-To: <c22e4c16-ad15-b358-ac42-778675aeb5ad@huaweicloud.com>
From:   CoolCold <coolthecold@gmail.com>
Date:   Thu, 7 Sep 2023 18:29:13 +0700
Message-ID: <CAGqmV7obHLD5FOT_jL05gw5-kMLXsWJpvv6VfoHce9-Pz6i74Q@mail.gmail.com>
Subject: Re: RADI10 slower than SINGLE drive - tests with fio for block device
 (no filesystem in use) - 18.5k vs 26k iops
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Linux RAID <linux-raid@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>,
        "yangerkun@huawei.com" <yangerkun@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Good day!

On Mon, Sep 4, 2023 at 2:16=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2023/09/02 14:56, CoolCold =E5=86=99=E9=81=93:
> > Good day!
> > 2nd part of the question, in relation of hardware/system from previous
> > thread -  "raid10, far layout initial sync slow + XFS question"
> > https://www.spinics.net/lists/raid/msg74907.html - Ubuntu 20.04 with
> > kernel "5.4.0-153-generic #170-Ubuntu" on Hetzner AX161 / AMD EPYC
> > 7502P 32-Core Processor
> >
> > Gist: issuing the same load on RAID10 4 drives N2 16kb chunk is slower
> > than running the same load on a single member of that RAID
> > Question: is such kind of behavior normal and expected? Am I doing
> > something terribly wrong?
>
> Write will be slower is normal, because each write to the array must
> write to all the rdev and wait for these write be be done.

This contradicts with common wisdom and basically eliminates one of
the points of having striped setups - having N stripes, excepted to
give up to N/2 improvement in iops.

Say, 3Ware "hardware" RAID has public benchmarks -
https://www.broadcom.com/support/knowledgebase/1211161476065/what-kind-of-r=
esults-can-i-expect-to-see-under-windows-with-3war
, test: 2K Random Writes (IOs/sec)(256 outstanding I/Os)
showing single drive ( 203.0 iops )  vs RAID10 4 drives ( 299.8 iops )
, which is roughly 1.5 times better, no WORSE as we see it with mdadm

I've done slightly different test, with fio numjobs=3D4 , result it 20k
(single job) vs 35k iops, which is just on par with single drive
performance.

>
> On the other hand, read should be faster, because raid10 only need to
> choose one rdev to read.
>
> Thanks,
> Kuai
>
> >
> > RAID10: 18.5k iops
> > SINGLE DRIVE: 26k iops
> >
> > raw data:
> >
> > RAID config
> > root@node2:/data# cat /proc/mdstat
> > Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> > [raid4] [raid10]
> > md3 : active raid10 nvme5n1[3] nvme3n1[2] nvme4n1[1] nvme0n1[0]
> >        7501212320 blocks super 1.2 16K chunks 2 near-copies [4/4] [UUUU=
]
> >
> > Single drive with:
> > root@node2:/data# mdadm /dev/md3 --fail /dev/nvme5n1 --remove /dev/nvme=
5n1
> > mdadm: set /dev/nvme5n1 faulty in /dev/md3
> > mdadm: hot removed /dev/nvme5n1 from /dev/md3
> >
> > mdadm --zero-superblock /dev/nvme5n1
> >
> > TEST COMMANDS
> > RADI10:              fio --rw=3Dwrite --ioengine=3Dsync --fdatasync=3D1
> > --filename=3D/dev/md3 --size=3D8200m --bs=3D16k --name=3Dmytest
> > SINGLE DRIVE: fio --rw=3Dwrite --ioengine=3Dsync --fdatasync=3D1
> > --filename=3D/dev/nvme5n1 --size=3D8200m --bs=3D16k --name=3Dmytest
> >
> > FIO output:
> >
> > RAID10:
> > root@node2:/mnt# fio --rw=3Dwrite --ioengine=3Dsync --fdatasync=3D1
> > --filename=3D/dev/md3 --size=3D8200m --bs=3D16k --name=3Dmytest
> > mytest: (g=3D0): rw=3Dwrite, bs=3D(R) 16.0KiB-16.0KiB, (W) 16.0KiB-16.0=
KiB,
> > (T) 16.0KiB-16.0KiB, ioengine=3Dsync, iodepth=3D1
> > fio-3.16
> > Starting 1 process
> > Jobs: 1 (f=3D1): [W(1)][100.0%][w=3D298MiB/s][w=3D19.0k IOPS][eta 00m:0=
0s]
> > mytest: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2130392: Sat Sep  2 08=
:21:39 2023
> >    write: IOPS=3D18.5k, BW=3D290MiB/s (304MB/s)(8200MiB/28321msec); 0 z=
one resets
> >      clat (usec): min=3D5, max=3D745, avg=3D12.12, stdev=3D 7.30
> >       lat (usec): min=3D6, max=3D746, avg=3D12.47, stdev=3D 7.34
> >      clat percentiles (usec):
> >       |  1.00th=3D[    8],  5.00th=3D[    9], 10.00th=3D[   10], 20.00t=
h=3D[   10],
> >       | 30.00th=3D[   10], 40.00th=3D[   11], 50.00th=3D[   11], 60.00t=
h=3D[   11],
> >       | 70.00th=3D[   12], 80.00th=3D[   13], 90.00th=3D[   16], 95.00t=
h=3D[   20],
> >       | 99.00th=3D[   39], 99.50th=3D[   55], 99.90th=3D[  100], 99.95t=
h=3D[  116],
> >       | 99.99th=3D[  147]
> >     bw (  KiB/s): min=3D276160, max=3D308672, per=3D99.96%, avg=3D29635=
4.86,
> > stdev=3D6624.06, samples=3D56
> >     iops        : min=3D17260, max=3D19292, avg=3D18522.18, stdev=3D414=
.00, samples=3D56
> >
> > Run status group 0 (all jobs):
> >    WRITE: bw=3D290MiB/s (304MB/s), 290MiB/s-290MiB/s (304MB/s-304MB/s),
> > io=3D8200MiB (8598MB), run=3D28321-28321msec
> >
> >
> >                                                Disk stats (read/write):
> >
> >                                       md3: ios=3D0/2604727, merge=3D0/0=
,
> > ticks=3D0/0, in_queue=3D0, util=3D0.00%, aggrios=3D25/262403,
> > aggrmerge=3D0/787199, aggrticks=3D1/5563, aggrin_queue=3D0, aggrutil=3D=
98.10%
> >    nvme0n1: ios=3D40/262402, merge=3D1/787200, ticks=3D3/5092, in_queue=
=3D0, util=3D98.09%
> >    nvme3n1: ios=3D33/262404, merge=3D1/787198, ticks=3D2/5050, in_queue=
=3D0, util=3D98.08%
> >    nvme5n1: ios=3D15/262404, merge=3D0/787198, ticks=3D1/6061, in_queue=
=3D0, util=3D98.08%
> >    nvme4n1: ios=3D12/262402, merge=3D0/787200, ticks=3D1/6052, in_queue=
=3D0, util=3D98.10%
> >
> >
> > SINGLE DRIVE:
> > root@node2:/mnt# fio --rw=3Dwrite --ioengine=3Dsync --fdatasync=3D1
> > --filename=3D/dev/nvme5n1 --size=3D8200m --bs=3D16k --name=3Dmytest
> > mytest: (g=3D0): rw=3Dwrite, bs=3D(R) 16.0KiB-16.0KiB, (W) 16.0KiB-16.0=
KiB,
> > (T) 16.0KiB-16.0KiB, ioengine=3Dsync, iodepth=3D1
> > fio-3.16
> > Starting 1 process
> > Jobs: 1 (f=3D1): [W(1)][100.0%][w=3D414MiB/s][w=3D26.5k IOPS][eta 00m:0=
0s]
> > mytest: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2155313: Sat Sep  2 08=
:26:23 2023
> >    write: IOPS=3D26.2k, BW=3D410MiB/s (430MB/s)(8200MiB/20000msec); 0 z=
one resets
> >      clat (usec): min=3D4, max=3D848, avg=3D11.25, stdev=3D 7.15
> >       lat (usec): min=3D5, max=3D848, avg=3D11.50, stdev=3D 7.17
> >      clat percentiles (usec):
> >       |  1.00th=3D[    7],  5.00th=3D[    9], 10.00th=3D[    9], 20.00t=
h=3D[    9],
> >       | 30.00th=3D[   10], 40.00th=3D[   10], 50.00th=3D[   10], 60.00t=
h=3D[   11],
> >       | 70.00th=3D[   11], 80.00th=3D[   12], 90.00th=3D[   15], 95.00t=
h=3D[   18],
> >       | 99.00th=3D[   43], 99.50th=3D[   62], 99.90th=3D[   95], 99.95t=
h=3D[  108],
> >       | 99.99th=3D[  133]
> >     bw (  KiB/s): min=3D395040, max=3D464480, per=3D99.90%, avg=3D41943=
8.95,
> > stdev=3D17496.05, samples=3D39
> >     iops        : min=3D24690, max=3D29030, avg=3D26214.92, stdev=3D109=
3.56, samples=3D39
> >
> > Run status group 0 (all jobs):
> >    WRITE: bw=3D423MiB/s (444MB/s), 423MiB/s-423MiB/s (444MB/s-444MB/s),
> > io=3D8200MiB (8598MB), run=3D19379-19379msec
> >
> > Disk stats (read/write):
> >    nvme5n1: ios=3D49/518250, merge=3D0/1554753, ticks=3D2/10629, in_que=
ue=3D0,
> > util=3D99.61%
> >
>


--=20
Best regards,
[COOLCOLD-RIPN]
