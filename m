From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: Why does one get =?UTF-8?Q?mismatches=3F?=
Date: Wed, 17 Feb 2010 08:38:11 +1100
Message-ID: <6db64f7872286165ac1fd3436e9d6476@localhost>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com> <4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown> <4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown> <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu> <4B7B0D45.7040801@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B7B0D45.7040801@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Bryan Mesich <bryan.mesich@ndsu.edu>, Neil Brown <neilb@suse.de>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 16 Feb 2010 16:25:25 -0500, Bill Davidsen <davidsen@tmr.com>
wrote:
> Bryan Mesich wrote:
>> On Thu, Feb 11, 2010 at 04:14:44PM +1100, Neil Brown wrote:
>>   
>>>> This whole discussion simply shows that for RAID-1 software RAID is
>>>> less
>>>> reliable than hardware RAID (no, I don't mean fake-RAID), because it 
>>>> doesn't pin the data buffer until all copies are written.
>>>>       
>>> That doesn't make it less reliable.  It just makes it more confusing.
>>>     
>>
>> I agree that linux software RAID is no less reliable than
>> hardware RAID with regards to the above conversation.  It's
>> however confusing to have a counter that indicates there are
>> problems with a RAID 1 array when in fact there is not.
>>   
> 
> Sorry, but real hardware raid is more reliable than software raid, and 
> Neil's justification for not doing smart recovery mentions it. Note this

> referes to real hardware raid, not fakeraid which is just some firmware 
> in a BIOS to use the existing hardware.
> 
> The issue lies with data changing between write to multiple drives. In 
> hardware raid the data traverses the memory bus once, only once, and 
> goes into cache in the controller, from which it is written to all 
> mirrored drives. With software raid an individual write is done to each 
> drive, and if the data in the buffer changes between writes to one drive

> or the other you get different values. Neil may be convinced that the OS

> somehow "knows" which of the mirror copies is correct, ie. most recent, 
> and never uses the stale data, but if that information was really 
> available reads would always return the latest value and it wouldn't be 
> possible to read the same file multiple times and get different MD5sums.

> It would also be possible to do a stable smart recovery by propagating 
> the most recent copy to the other mirror drives.
> 
> I hoped that mounting data=journal would lead to consistency, that seems

> not to be true either.

I agree Bill, there is an issue with the software RAID1 when it comes down
to some hardware. I have one machine where the ONLY way to stop the root
filesystem going readonly due to journal issues is to remove RAID. Having
RAID1 enabled gives silent corruption of both data and the journal at
seemingly random times.

I can see the data corruption from running a verify between RPM and data
on the drive. Reinstalling these packages fixes things - until something
random things get corrupted next time.

The myth that data corruption in RAID1 ONLY happens to swap and/or unused
space on a drive is absolute rubbish.

-- 
Steven Haigh
 
Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299
