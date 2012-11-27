From: David Brown <david.brown@hesbynett.no>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 15:34:07 +0100
Message-ID: <50B4CF5F.3010309@hesbynett.no>
References: <25425956.18.1354024591879.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <25425956.18.1354024591879.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>
List-Id: linux-raid.ids

On 27/11/2012 14:56, Roy Sigurd Karlsbakk wrote:
>>> If this system is running RAID-6, recovery should be possible to
>>> check both parity chunks, right?
>>
>> Yes, of course. (And if anyone ever needs it, it is possible to
>> extend raid6 to 3 parity chunks. I've done the maths, but it is
>> not implemented - there doesn't seem to be a big need for it.) But
>> - again referring back to Neil's blog - if the low-level raid spots
>> a consistency error, it still cannot correct it reliably even with
>> 2 parity chunks, and should pass on a read error to the higher
>> level raid. Using raid6 at the low level would let you do a good
>> consistency check even in the case of a failed drive (or a known
>> read error on a drive) - or two simultaneous undetected read
>> errors. And raid6 on the higher level raid would let you correct
>> such errors, even when there are other errors around. You'd soon
>> reach the point where it is more likely for your disks to
>> spontaneously turn into a bowl of petunias than for read errors to
>> be undetected or unrecoverable.
>
> That would be nice. So what should be done here in the first place,
> is to change the code to allow parity data to be read and calculated
> also on reads?

Well, what should be done /first/ is to hope that some of the more 
experienced md raid experts express an opinion on the idea - is it 
possible, is it useful, and is it practical to implement?

The main aim would be to add an option to a md arrays that will turn 
each read into an implicit scrub or check of the whole stripe, and that 
a consistency error there would return a read error to the next layer of 
md raid.

I can see plenty of scope for complications here, such as what to do on 
normal (detected) read errors, or how to ensure that the upper layer 
re-writes the whole stripe and not just part of it (or perhaps partial 
re-writes would be enough).  I am fully aware that I'm just giving a 
rough idea here - it needs a lot more thought before anyone can start 
changing code.  But if my theory here is correct, and if it is practical 
to implement, then it might be a useful tool for big data producers.

mvh.,

David





>
> Vennlige hilsener / Best regards
>
> roy

