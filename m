From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: raid5:md3: kernel BUG , followed by , Silent halt .
Date: Wed, 5 Sep 2007 21:45:57 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0709052144120.28118@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
 <Pine.LNX.4.64.0708181328510.14169@filesrv1.baby-dragons.com>
 <e9c3a7c20708201029l15e37d8eh9db6714be6a8e7b8@mail.gmail.com>
 <Pine.LNX.4.64.0708251903200.6971@filesrv1.baby-dragons.com>
 <e9c3a7c20708271511w239fa643q1d1745ed0d552eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20708271511w239fa643q1d1745ed0d552eb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Dan ,
On Mon, 27 Aug 2007, Dan Williams wrote:
> On 8/25/07, Mr. James W. Laferriere <babydr@baby-dragons.com> wrote:
>> On Mon, 20 Aug 2007, Dan Williams wrote:
>>> On 8/18/07, Mr. James W. Laferriere <babydr@baby-dragons.com> wrote:
>>>>         Hello All ,  Here we go again .  Again attempting to do bonnie++ testing
>>>> on a small array .
>>>>         Kernel 2.6.22.1
>>>>         Patches involved ,
>>>>         IOP1 ,  2.6.22.1-iop1 for improved sequential write performance
>>>> (stripe-queue) ,  Dan Williams <dan.j.williams@intel.com>
>>>
>>> Hello James,
>>>
>>> Thanks for the report.
>>>
>>> I tried to reproduce this on my system, no luck.
>>         Possibly because there is significant hardware differances ?
>>         See 'lspci -v' below .sig .
>>
>>> However it looks
>>> like their is a potential race between 'handle_queue' and
>>> 'add_queue_bio'.  The attached patch moves these critical sections
>>> under spin_lock(&sq->lock), and adds some debugging output if this BUG
>>> triggers.  It also includes a fix for retry_aligned_read which is
>>> unrelated to this debug.
>>> --
>>> Dan
>>         Applied your patch .  The same 'kernel BUG at drivers/md/raid5.c:3689!'
>> messages appear (see attached) .  The system is still responsive with your
>> patch ,  the kernel crashed last time .  Tho the bonnie++ run is stuck in 'D' .
>> And doing a '> /md3/asdf'  stays hung even after passing the parent process a
>> 'kill -9' .
>>         Any further info You can think of I can/should ,  I will try to acquire
>> .  But I'll have to repeat these steps to attempt to get the same results .
>> I'll be shutting the system down after sending this off .
>>         Fyi ,  the previous 'BUG" without your patch was quite repeatable .
>>         I might have time over the next couple of weeks to be able to see if it
>> is as repatable as the last one .
>>
>>         Contents of /proc/mdstat for md3 .
>>
>> md3 : active raid6 sdx1[3] sdw1[2] sdv1[1] sdu1[0] sdt1[7](S) sds1[6] sdr1[5] sdq1[4]
>>        717378560 blocks level 6, 1024k chunk, algorithm 2 [7/7] [UUUUUUU]
>>        bitmap: 2/137 pages [8KB], 512KB chunk
>>
>>         Commands I ran that lead to the 'BUG' .
>>
>> bonniemd3() { /root/bonnie++-1.03a/bonnie++  -u0:0  -d /md3  -s 131072  -f; }
>> bonniemd3 > 131072MB-bonnie++-run-md3-xfs.log-20070825 2>&1 &
>>
> Ok, the 'bitmap' and 'raid6' details were the missing pieces of my
> testing.  I can now reproduce this bug in handle_queue.  I'll keep you
> posted on what I find.
>
> Thank you for tracking this.
> Regards,

 	You said to watch here & I have .
 	Is there any hope of digging this out ?
 	Anything further I can provide ?  Please just say so .
 		Tia ,  JimL
