From: David Brown <david.brown@hesbynett.no>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 12:20:53 +0100
Message-ID: <50B4A215.4000203@hesbynett.no>
References: <14319197.21.1353936449959.JavaMail.root@zimbra> <50B48BAA.8060903@hesbynett.no> <50B4934F.6060105@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B4934F.6060105@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 27/11/2012 11:17, Bernd Schubert wrote:
> On 11/27/2012 10:45 AM, David Brown wrote:
>> On 26/11/2012 14:27, Roy Sigurd Karlsbakk wrote:
>>> Hi all
>>>
>>> I see from an article at
>>> http://pages.cs.wisc.edu/~bpkroth/cs736/md-checksums/md-checksums-paper.pdf
>>>
>>>
>>> that an implementation has been made to allow for ZFS-like
>>> checksumming inside Linux MD. However, this code doesn't seem to
>>> exist in any kernel trees. Does anyone know the current status for
>>> data checksumming in MD?
>>>
>>
>> See <http://neil.brown.name/blog/20110227114201> for a discussion on
>> data checksums.
>>
>> As far as I have seen on this mailing list, there has been no "official"
>> work on checksums as described in that paper.  I suspect it's just a
>> matter of a student or two doing a project as part of their university
>> degree.  It's great that people can do that - they are free to take a
>> copy of the kernel, and experiment with new ideas.  If the ideas are
>> good, then it is possible to work it back into the mainline kernel
>> development.
>>
>> However, in this case I think there is not much support for data
>> checksumming amongst the "big boys" in this part of the Linux kernel -
>> as explained by Neil in his blog post.
>>
>> My first thought when reading the paper in question is that it doesn't
>> really add much that is actually useful.  md does not need checksums -
>> it already has a more powerful system for error detection and correction
>> through the parity blocks.  If you want more checksumming than raid5
>> gives you, then use raid6.
>>
>> What might be of interest for confirming the data integrity is so say
>> that whenever a block is to be read, the stripe it is in should be
>> scrubbed.  This would enforce regular scrubbing of data that is
>> regularly used, and give the same benefits as the article's data
>> checksumming.  It would lead to more disk reads when you have small
>> reads, but the overhead would be small for larger reads or for RMW
>> writes (since the whole stripe, minus the parity, is read in this case).
>>
>> However, referring to another of Neil's blog posts at
>> <http://neil.brown.name/blog/20100211050355>, you have to ask yourself
>> how likely is it that data will be read from the drive with an error,
>> but without the disk telling you of the error - and what can you
>> sensibly do about it?  You don't need checksums to tell you that there
>> is a problem reading data from the disk - the disk already has very
>> comprehensive checking of the data, and if that fails it will report an
>> error and the md layer will re-construct the data from the parity and
>> the rest of the stripe.
>
> Thats the theory, real live unfortunately teaches a different story. I
> just helped to recover as much data as possible from a troublesome
> infortrend raid system, which again is part of a software raid. The
> stupid hardware raid decided for unknown reasons to return different
> data on each read. And this is already the 4th or 5th time that happened
> (its a rather big installation and each time another hardware raid
> causes the trouble).
> And yes, I also aready have seen several hard disks to return wrong
> data. That is actually the reason why some hardware raid vendors such as
> DDN do parity reads all the time and then correct wrong data or entirely
> fail the disks.
>
> I will sent patches to better handle parity mismatches during the next
> weeks (for performance reasons only for background checks).
>
> Cheers,
> Bernd
>
>

I can certainly sympathise with you, but I am not sure that data 
checksumming would help here.  If your hardware raid sends out nonsense, 
then it is going to be very difficult to get anything trustworthy.  The 
obvious answer here is to throw out the broken hardware raid and use a 
system that works - but it is equally obvious that that is easier said 
than done!  But I would find it hard to believe that this is a common 
issue with hardware raid systems - it goes against the whole point of 
data storage.

There is always a chance of undetected read errors - the question is if 
the chances of such read errors, and the consequences of them, justify 
the costs of extra checking.  And if they /do/ justify extra checking, 
are data checksums the right way?  I agree with Neil's post that 
end-to-end checksums (such as CRCs in a gzip file, or GPG integrity 
checks) are the best check when they are possible, but they are not 
always possible because they are not transparent.

mvh.,

David


