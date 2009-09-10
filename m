From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: Raid5 Read Perf drop in 2.6.27
Date: Thu, 10 Sep 2009 14:57:17 -0700
Message-ID: <f5d1f90a0909101457w7662e17ax790e179c9b11150c@mail.gmail.com>
References: <f5d1f90a0909091554u6d40b402ga7e9f58cabf21b57@mail.gmail.com>
	 <70ed7c3e0909091652m60b0ea9cp7000db919a639c35@mail.gmail.com>
	 <f5d1f90a0909091817g667d211djcf767714740102d@mail.gmail.com>
	 <70ed7c3e0909091827i745e2e38u6f8e246a0c9a49f@mail.gmail.com>
	 <f5d1f90a0909091845t744ce5cerdf00fd656ff21c09@mail.gmail.com>
	 <20090910172219.GB420@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090910172219.GB420@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@dkuug.dk>
Cc: "Majed B." <majedb@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello:

According to Wiki at http://linux-raid.osdl.org/index.php/Performance,
disabling NCQ helps in improving perf....I thought enabling
command-queuing helps is perf improvement. Can someone pls elaborate
how disabling NCQ helps....

I have 3 seagate HDDs (7200RPM) and 2 WD VelcoiRaptor (10k RPM) and
disabling NCQ doesn't help in performance....

thanks!

[ snip from wiki ]

# Disable NCQ on all disks. (for raptors it increases the speed 30-40Mi=
B/s)
echo "Disabling NCQ on all disks..."
for i in $DISKS
do
  echo "Disabling NCQ on $i"
  echo 1 > /sys/block/"$i"/device/queue_depth
done

2009/9/10 Keld J=C3=B8rn Simonsen <keld@dkuug.dk>:
> Hi
>
> There is some data on raid5 performance (and other raid types) at our
> wiki at: http://linux-raid.osdl.org/index.php/Performance
>
> When you have something you want to share with others, then we can ad=
d
> your info to the data there, either by a URL or by direct inclusion i=
n
> the wiki.
>
> best regards
> keld
>
> On Wed, Sep 09, 2009 at 06:45:31PM -0700, Linux Raid Study wrote:
>> I build/compile my own kernel..
>>
>> Have you done any benchmarks for Read RAID5 perf?
>>
>> Thanks!
>>
>> On 9/9/09, Majed B. <majedb@gmail.com> wrote:
>> > Well, that's my point. To make sure that your kernels are identica=
l in
>> > =C2=A0options, compare the .config files found in /usr/src/linux-<=
version>
>> >
>> > =C2=A0You may find changes and differences in areas like bluetooth=
,
>> > =C2=A0wireless, ...etc. These don't matter.
>> >
>> > =C2=A0Did you compile your own kernel, or are you using one compil=
ed for a
>> > =C2=A0specific distro?
>> >
>> > =C2=A0On Thu, Sep 10, 2009 at 4:17 AM, Linux Raid
>> >
>> > Study<linuxraid.study@gmail.com> wrote:
>> > =C2=A0> Yes - the setup is the same. The only thing that changes i=
s the kernel.
>> > =C2=A0>
>> > =C2=A0> I have 4 HDDs (2 from WD VelociRaptor 150GB/10k RPM and 2 =
from Seagate
>> > =C2=A0> 320GB/7.2k RPM). =C2=A0The HDDs are connected using two Si=
licon Image SATA
>> > =C2=A0> controllers (Sil3132) connected to my host using PCIe.
>> > =C2=A0>
>> > =C2=A0> I use the default kernel scheduling scheme.
>> > =C2=A0>
>> > =C2=A0> Thanks!
>> > =C2=A0>
>> > =C2=A0> On 9/9/09, Majed B. <majedb@gmail.com> wrote:
>> > =C2=A0>> Are you sure you're using the same Kernel Scheduler on bo=
th kernels?
>> > =C2=A0>>
>> > =C2=A0>> =C2=A0Have you checked and verified that the same drivers=
 are being loaded?
>> > =C2=A0>> =C2=A0(IDE vs. AHCI -- proprietary drivers vs. open sourc=
e)
>> > =C2=A0>>
>> > =C2=A0>> =C2=A0This is interesting!
>> > =C2=A0>>
>> > =C2=A0>>
>> > =C2=A0>> =C2=A0On Thu, Sep 10, 2009 at 1:54 AM, Linux Raid
>> > =C2=A0>> =C2=A0Study<linuxraid.study@gmail.com> wrote:
>> > =C2=A0>> =C2=A0> Hello:
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0> I'm benchmarking RAID5 Read performance with 4 di=
sks and notice perf
>> > =C2=A0>> =C2=A0> drop when using kernel 2.6.27.
>> > =C2=A0>> =C2=A0> The perf with 2.6.27 is 150MB/s whereas with kern=
el 2.6.21 (and same
>> > =C2=A0>> =C2=A0> setup), the perf is 180MB/s/
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0> Some of the tests I have done:
>> > =C2=A0>> =C2=A0> 1. I ran =C2=A0experiments using iozone also but =
notice that READ perf with
>> > =C2=A0>> =C2=A0> RAID5 in 2.6.27 is ~30% less as compared to 2.6.2=
1.
>> > =C2=A0>> =C2=A0> Write perf is similar but Read is an issue.
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0> 2. On 2.6.27, I played around with chunk size and=
 blocksize parameters
>> > =C2=A0>> =C2=A0> and got ~5% improvement but not much. I used foll=
owing cmds:
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0> #mdadm --create /dev/md0 --level=3D5 --assume-cle=
an --raid-devices=3D4
>> > =C2=A0>> =C2=A0> /dev/sda /dev/sdb /dev/sdc /dev/sdd --chunk=3D32
>> > =C2=A0>> =C2=A0> #mke2fs -b 4096 -E stride=3D8 /dev/md0
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0> #time dd if=3D/dev/md0 of=3D/dev/null bs=3D94208 =
count=3D1024
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0> Is this perf drop a known issue? Can someone plea=
se recommend some
>> > =C2=A0>> =C2=A0> performance tuning tips?
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>> =C2=A0> Thanks a lot for your time and help!
>> > =C2=A0>>
>> > =C2=A0>> > --
>> > =C2=A0>> =C2=A0> To unsubscribe from this list: send the line "uns=
ubscribe linux-raid" in
>> > =C2=A0>> =C2=A0> the body of a message to majordomo@vger.kernel.or=
g
>> > =C2=A0>> =C2=A0> More majordomo info at =C2=A0http://vger.kernel.o=
rg/majordomo-info.html
>> > =C2=A0>> =C2=A0>
>> > =C2=A0>>
>> > =C2=A0>>
>> > =C2=A0>>
>> > =C2=A0>> =C2=A0--
>> > =C2=A0>>
>> > =C2=A0>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Majed B.
>> > =C2=A0>>
>> > =C2=A0>
>> >
>> >
>> >
>> >
>> > --
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0Majed B.
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
