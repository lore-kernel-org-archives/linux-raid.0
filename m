From: Ole Tange <ole@tange.dk>
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 09:47:25 +0200
Message-ID: <CA+4vN7zTmKPuyseOO9QhSKO3vjeLpt8pQ76W-MwZg1-YCz+vLA@mail.gmail.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
 <CA+sTkh6rA_yoeM3Fw1s47sgEsJRWG7vbtXH9QaPWbwG6Mvt7fQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh6rA_yoeM3Fw1s47sgEsJRWG7vbtXH9QaPWbwG6Mvt7fQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 5, 2012 at 5:36 AM, Igor M Podlesny <for.poige+lsr@gmail.co=
m> wrote:
> On 5 June 2012 07:14, Ole Tange <ole@tange.dk> wrote:
>> On my new 24 disk array I get 900 MB/s of raw read or write using `d=
d`
>> to all the disks.
>
> =A0 =97 Array of layout what?

Raw performance. I.e. no RAID:

  echo 3 > /proc/sys/vm/drop_caches
  time parallel -j0 dd if=3D{} of=3D/dev/null bs=3D1000k count=3D1k :::=
 /dev/sd?

The 900 MB/s was based on my old controller. I re-measured using my
new controller and get closer to 2000 MB/s in raw (non-RAID)
performance, which is close to the theoretical maximum for that
controller (2400 MB/s). This indicated that hardware is not a
bottleneck.

>> When I set the disks up as a 24 disk software RAID6 I get 400 MB/s
>> write and 600 MB/s read. It seems to be due to checksuming, as I hav=
e
>> a single process (md0_raid6) taking up 100% of one CPU.
> [=85]
>> I tested this by creating 24 devices in RAM, used different chunk
>> sizes, and then copied the linux kernel source. Test script can be
>> found on http://oletange.blogspot.dk/2012/05/software-raid-performan=
ce-on-24-disks.html
>
> =A0 What a wild train of thoughts=85 Are those 24 disks HDDs or they'=
re "in RAM"?

As I write:

>> I tested this by creating 24 devices in RAM

so yes: For the test they are loop back devices on a tmpfs in RAM.

>> By doing it in RAM the results are not affected by physical disks or
>> disk controller.

So the test results are NOT affected by various hardware issues
(controller, PCIe lanes, disk, ...), and also NOT affected by
software related to the hardware (IO stack traversal, elevators,
buffers/cache fills, ... etc.).

The test is thus not limited by the 2000 MB/s that 'dd'-test shows the
hardware supports.

The only hardware being used in the test is RAM.

It should therefore be possible to reproduce my findings on most
systems with > 10 GB RAM. Maybe you get different values, but I would
think you will see the same trend: md0_raid6 is the limiting factor
and you do not get anywhere near the theoretical max that the kernel
reports (6196 MB/s in my case).

The theoretical max raw performance of my loop devices in RAM is 7000
MB/s as measured by:

  time parallel -j0 dd if=3D{} of=3D/dev/null bs=3D500k count=3D1k ::: =
/dev/loop*

>> So the only change is the speed of computing
>> checksums. This can also be seen as the time the process md0_raid0 i=
s
>> running.
>>
>> The results were:
>>
>> Chunk size =A0 =A0 =A0Time to copy 10 linux kernel sources as files =
=A0 Time to copy
>> 10 linux kernel sources as a single tar file
>> 16 =A0 =A0 =A032s =A0 =A0 13s
> [=85]
>> 4096 =A0 =A01m38s =A0 16s
>
> =A0 You were talking bout MB/secs and now you're not. It doesn't help
> understanding you either.

The table shows chunk size (mdadm -c), timings for copying the linux
source 10 times in parallel as files and second time as single
uncompressed tar file. This is to measure performance for small files
and big files respectively.

>> But I cannot explain why even the best performance (4600 MB/11s =3D =
420
>> MB/s) is not even close to the checksum performance reported by the
>> kernel at boot (6196 MB/s):
>>
>> =A0 =A0Mar 13 16:02:42 server kernel: [ =A0 35.120035] raid6: using
>> algorithm sse2x4 (6196 MB/s)
>>
>> Can you explain why I only get 420 MB/s of real world checksumming
>> instead of 6196 MB/s?
>
> =A0 Again =97 420 MB/sec on HDD-based RAID or in-RAM one? What do you
> think LSR subscribers are =97 mediums?

I had assumed that if they had any doubt they would read the test
script. As I wrote:

>> Test script can be found on http://oletange.blogspot.dk/2012/05/soft=
ware-raid-performance-on-24-disks.html

Here it should be clear that for this test setup the HDDs are
loop-back files on a tmpfs (which is 100% in ram - not swapped out).

The main point is:

When I run 'top' during the tests I see 'md0_raid6' taking up 100% of
one CPU core. This leads me to believe the limiting factor is indeed
'md0_raid6' and not hardware. This is true for all the in RAM tests
(and it is also true for the production system which runs on normal
magnetic SATA disks).

So what puzzles me is: If the theoretical maximum for checksumming is
6196 MB/s and the loop back devices delivers 7000 MB/s in raw
(non-RAID) performance, why do I only get 420 MB/s if the loop-back
devices are in RAID6? And why is md0_raid6 taking up 100% of one CPU
core, but only delivering 420 MB/s of performance?

I _do_ expect md0_raid6 to take up 100% of one CPU core, but it should
perform at 6196 MB/s, and not at 420 MB/s that I  measure.

What performance do you get if you run the test script (lower part of
http://oletange.blogspot.dk/2012/05/software-raid-performance-on-24-dis=
ks.html)?
Can you reproduce the findings?


/Ole
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
