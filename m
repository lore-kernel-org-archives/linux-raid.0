From: Bas van Schaik <bas@tuxes.nl>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Thu, 20 Mar 2008 16:16:08 +0100
Message-ID: <47E27FB8.1070009@tuxes.nl>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320144549.GB28114@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080320144549.GB28114@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
> On Thu Mar 20, 2008 at 03:19:08PM +0100, Bas van Schaik wrote:
>
>   
>> Robin Hill wrote:
>>     
>>> On Thu Mar 20, 2008 at 02:32:37PM +0100, Bas van Schaik wrote:
>>>   
>>>       
>>>> Anyone able to answer the last and most important question: does it
>>>> produce a message during resync in case of corruption? That would be great!
>>>>     
>>>>         
>>> There's no explicit message produced by the md module, no.  You need to
>>> check the /sys/block/md{X}/md/mismatch_cnt entry to find out how many
>>> mismatches there are.  Similarly, following a repair this will indicate
>>> how many mismatches it thinks have been fixed (by updating the parity
>>> block to match the data blocks).
>>>   
>>>       
>> Marvellous! I naively assumed that the module would warn me, but that's
>> not true. Wouldn't it be appropriate to print a message to dmesg if such
>> a mismatch occurs during a check? Such a mismatch clearly means that
>> there is something wrong with your hardware lying beneath md, doesn't it?
>>
>>     
> With a RAID5 then mostly, yes - there may be errors caused by transient
> situations (interference, cosmic rays, etc) which are entirely
> independent of the hardware.  With other RAID versions it's not quite as
> clear cut.  For example with RAID1 it's possible for the in-memory data
> to have been changed between writing to each disk (especially with swap
> disks) - this isn't necessarily an issue (and certainly not a hardware
> one).
>   
Maybe I understand something wrong then. In an ideal situation, the
following should hold:
 - for RAID5: all data should count up to the parity bit
 - for RAID1: all bits should be identical

If the redundancy check encounters a anomaly, something should be fixed.
If something should be fixed, clearly something went wrong somewhere in
the past. Or can you give an example where the statements mentioned
above don't hold and nothing is wrong?

>>> I've no idea whether the checkarray script you're using is checking this
>>> counter - there seems little point in having a special script if it
>>> isn't though.
>>>   
>>>       
>> If I understand the meaning of this counter, it would be sufficient to
>> check the value of it _before_ the check operation and compare that
>> value to the counter value _after_ the check. If the counter has
>> increased: the check has encountered some inconsistencies which should
>> be reported.
>> Please correct me if I'm wrong
> Depends on what the previous operation was.  After a repair, the counter
> will indicate the number of errors fixed, not the number remaining.
> Theoretically, after a repair there will be no errors remaining, so any
> value (> 0) in the counter after a check would indicate an issue to be
> reported.
>   
Bottom line: I just want to know if an md check (using "echo check >
sync_action") encountered any inconsistencies. If so, in my setup that
would probably mean there is something wrong (bits flipping somewhere
between md, the bus, the NIC, the network, the NIC of a storage server,
etc.)

I just don't want to be surprised by any major filesystem corruptions
anymore!

Cheers,

  Bas
