From: Carlos Knowlton <cknowlton@science.edu>
Subject: Re: Is there a drive error "retry" parameter?
Date: Wed, 15 Jun 2005 16:40:52 -0500
Message-ID: <42B0A064.20406@science.edu>
References: <200505021224.35396.mlaks@verizon.net> <429F2458.6070404@update.fsix.com> <429F3ED5.4020005@tls.msk.ru> <42AF51CD.7050102@update.fsix.com> <42AF5E2B.3010908@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AF5E2B.3010908@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Michael,

Michael Tokarev wrote:
...

> (For completness: there's another reallocation feature supporting
> by most drives - write-error relocation, when a drive relocates
> bad block on *write* error, because it knows which data should be
> there.  A block that was unreadable may become good again after
> re-write, either "just because", after refreshing its pieces,
> it is now in cleaner state, or because the write-error relocation
> mechanism in the drive did its work.  That's why re-writing
> a drive with bad blocks often results in a good drive, and often
> that good state persists; it's more or less normal for a drive
> to develop one or two bad blocks during its lifetime and reallocate
> them.)

Thanks!  This is useful info. 

I did some googling on sector relocation, and it appears that SpinRite 
6.0  (on their features page <http://www.grc.com/srfeatures.htm>),  
claims to be able to turn off sector relocation, and re-read and analyze 
the "bad" sector in different ways until it can get a good read, (or 
deduce the correct data from the statistical outcome of multiple failed 
reads) then turn relocation back on, and map around the sector.  Any 
reason this couldn't be done in the block device driver (or some other, 
more appropriate layer)?  It seems that this kind of transparent data 
recovery would be a real plus!  Do you know if any thought has gone into 
this kind of thing?

>
>>>> Is there a "retry" parameter that can be set in the kernel parameters,
>>>> or else in the code itself to prolong the existence of a drive in an
>>>> array before it is considered dirty?
>>>
>>>
>>> There's no such parameter currently.  But there was several discussions
>>> about how to make raid code more robust - in particular, in case of
>>> read error, raid code may keep the errored drive in the array and mark
>>> it dirty only in case of write error.
>>>
>> That would be nice.  Do you know if anyone has done any work toward 
>> such a fix?
>
>
> Looks like this is a "FAQ #1" candidate for linux softraid ;)
> I tried to do just that myself, with a help from Peter T. Breuer.
> The code even worked here on a test machine for some time.
> But it's umm.. quite a bit ugly, and Neil is going to slightly
> different direction (which I for one don't like much - the
> persistent bitmaps stuff, -- I think simpler approach is better).

Is that the journal stuff mentioned here 
<http://lwn.net/2002/0523/a/jbd-md.php3> between Neil and Steven  
Tweedie?  What is the status of it?  (a complex approach to a solution 
is better than nothing, as long as it solves the problem, right?)

> If memory serves me right, you mentioned *several* drives goes off
> all at once.  This is not a bad sector on one drive, it's something
> else like bad cabling or power supplies, whatever.

I've looked into cable and power issues, and if they are the culprit, 
the problem is terribly intermittent, and my setup  is generally within 
spec.  (although on some servers we have mounted two drives on a 40pin 
ATA cable, we've rarely seen two drives fail that have shared a 
cable.).  After a reboot, the drives that had these errors are happily 
restored back into the array as if nothing happened. If these are issues 
with a standard setup, this is all the more reason to want RAID to be a 
little bit more lenient on the isolated read error.

I've been looking into the IDE code to see if I can get it to give me a 
few more read retries before declaring a read error.  The "ERROR_MAX" 
variable in ".../linux-x.x.x/include/linux/ide.h" looks like it might 
afford me some extra time.  Is there a better place to find this kind of 
relief?

> Speaking of drives and bad sectors -- see above.  On SCSI drives
> there's a way to see all the relocations (scsiinfo utility for
> example).

Is there anything similar  to this for S-ATA, or P-ATA drives?

> And yes indeed, it'd be nice to keep the drive in the array in case
> of read error, and only kick it off on write errors - huge step in
> the right direction.

I appreciate your effort toward this end.   Thanks again for your help!


Regards,
Carlos
