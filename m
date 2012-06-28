From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Thu, 28 Jun 2012 10:59:19 +0200
Message-ID: <4FEC1CE7.5010709@xunil.at>
References: <4FE9BFC1.5070607@xunil.at> <20120628163205.2c6a1122@notabene.brown>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120628163205.2c6a1122@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 28.06.2012 08:32, schrieb NeilBrown:
> On Tue, 26 Jun 2012 15:57:21 +0200 "Stefan G. Weichinger"
> <lists@xunil.at> wrote:
>> Could that relate to this issue:
>> 
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=500309
> 
> Nope.  It was an earlier bug fixed in 2.6.5 by
> 
> http://neil.brown.name/git?p=mdadm;a=commitdiff;h=7a3be72fc621b4a7589e923cf065

Ah,
> 
I see. So this *could* be solved by using a more recent mdadm,
correct?

>> The NAS seems to run some ubuntu:
>> 
>> # cat /proc/version Linux version 2.6.33.2 (root@NasX86-5) (gcc
>> version 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #1
>> SMP Mon Sep 13 04:28:32 CST 2010
> 
> Does the "X86" in there suggest and x86 processor?  What does
> "uname -a" show?

# uname -a
Linux NASCA0A00 2.6.33.2 #1 SMP Mon Sep 13 04:28:32 CST 2010 i686 unknown

# cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 28
model name	: Intel(R) Atom(TM) CPU D525   @ 1.80GHz
stepping	: 10
cpu MHz		: 1795.730
cache size	: 512 KB
[...]

> You mean the NAS didn't come with a complete build environment and
> sources for all programs?  Outrageous.

*sigh*

> If you have a machine with the same arch at the NAS, you could
> 
> git clone git://neil.brown.name/mdadm -b mdadm-2.6.5 cd mdadm make
> mdadm.static CWFLAGS=-Wall
> 
> and then use the "mdadm.static" on the NAS.

Ok, thanks. I could boot some ubuntu on my Atom-netbook .. or what?
Would it be enough to match the 64bit-environment, or would I have to
use something with the same kernel ... ?

Thanks! Stefan
