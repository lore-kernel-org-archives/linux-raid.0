From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Software RAID1 deadlock in 2.6.25 kernels
Date: Mon, 30 Jun 2008 09:56:51 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0806300955450.13171@p34.internal.lan>
References: <48650567.3000501@w1nr.net> <18533.20961.694041.556763@notabene.brown> <20080630092348.GJ17557@boogie.lpds.sztaki.hu> <4868C410.2060005@w1nr.net> <20080630115926.GA31564@ruf099.fkie.fgan.de> <4868E050.7090904@tmr.com> <4868E45F.30105@w1nr.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4868E45F.30105@w1nr.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mike McCarthy <mike@w1nr.net>
Cc: Bill Davidsen <davidsen@tmr.com>, Michael Bussmann <bus@mb-net.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 30 Jun 2008, Mike McCarthy wrote:

> Bill Davidsen wrote:
>> 
>> Wonder if hardware or software is happening, sounds like an mishandled 
>> hardware error, but I'm guessing. I have a server with RAID1 and Fedora 
>> 2.6.22.14-72.fc6PAE kernel, up 72 days, no problems.
>> 
>
> 2.6.22 is running fine.  The problems are in the 2.6.25 kernel (FC9 and SUSE 
> 11.0)
>
> Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I am running 2.6.25 and have run every 'fix' iteration to now currently 
2.6.25.9, I use RAID1 on two hosts and have not seen any issues on either.

That error looks HW related, you should run some heavy disk I/O processes 
for a few days / see if you can get it to re-occur on 2.6.22?

Or.. does it occur immedaitely after booting 2.6.25?

Justin.
