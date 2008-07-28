From: "David Lethe" <david@santools.com>
Subject: RE: AWFUL reshape speed with raid5.
Date: Mon, 28 Jul 2008 14:59:37 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C0143F8D5@34093-C3-EVS3.exchange.rackspace.com>
References: <cccedfc60807281039y67c27685n161708146d7c2b3d@mail.gmail.com>  <alpine.DEB.1.10.0807281414020.3288@p34.internal.lan>  <cccedfc60807281124w6301915bo88b8be45599f4fb3@mail.gmail.com> <cccedfc60807281155u7a6561a7jce3ca46799f46e4@mail.gmail.com> <alpine.DEB.1.10.0807281543000.3288@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.1.10.0807281543000.3288@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Justin Piszcz
>Sent: Monday, July 28, 2008 2:44 PM
>To: Jon Nelson
>Cc: LinuxRaid
>Subject: Re: AWFUL reshape speed with raid5.
>
>There once was a bug in an earlier kernel, in which the min_speed is
what 
>the rebuild ran at if you had a specific chunk size, have you tried to 
>echo 30000 > to min_speed?  Does it increase it to 30mb/s for the
rebuild?
>
>On Mon, 28 Jul 2008, Jon Nelson wrote:
>
>> Some more data points, observations, and questions.
>>
>> For each test, I'd --create the array, drop the caches, --grow, and
>> then watch vmstat and also record the time between
>>
>> kernel: md: resuming resync of md99 from checkpoint.
>> and
>> kernel: md: md99: resync done.
>>
>> I found two things:
>>
>> 1. metadata version matters. Why?
>> 2. VERY LITTLE I/O takes place (between 0 and 100KB/s, typically no
>> I/O at all) according to vmstat. Why? If it takes 1m34s to "grow" the
>> array, but no I/O is taking place, then what is actually taking so
>> long?
>> 3. I removed the bitmap for these tests. Having a bitmap meant that
>> the overall speed was REALLY HORRIBLE.
>>
>> The results:
>>
>> metadata: time taken
>>
>> 0.9: 27s
>> 1.0: 27s
>> 1.1: 37s
>> 1.2: 1m34s
>>
>> Questions (repeated):
>>
>> 1. Why does the metadata version matter so much?
>> 2. If no I/O is taking place, why does it take so long? [ NOTE: I/O
>> must be taking place but why doesn't vmstat show it? ]
>>
>> -- 
>> Jon
>>

You are incorrectly working from the premise that vmstat is measures
disk activity.  It does not.  Vmstat has no idea how many actual bytes
get sent to, or received from disk drives.

Why not do a real test and hook up a pair of SAS, SCSI, or FC disks,
then issue some LOG SENSE commands to report the actual number of bytes
read & written to each disk during the rebuild? If the disks are
FibreChannel, then you have even more ways to measure true throughput in
bytes.  It will not be an estimate, it will be a real count of
cumulative bytes read, written, re-read/re-written, recovered, etc., for
any instant in time.  Heck, if you have Seagate and some other disks,
then you can even see detailed information for cached reads so you can
see if any particular md configuration results in a higher number of
cached I/Os, meaning greater efficiency and smaller overall latency.


David @ santools dot com

David


