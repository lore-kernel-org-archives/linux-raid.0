From: Max Eaves <max@maxeaves.co.uk>
Subject: Re: Problems with RAID 6 across 15 disks
Date: Thu, 01 Apr 2010 15:07:27 +0100
Message-ID: <4BB4A89F.7030707@maxeaves.co.uk>
References: <4BB49E4D.1090809@maxeaves.co.uk> <4BB4A461.5030704@redhat.com>
Reply-To: max@maxeaves.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB4A461.5030704@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

Doug,

Thank you very much for that; a great relief off my shoulders.

You are right - there is a config file located in 
/etc/sysconfig/raid-check.  I've changed ENABLED to no.

Amazing - I've learnt something today.

Thanks once again.

Max

On 01/04/10 14:49, Doug Ledford wrote:
> On 04/01/2010 09:23 AM, Max Eaves wrote:
>    
>> Hi there,
>>
>> I hope this gets through....my first posting on this dist.list.
>>
>> I am running Centos 5.4 with a 2.6.18-164.15.1.el5 kernel (x86_64)
>> kernel using a rather "homebrew" backblaze system
>> (http://blog.backblaze.com/) system.
>>
>> The mdadm version is: mdadm - v2.6.9 - 10th March 2009
>>
>> It uses a number of Silicon Image 3124 (sIL 3124) cards and a number of
>> multiplier port cards (sIL3132) to read a large number of disks.
>>
>> I have 45 disks arranged into 3 mdadm raid sets of 15 disks.  These 15
>> disks are raided using RAID6.
>>
>> The problem I have is this:
>>
>> At random times, the RAID decides that it needs to resynchronise
>> /dev/md10 /dev/md11 and /dev/md12.  There is no error or log event in
>> /var/log/messages, but the first thing I notice is that the performance
>> of the RAID array drops, and checking out "cat /proc/mdadm" shows all
>> three RAID re synchronising themselves.
>>
>> ARRAY /dev/md0 level=raid1 num-devices=2
>> uuid=7d7b19e6:56cc90cc:3cb166bd:b8086f29 (system boot) (not a problem)
>> ARRAY /dev/md1 level=raid1 num-devices=2
>> uuid=3782d93d:a491ffd4:f32c1014:94a2b3f7 (system LVM) (not a problem)
>> ARRAY /dev/md10 level=raid6 num-devices=15
>> uuid=5ca86e2a-3b86-4c0b-9a7a-59143bdcd0f1 (partition 1) (problem)
>> ARRAY /dev/md11 level=raid6 num-devices=15
>> uuid=61188c90-4825-44c5-8fac-9bc82a5799fe (partition 2) (problem)
>> ARRAY /dev/md12 level=raid6 num-devices=15
>> uuid=fa939816-1d0f-4eaa-98dd-c131449c3921 (partition 3) (problem)
>>
>> These re-synchronisation events take about a week to complete (the RAID
>> is 18TB a pop)
>>
>> I know that the performance of this system is not great, but I wonder if
>> this resynchronisation is occurring because of some I/O time-out.
>>
>> Oddly enough, a restart of the server fixes the problem for a couple of
>> days, and then problem occurs again (humm - not good).
>>
>> I'm happy to post logs etc....just let me know what you need.
>>      
> Disable /etc/cron.weekly/99-raid-check.  They aren't resyncronizing,
> they are actually just checking themselves for consistency, but because
> the 2.6.18 kernel didn't have a different word for it in the output of
> /proc/mdstat it just looks that way.  I can't remember if the version of
> mdadm in centos 5.4 has the /etc/sysconfig/raid-check config file, but
> if it does, it's easy to disable the weekly check there.
>
>
>    

