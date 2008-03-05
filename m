From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: equal size not large enough for RAID1?
Date: Wed, 5 Mar 2008 10:05:47 +0100
Message-ID: <20080305100547.2634bd04.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hallo list,

I'm new to this list. But I came across some strange problems I nowhere=
 found a solution for on the net.
This is our situation:

monosan + duosan:
Linux duosan 2.6.22.17-0.1-default #1 SMP 2008/02/10 20:01:04 UTC x86_6=
4 x86_64 x86_64 GNU/Linux

/proc/cpuinfo:
[...]
processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 65
model name      : Dual-Core AMD Opteron(tm) Processor 2216
stepping        : 3
cpu MHz         : 2412.402
cache size      : 1024 KB
physical id     : 1
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge =
mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_=
opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr=
8_legacy
bogomips        : 4825.08
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

SAS controller:
07:00.0 Ethernet controller: MYRICOM Inc. Myri-10G Dual-Protocol NIC (1=
0G-PCIE-8A)


There are 16 SATA drives multipathed connected to each server.
duosan exports its RAID 6 over AoE via qaoed
monosan sees this as etherd/e22.0

monosan# cat /proc/partitions:
   9     4 12697912448 md4
   9     9 12697912312 md9
 152  5632 12697912448 etherd/e22.0


monosan:~ # cat /proc/mdstat=20
Personalities : [raid1] [raid0] [raid6] [raid5] [raid4]=20
md9 : active raid1 md4[0]
      12697912312 blocks super 1.0 [2/1] [U_]
     =20
md4 : active raid6 dm-0[0] dm-8[14] dm-7[13] dm-6[12] dm-5[11] dm-4[10]=
 dm-3[9] dm-2[8] dm-14[7] dm-13[6] dm-12[5] dm-11[4] dm-10[3] dm-9[2] d=
m-1[1]
      12697912448 blocks level 6, 64k chunk, algorithm 2 [15/15] [UUUUU=
UUUUUUUUUU]



But then this:
monosan:~ # mdadm /dev/md9 -a /dev/etherd/e22.0=20
mdadm: /dev/etherd/e22.0 not large enough to join array

The md9 RAID1 was originally built with e22.0 as second drive. I just s=
imulated a connection loss.

Why is this happening? As you can see md9 consists of md4 and e22.0 and=
 both are equal in size: 12697912448 .
How can I debug this? Are there detailed logs anywhere?

Many thanks for any hint.
Lars



--=20
                            Informationstechnologie
Berlin-Brandenburgische Akademie der Wissenschaften
J=C3=A4gerstrasse 22-23                     10117 Berlin
Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
