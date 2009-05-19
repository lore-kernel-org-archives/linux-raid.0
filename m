From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: RCU detected CPU 1 stall (t=4295904002/751 jiffies) Pid: 902, comm: md1_raid5
Date: Tue, 19 May 2009 12:30:13 +0200
Message-ID: <154801c9d86c$cd8fc9f0$0400a8c0@dcccs>
References: <12a901c9d805$119fef20$0400a8c0@dcccs> <18962.1522.937784.126331@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Tuesday, May 19, 2009 3:05 AM
Subject: Re: RCU detected CPU 1 stall (t=4295904002/751 jiffies) Pid: 902, 
comm: md1_raid5


> On Tuesday May 19, janos.haar@netcenter.hu wrote:
>> Hello list, Neil,
>>
>> Somebody can say something about this issue?
>> I am not surprised, if it is hardware related, but this is on a brand new
>> server, so i am looking for a solution... :-)
>> May 17 23:12:13 gladiator-afth1 kernel: RCU detected CPU 1 stall
>> (t=4295904002/751 jiffies)
>
> I have no idea what this means.
> I've occasionally seen this sort of message in early boot then the
> system continued to work perfectly so I figured it was an early-boot
> glitch.  I suggest asking someone who understands RCU.
>
>>
>> The entire log is here:
>> http://download.netcenter.hu/bughunt/20090518/messages
>>
>> The system is on the md1, and working, but slowly.
>
> How slowly?  Is the slowness due to disk throughput?

No no, this is a fresh and idle server.
I have configured the disks, raid on another PC, and when it finished, i 
have copy up the known good, pre-installed sw pack with old 2.6.18.
This pack is good, tested on many times, and this reports too this issue on 
this machine. (first)
I have compiled the 2.6.28.10 on it, it takes about 6 hour! 8-/
But the 2.6.28.10 reports this too.

The slowness is not disk based, i think, on idle time if i move the selector 
line in mc, this stopps too for some seconds or i can't type in bash when 
this happens, and another one RCU message comes to the log...
(It happens periodically, independently of i am doing something or not.)

I am not sure, it is raid related or not, but the kernel reports only the 
md1_raid5 pid, not another one.
This is why i am asking here first.

Thanks anyway. :-)

> Have you tested the individual drives and compared that with the
> array?

This is a brand new hw, with 4x500GB samsung drive, wich reports no problem 
at all by smart.

>
>
>> If i left the server for 1 day,  it will crash without a saved log.
>
> This is a concern!  It usually points to some sort of hardware
> problem, but it is very hard to trace.
> Is the power supply rated high enough to support all devices?

I am using 550W good quality new PS, and the PC uses only 55-65W, measured. 
;-)
(1x core2duo, 4x hdd, nothing more interesting)

> I cannot think of anything else to suggest .. except start swapping
> components until the problem goes away...

In this way, i need to start with the motherboard. 8-(

Thanks a lot,
Janos Haar

>
> NeilBrown 

