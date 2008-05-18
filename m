From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: questions about softraid limitations
Date: Sun, 18 May 2008 13:11:37 +0200
Message-ID: <07b301c8b8d7$f3e6d590$9300a8c0@dcccs>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs> <482AC2BB.5010602@dgreaves.com> <01be01c8b61a$6e616260$9300a8c0@dcccs> <482D479F.3040809@dgreaves.com> <022401c8b739$5262ba80$9300a8c0@dcccs> <482FF2DB.9060604@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "David Greaves" <david@dgreaves.com>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>; "David Lethe" <david@santools.com>
Sent: Sunday, May 18, 2008 11:11 AM
Subject: Re: questions about softraid limitations


> Janos Haar wrote:
>> At this time, i working in my data recovery company, and some times need
> Ah - I missed this too.
>
>> to recover the broken hw raid arrays too.
>> (with md arrays, we have no problem at all. :-) )
> Nice quote for "the benefits of software raid" somewhere :)
>
>> In your rows, we talking about 2 cases:
>>
>> a, disk hw problem (only bad sectors, the completely failed disk is in
>> 'b' case)
>> Yes, the ddrescue is the best way, to do the recovery, but:
>> The ddrescue is too agressive with default -e 0 setting!
>> This can be easily fail down the drive! (dependig the reason of the bad
>> sectors)
> OK, worth knowing - what would you suggest?

The actually best way is this:

blockdev --setro /dev/SOURCE
blockdev --setra  0 /dev/SOURCE
ddrescue -v -b 4096 -B 1024 -e 1 -y 0 /dev/SOURCE /dev/TARGET (if you dont 
use a real clean disk with full of zeros, you need the -A option too)

+ need some kernel patch to disable all retry on the source disk.

The best recovery history is in 3 steps:

1. read the drive with these settings, and after the error-stop, jump up 
with x Kbyte, and continue reading...
2. jump only the start-kbytes, and read backward (with -e 1) to the first 
error or until the end of x Kbyte.
3. read with -B 1024 -b 1204 -e 0 -y 0 only the holes. :-)

+ need to count the jump-start-errors! (if the drive gives read error after 
3-5 jump continously, this means something wrong happening, and need to stop 
the dirve immediately!)

The best step up x Kbyte for good heads and good platter is 16KByte - 8 
MByte.
And for damaged head and/or damaged platters is 100MB - 1GB.

There is no easy solution. :-(

>
>> And with the images, we have another problem!
>> The 0x00 holes.
>> The hw or md have no deal about where we need recover from parity and
>> where we have real zero blocks....
>> Overall this is why data recovery companys learning and developing more
>> and more.... :-)
>
> Hmm - I wonder if things like ddrescue could work with the md bitmaps to 
> improve
> this situation?
> Is this related to David Lethe's recent request?

I think ddrescue is for copy/rescue the data, not for processing it.
But can log the errors... ;-)

But we have another problem at this point:
The practical step is to copy the whole block device, not the partition 
only.
(if something wrong happening with the damaged heads or platters, we dont 
know the MBR (first sector) will be exists on the next reboot....)

Cheers,

Janos


>
>> I need no help at this time, i just want to share my ideas, to helping
>> upgrading/developing md, and helping for people....
> OK - ta.
>
> David 

