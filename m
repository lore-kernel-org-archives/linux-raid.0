From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: Raid5 Read Perf drop in 2.6.27
Date: Thu, 17 Sep 2009 00:50:36 -0700
Message-ID: <f5d1f90a0909170050g31854d0cr6af063e27a9575cc@mail.gmail.com>
References: <f5d1f90a0909091554u6d40b402ga7e9f58cabf21b57@mail.gmail.com>
	 <70ed7c3e0909091652m60b0ea9cp7000db919a639c35@mail.gmail.com>
	 <f5d1f90a0909091817g667d211djcf767714740102d@mail.gmail.com>
	 <70ed7c3e0909091827i745e2e38u6f8e246a0c9a49f@mail.gmail.com>
	 <f5d1f90a0909091845t744ce5cerdf00fd656ff21c09@mail.gmail.com>
	 <20090910172219.GB420@rap.rap.dk>
	 <f5d1f90a0909161645y42390766pd3cd24cfe4e048f@mail.gmail.com>
	 <70ed7c3e0909162112h15da413cgfc1f47c544f96af9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909162112h15da413cgfc1f47c544f96af9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Majed:

I have compiled by kernel. 2.6.27 config has lot of new stuff - port
multiplier/Sil3124/3132 support etc.

I see following SCHED/DMA related differences:
CONFIG_IOSCHED_AS
CONFIG_IOSCHED_CONFIG
CONFIG_CLASSIS_RCV

CONFIG_SCSI_DMA

Is there anything else that I missed?

Thanks for ur time and help!


On Wed, Sep 16, 2009 at 9:12 PM, Majed B. <majedb@gmail.com> wrote:
> Attached is the diff file between the config files of kernels 21 & 27=
=2E
>
> I see a lot of DMA changes and schedulers.
>
> I've asked you before if you compiled your own kernel or do you use
> unmodified distro kernels?
>
> If you compile your own, then you could import the 21 config to the 2=
7
> compile process and then compare the performance of the two kernels.
>
> 2009/9/17 Linux Raid Study <linuxraid.study@gmail.com>:
>> Hi:
>>
>> I tried to change the Raid5 stripe cache size by doing
>> "echo  262144 > /sys/block/md0/md/stripe_cache_size"
>> But if I do "cat /sys/block/md0/md/stripe_cache_size", it still show=
s 1024!
>>
>> Can someone please suggest how to increase stripe cache size?
>>
>> thanks!
>>
>>
>> 2009/9/10 Keld J=C3=B8rn Simonsen <keld@dkuug.dk>:
>>> Hi
>>>
>>> There is some data on raid5 performance (and other raid types) at o=
ur
>>> wiki at: http://linux-raid.osdl.org/index.php/Performance
>>>
>>> When you have something you want to share with others, then we can =
add
>>> your info to the data there, either by a URL or by direct inclusion=
 in
>>> the wiki.
>>>
>>> best regards
>>> keld
>>>
>>> On Wed, Sep 09, 2009 at 06:45:31PM -0700, Linux Raid Study wrote:
>>>> I build/compile my own kernel..
>>>>
>>>> Have you done any benchmarks for Read RAID5 perf?
>>>>
>>>> Thanks!
>>>>
>>>> On 9/9/09, Majed B. <majedb@gmail.com> wrote:
>>>> > Well, that's my point. To make sure that your kernels are identi=
cal in
>>>> >  options, compare the .config files found in /usr/src/linux-<ver=
sion>
>>>> >
>>>> >  You may find changes and differences in areas like bluetooth,
>>>> >  wireless, ...etc. These don't matter.
>>>> >
>>>> >  Did you compile your own kernel, or are you using one compiled =
for a
>>>> >  specific distro?
>>>> >
>>>> >  On Thu, Sep 10, 2009 at 4:17 AM, Linux Raid
>>>> >
>>>> > Study<linuxraid.study@gmail.com> wrote:
>>>> >  > Yes - the setup is the same. The only thing that changes is t=
he kernel.
>>>> >  >
>>>> >  > I have 4 HDDs (2 from WD VelociRaptor 150GB/10k RPM and 2 fro=
m Seagate
>>>> >  > 320GB/7.2k RPM).  The HDDs are connected using two Silicon Im=
age SATA
>>>> >  > controllers (Sil3132) connected to my host using PCIe.
>>>> >  >
>>>> >  > I use the default kernel scheduling scheme.
>>>> >  >
>>>> >  > Thanks!
>>>> >  >
>>>> >  > On 9/9/09, Majed B. <majedb@gmail.com> wrote:
>>>> >  >> Are you sure you're using the same Kernel Scheduler on both =
kernels?
>>>> >  >>
>>>> >  >>  Have you checked and verified that the same drivers are bei=
ng loaded?
>>>> >  >>  (IDE vs. AHCI -- proprietary drivers vs. open source)
>>>> >  >>
>>>> >  >>  This is interesting!
>>>> >  >>
>>>> >  >>
>>>> >  >>  On Thu, Sep 10, 2009 at 1:54 AM, Linux Raid
>>>> >  >>  Study<linuxraid.study@gmail.com> wrote:
>>>> >  >>  > Hello:
>>>> >  >>  >
>>>> >  >>  > I'm benchmarking RAID5 Read performance with 4 disks and =
notice perf
>>>> >  >>  > drop when using kernel 2.6.27.
>>>> >  >>  > The perf with 2.6.27 is 150MB/s whereas with kernel 2.6.2=
1 (and same
>>>> >  >>  > setup), the perf is 180MB/s/
>>>> >  >>  >
>>>> >  >>  >
>>>> >  >>  >
>>>> >  >>  > Some of the tests I have done:
>>>> >  >>  > 1. I ran  experiments using iozone also but notice that R=
EAD perf with
>>>> >  >>  > RAID5 in 2.6.27 is ~30% less as compared to 2.6.21.
>>>> >  >>  > Write perf is similar but Read is an issue.
>>>> >  >>  >
>>>> >  >>  > 2. On 2.6.27, I played around with chunk size and blocksi=
ze parameters
>>>> >  >>  > and got ~5% improvement but not much. I used following cm=
ds:
>>>> >  >>  >
>>>> >  >>  > #mdadm --create /dev/md0 --level=3D5 --assume-clean --rai=
d-devices=3D4
>>>> >  >>  > /dev/sda /dev/sdb /dev/sdc /dev/sdd --chunk=3D32
>>>> >  >>  > #mke2fs -b 4096 -E stride=3D8 /dev/md0
>>>> >  >>  >
>>>> >  >>  > #time dd if=3D/dev/md0 of=3D/dev/null bs=3D94208 count=3D=
1024
>>>> >  >>  >
>>>> >  >>  >
>>>> >  >>  > Is this perf drop a known issue? Can someone please recom=
mend some
>>>> >  >>  > performance tuning tips?
>>>> >  >>  >
>>>> >  >>  > Thanks a lot for your time and help!
>>>> >  >>
>>>> >  >> > --
>>>> >  >>  > To unsubscribe from this list: send the line "unsubscribe=
 linux-raid" in
>>>> >  >>  > the body of a message to majordomo@vger.kernel.org
>>>> >  >>  > More majordomo info at  http://vger.kernel.org/majordomo-=
info.html
>>>> >  >>  >
>>>> >  >>
>>>> >  >>
>>>> >  >>
>>>> >  >>  --
>>>> >  >>
>>>> >  >>        Majed B.
>>>> >  >>
>>>> >  >
>>>> >
>>>> >
>>>> >
>>>> >
>>>> > --
>>>> >
>>>> >        Majed B.
>>>> >
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
>
>
> --
>       Majed B.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
