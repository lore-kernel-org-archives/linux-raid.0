From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: device and partition alignment
Date: Sun, 06 Jun 2010 12:56:16 +0200
Message-ID: <4C0B7ED0.5000104@stud.tu-ilmenau.de>
References: <000b01cb04f0$dbcf7720$936e6560$@woodlea.com> <4C0AC6E4.4080408@stud.tu-ilmenau.de> <20100605221139.D066814E867@gemini.denx.de> <000001cb0504$e49c07b0$add41710$@woodlea.com>
Reply-To: st0ff@npl.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000001cb0504$e49c07b0$add41710$@woodlea.com>
Sender: linux-raid-owner@vger.kernel.org
To: Graham Mitchell <gmitch@woodlea.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi again,

Am 06.06.2010 01:14, schrieb Graham Mitchell:
>> Dear Stefan,
>>
>> In message <4C0AC6E4.4080408@stud.tu-ilmenau.de> you wrote:
>>>
>>> I guess you couldn't find much about this as it has more to do with
>>> common sense than magic formulae.  If you have 4k-sector drives, align
>>> everything at multiples of 4k, use filesystem-units of multiples of 4k.
>>>  As I read and it also seems very logical from the ATA / SCSI point of
>>> view, a stripe size of 256k seems most straight forward.  This is the
>>> largest amount of data (a.t.m.) that can be read or written with a
>>> single command to a disk.
>>
>> And why would that be optimal, in general?

Not really in general, and after reviewing the ATA8-ACS draft I'll have
to take it back.  The maximum number of bytes that can be transferred
with a single READ FPDMA command seem to be 32MB (on 512byte sector size
disks - which the recent WDXXEARS simulate to be, also), but I guess
kernel memory management does it differently.  I read a few days ago in
this list, that after benchmarking a lot 256k chunks seemed to give best
performance on large files.  Which must be related to how the kernel
manages it all.
>>
>> For example, in a file system I have here (with some 15 millions
>> files) we see the following distribution of file sizes:
>>
>> 	65%   are smaller than  4 kB
>> 	80%   are smaller than  8 kB
>> 	90%   are smaller than 16 kB
>> 	96%   are smaller than 32 kB
>> 	98.4% are smaller than 64 kB
>>
>> With many write accesses going on, a stripe size of 16 KiB gives much
> better
>> performance.

Nobody talked about a small file raid, so I guessed that larger files
were the most common planned content, as this is what most of my
customers want.
>>
>> I think you cannot recommend a stripe size or other specific tuning
> measures
>> without exactly knowing the characteristics of the load.
> 
2nd that!
> 
> To give you a bit more of the background in this particular case (but I'm
> not really looking for a case specific answer here).
> 
> This particular array is for a media server, so for practical purposes, the
> minimum file size is about 600MB (there are smaller, but very exceptional),
> file sizes average 1GB to 2GB, with some as large as 8GB.

so my guess was right...
> 
> So, starting backwards....
> 
> When I built the file system (ext4), I did some calculations for the stride
> (chunk size / fs block size), so in my case 512k / 4k, which came to 128k.

I'm generally recommending xfs before ext3 and just at the end ext4.
There were too many discussions going on about the internals of ext4 and
if the implementation is the right way to go.
> 
> The strip width is stride * No of data disks (for RAID5 and RAID6 - I am
> using RAID 6), so in my case it's 128k * 15, so 1664k.
> 
> Passed these to mkfs.ext4 with the -T largefile4 option, and that should
> mean that everything was aligned properly on the RAID device md0.
> 
> Except that it probably isn't....
> 
> Even if md0 were perfectly aligned to the underlying disks, it probably
> isn't aligned because the raid superblock starts at the start of md0 (or in
> my case, it's offset by 4k). We don't even know what size the superblock is
> - there's a fixed 256 byte section, then a variable section that defines the
> device roles in the array. So even if the md device itself is perfectly
> aligned, we can almost guarantee(?) that the data section of the device
> isn't going to be.
> 
> So, I'm looking for some way to do the file system alignment properly
> 
> 
> Then we come back to the physical disks that go to make up the RAID device.
> I guess the simplest way (or am I being too simplistic here) would be to use
> the raw device, which would (should?) guarantee that everything would be
> aligned? However, I want to be able to use partitions on the disk to create
> the array, so that doesn't really help. One suggestion I've read is to start
> each partition on a 2k boundary, with the first partition starting at sector
> 2048 - I didn't manage to find out why 2k was suggested and not 4k.
> 
> I'm also not finding where the 256k limit on a disk write comes from - the
> Hitachi drive I'm looking at shows a logical/physical sector size of 512
> bytes, though I've not pulled the data sheet to check if it's one of the new
> 4k sector drives (and I suspect that this one isn't) - is it some kernel
> limit?

Talking HDS722020ALA330?  It's 512bytes/sector.
> 
> So, I'm also looking for some way to do the partition alignment properly. Do
> I use 2048, as was suggested somewhere, or do I make each partition align to
> 4096, just in case?
> 
> A lot of what I've read is 'just common sense', or 'obvious', when it isn't
> really. Some things you need to need to make some number based on (say) the
> type of files on the final file system, where a smaller chunk size would
> make sense, in other cases, a larger chunk size would make sense. But once
> you've made those design decisions, there should be some set of formulae you
> can use to work out the optimal settings for partitions, alignment etc. (it
> may not be a simple formula, but them's the breaks sometimes).
> 
From everything that is common sense you can create a formula.  That's
how physics work ;)  But as in physics, the formula gets as complicated,
as many aspects of the problem you want to take care of.  I wouldn't
want to create a formula where 20 people say: "sounds great" and another
50 moan "you didn't think of this, you didn't think of that".
> 
> Graham
> 

Stefan
