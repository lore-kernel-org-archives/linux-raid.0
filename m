From: Mike McCarthy <mike@w1nr.net>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Mon, 30 Jun 2008 07:31:28 -0400
Message-ID: <4868C410.2060005@w1nr.net>
References: <48650567.3000501@w1nr.net> <18533.20961.694041.556763@notabene.brown> <20080630092348.GJ17557@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080630092348.GJ17557@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gabor Gombas wrote:
> On Sat, Jun 28, 2008 at 06:47:29AM +1000, Neil Brown wrote:
>
>   
>>>    System locks up after running a short time.  Had it hang once during 
>>> installation.  Tried both Reiserfs and EXT3.
>>>       
>> We need more details about the lockup.  Does the whole system lock up,
>> or just the array.
>> Can  you get
>>    alt-sysrq-T
>> output?  That might be useful.
>>     
>
> Also, try to set up netconsole and boot with nmi_watchdog=2. I've now 3
> completely different HW setups where 2.6.25 hangs due to HPET issues.
>
> Gabor
>
>   
Due to time constraints, I will be unable to do much on this until the 
weekend.

In the meantime, a more detailed description of the symptoms:

When the system hangs, the mouse movement is tracked across the screen 
and I can ping the node. There is no response to clicking on a mouse 
button or trying to type anything into a field. It also does not respond 
to ssh or to <CTRL><ALT><F1>.

I may also try and reproduce it on different hardware to rule out a 
graphics problem if you wish.

Mike

