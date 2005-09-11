From: Ric Wheeler <ric@emc.com>
Subject: Re: Accelerating Linux software raid
Date: Sun, 11 Sep 2005 08:00:54 -0400
Message-ID: <43241C76.4030900@emc.com>
References: <Pine.LNX.4.44.0509100927130.29141-100000@coffee.psychology.mcmaster.ca> <4323911D.8010307@emc.com> <20050911023518.GD10501@sam.triumf.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050911023518.GD10501@sam.triumf.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Konstantin Olchanski <olchansk@sam.triumf.ca>
Cc: Mark Hahn <hahn@physics.mcmaster.ca>, Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Konstantin Olchanski wrote:

>I am now confused. Is somebody trying to save power by adding an i/o
>coprocessor? (with it's own power overhead for memory, i/o, etc)
>
>To me it is simple:
>
>1) If you have an infinite power budget (big box), you might as well
>   let the main cpus do the raid stuff. If you are short on power (embedded),
>   you cannot afford to power an extra processor (+memory and stuff).
>
>2) If you have rich customers (big box), let them pay for a bigger
>   main cpu to do the raid, if you want to be cheap (embedded, appliance),
>   you cannot afford to plop an extra cpu (+support chips) on your custom pcb.
>  
>
The actual facts don't support this view since the gap in power 
consumption is huge. Most of these system on a chip designs provide the 
main CPU/northbridge/southbridge and extra execution units for a small 
fraction of one standard CPU.  Say under 20  watts for all of the above 
versus up to (over sometimes) 100 watts for a standard CPU (without its 
system chip sets).


