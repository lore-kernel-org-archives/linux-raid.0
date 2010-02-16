From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Why does one get mismatches?
Date: Tue, 16 Feb 2010 16:25:25 -0500
Message-ID: <4B7B0D45.7040801@tmr.com>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com> <4B67451F.8040206@tmr.com> <20100202093738.44b4fece@notabene.brown> <4B684087.50001@tmr.com> <20100211161444.7a0ea7bb@notabene.brown> <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Mesich <bryan.mesich@ndsu.edu>, Neil Brown <neilb@suse.de>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bryan Mesich wrote:
> On Thu, Feb 11, 2010 at 04:14:44PM +1100, Neil Brown wrote:
>   
>>> This whole discussion simply shows that for RAID-1 software RAID is less 
>>> reliable than hardware RAID (no, I don't mean fake-RAID), because it 
>>> doesn't pin the data buffer until all copies are written.
>>>       
>> That doesn't make it less reliable.  It just makes it more confusing.
>>     
>
> I agree that linux software RAID is no less reliable than
> hardware RAID with regards to the above conversation.  It's
> however confusing to have a counter that indicates there are
> problems with a RAID 1 array when in fact there is not.
>   

Sorry, but real hardware raid is more reliable than software raid, and 
Neil's justification for not doing smart recovery mentions it. Note this 
referes to real hardware raid, not fakeraid which is just some firmware 
in a BIOS to use the existing hardware.

The issue lies with data changing between write to multiple drives. In 
hardware raid the data traverses the memory bus once, only once, and 
goes into cache in the controller, from which it is written to all 
mirrored drives. With software raid an individual write is done to each 
drive, and if the data in the buffer changes between writes to one drive 
or the other you get different values. Neil may be convinced that the OS 
somehow "knows" which of the mirror copies is correct, ie. most recent, 
and never uses the stale data, but if that information was really 
available reads would always return the latest value and it wouldn't be 
possible to read the same file multiple times and get different MD5sums. 
It would also be possible to do a stable smart recovery by propagating 
the most recent copy to the other mirror drives.

I hoped that mounting data=journal would lead to consistency, that seems 
not to be true either.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

