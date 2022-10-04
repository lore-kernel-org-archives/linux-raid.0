Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9B3C433FE
	for <linux-raid@archiver.kernel.org>; Tue,  4 Oct 2022 22:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJDWjQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJDWjP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Oct 2022 18:39:15 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77B76BCEF
        for <linux-raid@vger.kernel.org>; Tue,  4 Oct 2022 15:39:13 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id x18so9275015qkn.6
        for <linux-raid@vger.kernel.org>; Tue, 04 Oct 2022 15:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n96rV5YeZ3Vjyo7B4FnMUKO/TQ7v+B7SkmsrDc7k2Mg=;
        b=XPeoiTqK73+NaNbflEZaXM51OXwlKN6yG074vQ+XEqfyVQaep3585ESjO5oN98wzGf
         JV4xoHfw71GT4UOTkK1GO3Ib2RTIu1S1gzdtZ9ISZnytqU+ld9ArOcQm53zh+FQwQbyv
         GOFBwcB12w1tUGBRGckaetj4xqDR3nyV0VZJq0bffOHuc0Ov6dFHq9stErxhZJZPPyHF
         uNpwOdv/CfMe8nyTTynSmLAMaV+NlRihb7ykFT3A7ld7GfdnzCfGCXde1tiV4zF/9o8T
         mFwdqhrnkOmbFPKB7VbDanjGGK8bBJv94kbcHNEhPeyR4Zn35ZrEz8YnaEAvKfeNqYkJ
         JMeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n96rV5YeZ3Vjyo7B4FnMUKO/TQ7v+B7SkmsrDc7k2Mg=;
        b=u1de/KDXNB58Ta7FqSQY06pJk5F6uQjtpez8cCQvN6VU+KGhu88r/ipj/xFgZbAlva
         sw9WdqD0leEqNz46Gc+3m9qv6u7HhY22jP8rrME9fmnZ1JW3VXLpeuFaIBnCRoq/x0u4
         idnVzprUJrHmCoexZPvFoie1+Nv/t91VS554CenjuVHR2KZIBS+uh3iANyhntEW69dPY
         l8KOe2C92j9XbALG3lr2BWQ3wybH8K/0ehS8QyJQWTgNiIvItCpCwC/LT3A7a9xxnpJ4
         6VH88DROEW31Q13YDCwg4JL1PHW22LKiSihVGYpkPuq5o5lQjjyZmKBl5Lsgxb9HFNLQ
         VfQg==
X-Gm-Message-State: ACrzQf0RbAEbZvQFeFQT5r0gmrMWMJOeNWAxwk+v37Uwk647rwF2GTGM
        Shg8PJsBNW16KFp6lTd6bdhRBtpMec0FinUmLTumbVqO
X-Google-Smtp-Source: AMsMyM5loXXO5mG2maFql2yUddKdbG3C8DTgKdTGxVPOuAAkLdL5QnWdigRSGHKl23lGWx4kxF3pok9c2Gvo2PLt4Gw=
X-Received: by 2002:a05:620a:430d:b0:6d3:9dc9:d83d with SMTP id
 u13-20020a05620a430d00b006d39dc9d83dmr11498693qko.224.1664923152977; Tue, 04
 Oct 2022 15:39:12 -0700 (PDT)
MIME-Version: 1.0
References: <BN8P111MB1956CAEE20D8EDA11B0DFDB3A95A9@BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM>
 <BN8P111MB195628A92DE701D773E63DD8A95A9@BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM>
In-Reply-To: <BN8P111MB195628A92DE701D773E63DD8A95A9@BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM>
From:   Roger Heflin <rogerheflin@gmail.com>
Date:   Tue, 4 Oct 2022 17:39:01 -0500
Message-ID: <CAAMCDefoz-6zRgiLYpL9LHqZSvyi7qSJkvU=RSNVNdjoPNFU+w@mail.gmail.com>
Subject: Re: Linux RAID futures question
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

You might install perf and run "perf top" and see if there are any
spinlock's showing up using cpu.   They will be part of the system
time.  If they do show up using cpu time then do a "echo l >
/proc/sysrq-trigger" and that will show you the call paths causing the
spinlocks.   I have seen spinlock's drive up await and util with high
io rates.

