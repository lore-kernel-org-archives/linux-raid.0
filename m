From: Michael Bussmann <bus@mb-net.net>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Tue, 1 Jul 2008 21:45:08 +0200
Message-ID: <20080701194508.GB6177@astaroth.intranet.mb-net.net>
References: <48650567.3000501@w1nr.net> <18533.20961.694041.556763@notabene.brown> <20080630092348.GJ17557@boogie.lpds.sztaki.hu> <4868C410.2060005@w1nr.net> <20080630115926.GA31564@ruf099.fkie.fgan.de> <4868E050.7090904@tmr.com> <4868E45F.30105@w1nr.net> <486A4E7B.50604@tmr.com> <486A6291.20207@w1nr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <486A6291.20207@w1nr.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On 2008-07-01 13:00:01 -0400, Mike McCarthy wrote:
> Bill Davidsen wrote:
>> Mike McCarthy wrote:
>>> Bill Davidsen wrote:
>>>>
>>>> Wonder if hardware or software is happening, sounds like an  
>>>> mishandled hardware error, but I'm guessing. I have a server with  
>>>> RAID1 and Fedora 2.6.22.14-72.fc6PAE kernel, up 72 days, no 
>>>> problems.

I have a number of 2.6.25.7-9 machines with SW-RAID1 that are running
flawlessly so far.

>> Given heavy 2.6.25 use, my guess is still that the root cause of this  
>> is hardware, and that the change in disk code either triggers the  
>> hardware problem, or handles it differently. Are you by any chance  
>> running NCQ on your system?
>>
> No.  This system and the drives pre-date NCQ.  I think NCQ is only  

Same here.  In my case the lockups are totally random and not related to
heavy disc i/o.  Actually most lockups occur when the system was quite idle.

So far I tried
	- Replaced IDE cables
	- kernel upgrades up to 2.6.25.9
	- removed one drive from the RAID, thus running in degraded mode
	- disabled CPU frequency scaling
	- put one drive on the PDC20276, the other on the ICH4 (82801DB)

Maybe my hardware _is_ broken, but I'll try some other settings anyway
(including using RTC again for ztdummy instead of HPET, disabling NOHZ etc).

Cheers,
MB

-- 
Michael Bussmann <bus@mb-net.net>
