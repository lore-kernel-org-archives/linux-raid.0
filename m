From: Brad Campbell <brad@wasp.net.au>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Sat, 10 Jul 2010 12:42:26 +0800
Message-ID: <4C37FA32.8020008@wasp.net.au>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se> <87wrt7ijp3.fsf@rimspace.net> <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se> <4C35A2FC.5080402@buttersideup.com> <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se> <20100708104422.GA32564@cthulhu.home.robinhill.me.uk> <alpine.DEB.1.10.1007081259560.23489@uplift.swm.pp.se> <20100708232631.014a5ade@atak.bl.pg.gda.pl> <alpine.DEB.1.10.1007082348190.23489@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1007082348190.23489@uplift.swm.pp.se>
Sender: linux-ide-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On 09/07/10 05:53, Mikael Abrahamsson wrote:

> I never really had a huge problem figuring out with high probability
> which drive it was, but I wanted to know if there was a 100% certain way
> of doing it. Seems there is not, am I the only one who is looking for
> this functionality? I would think this is a fairly common problem?

Certainty would be nice, but in practice here I've always found that ataX = sdX+1 and I've relied on 
that mapping to always be constant. I've not yet found it otherwise, but I guess it's possible. I'd 
assume the libata guys should be able to provide a definite comment on that.

I've got no lights on my arrays, so it's even harder to identify which drive is which when you need 
to swap one out live. I've resorted to keeping a log of which serial number is in which physical 
slot, so I can look up the serial number of the failing drive with hdparm and I know I've got the 
right one. Again, it still hinges on the ata-sd mapping being constant. (it also relies on me 
updating the log when I swap a disk)

Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
