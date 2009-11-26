From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Help on first dangerous scrub / suggestions
Date: Thu, 26 Nov 2009 15:55:53 -0500 (EST)
Message-ID: <alpine.DEB.2.00.0911261554170.14297@p34.internal.lan>
References: <4B0E7111.20202@shiftmail.org> <alpine.DEB.2.00.0911260720220.23317@p34.internal.lan> <4B0E8B75.2030006@shiftmail.org> <alpine.DEB.2.00.0911260915520.17452@p34.internal.lan> <4B0ED0DF.10502@shiftmail.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B0ED0DF.10502@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Thu, 26 Nov 2009, Asdo wrote:

> Justin Piszcz wrote:
>> On Thu, 26 Nov 2009, Asdo wrote:
>> 
>>>>> 
>>>>> BTW I would like to ask an info on "readonly" mode mentioned here:
>>>>> http://www.mjmwired.net/kernel/Documentation/md.txt
>>>>> upon read error, will it initiate a rebuild / degrade the array or not?
>> This is a good question but it is difficult to test as each use case is
>> different. That would be a question for Neil.
>> 
>>>>> 
>>>>> Anyway the "nodegrade" mode I suggest above would be still more useful 
>>>>> because you do not need to put the array in readonly mode, which is 
>>>>> important for doing backups during normal operation.
>>>>> 
>>>>> Coming back to my problem, I have thought that the best approach would 
>>>>> probably be to first collect information on how good are my 12 drives, 
>>>>> and I probably can do that by reading each device like
>>>>> dd if=/dev/sda of=/dev/null
>>>>> and see how many of them read with errors. I just hope my 3ware disk 
>>>>> controllers won't disconnect the whole drive upon read error.
>>>>> (anyone has a better strategy?)
>> I see where you're going here.  Read below but if you go this route I 
>> assume
>> you would first stop the array (?) mdadm -S /dev/mdX and then test each
>> individual disk one at a time?
>
> I don't plan to stop the array prior to reading the drives. Reads should not 
> be harmful...
> You think otherwise?
Depends on the drives, ever try to copy a file from a failing drive? Some
drives will start to click/reset/ATA errors, etc.  Depends on how it is
failing and what is wrong with it.

> I think I did read the drives in the past on a mounted array and it was no 
> problem.
Good to hear, let us know which option you choose & what the outcome is!

Justin.