On Tue, Oct 4, 2022 at 3:52 PM Finlayson, James M CIV (USA)
<james.m.finlayson4.civ@mail.mil> wrote:
>
> I messed with sync_force_parallel and got the speed up momentarily, but t=
he drive bandwidth and IOPs are down and then my sync speed started droppin=
g to well below 1GB/s after climbing initially to 1.2GB/s....
> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrq=
m  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme16c16n1   117608.00    0.00 848824.00      0.00 94603.00     0.00  44=
.58   0.00    0.83    0.00  98.03     7.22     0.00   0.01 100.00
> nvme18c18n1   117614.00    0.00 848936.00      0.00 94580.00     0.00  44=
.57   0.00    0.85    0.00  99.91     7.22     0.00   0.01 100.00
> nvme17c17n1   117612.00    0.00 848856.00      0.00 94563.00     0.00  44=
.57   0.00    0.84    0.00  99.35     7.22     0.00   0.01 100.00
> nvme19c19n1   117615.00    0.00 848968.00      0.00 94553.00     0.00  44=
.57   0.00    0.85    0.00  99.72     7.22     0.00   0.01 100.00
> nvme21c21n1   117657.00    0.00 848940.00      0.00 94516.00     0.00  44=
.55   0.00    0.86    0.00 101.30     7.22     0.00   0.01 100.00
> nvme22c22n1   117687.00    0.00 849060.00      0.00 94513.00     0.00  44=
.54   0.00    0.86    0.00 101.44     7.21     0.00   0.01 100.00
> nvme23c23n1   117720.00    0.00 849248.00      0.00 94515.00     0.00  44=
.53   0.00    0.86    0.00 101.51     7.21     0.00   0.01 100.00
> nvme24c24n1   117793.00    0.00 849700.00      0.00 94512.00     0.00  44=
.52   0.00    0.86    0.00 101.07     7.21     0.00   0.01 100.00
> nvme29c29n1   118601.00    0.00 849520.00      0.00 93685.00     0.00  44=
.13   0.00    0.85    0.00 101.02     7.16     0.00   0.01  99.90
> nvme30c30n1   118615.00    0.00 849592.00      0.00 93702.00     0.00  44=
.13   0.00    0.85    0.00 100.55     7.16     0.00   0.01 100.00
> nvme31c31n1   118530.00    0.00 848924.00      0.00 93714.00     0.00  44=
.15   0.00    0.85    0.00 101.28     7.16     0.00   0.01 100.00
> nvme32c32n1   118495.00    0.00 848720.00      0.00 93709.00     0.00  44=
.16   0.00    0.86    0.00 102.13     7.16     0.00   0.01 100.00
>
>
> -----Original Message-----
> From: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> Sent: Tuesday, October 4, 2022 4:37 PM
> To: linux-raid@vger.kernel.org
> Cc: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
> Subject: Linux RAID futures question
>
> All,
> First off, I'm a huge advocate for mdraid and I appreciate all of the eff=
ort that goes into it.   As far as mdraid, I think I'm my own definition of=
 "dangerous", in that "I don't know what I don't know" :)   In my ideal wor=
ld, I hope all of these are solved and somebody just points me to the Fine =
manual or accuses me of ID10T errors, but I can't find solutions to anythin=
g below.   Any and all advice appreciated.    To be honest, I have a goal o=
f putting together one of these servers, implementing mdraid and an NVMe ta=
rget driver and showing that a well-tuned server with mdraid could out run =
some of these all flash hardware arrays from a cocky vendor or two.
>
> Given that this is quickly becoming an SSD world, I've noticed a few thin=
gs related to mdraid where I'm hoping there might be some relief in the fut=
ure.   If there are solutions for any of these, I'd be grateful.
>
> This is on 5.19.12.....
> [root@hornet05 md]# uname -r
> 5.19.12-1.el8.elrepo.x86_64
>
> The raid process doesn't seem to be numa aware, so we often have to move =
it after the raid is assembled with taskset.    We currently look for the <=
md>_raid6 process and pin it to the proper NUMA node.   Might there be knob=
s if we want to pin the process to specific NUMA nodes?  There is a pretty =
heavy penalty on dual socket AMDs for cross numa operations.
> Relative latency matrix (name NUMALatency kind 5) between 2 NUMANodes (de=
pth -3) by logical indexes:
>   index     0     1
>       0    10    32
>       1    32    10
>
> The resync process seems to move across numa nodes - here is a NUMA node =
1 md raid running a resync that when I caught this snapshot in top, showed =
it was on  NUMA 0:
>     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ NU=
   P COMMAND
>  731597 root      20   0       0      0      0 R  99.0   0.0  12:53.02  0=
   0 md1_resync
>    3778 root      20   0       0      0      0 R  93.4   0.0  12:17.70  1=
  89 md1_raid6
>
>
> Even with my biggest, baddest AMD 24x nvme SSD servers, I rarely see a ra=
id build/rebuild rate of greater than 1GB/s per second, even though my SSDs=
 will each read at > 6GB/s and might even write at 3.8GB/s.
>
> [root@hornet05 md]# cat /proc/mdstat  (this system is currently idle othe=
r than the raid check)....
> Personalities : [raid6] [raid5] [raid4]
> md1 : active raid6 nvme32n1p1[13] nvme31n1p1[8] nvme30n1p1[11] nvme29n1p1=
[12] nvme24n1p1[7] nvme23n1p1[6] nvme22n1p1[5] nvme21n1p1[4] nvme19n1p1[3] =
nvme18n1p1[2] nvme17n1p1[1] nvme16n1p1[0]
>       150007941120 blocks super 1.2 level 6, 128k chunk, algorithm 2 [12/=
12] [UUUUUUUUUUUU]
>       [=3D>...................]  check =3D  6.2% (937365120/15000794112) =
finish=3D206.3min speed=3D1136048K/sec
>       bitmap: 0/112 pages [0KB], 65536KB chunk
>
> I have set the max speeds  with sysctl to be much higher, as well as with=
 udev for each md device.   I set group_thread_cnt to 64 an stripe_cache_si=
