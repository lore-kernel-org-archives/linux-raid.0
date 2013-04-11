From: Phil Turmel <philip@turmel.org>
Subject: Re: multiple disk failures in an md raid6 array
Date: Thu, 11 Apr 2013 16:36:16 -0400
Message-ID: <51671EC0.9000707@turmel.org>
References: <1365607598.94859.YahooMailNeo@web161904.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1365607598.94859.YahooMailNeo@web161904.mail.bf1.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike VanHorn <mr_vanhorn@yahoo.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Mike,

On 04/10/2013 11:26 AM, Mike VanHorn wrote:
> For some reason, my replies to the linux-raid list aren't going
> through, and not all of the messages from the list seem to be
> getting to me, either, so I hope it is okay that I am replying
> to you directly.

It's ok, but I am adding the list back.

> Also, Microsoft's mail server from whence my message was
> originating has been blacklisted on your server, so I am
> sending this to you from my personal account on Yahoo!.

You really need to fix your server, then, or just use this yahoo
account for linux-raid.  My server just uses standard SPF validation
and common dns blacklists.

> In your reply, you said
> 
>> I recommend:
>>
>> 1) Fix timeouts as needed.  Either set your drives' ERC to 7.0
>> seconds, or raise the driver timeouts ~180 seconds.
> 
> As it turns out, the drives in question aren't ERC capable:
> 
> # smartctl -l scterc,70,70 /dev/sdc
> smartctl 5.42 2011-10-20 r3458 [x86_64-linux-2.6.18-308.13.1.el5] (local
> build)
> Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net
> <http://smartmontools.sourceforge.net/>
> 
> Warning: device does not support SCT Error Recovery Control command
> #
> 
> However, when I do the following
> 
> for x in /sys/block/sd[cdfghij] ; do echo $x: $(< $x/device/timeout) ;
> done>timeout.txt
> 
> I get output such as
> 
> /sys/block/sdj: 180
> 
> because it seems that I've previously discovered that they aren't ERC capable, as I'm setting the timeout in /etc/rc.local like so:
> 
> echo 180 >/sys/block/sdc/device/timeout
> echo 180 >/sys/block/sdd/device/timeout
> echo 180 >/sys/block/sde/device/timeout
> echo 180 >/sys/block/sdf/device/timeout
> echo 180 >/sys/block/sdg/device/timeout
> echo 180 >/sys/block/sdh/device/timeout
> echo 180 >/sys/block/sdi/device/timeout
> echo 180 >/sys/block/sdj/device/timeout
> 
> Doing this is what is meant by changing the driver's timeout, correct?

Yes.

> Should I be setting this for an even longer period of time?

No.

> Thank you for helping me to understand what is going on!

Are you already doing weekly scrubs and drive self-tests?

Do you still have the complete dmesg from the original triple
failure?

> Mike VanHorn
> Senior Computer Systems Administrator
> College of Engineering and Computer Science
> Wright State University
> 265 Russ Engineering Center
> 937-775-5157
> michael.vanhorn@wright.edu
> http://www.cecs.wright.edu/~mvanhorn/

Phil
