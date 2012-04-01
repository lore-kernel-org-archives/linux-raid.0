From: daobang wang <wangdb1981@gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Sun, 1 Apr 2012 13:59:01 +0800
Message-ID: <CACwgYDMVHT5DFjJztX9JvsVQJ+uOjPrfcs4+0aGXotDvf6tymQ@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com>
	<4F776492.4070600@hardwarefreak.com>
	<CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
	<4F77D0B2.8000809@hardwarefreak.com>
	<CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com>
	<4F77EA55.6090004@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F77EA55.6090004@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

So sorry, the kernel version should be 2.6.36.4, and we do not use
distro, we compiled the kernel codes and user space codes.

I'm duplicating the input/output error issue, the system was
restarted, I will dump the dmesg log if i can duplicate it.

Thanks again,
Daobang Wang.

On 4/1/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 4/1/2012 12:12 AM, daobang wang wrote:
>> Thank you very much!
>> I got it, so we can remove the Volume Group and Logical Volume to save
>> resource.
>> And i will try RAID5 with 16 disks to write 96 total streams again.
>
> Why do you keep insisting on RAID5?!?!  It is not suitable for your
> workload.  It sucks Monday through Saturday and twice on Sunday for this
> workload.
>
> Test your 16 drive RAID5 array head to head with the linear array + XFS
> architecture I gave you instructions to create, and report back your
> results.
>
>> I used the Linux kernel 2.6.26.4.
>
> Which distro?
>
> 2.6.26 is *ancient* and has storage layer bugs.  It does NOT have
> delaylog, which was introduced in 2.6.35, and wasn't fully performant
> until 2.6.38+.
>
> You're building and testing a new platform with a terribly obsolete
> distribution.  You need a much newer kernel and distro.  3.0.x would be
> best.  Debian 6.0.4 with a backport 3.0.x kernel would be a good start.
>
>> And we do not have BBWC
>
> Then you must re-enable barriers or perennially suffer more filesystem
> problems.  I simply cannot emphasize enough how critical write barriers
> are to filesystem consistency.
>
>> The application has 16kb cache per stream, Is it possible to optimize
>> it if we use 32kb or 64kb cache?
>
> No.  Read the app's documentation.  This caching is to prevent dropped
> frames in the recorded file.  Increasing this value won't affect disk
> performance.
>
> --
> Stan
>
