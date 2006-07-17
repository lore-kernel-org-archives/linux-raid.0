From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Test feedback 2.6.17.4+libata-tj-stable (EH, hotplug)
Date: Mon, 17 Jul 2006 14:08:17 -0400
Message-ID: <44BBD211.9030501@tmr.com>
References: <bb145bd20607101439n475b1771g1c754af31911288@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <bb145bd20607101439n475b1771g1c754af31911288@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christian Pernegger wrote:

> I finally got around to testing 2.6.17.4 with libata-tj-stable-20060710.
>
> Hardware: ICH7R in ahci mode + WD5000YS's.
>
> EH: much, much better. Before the patch it seemed like errors were
> only printed to dmesg but never handed up to any layer above. Now md
> actually fails the disk when I pull the (power) plug. I'll try my bad
> cable once I can find it.
>
> Hotplug: Unplugging was fine, took about 15s until the driver gave up
> on the disk. After re-plugging the driver had to hard-reset the port
> once to get the disk back, though that might be by design.
>
> The fact that the disk had changed minor numbers after it was plugged
> back in bugs me a bit. (was sdc before, sde after). Additionally udev
> removed the sdc device file, so I had to manually recreate it to be
> able to remove the 'faulty' disk from its md array.
>
> Thanks for a great patch! I just hope it doesn't eat my data :) 

And thank you for testing!

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

