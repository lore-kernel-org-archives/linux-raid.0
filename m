From: Marcus Sorensen <shadowsor@gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Sun, 1 Apr 2012 01:08:41 -0600
Message-ID: <CALFpzo5aKM2y_stDR14PNYMHEcq5CEptuFiXrvcCpXTzSQmAxw@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com>
	<4F776492.4070600@hardwarefreak.com>
	<CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
	<4F77D0B2.8000809@hardwarefreak.com>
	<CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com>
	<4F77EA55.6090004@hardwarefreak.com>
	<CACwgYDMVHT5DFjJztX9JvsVQJ+uOjPrfcs4+0aGXotDvf6tymQ@mail.gmail.com>
	<CACwgYDMXF9WEgzW9vL_0=GdRc_t+67WAkRTKNoKOMEMCvjujVw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACwgYDMXF9WEgzW9vL_0=GdRc_t+67WAkRTKNoKOMEMCvjujVw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: daobang wang <wangdb1981@gmail.com>
Cc: stan@hardwarefreak.com, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Streaming workloads don't benefit much from writeback cache.
Writeback can absorb spikes, but if you have a constant load that goes
beyond what your disks can handle, you'll have good performance
exactly to the point where your writeback is full. Once you hit
dirty_bytes, dirty_ratio, or the timeout, your system will be crushed
with I/O beyond recovery. It's best to limit your writeback cache to a
relatively small number with such a constant IO load.

You are right that merging could help to some degree, but you likely
won't be merging I/Os from separate streams, so your workload is still
terribly random and you just end up with larger random I/Os. I don't
think it will make up for the difference between your workload and
your configuration.

On Sun, Apr 1, 2012 at 12:20 AM, daobang wang <wangdb1981@gmail.com> wr=
ote:
> I have the different opinion, the application does not write the disk
> directly, disk IOs will be merged before writen in kernel, just we ca=
n
> not caculate how many IOs will be merged.
>
> On 4/1/12, daobang wang <wangdb1981@gmail.com> wrote:
>> So sorry, the kernel version should be 2.6.36.4, and we do not use
>> distro, we compiled the kernel codes and user space codes.
>>
>> I'm duplicating the input/output error issue, the system was
>> restarted, I will dump the dmesg log if i can duplicate it.
>>
>> Thanks again,
>> Daobang Wang.
>>
>> On 4/1/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>>> On 4/1/2012 12:12 AM, daobang wang wrote:
>>>> Thank you very much!
>>>> I got it, so we can remove the Volume Group and Logical Volume to =
save
>>>> resource.
>>>> And i will try RAID5 with 16 disks to write 96 total streams again=
=2E
>>>
>>> Why do you keep insisting on RAID5?!?! =A0It is not suitable for yo=
ur
>>> workload. =A0It sucks Monday through Saturday and twice on Sunday f=
or this
>>> workload.
>>>
>>> Test your 16 drive RAID5 array head to head with the linear array +=
 XFS
>>> architecture I gave you instructions to create, and report back you=
r
>>> results.
>>>
>>>> I used the Linux kernel 2.6.26.4.
>>>
>>> Which distro?
>>>
>>> 2.6.26 is *ancient* and has storage layer bugs. =A0It does NOT have
>>> delaylog, which was introduced in 2.6.35, and wasn't fully performa=
nt
>>> until 2.6.38+.
>>>
>>> You're building and testing a new platform with a terribly obsolete
>>> distribution. =A0You need a much newer kernel and distro. =A03.0.x =
would be
>>> best. =A0Debian 6.0.4 with a backport 3.0.x kernel would be a good =
start.
>>>
>>>> And we do not have BBWC
>>>
>>> Then you must re-enable barriers or perennially suffer more filesys=
tem
>>> problems. =A0I simply cannot emphasize enough how critical write ba=
rriers
>>> are to filesystem consistency.
>>>
>>>> The application has 16kb cache per stream, Is it possible to optim=
ize
>>>> it if we use 32kb or 64kb cache?
>>>
>>> No. =A0Read the app's documentation. =A0This caching is to prevent =
dropped
>>> frames in the recorded file. =A0Increasing this value won't affect =
disk
>>> performance.
>>>
>>> --
>>> Stan
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
