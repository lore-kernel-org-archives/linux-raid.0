From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Tue, 25 Mar 2008 11:17:36 -0400
Message-ID: <47E91790.2040101@tmr.com>
References: <20080316161451.0d17fd22@szpak>	<47E26775.3000500@tuxes.nl>	<20080320134747.GA28114@cthulhu.home.robinhill.me.uk>	<47E2725C.1020206@tuxes.nl>	<20080320163551.GG13719@mit.edu>	<47E2EE64.5080101@rabbit.us>	<47E3C504.3010700@tmr.com>	<47E3CBAF.4090808@rabbit.us>	<20080321171348.GK7991@mit.edu>	<47E3F1EF.3030705@rabbit.us>	<20080322132733.GR7991@mit.edu> <18408.33596.390197.465267@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.33596.390197.465267@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Theodore Tso <tytso@MIT.EDU>, Peter Rabbitson <rabbit+list@rabbit.us>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday March 22, tytso@MIT.EDU wrote:
>   
>> On Fri, Mar 21, 2008 at 06:35:43PM +0100, Peter Rabbitson wrote:
>>     
>>> Of course it would be possible to instruct md to always read all 
>>> data+parity chunks and make a comparison on every read. The performance 
>>> would not be much to write home about though.
>>>       
>> Yeah, and that's probably the real problem with this scheme.  You
>> basically reduce the read bandwidth of your array down to a single
>> (slowest) disk --- basically the same reason why RAID-2 is a
>> commercial failure.  
>>     
>
> Exactly.
>
>   
In some cases that would be acceptable. Obviously in the general case 
it's not required.
>> I suspect the best thing we *can* to do is for filesystems that
>> include checksums in the metadata and/or the data blocks, is if the
>> CRC doesn't match, to have the filesystem tell the RAID subsystem,
>> "um, could you send me copies of the data from all of the RAID-1
>> mirrors, and see if one of the copies from the mirrors causes a valid
>> checksum".  Something similar could be done with RAID-5/RAID-6 arrays,
>> if the fs layer could ask the RAID subsystem, "the external checksum
>> for this block is bad; can you recalculate it from all available
>> parity stripes assuming the data stripe is invalid".
>>     
>
> Something along these lines would be very appropriate I think.
> Particularly for raid1.
> For raid5/raid6 it is possible that a valid block in the same stripe
> was read and written before the faulty block was read.  This would
> correct the parity so when the bad block was found, there would be no
> way to recover the correct data.
> Still, having the possibility of recovery might be better than not
> having it.
>
>   
>> As far as the question of how often this happens, where a disk
>> silently corrupts a block without returning a media error, it
>> definitely happens.  Larry McVoy tells a story of periodically running
>> a per-file CRC across a backup/archival filesystems, and was able to
>> detect files that had not been modified changing out from under him.
>> One way this can happen is if the disk accidentally writes some block
>> to the wrong location on disk; the blockguard extension and various
>> enterprise databases (since they can control their db-specific on-disk
>> format) will encode the intended location of a block in their
>> per-block checksums, to detect this specific type of failure, which
>> should broad hint that this sort of thing can and does happen.
>>     
>
> The "address data was corrupted" is certainly a credible possibility.
> I remember reading that SCSI has a parity check for data, but not for
> the command, which include the storage address.
>
> With the raid6 algorithm, we can tell which device has an error
> (assuming only one device does) for each byte in the block.
> If this returns the same device for every block in a sector, it is
> probably reasonable to assume that exactly that block is bad.
> Still, if we only do that on the monthly 'check', it could be too
> late.
>
>   
I think the old saying "better late than never" applies, once the user 
knows that there is a problem via 'check,' and fixes it if possible, 
some form of recovery would then at least be possible.

> I'm not sure that "surviving some data corruptions, if you are lucky"
> is really better than surviving none.  We don't want to provide a
> false sense of security.... but maybe RAID already does that.
>
> A filesystem that always writes full stripes and never over-writes
> valid data.  And that (optionally) stores checksums for everything is
> looking more an more appealing.   The trouble is, I don't seem to have
> enough "spare time" :-)
>   

Frankly I think your limited time is better spent on raid, there are 
undoubtedly plenty of things on your "to do" list. I'd like to hope that 
raid5e is at least on that list, but I would be the first to say that 
performance improvements for raid5 would benefit more people.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


