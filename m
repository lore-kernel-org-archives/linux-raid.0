From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Wed, 2 Dec 2015 18:12:55 -0600
Message-ID: <CAE9DZUR=w9gbyqm0NzqrKk-G-mT3vd9Py54uEps7fpxC4LMBhg@mail.gmail.com>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
	<20151202010745.GC9812@www5.open-std.org>
	<F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
	<565F03F2.3070803@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
	<565F1035.10800@turmel.org>
	<F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
	<565F136F.2090709@turmel.org>
	<CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 2, 2015 at 1:50 PM, Dallas Clement
<dallas.a.clement@gmail.com> wrote:
> On Wed, Dec 2, 2015 at 9:51 AM, Phil Turmel <philip@turmel.org> wrote:
>> On 12/02/2015 10:44 AM, Robert Kierski wrote:
>>> I've tried a variety of settings... ranging from 17 to 32768.
>>>
>>> Yes.. with stripe_cache_size set to 17, I see a C/T of rmw's.  And my TP goes in the toilet -- even with the RAM disks, I get only about 30M/s.
>>
>> Ok.
>>
>> You mentioned you aren't using a filesystem.  How are you testing?
>>
>> Phil
>>
>> ps. convention on kernel.org is to trim replies and bottom-post, or
>> interleave.  Please do.
>
> Thank you all for your responses.
>
> Keld,
>
>> Did you test the performance of other raid types, such as RAID1 and the various layouts of RAID10 for the newer kernels?
>
> I did try RAID 1 but not RAID 10.  With RAID 1 I am seeing much higher
> average and peak wMB/s and disk utilization than with RAID 5 and 6.
> Though I need to run some more tests to compare the performance of
> newer kernels with the 2.6.39.4 kernel.  Will report on that a bit
> later.
>
> Roman,
>
>> Do you use a write intent bitmap (internal?), what is your bitmap chunk size?
>
> Yes, I do.  After reading up on this, I see that it can negatively
> affect write performance.  The bitmap chunk size is 67108864.
>
>> What is your stripe_cache_size set to?
>
> strip_cache_size is 8192
>
> Robert, like you I am observing that my CPU is mostly idle during RAID
> 5 or 6 write testing.  Something else is throttling the traffic.  Not
> sure if there is some threshold crossing i.e. queue size, await time
> etc that is causing this or if it is implementation problem.
>
> I understand that the stripe cache grows dynamically in >= 4.1
> kernels.   Fwiw, adjusting the stripe cache made no difference in my
> results.
>
> Regards,
>
> Dallas

Here is a summary of the performance differences I am seeing with the
3.10.69 kernel vs the 2.6.39.4 kernel (baseline):

RAID 0

bs = 512k - 3.5% slower
bs = 2048k - 1.5% slower

RAID 1

bs = 512k - 35% faster
bs = 2048k - 48% faster

RAID 5

bs = 512k - 22% slower
bs = 2048k - 28% slower

RAID 6

bs = 512k - 24% slower
bs = 2048k - 30% slower

Surprisingly  RAID 1 is faster in the newer kernel, but RAID 5 & 6 much slower.

All measurements computed from bandwidth averages taken on 12 disk
array with XFS filesytem using fio with direct=1, sync=1,
invalidate=1.

Seems incredulous!?
