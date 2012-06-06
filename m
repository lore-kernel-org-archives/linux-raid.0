From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Tue, 05 Jun 2012 20:38:10 -0500
Message-ID: <4FCEB482.3040205@hardwarefreak.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com> <CA+sTkh4fd+oZqagpHkGv5Kw+nkDyhunXfJm0tu0rqvuxVZBOyQ@mail.gmail.com> <CA+4vN7xH10qS-=OSS_3z3B3EohKHjk8-GBVvVfPj01TH-0pe3w@mail.gmail.com> <CA+sTkh7XeE49HmF+REyNTcOWJK6OS-tfi0qk7-SosFmAWenTqA@mail.gmail.com> <20430.1303.6379.122789@tree.ty.sabi.co.UK> <CA+4vN7wVbiHHR=B=QyvSqA+Y9ohiYMZ3xYDokJ+MY0h-AkatxA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7wVbiHHR=B=QyvSqA+Y9ohiYMZ3xYDokJ+MY0h-AkatxA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: Peter Grandi <pg@lxra2.for.sabi.co.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/5/2012 4:17 PM, Ole Tange wrote:
> On Tue, Jun 5, 2012 at 3:09 PM, Peter Grandi <pg@lxra2.for.sabi.co.uk> wrote:
>> [ ... ]
>>
>>>> Good call. But the resync is done before the mkfs.xfs is finished, so
>>>> the time of the copying is not affected by resync.
>>>>
>>>> I re-tested with --assume-clean and as expected it has no impact.
>>
>>>    Wanna try CONFIG_MULTICORE_RAID456? :-)
>>
>> That would be intreresting, but the original post reports over
>> 6GB/s for pure checksumming, and around 400MB/s actual transfer
>> rate. In theory there is no need here for multihreading. There
>> may something else going on :-).
> 
> I have the feeling that some of you have not experienced md0_raid6
> taking up 100% CPU of a single core. If you have not, please run the
> test on http://oletange.blogspot.dk/2012/05/software-raid-performance-on-24-disks.html
> 
> The test requires 10 GB RAM, atleast 2 CPU cores, and takes less than
> 3 minutes to run.
> 
> See if you can reproduce the CPU usage, and post your results along
> with the reported checksumming speed reported by the kernel.

There's no need for anyone to duplicate this testing.  It's already been
done, problem code identified, and patches submitted, about a week
before you started this thread.

Patches to make md RAID 1/10/5 write ops multi-threaded have already
been submitted (read ops already in essence are multi-threaded).  A
patch for RAID 6 has not yet been submitted but is probably in the
works.  Your thread comes about a week on the heels of the most recent
discussion of this problem.  See the archives.

And specifically, search the list archive for these thread scalability
patches by Shaohua Li.  AFAIK the patches haven't been accepted yet, and
it will likely be a while before they hit mainline.

In the mean time, the quickest way to "restore" your lost performance
while still using parity, and not sacrificing lots of platter space, is
to set two spares and create two 11 drive RAID5 arrays.  This costs you
one additional disk as a spare.  Each md RAID5 thread will run on a
different core, and with only 11 SRDs shouldn't peak a single core,
unless you have really slow cores such as the dual core Intel Atom 330 @
1.60 GHz.

If you need a single file space then layer a concatenated array
(--linear) over the two RAID 5 arrays and format the --linear device
with XFS, which will yield multi-threaded/multi-user parallelism with a
concatenated volume, assuming your workload writes files to multiple
directories.  If you think you need maximum single file streaming
performance, then lay a RAID 0 stripe over the two RAID5s and use
whichever filesystem you like.  If it's XFS, take care to properly align
writes.  This can be difficult using a nested stripe over multiple
parity arrays.

-- 
Stan
