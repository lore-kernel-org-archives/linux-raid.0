Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9C2C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jan 2022 20:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbiAKU0Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jan 2022 15:26:24 -0500
Received: from outbound5b.eu.mailhop.org ([3.125.66.160]:32977 "EHLO
        outbound5b.eu.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiAKU0Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jan 2022 15:26:24 -0500
X-Greylist: delayed 2702 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 15:26:23 EST
ARC-Seal: i=1; a=rsa-sha256; t=1641930019; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=cykwxP5dR30b18DtiL0+gTKidk8czQVawQeBYgkZSyiB34VWPqND32+1FxnKuilygiH2mnmRs4Zgp
         llMliFp2P3xok45TEaxW4vHRCKKr3kfvS3ebGxGw4ez3RaRDB3nwquxvUsmTzUOpRz3g+zrozgPBDp
         7gZLIZPJda+yaYBCJwaCdnerU0u8vYnTLvYE2VLZ/17O3PLRk7m7hdJcfv+qZw1Na3KCyFd1HM0/R8
         K0PPVPcfPA3pNXJNctknomxoxYgpAx9o/Z5kdBvfuInP7KrEjm2MIvaa6oUhA7sN8XOVPlr92RU8UI
         d9QZ+tU49BkqKslddlK51Rq6cmO3yRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
         mime-version:date:message-id:dkim-signature:from;
        bh=DYxxkQkI1WPVJRJjh1Z9EEYr1ScgaEo4aKx6hG3Rd9A=;
        b=LvM1R/UNWdP3my3R4U5GcOId8/HuBXYICh3GVhYGT8l1iXtUWlmJlDE4xbIRAi32SjrC3lGTB11GE
         rWxySGjLXm/NB3VlWtg9CmigHg8FET6PKnVYhvbADfeiyMtmiUaHkov2AW6CWringimWCJXipMekCp
         iBn3I8zkJ45w73xVev/krcT9TIEabQ84WSM2Yk2B/3LPpTjCGpLrOHOwIRY4Jhh+RKmbCZhwnd/3oG
         76dkrWK38c7ZIbKJYoMwnwE+2jijZDFOy13xuAQNRydJE6Ms2tSxdh/sj18rbvgKBaQIoo0Xvwx58n
         z+fGbDD5zMiiUefVEvrBKifF8YxIvmQ==
ARC-Authentication-Results: i=1; outbound3.eu.mailhop.org;
        spf=softfail smtp.mailfrom=demonlair.co.uk smtp.remote-ip=86.166.202.46;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
         mime-version:date:message-id:from;
        bh=DYxxkQkI1WPVJRJjh1Z9EEYr1ScgaEo4aKx6hG3Rd9A=;
        b=MkDJo9ZK5+fZL7qm4Oj8tGMk4G8mTlZ3LtoYoRgV3vxzAA6qlicS+yTCBNIQp75uaefch3xLkToCw
         xJLmjVWD/mITc2a1ikfYP1tiq64J0z3n8r8M2I9zE7/AcJssoiaqyHz6jHG5ZtWBjhzOcIJoOMZfoV
         8JLNfmwvCLqHw+iL5yXCDag2d6knX0LXSBls8fqBG70JsgQtstsCdevE5khCuZO7BnBH86HwiB6Mob
         hL632eo46JC39oyCfG7B7gdXhEZTr3PBCEQikqEktKwX7DBJjz1YAZpT9vnQ2aJ/1tfZD+xO3pmhdU
         QJO6q0duFsiV18LjsQ3XKOetefg5Nww==
X-Originating-IP: 86.166.202.46
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: 4cdd0c83-7316-11ec-b830-95b64d6800c5
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from phoenix.demonlair.co.uk (host86-166-202-46.range86-166.btcentralplus.com [86.166.202.46])
        by outbound3.eu.mailhop.org (Halon) with ESMTPA
        id 4cdd0c83-7316-11ec-b830-95b64d6800c5;
        Tue, 11 Jan 2022 19:40:16 +0000 (UTC)
Received: from [10.57.1.71] (mercury.demonlair.co.uk [10.57.1.71])
        by phoenix.demonlair.co.uk (Postfix) with ESMTP id 98F401EA047;
        Tue, 11 Jan 2022 19:40:15 +0000 (GMT)
Message-ID: <4f30f93a-1f2d-e082-d598-aa2987658b01@demonlair.co.uk>
Date:   Tue, 11 Jan 2022 19:40:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: MDRAID NVMe performance question, but I don't know what I don't
 know
Content-Language: en-GB
To:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <5EAED86C53DED2479E3E145969315A238926397D@UMECHPA7B.easf.csd.disa.mil>
From:   Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <5EAED86C53DED2479E3E145969315A238926397D@UMECHPA7B.easf.csd.disa.mil>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi James,

My first thought would be: how sure are you about which physical socket
(and hence NUMA node) each NVME drive is connected to?

Regards,

Geoff.


On 11/01/2022 16:03, Finlayson, James M CIV (USA) wrote:
> Hi,
> Sorry this is a long read.   If you want to get to the gist of it, look for "<KEY>" for key points.   I'm having some issues with where to find information to troubleshoot mdraid performance issues.   The latest "rathole" I'm going down is that I have two identically configured mdraids, 1 per NUMA node on a dual socket AMD Rome with "numas per socket" set to 1 in the BIOS.   Things are cranking with a 64K blocksize but I have a substantial disparity between NUMA0's mdraid and NUMA1's.     
>
> [root@hornet04 block]# uname -r
> <KEY> 5.15.13-1.el8.elrepo.x86_64
>
> <KEY>  [root@hornet04 block]# cat /proc/mdstat  (md127 is NUMA 0, md126 is NUMA 1).
> Personalities : [raid6] [raid5] [raid4] 
> md126 : active raid5 nvme22n1p1[10] nvme20n1p1[7] nvme21n1p1[8] nvme18n1p1[5] nvme19n1p1[6] nvme17n1p1[4] nvme15n1p1[3] nvme14n1p1[2] nvme12n1p1[0] nvme13n1p1[1]
>       135007147008 blocks super 1.2 level 5, 128k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
>       bitmap: 0/112 pages [0KB], 65536KB chunk
>
> md127 : active raid5 nvme9n1p1[10] nvme8n1p1[8] nvme7n1p1[7] nvme6n1p1[6] nvme5n1p1[5] nvme3n1p1[3] nvme4n1p1[4] nvme2n1p1[2] nvme1n1p1[1] nvme0n1p1[0]
>       135007147008 blocks super 1.2 level 5, 128k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
>       bitmap: 0/112 pages [0KB], 65536KB chunk
>
> unused devices: <none>
>
>
> I'm running numa aware identical FIOs, but getting the following in iostat (numa 0 mdraid, outperforms numa 1 mdraid by 12GB/s)
>
> [root@hornet04 ~]#  iostat -xkz 1 
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            0.20    0.00    3.35    0.00    0.00   96.45
>
> Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm  %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
> nvme2c2n1     72856.00    0.00 4662784.00      0.00     0.00     0.00   0.00   0.00    0.68    0.00  49.50    64.00     0.00   0.01 100.00
> nvme3c3n1     73077.00    0.00 4676928.00      0.00     0.00     0.00   0.00   0.00    0.68    0.00  49.94    64.00     0.00   0.01 100.00
> nvme4c4n1     73013.00    0.00 4672896.00      0.00     0.00     0.00   0.00   0.00    0.69    0.00  50.35    64.00     0.00   0.01 100.00
> <KEY> nvme18c18n1   54384.00    0.00 3480576.00      0.00     0.00     0.00   0.00   0.00  144.80    0.00 7874.85    64.00     0.00   0.02 100.00
> nvme5c5n1     72841.00    0.00 4661824.00      0.00     0.00     0.00   0.00   0.00    0.70    0.00  51.01    64.00     0.00   0.01 100.00
> nvme7c7n1     72220.00    0.00 4622080.00      0.00     0.00     0.00   0.00   0.00    0.67    0.00  48.61    64.00     0.00   0.01 100.00
> nvme22c22n1   54652.00    0.00 3497728.00      0.00     0.00     0.00   0.00   0.00    0.64    0.00  34.73    64.00     0.00   0.02 100.00
> nvme12c12n1   54756.00    0.00 3504384.00      0.00     0.00     0.00   0.00   0.00    0.66    0.00  36.34    64.00     0.00   0.02 100.00
> nvme14c14n1   54517.00    0.00 3489088.00      0.00     0.00     0.00   0.00   0.00    0.65    0.00  35.66    64.00     0.00   0.02 100.00
> nvme6c6n1     72721.00    0.00 4654144.00      0.00     0.00     0.00   0.00   0.00    0.68    0.00  49.77    64.00     0.00   0.01 100.00
> nvme21c21n1   54731.00    0.00 3502784.00      0.00     0.00     0.00   0.00   0.00    0.67    0.00  36.46    64.00     0.00   0.02 100.00
> nvme9c9n1     72661.00    0.00 4650304.00      0.00     0.00     0.00   0.00   0.00    0.71    0.00  51.35    64.00     0.00   0.01 100.00
> nvme17c17n1   54462.00    0.00 3485568.00      0.00     0.00     0.00   0.00   0.00    0.66    0.00  36.09    64.00     0.00   0.02 100.00
> nvme20c20n1   54463.00    0.00 3485632.00      0.00     0.00     0.00   0.00   0.00    0.66    0.00  36.10    64.00     0.00   0.02 100.10
> nvme13c13n1   54910.00    0.00 3514240.00      0.00     0.00     0.00   0.00   0.00    0.61    0.00  33.45    64.00     0.00   0.02 100.00
> nvme8c8n1     72622.00    0.00 4647808.00      0.00     0.00     0.00   0.00   0.00    0.67    0.00  48.52    64.00     0.00   0.01 100.00
> nvme15c15n1   54543.00    0.00 3490752.00      0.00     0.00     0.00   0.00   0.00    0.61    0.00  33.28    64.00     0.00   0.02 100.00
> nvme0c0n1     73215.00    0.00 4685760.00      0.00     0.00     0.00   0.00   0.00    0.67    0.00  49.41    64.00     0.00   0.01 100.00
> nvme19c19n1   55034.00    0.00 3522176.00      0.00     0.00     0.00   0.00   0.00    0.67    0.00  36.93    64.00     0.00   0.02 100.10
> <KEY> nvme1c1n1     72672.00    0.00 4650944.00      0.00     0.00     0.00   0.00   0.00  106.98    0.00 7774.54    64.00     0.00   0.01 100.00
> <KEY> md127         727871.00    0.00 46583744.00      0.00     0.00     0.00   0.00   0.00   11.30    0.00 8221.92    64.00     0.00   0.00 100.00
> <KEY> md126         546553.00    0.00 34979392.00      0.00     0.00     0.00   0.00   0.00   14.99    0.00 8194.91    64.00     0.00   0.00 100.10
>
>
> <KEY> I started chasing the aqu_sz and r_await to see if I have a device issue or if these are known mdraid "features" when I started to try to find the kernel workers and start chasing kernel workers when it became apparent to me that I DON'T KNOW WHAT I'M DOING OR WHAT TO DO NEXT. Any guidance is appreciated.  Given 1 drive per NUMA is showing the bad behavior, I'm reluctant to point the finger at hardware.
>
>
> [root@hornet04 ~]# lscpu
> Architecture:        x86_64
> CPU op-mode(s):      32-bit, 64-bit
> Byte Order:          Little Endian
> CPU(s):              256
> On-line CPU(s) list: 0-255
> Thread(s) per core:  2
> Core(s) per socket:  64
> Socket(s):           2
> NUMA node(s):        2
> Vendor ID:           AuthenticAMD
> BIOS Vendor ID:      Advanced Micro Devices, Inc.
> CPU family:          23
> Model:               49
> Model name:          AMD EPYC 7742 64-Core Processor
> BIOS Model name:     AMD EPYC 7742 64-Core Processor                
> Stepping:            0
> CPU MHz:             3243.803
> BogoMIPS:            4491.53
> Virtualization:      AMD-V
> L1d cache:           32K
> L1i cache:           32K
> L2 cache:            512K
> L3 cache:            16384K
> <KEY> NUMA node0 CPU(s):   0-63,128-191
> <KEY>  NUMA node1 CPU(s):   64-127,192-255
> Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb cat_l3 cdp_l3 hw_pstate ssbd mba ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 cqm rdt_a rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local clzero irperf xsaveerptr rdpru wbnoinvd amd_ppin arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif v_spec_ctrl umip rdpid overflow_recov succor smca
>
>
> <KEY> When I start doing some basic debugging - not a Linux ninja by far, I see the following, but what is throwing me is seeing (at least these workers that I suspect have to do with md, all running on NUMA node 1.   This is catching me by surprise.   Are there other workers that I'm missing?????
>
> ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan:14,comm | head -1; ps -eo pid,tid,class,rtprio,ni,pri,numa,psr,pcpu,stat,wchan:14,comm  | egrep 'md|raid' | grep -v systemd | grep -v mlx
>     PID     TID CLS RTPRIO  NI PRI NUMA PSR %CPU STAT WCHAN          COMMAND
>    1522    1522 TS       -   5  14    1 208  0.0 SN   -              ksmd
>    1590    1590 TS       - -20  39    1 220  0.0 I<   -              md
>    3688    3688 TS       - -20  39    1 198  0.0 I<   -              raid5wq
>    3693    3693 TS       -   0  19    1 234  0.0 S    -              md126_raid5
>    3694    3694 TS       -   0  19    1  95  0.0 S    -              md127_raid5
>    3788    3788 TS       -   0  19    1 240  0.0 Ss   -              lsmdcat /
>
>
>
> Jim Finlayson
> U.S. Department of Defense
>

-- 
Geoff Back
What if we're all just characters in someone's nightmares?

