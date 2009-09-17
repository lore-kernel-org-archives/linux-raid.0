From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: changing stripe cache size
Date: Wed, 16 Sep 2009 18:30:58 -0700
Message-ID: <f5d1f90a0909161830w8a2cba3laa08fd09111a83e5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@dkuug.dk>
Cc: "Majed B." <majedb@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok...I figured out...the max stripe_cache_size on my system is 8k.
Since I was setting it to 32k, it was failing and staying at 1k.

Per mdadm, my chunk size is default 64k.

The final goal here is to export this /dev/md0 device to iSCSI
initiators (running on different PCs) and measure performance. So,
ques is what would be an optimal block size for iSCSI reads if chunk
size is 64k and stripe cache size is 8k.

Thanks for your help...

2009/9/16 Linux Raid Study <linuxraid.study@gmail.com>:
> Hi:
>
> I tried to change the Raid5 stripe cache size by doing
> "echo =C2=A0262144 > /sys/block/md0/md/stripe_cache_size"
> But if I do "cat /sys/block/md0/md/stripe_cache_size", it still shows=
 1024!
>
> Can someone please suggest how to increase stripe cache size?
>
> thanks!
>
>
> 2009/9/10 Keld J=C3=B8rn Simonsen <keld@dkuug.dk>:
>> Hi
>>
>> There is some data on raid5 performance (and other raid types) at ou=
r
>> wiki at: http://linux-raid.osdl.org/index.php/Performance
>>
>> When you have something you want to share with others, then we can a=
dd
>> your info to the data there, either by a URL or by direct inclusion =
in
>> the wiki.
>>
>> best regards
>> keld
>>
>> On Wed, Sep 09, 2009 at 06:45:31PM -0700, Linux Raid Study wrote:
>>> I build/compile my own kernel..
>>>
>>> Have you done any benchmarks for Read RAID5 perf?
>>>
>>> Thanks!
>>>
>>> On 9/9/09, Majed B. <majedb@gmail.com> wrote:
>>> > Well, that's my point. To make sure that your kernels are identic=
al in
>>> > =C2=A0options, compare the .config files found in /usr/src/linux-=
<version>
>>> >
>>> > =C2=A0You may find changes and differences in areas like bluetoot=
h,
>>> > =C2=A0wireless, ...etc. These don't matter.
>>> >
>>> > =C2=A0Did you compile your own kernel, or are you using one compi=
led for a
>>> > =C2=A0specific distro?
>>> >
>>> > =C2=A0On Thu, Sep 10, 2009 at 4:17 AM, Linux Raid
>>> >
>>> > Study<linuxraid.study@gmail.com> wrote:
>>> > =C2=A0> Yes - the setup is the same. The only thing that changes =
is the kernel.
>>> > =C2=A0>
>>> > =C2=A0> I have 4 HDDs (2 from WD VelociRaptor 150GB/10k RPM and 2=
 from Seagate
>>> > =C2=A0> 320GB/7.2k RPM). =C2=A0The HDDs are connected using two S=
ilicon Image SATA
>>> > =C2=A0> controllers (Sil3132) connected to my host using PCIe.
>>> > =C2=A0>
>>> > =C2=A0> I use the default kernel scheduling scheme.
>>> > =C2=A0>
>>> > =C2=A0> Thanks!
>>> > =C2=A0>
>>> > =C2=A0> On 9/9/09, Majed B. <majedb@gmail.com> wrote:
>>> > =C2=A0>> Are you sure you're using the same Kernel Scheduler on b=
oth kernels?
>>> > =C2=A0>>
>>> > =C2=A0>> =C2=A0Have you checked and verified that the same driver=
s are being loaded?
>>> > =C2=A0>> =C2=A0(IDE vs. AHCI -- proprietary drivers vs. open sour=
ce)
>>> > =C2=A0>>
>>> > =C2=A0>> =C2=A0This is interesting!
>>> > =C2=A0>>
>>> > =C2=A0>>
>>> > =C2=A0>> =C2=A0On Thu, Sep 10, 2009 at 1:54 AM, Linux Raid
>>> > =C2=A0>> =C2=A0Study<linuxraid.study@gmail.com> wrote:
>>> > =C2=A0>> =C2=A0> Hello:
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0> I'm benchmarking RAID5 Read performance with 4 d=
isks and notice perf
>>> > =C2=A0>> =C2=A0> drop when using kernel 2.6.27.
>>> > =C2=A0>> =C2=A0> The perf with 2.6.27 is 150MB/s whereas with ker=
nel 2.6.21 (and same
>>> > =C2=A0>> =C2=A0> setup), the perf is 180MB/s/
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0> Some of the tests I have done:
>>> > =C2=A0>> =C2=A0> 1. I ran =C2=A0experiments using iozone also but=
 notice that READ perf with
>>> > =C2=A0>> =C2=A0> RAID5 in 2.6.27 is ~30% less as compared to 2.6.=
21.
>>> > =C2=A0>> =C2=A0> Write perf is similar but Read is an issue.
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0> 2. On 2.6.27, I played around with chunk size an=
d blocksize parameters
>>> > =C2=A0>> =C2=A0> and got ~5% improvement but not much. I used fol=
lowing cmds:
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0> #mdadm --create /dev/md0 --level=3D5 --assume-cl=
ean --raid-devices=3D4
>>> > =C2=A0>> =C2=A0> /dev/sda /dev/sdb /dev/sdc /dev/sdd --chunk=3D32
>>> > =C2=A0>> =C2=A0> #mke2fs -b 4096 -E stride=3D8 /dev/md0
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0> #time dd if=3D/dev/md0 of=3D/dev/null bs=3D94208=
 count=3D1024
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0> Is this perf drop a known issue? Can someone ple=
ase recommend some
>>> > =C2=A0>> =C2=A0> performance tuning tips?
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>> =C2=A0> Thanks a lot for your time and help!
>>> > =C2=A0>>
>>> > =C2=A0>> > --
>>> > =C2=A0>> =C2=A0> To unsubscribe from this list: send the line "un=
subscribe linux-raid" in
>>> > =C2=A0>> =C2=A0> the body of a message to majordomo@vger.kernel.o=
rg
>>> > =C2=A0>> =C2=A0> More majordomo info at =C2=A0http://vger.kernel.=
org/majordomo-info.html
>>> > =C2=A0>> =C2=A0>
>>> > =C2=A0>>
>>> > =C2=A0>>
>>> > =C2=A0>>
>>> > =C2=A0>> =C2=A0--
>>> > =C2=A0>>
>>> > =C2=A0>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Majed B.
>>> > =C2=A0>>
>>> > =C2=A0>
>>> >
>>> >
>>> >
>>> >
>>> > --
>>> >
>>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0Majed B.
>>> >
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
