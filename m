From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID corruption with kernel 3.2?
Date: Sun, 12 Feb 2012 10:00:07 -0800
Message-ID: <4F37FE27.9050309@zytor.com>
References: <4F372848.5050105@zytor.com> <CADNH=7GGPdi87v2nJ1Jfsnym133uYdTiJ4yhtj8mJew2FMjFJQ@mail.gmail.com> <4F374363.8040306@zytor.com> <alpine.LRH.2.02.1202121551560.8312@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1202121551560.8312@diagnostix.dwd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/12/2012 08:06 AM, Holger Kiehl wrote:
>>
>> The current suspicion -- but we don't know yet -- is that this is a
>> problem on Sandy Bridge and some Penryn CPUs which have the XSAVE
>> instruction, but we might very well be completely wrong on that.
>>
> I have NOT seen any corruptions. Have a dual CPU (8 cores) system with
> the following CPU:
> 
>    cat /proc/cpuinfo
>    processor       : 0
>    vendor_id       : GenuineIntel
>    cpu family      : 6
>    model           : 23
>    model name      : Intel(R) Xeon(R) CPU           X5460  @ 3.16GHz
>    stepping        : 10
>    microcode       : 0xa07
>    cpu MHz         : 1999.000
>    cache size      : 6144 KB
>    physical id     : 0
>    siblings        : 4
>    core id         : 0
>    cpu cores       : 4
>    apicid          : 0
>    initial apicid  : 0
>    fpu             : yes
>    fpu_exception   : yes
>    cpuid level     : 13
>    wp              : yes
>    flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
> pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe
> syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
> aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm
> dca sse4_1 xsave lahf_lm dts tpr_shadow vnmi flexpriority
>    bogomips        : 6317.90
>    clflush size    : 64
>    cache_alignment : 64
>    address sizes   : 38 bits physical, 48 bits virtual
>    power management:
> 

Okay, so that's Penryn, it has XSAVE but not XSAVEOPT.  Very interesting
data point, I appreciate the info!

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

