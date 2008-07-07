From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Mon, 07 Jul 2008 12:07:54 -0400
Message-ID: <48723F5A.4060301@tmr.com>
References: <48650567.3000501@w1nr.net> <18533.20961.694041.556763@notabene.brown> <20080630092348.GJ17557@boogie.lpds.sztaki.hu> <4868C410.2060005@w1nr.net> <20080630115926.GA31564@ruf099.fkie.fgan.de> <4868E050.7090904@tmr.com> <4868E45F.30105@w1nr.net> <486A4E7B.50604@tmr.com> <486A6291.20207@w1nr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <486A6291.20207@w1nr.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mike McCarthy <mike@w1nr.net>
Cc: Michael Bussmann <bus@mb-net.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike McCarthy wrote:
> Bill Davidsen wrote:
>>
>> Given heavy 2.6.25 use, my guess is still that the root cause of this 
>> is hardware, and that the change in disk code either triggers the 
>> hardware problem, or handles it differently. Are you by any chance 
>> running NCQ on your system?
>>
> No.  This system and the drives pre-date NCQ.  I think NCQ is only 
> implemented in SATA and these are IDE drives.  Sometime over the 
> weekend, I am going to reload SUSE 11 and try to do some more debugging.
>
> BTW: It's back to 10.3 (kernel 2.6.22) running happily with a VMware 
> server thrashing away at the disks.

This has recycled back to the top of my todo list, I have a server in 
mothballs with IDE drives, I'll pull it out, upgrade to FC9 current 
(non-rawhide) and see if I have any problems. It's off due to lack of 
need, not really obsolete, so it's a fair test. O'll put a dew hundred 
GB of raid-1 and beat on it.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


