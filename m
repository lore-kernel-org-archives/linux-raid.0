From: Asdo <asdo@shiftmail.org>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Fri, 27 Nov 2009 14:39:21 +0100
Message-ID: <4B0FD689.9030904@shiftmail.org>
References: <4B0E7111.20202@shiftmail.org>
 <alpine.DEB.2.00.0911260720220.23317@p34.internal.lan>
 <4B0E8B75.2030006@shiftmail.org>
 <alpine.DEB.2.00.0911260915520.17452@p34.internal.lan>
 <4B0ED0DF.10502@shiftmail.org>
 <alpine.DEB.2.00.0911261554170.14297@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.2.00.0911261554170.14297@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz wrote:
>>> I see where you're going here.  Read below but if you go this route 
>>> I assume
>>> you would first stop the array (?) mdadm -S /dev/mdX and then test each
>>> individual disk one at a time?
>>
>> I don't plan to stop the array prior to reading the drives. Reads 
>> should not be harmful...
>> You think otherwise?
> Depends on the drives, ever try to copy a file from a failing drive? Some
> drives will start to click/reset/ATA errors, etc.  Depends on how it is
> failing and what is wrong with it.

You are right, good thinking...

The drives are WD RE2, so they do have TLER, however the default retry 
time is I think 7 seconds. So if I read a drive with dd and it hits an 
unreadable area it will retry for 7 second and during that time it would 
not be responsive and any request coming from MD, and I think 7secs is 
probably enough for MD to kick the drive out of the array. If the MD 
requests are queued in the elevator maybe MD will wait... not sure. I 
might help them to queue in elevator by disabling NCQ.

TLER is configurable in theory (so to lower the time to e.g. 1 second) 
but I have never done it and it seems I would need to reboot into MSDOS 
/ Freedos (wdtler is DOS utility as it seems). The problem is that the 
computer is in heavy use and the array also.

This would be another question for Neil (if 7 secs is enough for MD to 
kick out the drive, and if the drive will still be kicked if MD requests 
to it are queued in the linux elevator).

Without knowing this I will probably opt for your way: rsync data out, 
starting from the smallest and most important stuff...

>> I think I did read the drives in the past on a mounted array and it 
>> was no problem.
I forgot to mention that in that case there were no read errors... :-D

> Good to hear, let us know which option you choose & what the outcome is!
>
> Justin.

Thank you
