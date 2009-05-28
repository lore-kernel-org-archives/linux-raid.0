From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: forcing check of RAID1 arrays causes lockup
Date: Thu, 28 May 2009 18:25:35 -0500
Message-ID: <4A1F1D6F.2000205@gmail.com>
References: <20090526234523.GB14974@foobox.homelinux.net>	 <4A1C986A.7040403@gmail.com>  <20090528091726.GA8067@athlon> <1243514523.5740.90.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243514523.5740.90.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: Kyle Liddell <kyle@foobox.homelinux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Redeeman wrote:
> On Thu, 2009-05-28 at 05:17 -0400, Kyle Liddell wrote:
>> On Tue, May 26, 2009 at 08:33:30PM -0500, Roger Heflin wrote:
>>> Not what you are going to want to hear but badly designed hardware.
>>>
>>> On a machine I had with 4 disks (2 on a build-in via, 2 on other 
>>> ports--either a built-in promise, or a sil pci card), when the 2 
>>> build-in via sata ports got used heavily at the same times as any 
>> ...
>>>    It appeared to me as designed the via chipsets (And think your 
>>> chipset is pretty close to the one I was using) did not appear to deal 
>>> with with high levels of traffic to several devices at once, and would 
>>> become unstable.
>>>
>>> Once I figured out the issue, I could duplicate it in under 5 minutes, 
>>> and the only working solution was to not use the via ports.
>>>
>>> My mb at the time was a Asus k8v se deluxe with a K8T800 chipset, and 
>>> so long as it was not heavily used it was stable, but under heavy use 
>>> it was junk.
>> That does sound like my problem, and the hardware is similar.  However, I don't think it's the VIA controller that's the problem here:  I moved the two drives off the on-board VIA controller and placed them as slaves on the Promise card.  I was able to install fedora, which was an improvement, but once installed, I was able to bring the system down again by forcing a check.  I've got a spare Promise IDE controller, so I tried swapping it out, with no change.
>>
>> I suppose it's a weird hardware bug, although it still is strange that certain combinations of kernels (which makes a little sense) + distributions (which makes no sense) will work.  I just went back to debian on the machine, and it works fine.  
>>
>> I'm trying to reproduce the problem on another machine, but I'm not too hopeful.
> 
> I have a system with 6 drives in raid5, on such a k8v se deluxe board
> with the via controller, and an additional PCI controller.
> 
> I am experiencing some weird problems on this system too, when doing
> lots of read/write it will freeze for up to 10 seconds sometimes, what
> happens is that one of the disks gets the bus soft reset.
> 
> Now with the old IDE driver, this would f*** up completely, and the box
> had to be rebooted, however, libata was able to recover it nicely and
> just continue after the freeze.

With the sata via's and sata_via under heavy enough loads it was not 
recovering.   Under lighter loads it did get some odd errors that were 
not fatal.

> 
> I was never able to solve the issue, and since  it wasnt a major problem
> for the use, i have just ignored it.

On mine until I tried it full rebuild (after a crash) it was not an 
issue, with 2 on the via, and 2 either on the promise or a sil pci 
card it crashed quickly under a rebuild, the machine had been mostly 
stable (a few odd things happened) for a couple of months, after 
moving away from the via ports the few odd things quit happening, so I 
believe the odd behavior (video capture cards appearing to lose parts 
of their video data, video capture cards locking up internally-note 2 
completely different pci card designs/chipsets were both doing funny 
things).

> 
> do you suppose adding another pci card with IDE ports and discontinuing
> use of the via controller entirely would fix it?

On mine moving everything off of the sata_via ports make things slower 
but stable (the via pata/sata ports are on pci66x32bit vs. the pci bus 
sharing a single pci33x32bit bus), so in the first setup 
(2via/2pcibus) the slowest disk's share of bandwidth is in theory 
66mb/second, on the second case (4pcibus) each disk's share of 
bandwidth is in theory 33mb/second, and I could see a large difference 
in the raid5 read/writes in one case vs the other, but the faster case 
was unstable so useless.

> 
> though, i have actually just replaced this box with a newer, so it wont
> do me much good now, however, the small amount of money a pci ide
> controller costs, would be worth it just to actually find out what was
> wrong.
>

I have since replaced mine (it is no longer a server needing more than 
  1 drive) so mine is not longer causing issues.
