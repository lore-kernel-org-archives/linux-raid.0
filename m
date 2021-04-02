Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C902C433ED
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 08:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4285610E8
	for <linux-raid@archiver.kernel.org>; Fri,  2 Apr 2021 08:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhDBIdy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 04:33:54 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:59767 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229522AbhDBIdy (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 2 Apr 2021 04:33:54 -0400
Received: from [192.168.0.2] (ip5f5aef94.dynamic.kabel-deutschland.de [95.90.239.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7B132206473D6;
        Fri,  2 Apr 2021 10:33:51 +0200 (CEST)
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, it+linux-x86@molgen.mpg.de
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: =?UTF-8?B?W3JlZ3Jlc3Npb24gNS40Ljk3IOKGkiA1LjEwLjI0XTogcmFpZDYgYXZ4?=
 =?UTF-8?Q?2x4_speed_drops_from_18429_MB/s_to_6155_MB/s?=
Message-ID: <6a1b0110-07f1-8c2e-fc7f-379758dbd8ca@molgen.mpg.de>
Date:   Fri, 2 Apr 2021 10:33:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Linux folks,


On an two socket AMD EPYC 7601, we noticed a decrease in raid6 avx2x4 
speed shown at the beginning of the boot.

                        5.4.95        5.10.24
----------------------------------------------
raid6: avx2x4 gen()   18429 MB/s     6155 MB/s
raid6: avx2x4 xor()    6644 MB/s     4274 MB/s
raid6: avx2x2 gen()   17894 MB/s    18744 MB/s
raid6: avx2x2 xor()   11642 MB/s    11950 MB/s
raid6: avx2x1 gen()   13992 MB/s    17112 MB/s
raid6: avx2x1 xor()   10855 MB/s    11143 MB/s

We are able to reproduce this with different models: Supermicro 
AS-2023US-TR4/H11DSU-iN and Dell PowerEdge R7425 (with different 
microcode versions).

Can you reproduce this on your systems?

Bisecting is going to be hard, so the systems are in production and also 
take a while to boot. (Maybe kexec would help here.)


Kind regards,

Paul


PS: Some more information:

```
[    0.000000] Linux version 5.4.97.mx64.368 
(root@theinternet.molgen.mpg.de) (gcc version 7.5.0 (GCC
)) #1 SMP Wed Feb 10 18:22:50 CET 2021
[…]
[    0.000000] DMI: Supermicro AS -2023US-TR4/H11DSU-iN, BIOS 1.1 02/07/2018
[…]
[    0.630603] raid6: avx2x4   gen() 18429 MB/s
[    0.651607] raid6: avx2x4   xor()  6644 MB/s
[    0.672605] raid6: avx2x2   gen() 17894 MB/s
[    0.693603] raid6: avx2x2   xor() 11642 MB/s
[    0.714605] raid6: avx2x1   gen() 13992 MB/s
[    0.735604] raid6: avx2x1   xor() 10855 MB/s
[    0.756607] raid6: sse2x4   gen() 12246 MB/s
[    0.777605] raid6: sse2x4   xor()  5724 MB/s
[    0.798605] raid6: sse2x2   gen() 10945 MB/s
[    0.819603] raid6: sse2x2   xor()  8097 MB/s
[    0.840606] raid6: sse2x1   gen()  5941 MB/s
[    0.861606] raid6: sse2x1   xor()  5894 MB/s
[    0.866565] raid6: using algorithm avx2x4 gen() 18429 MB/s
[    0.871567] raid6: .... xor() 6644 MB/s, rmw enabled
[    0.877566] raid6: using avx2x2 recovery algorithm
[…]
```


```
[    0.000000] Linux version 5.10.24.mx64.375 
(root@theinternet.molgen.mpg.de) (gcc (GCC) 7.5.0, GNU ld (GNU Binutils) 
2.32) #1 SMP Fri Mar 19 12:29:21 CET 2021
[…]
[    0.000000] DMI: Supermicro AS -2023US-TR4/H11DSU-iN, BIOS 1.1 02/07/2018
[…]
[    0.655382] raid6: avx2x4   gen()  6155 MB/s
[    0.676382] raid6: avx2x4   xor()  4274 MB/s
[    0.697380] raid6: avx2x2   gen() 18744 MB/s
[    0.718380] raid6: avx2x2   xor() 11950 MB/s
[    0.739380] raid6: avx2x1   gen() 17112 MB/s
[    0.760380] raid6: avx2x1   xor() 11143 MB/s
[    0.781381] raid6: sse2x4   gen() 11062 MB/s
[    0.802380] raid6: sse2x4   xor()  5180 MB/s
[    0.823380] raid6: sse2x2   gen() 12467 MB/s
[    0.844380] raid6: sse2x2   xor()  7672 MB/s
[    0.865381] raid6: sse2x1   gen()  9733 MB/s
[    0.886380] raid6: sse2x1   xor()  5717 MB/s
[    0.890674] raid6: using algorithm avx2x2 gen() 18744 MB/s
[    0.895673] raid6: .... xor() 11950 MB/s, rmw enabled
[    0.901673] raid6: using avx2x2 recovery algorithm
```

```
$ lscpu
Architecture:                    x86_64
CPU op-mode(s):                  32-bit, 64-bit
Byte Order:                      Little Endian
Address sizes:                   48 bits physical, 48 bits virtual
CPU(s):                          128
On-line CPU(s) list:             0-127
Thread(s) per core:              2
Core(s) per socket:              32
Socket(s):                       2
NUMA node(s):                    8
Vendor ID:                       AuthenticAMD
CPU family:                      23
Model:                           1
Model name:                      AMD EPYC 7601 32-Core Processor
Stepping:                        2
Frequency boost:                 enabled
CPU MHz:                         3100.798
CPU max MHz:                     2200.0000
CPU min MHz:                     1200.0000
BogoMIPS:                        4399.53
Virtualization:                  AMD-V
L1d cache:                       2 MiB
L1i cache:                       4 MiB
L2 cache:                        32 MiB
L3 cache:                        128 MiB
NUMA node0 CPU(s):               0-7,64-71
NUMA node1 CPU(s):               8-15,72-79
NUMA node2 CPU(s):               16-23,80-87
NUMA node3 CPU(s):               24-31,88-95
NUMA node4 CPU(s):               32-39,96-103
NUMA node5 CPU(s):               40-47,104-111
NUMA node6 CPU(s):               48-55,112-119
NUMA node7 CPU(s):               56-63,120-127
Vulnerability Itlb multihit:     Not affected
Vulnerability L1tf:              Not affected
Vulnerability Mds:               Not affected
Vulnerability Meltdown:          Not affected
Vulnerability Spec store bypass: Mitigation; Speculative Store Bypass 
disabled via prctl and seccomp
Vulnerability Spectre v1:        Mitigation; usercopy/swapgs barriers 
and __user pointer sanitization
Vulnerability Spectre v2:        Mitigation; Full AMD retpoline, IBPB 
conditional, STIBP disabled, RSB filling
Vulnerability Srbds:             Not affected
Vulnerability Tsx async abort:   Not affected
Flags:                           fpu vme de pse tsc msr pae mce cx8 apic 
sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx 
mmxex
                                  t fxsr_opt pdpe1gb rdtscp lm 
constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid amd_dcm 
aperfmperf pni pclmulqd
                                  q monitor ssse3 fma cx16 sse4_1 sse4_2 
movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic 
cr8_lega
                                  cy abm sse4a misalignsse 3dnowprefetch 
osvw skinit wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc 
mwaitx c
                                  pb hw_pstate ssbd ibpb vmmcall 
fsgsbase bmi1 avx2 smep bmi2 rdseed adx smap clflushopt sha_ni xsaveopt 
xsavec xgetbv1
                                   xsaves clzero irperf xsaveerptr arat 
npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid 
decodeassists paus
                                  efilter pfthreshold avic 
v_vmsave_vmload vgif overflow_recov succor smca
```
