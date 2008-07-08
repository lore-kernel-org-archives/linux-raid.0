From: Gerhard Wiesinger <lists@wiesinger.com>
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
Date: Tue, 8 Jul 2008 08:59:54 +0200 (CEST)
Message-ID: <alpine.LFD.1.10.0807080857460.10532@bbs.intern>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan>
 <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
Sender: linux-ide-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Hello!

BTW:
The error in syslog also accoured when Reallocated_Sector_Ct didn't go up.

Ciao,
Gerhard

--
http://www.wiesinger.com/


On Tue, 8 Jul 2008, Gerhard Wiesinger wrote:

> On Mon, 7 Jul 2008, Justin Piszcz wrote:
>
>> Hi Gerhard,
>> 
>> It /could/ be the port itself if you have changed the cable and disk..
>> 
>
> Yes, but it is very unlikely. I have written TB of data there without any 
> problems. Anyway this is my 3rd exchanged SAMSUNG disk ...
>
>
>> Have you tried loading the disk with dd and seeing if you can reproduce the 
>> problem? You are getting the same error I get generally, I can recommend 
>> turning OFF NCQ first and see if the problem goes away.
>> 
>> # Define DISKS.
>> cd /sys/block
>> DISKS=$(/bin/ls -1d sd[a-z])
>> 
>> # Disable NCQ on all disks.
>> echo "Disabling NCQ on all disks..."
>> for i in $DISKS
>> do
>>  echo "Disabling NCQ on $i"
>>  echo 1 > /sys/block/"$i"/device/queue_depth
>> done
>> 
>
> I tried to disable NCQ on all disks and tried to rebuild the raid, but it 
> still failed to rebuild with the same error message.
>
> I also tried the nolapic kernel parameter without success.
>
> /dev/sda:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
> Always       -       0
> /dev/sdb:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
> Always       -       0
> /dev/sdc:  5 Reallocated_Sector_Ct   0x0033   091   091   010    Pre-fail 
> Always       -       413
> /dev/sdd:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
> Always       -       0
> /dev/sde:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
> Always       -       0
> /dev/sdf:  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
> Always       -       0
>
> The only thing is that the Reallocated_Sector_Ct is still >0 on /dev/sdc 
> (keep in mind this is my 3rd new Samsung disk on /dev/sdc and I had up to 
> 3000 Reallocated_Sector_Ct on previous disks in < 1 day !!!).
>
> Should I replace the disk a fourth time?
>
> When you search in google you find a lot of threads with the timeout problem. 
> Might this be a software issue?
>
