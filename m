From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: PROBLEM: raid5 hangs
Date: Wed, 14 Nov 2007 18:59:02 -0500
Message-ID: <473B8BC6.4070109@tmr.com>
References: <Pine.LNX.4.64.0711140607160.16327@sysbabe.flashdance.cx> <Pine.LNX.4.64.0711140407190.22735@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711140407190.22735@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Peter Magnusson <iocc@linux-raid.lists.flashdance.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> This is a known bug in 2.6.23 and should be fixed in 2.6.23.2 if the 
> RAID5 bio* patches are applied.

Note below he's running 2.6.22.3 which doesn't have the bug unless 
-STABLE added it. So should not really be in 2.6.22.anything. I assume 
you're talking the endless write or bio issue?
>
> Justin.
>
> On Wed, 14 Nov 2007, Peter Magnusson wrote:
>
>> Hey.
>>
>> [1.] One line summary of the problem:
>>
>> raid5 hangs and use 100% cpu
>>
>> [2.] Full description of the problem/report:
>>
>> I have used 2.6.18 for 284 days or something until my powersupply 
>> died, no problem what so ever duing that time. After that forced 
>> reboot I did these changes; Put in 2 GB more memory so I have 3 GB 
>> instead of 1 GB, two disks in the raid5 got badblocks so I didnt 
>> trust them anymore so I bought new disks (I managed to save the 
>> raid5). I have 6x300 GB in a raid5. Two of them are now 320 GB so 
>> created a small raid1 also. That raid5 is encrypted with 
>> aes-cbc-plain. The raid1 is encrypted with aes-cbc-essiv:sha256.
>>
>> I compiled linux-2.6.22.3 and started to use that. I used the same 
>> .config
>> as in default FC5, I think i just selected P4 cpu and preemptive 
>> kernel type.
>>
>> After 11 or 12 days the computer froze, I wasnt home when it happend and
>> couldnt fix it for like 3 days. It was just to reboot it as it wasnt 
>> possible to login remotely or on console. It did respond to ping 
>> however.
>> After reboot it rebuilded the raid5.
>>
>> Then it happend again after approx the same time, 11 or 12 days. I 
>> noticed
>> that the process md1_raid5 used 100% cpu all the time. After reboot it
>> rebuilded the raid5.
>>
>> I compiled linux-2.6.23.
>>
>> And then... it happend again... After about the same time as before.
>> md1_raid5 used 100% cpu. I also noticed that I wasnt able to save
>> anything in my homedir, it froze during save. I could read from it 
>> however. My homedir isnt on raid5 but its encrypted. Its not on any 
>> disk that has to do with raid. This problem didnt happend when I used 
>> 2.6.18. Currently I use 2.6.18 as I kinda need the computer stable.
>> After reboot it rebuilded the raid5.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

