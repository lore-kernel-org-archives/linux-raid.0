From: "Majed B." <majedb@gmail.com>
Subject: Re: Raid5 Read Perf drop in 2.6.27
Date: Wed, 16 Sep 2009 11:21:39 +0300
Message-ID: <70ed7c3e0909160121i4b369e7ej53eaa1791d7c2949@mail.gmail.com>
References: <f5d1f90a0909091554u6d40b402ga7e9f58cabf21b57@mail.gmail.com>
	<70ed7c3e0909091652m60b0ea9cp7000db919a639c35@mail.gmail.com>
	<f5d1f90a0909160057s5846df48i12c1026deb666d90@mail.gmail.com>
	<70ed7c3e0909160106u23b19365gc8af3150de0efd87@mail.gmail.com>
	<f5d1f90a0909160110s3abc87bn102aca209cc8e5f7@mail.gmail.com>
	<70ed7c3e0909160119m3c26af4fx667cc257c9dc79e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909160119m3c26af4fx667cc257c9dc79e6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Would you mind attaching both kernel config files and emailing them?
Also, did you compile your own kernels or do you run certain images?

On Wed, Sep 16, 2009 at 11:19 AM, Majed B. <majedb@gmail.com> wrote:
> I've run my own tests a few days back on a machine I have, but I
> haven't compared the results to tests on the same machine with older
> kernels.
>
> I have attached my machine's kernel config file.
>
> I run an Ubuntu 9.04 Server - Kernel 2.6.28-15-server.
>
> On Wed, Sep 16, 2009 at 11:10 AM, Linux Raid Study
> <linuxraid.study@gmail.com> wrote:
>> Yes - as far as Raid/disk-controller stuff is concerned, they are
>> same. BTW, is there anything specific you would like me to check.
>>
>> Have you done similar tests? Do you see any perf drop?
>>
>> Thanks!
>>
>> On Wed, Sep 16, 2009 at 1:06 AM, Majed B. <majedb@gmail.com> wrote:
>>> Did you compare both kernel's config files to see whether these
>>> kernels have been compiled with different options?
>>>
>>> On Wed, Sep 16, 2009 at 10:57 AM, Linux Raid Study
>>> <linuxraid.study@gmail.com> wrote:
>>>> Hi Majed, All:
>>>>
>>>> I'm using the default scheduler with 2.6.21 and 2.6.27...do you kn=
ow
>>>> if there is any difference?
>>>>
>>>> I rechecked the perf today - everything (i.e. disks, disk controll=
er
>>>> etc) remaining the same, I see around 45MB/s difference in perform=
ance
>>>> when I change kernel from 2.6.21 to 2.6.27. I issue following cmd =
to
>>>> see performance:
>>>> hdparm -t /dev/md0
>>>>
>>>> FYI...I'm using Seagate HDDs (7200 RPM) with RocketRaid 2310 contr=
oller.
>>>>
>>>> Any ideas...I have tried blockdev readahead option and it helps bu=
t
>>>> still not enough...
>>>>
>>>> Thanks a lot!
>>>>
>>>> On Wed, Sep 9, 2009 at 4:52 PM, Majed B. <majedb@gmail.com> wrote:
>>>>> Are you sure you're using the same Kernel Scheduler on both kerne=
ls?
>>>>>
>>>>> Have you checked and verified that the same drivers are being loa=
ded?
>>>>> (IDE vs. AHCI -- proprietary drivers vs. open source)
>>>>>
>>>>> This is interesting!
>>>>>
>>>>> On Thu, Sep 10, 2009 at 1:54 AM, Linux Raid
>>>>> Study<linuxraid.study@gmail.com> wrote:
>>>>>> Hello:
>>>>>>
>>>>>> I'm benchmarking RAID5 Read performance with 4 disks and notice =
perf
>>>>>> drop when using kernel 2.6.27.
>>>>>> The perf with 2.6.27 is 150MB/s whereas with kernel 2.6.21 (and =
same
>>>>>> setup), the perf is 180MB/s/
>>>>>>
>>>>>>
>>>>>>
>>>>>> Some of the tests I have done:
>>>>>> 1. I ran =C2=A0experiments using iozone also but notice that REA=
D perf with
>>>>>> RAID5 in 2.6.27 is ~30% less as compared to 2.6.21.
>>>>>> Write perf is similar but Read is an issue.
>>>>>>
>>>>>> 2. On 2.6.27, I played around with chunk size and blocksize para=
meters
>>>>>> and got ~5% improvement but not much. I used following cmds:
>>>>>>
>>>>>> #mdadm --create /dev/md0 --level=3D5 --assume-clean --raid-devic=
es=3D4
>>>>>> /dev/sda /dev/sdb /dev/sdc /dev/sdd --chunk=3D32
>>>>>> #mke2fs -b 4096 -E stride=3D8 /dev/md0
>>>>>>
>>>>>> #time dd if=3D/dev/md0 of=3D/dev/null bs=3D94208 count=3D1024
>>>>>>
>>>>>>
>>>>>> Is this perf drop a known issue? Can someone please recommend so=
me
>>>>>> performance tuning tips?
>>>>>>
>>>>>> Thanks a lot for your time and help!
>>>>>> --
>>>>>> To unsubscribe from this list: send the line "unsubscribe linux-=
raid" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-in=
fo.html
>>>>>>
>>>>>
>>>>>
>>>>>
>>>>> --
>>>>> =C2=A0 =C2=A0 =C2=A0 Majed B.
>>>>>
>>>>
>>>
>>>
>>>
>>> --
>>> =C2=A0 =C2=A0 =C2=A0 Majed B.
>>>
>>
>
>
>
> --
> =C2=A0 =C2=A0 =C2=A0 Majed B.
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
