From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: 2.6.20: reproducible hard lockup with RAID-5 resync
Date: Sat, 17 Feb 2007 11:19:44 -0800
Message-ID: <45D75550.3090905@fatooh.org>
References: <45D55366.4010904@fatooh.org> <17877.25722.404051.470040@notabene.brown> <45D620D5.3060805@fatooh.org> <45D6DFB9.3090009@fatooh.org> <Pine.LNX.4.64.0702170613160.8145@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702170613160.8145@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
>> If anyone has any suggestions for further tests I can do, I'll be happy
>> to try them out.
>
> I noticed you are running a disk on /dev/hda, if this is an older mobo and 
> you use multiple PCI IDE controllers, if they are in certain slots, or you 
> put too many in, they can cause these problems, I have had a few mobos 
> that do it if the PCI cards are in a 'certain combination'-- I have had 
> this happen with an MSI and ABIT board.

I have a single Promise PCI IDE controller, but I don't have any hard
drives hooked up to it. /dev/hda and all the SATA drives are hooked up
to the onboard nVidia controllers.

My motherboard is a "DFI LanParty UT nf3 250Gb" (despite the unwieldy
name, it's a rather nice board) and I think it dates back to August
2004. I built my machine in November 2004, and I've never had an IDE or
SATA problem with it.

I started testing (and then using) my RAID-5 in May 2006 with Linux
2.6.16. I built the array degraded, so I know that resync worked for me
then. So did restriping, which I did twice. Since then, I've run 2.6.17
and 2.6.19, without any problems.

Thanks,
Corey