ze to 8192.   When I look at iostat, I see what looks a queue depth of ~90 =
on each drive and an average read size of a mix of 8K and 512byte I/Os if I=
 were to guess.   The reads are a bit beyond 1/10 of what each drive is cap=
able of doing (thank you for the much improved block stack - it isn't diffi=
cult to run all 24 drives at speed now when dealing with them individually.=
   My goal is to maximize them in 10+2 numa aware RAID configs in the short=
 term and then 14+2 when we switch from U.2/3 to E.3S and 32 will fit in th=
e front of a 2U server.     Am I missing an obvious knob???
>
> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrq=
m  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme16c16n1   155769.00    2.00 1125148.00      4.50 125544.00     0.00  =
44.63   0.00    0.59    0.50  91.58     7.22     2.25   0.01 100.00
> nvme18c18n1   155736.00    2.00 1124996.00      4.50 125536.00     0.00  =
44.63   0.00    0.59    0.50  92.18     7.22     2.25   0.01 100.00
> nvme17c17n1   155709.00    2.00 1124864.00      4.50 125534.00     0.00  =
44.64   0.00    0.59    0.50  92.48     7.22     2.25   0.01 100.10
> nvme19c19n1   155753.00    2.00 1125220.00      4.50 125528.00     0.00  =
44.63   0.00    0.60    0.50  93.34     7.22     2.25   0.01 100.10
> nvme21c21n1   155805.00    2.00 1125108.00      4.50 125453.00     0.00  =
44.60   0.00    0.60    0.50  93.29     7.22     2.25   0.01 100.10
> nvme22c22n1   155773.00    2.00 1124860.00      4.50 125455.00     0.00  =
44.61   0.00    0.60    0.50  93.17     7.22     2.25   0.01 100.00
> nvme23c23n1   155774.00    2.00 1124876.00      4.50 125451.00     0.00  =
44.61   0.00    0.60    0.00  94.01     7.22     2.25   0.01 100.00
> nvme24c24n1   155826.00    2.00 1125104.00      4.50 125445.00     0.00  =
44.60   0.00    0.60    0.50  93.24     7.22     2.25   0.01 100.00
> nvme29c29n1   157560.00    2.00 1125392.00      4.50 123758.00     0.00  =
43.99   0.00    0.59    0.50  93.40     7.14     2.25   0.01 100.00
> nvme30c30n1   157574.00    2.00 1125528.00      4.50 123775.00     0.00  =
43.99   0.00    0.59    0.50  93.15     7.14     2.25   0.01 100.00
> nvme31c31n1   157562.00    2.00 1125492.00      4.50 123772.00     0.00  =
43.99   0.00    0.59    0.50  93.55     7.14     2.25   0.01 100.00
> nvme32c32n1   157507.00    2.00 1125052.00      4.50 123763.00     0.00  =
44.00   0.00    0.69    0.50 108.94     7.14     2.25   0.01 100.00
>
> I believe this to mean that the algorithm is publishing that it is capabl=
e of > 30GB/s
> [root@hornet05 md]# dmesg | grep -i raid
> [   19.183736] raid6: avx2x4   gen() 22164 MB/s
> [   19.200842] raid6: avx2x2   gen() 36282 MB/s
> [   19.217736] raid6: avx2x1   gen() 25032 MB/s
> [   19.217963] raid6: using algorithm avx2x2 gen() 36282 MB/s
> [   19.234845] raid6: .... xor() 31236 MB/s, rmw enabled
>
> One might think that it could do I/O at "chunk_size" I/O sizes during reb=
uilds...
> [root@hornet05 md]# pwd
> /sys/block/md1/md
>  [root@hornet05 md]# cat chunk_size
> 131072
>
> When I'm down a drive, no matter what I/O size we send to the md device, =
the I/O seems to map to 4KB while it is "calculating parity" for a failed/m=
issing drive even though I might be doing 1MB random reads at the time.
>
> SUBSYSTEM=3D=3D"block",ACTION=3D=3D"add|change",KERNEL=3D=3D"md*",\
>         ATTR{md/sync_speed_max}=3D"2000000",\
>         ATTR{md/group_thread_cnt}=3D"64",\
>         ATTR{md/stripe_cache_size}=3D"8192",\
>         ATTR{queue/nomerges}=3D"2",\
>         ATTR{queue/nr_requests}=3D"1023",\
>         ATTR{queue/rotational}=3D"0",\
>         ATTR{queue/rq_affinity}=3D"2",\
>         ATTR{queue/scheduler}=3D"none",\
>         ATTR{queue/add_random}=3D"0",\
>         ATTR{queue/max_sectors_kb}=3D"4096"
>
>
> Thanks for any and all advice,
> Jim
>
>
> Jim Finlayson
> US Department of Defense
>
>
