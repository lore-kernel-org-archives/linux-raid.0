From: "Majed B." <majedb@gmail.com>
Subject: Re: Raid5 Read Perf drop in 2.6.27
Date: Thu, 10 Sep 2009 04:27:12 +0300
Message-ID: <70ed7c3e0909091827i745e2e38u6f8e246a0c9a49f@mail.gmail.com>
References: <f5d1f90a0909091554u6d40b402ga7e9f58cabf21b57@mail.gmail.com>
	<70ed7c3e0909091652m60b0ea9cp7000db919a639c35@mail.gmail.com>
	<f5d1f90a0909091817g667d211djcf767714740102d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5d1f90a0909091817g667d211djcf767714740102d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, that's my point. To make sure that your kernels are identical in
options, compare the .config files found in /usr/src/linux-<version>

You may find changes and differences in areas like bluetooth,
wireless, ...etc. These don't matter.

Did you compile your own kernel, or are you using one compiled for a
specific distro?

On Thu, Sep 10, 2009 at 4:17 AM, Linux Raid
Study<linuxraid.study@gmail.com> wrote:
> Yes - the setup is the same. The only thing that changes is the kerne=
l.
>
> I have 4 HDDs (2 from WD VelociRaptor 150GB/10k RPM and 2 from Seagat=
e
> 320GB/7.2k RPM). =C2=A0The HDDs are connected using two Silicon Image=
 SATA
> controllers (Sil3132) connected to my host using PCIe.
>
> I use the default kernel scheduling scheme.
>
> Thanks!
>
> On 9/9/09, Majed B. <majedb@gmail.com> wrote:
>> Are you sure you're using the same Kernel Scheduler on both kernels?
>>
>> =C2=A0Have you checked and verified that the same drivers are being =
loaded?
>> =C2=A0(IDE vs. AHCI -- proprietary drivers vs. open source)
>>
>> =C2=A0This is interesting!
>>
>>
>> =C2=A0On Thu, Sep 10, 2009 at 1:54 AM, Linux Raid
>> =C2=A0Study<linuxraid.study@gmail.com> wrote:
>> =C2=A0> Hello:
>> =C2=A0>
>> =C2=A0> I'm benchmarking RAID5 Read performance with 4 disks and not=
ice perf
>> =C2=A0> drop when using kernel 2.6.27.
>> =C2=A0> The perf with 2.6.27 is 150MB/s whereas with kernel 2.6.21 (=
and same
>> =C2=A0> setup), the perf is 180MB/s/
>> =C2=A0>
>> =C2=A0>
>> =C2=A0>
>> =C2=A0> Some of the tests I have done:
>> =C2=A0> 1. I ran =C2=A0experiments using iozone also but notice that=
 READ perf with
>> =C2=A0> RAID5 in 2.6.27 is ~30% less as compared to 2.6.21.
>> =C2=A0> Write perf is similar but Read is an issue.
>> =C2=A0>
>> =C2=A0> 2. On 2.6.27, I played around with chunk size and blocksize =
parameters
>> =C2=A0> and got ~5% improvement but not much. I used following cmds:
>> =C2=A0>
>> =C2=A0> #mdadm --create /dev/md0 --level=3D5 --assume-clean --raid-d=
evices=3D4
>> =C2=A0> /dev/sda /dev/sdb /dev/sdc /dev/sdd --chunk=3D32
>> =C2=A0> #mke2fs -b 4096 -E stride=3D8 /dev/md0
>> =C2=A0>
>> =C2=A0> #time dd if=3D/dev/md0 of=3D/dev/null bs=3D94208 count=3D102=
4
>> =C2=A0>
>> =C2=A0>
>> =C2=A0> Is this perf drop a known issue? Can someone please recommen=
d some
>> =C2=A0> performance tuning tips?
>> =C2=A0>
>> =C2=A0> Thanks a lot for your time and help!
>>
>> > --
>> =C2=A0> To unsubscribe from this list: send the line "unsubscribe li=
nux-raid" in
>> =C2=A0> the body of a message to majordomo@vger.kernel.org
>> =C2=A0> More majordomo info at =C2=A0http://vger.kernel.org/majordom=
o-info.html
>> =C2=A0>
>>
>>
>>
>> =C2=A0--
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0Majed B.
>>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
