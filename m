From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: RAID corruption with kernel 3.2?
Date: Sun, 12 Feb 2012 16:06:23 +0000 (GMT)
Message-ID: <alpine.LRH.2.02.1202121551560.8312@diagnostix.dwd.de>
References: <4F372848.5050105@zytor.com> <CADNH=7GGPdi87v2nJ1Jfsnym133uYdTiJ4yhtj8mJew2FMjFJQ@mail.gmail.com> <4F374363.8040306@zytor.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1730033388-1329062783=:8312"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F374363.8040306@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1730033388-1329062783=:8312
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

Hello,

On Sat, 11 Feb 2012, H. Peter Anvin wrote:

> On 02/11/2012 08:14 PM, Mathias Burén wrote:
>>
>>  Details? My>3.2 RAID6 still works fine.
>> 
>
> What is your hardware configuration?  Especially your CPU?
>
> The current suspicion -- but we don't know yet -- is that this is a problem 
> on Sandy Bridge and some Penryn CPUs which have the XSAVE instruction, but we 
> might very well be completely wrong on that.
>
I have NOT seen any corruptions. Have a dual CPU (8 cores) system with
the following CPU:

    cat /proc/cpuinfo
    processor       : 0
    vendor_id       : GenuineIntel
    cpu family      : 6
    model           : 23
    model name      : Intel(R) Xeon(R) CPU           X5460  @ 3.16GHz
    stepping        : 10
    microcode       : 0xa07
    cpu MHz         : 1999.000
    cache size      : 6144 KB
    physical id     : 0
    siblings        : 4
    core id         : 0
    cpu cores       : 4
    apicid          : 0
    initial apicid  : 0
    fpu             : yes
    fpu_exception   : yes
    cpuid level     : 13
    wp              : yes
    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 xsave lahf_lm dts tpr_shadow vnmi flexpriority
    bogomips        : 6317.90
    clflush size    : 64
    cache_alignment : 64
    address sizes   : 38 bits physical, 48 bits virtual
    power management:

Has the following softraids:

    cat /proc/mdstat
    Personalities : [raid1] [raid6] [raid5] [raid4]
    md3 : active raid1 sdf2[1] sdc2[0]
          70613632 blocks [2/2] [UU]

    md1 : active raid1 sdd2[1] sda2[0]
          70613632 blocks [2/2] [UU]

    md2 : active raid1 sdb2[0] sde2[1]
          70613632 blocks [2/2] [UU]

    md4 : active raid6 sdn1[7] sdm1[6] sdk1[4] sdl1[5] sdh1[1] sdj1[3] sdi1[2] sdg1[0]
          1754480640 blocks level 6, 2048k chunk, algorithm 2 [8/8] [UUUUUUUU]

    md0 : active raid1 sdb1[1] sdd1[3] sdf1[5] sde1[4] sdc1[2] sda1[0]
          521984 blocks [6/6] [UUUUUU]

The devices under md4 are hardware raid1 on two external SAS boxes.
Kernel currently is 3.2.1 with some security fixes. This system distributes
daily more then 5 TiB (9 million files) and so far no one has reported
any problems to me. I have several other systems with the same CPU (lower
clock) and software Raid6 but with local attached disks. They also have
no problems. Kernels there are 3.2.5.

Regards,
Holger
--8323328-1730033388-1329062783=:8312--
