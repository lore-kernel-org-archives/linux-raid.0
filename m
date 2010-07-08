From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mapping ataXX.YY to a /dev/sdX
Date: Thu, 8 Jul 2010 23:53:51 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1007082348190.23489@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1007070810540.23489@uplift.swm.pp.se> <87wrt7ijp3.fsf@rimspace.net> <alpine.DEB.1.10.1007071749320.23489@uplift.swm.pp.se> <4C35A2FC.5080402@buttersideup.com> <alpine.DEB.1.10.1007081214590.23489@uplift.swm.pp.se>
 <20100708104422.GA32564@cthulhu.home.robinhill.me.uk> <alpine.DEB.1.10.1007081259560.23489@uplift.swm.pp.se> <20100708232631.014a5ade@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100708232631.014a5ade@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 8 Jul 2010, Janek Kozicki wrote:

> could you make some trial and error tests, while staying safe?
>
> turn off the array. Shut down. Unplug sdj, boot up. See if it is sdj
> that disappeared, but do not assemble the array (so that it won't get
> corrupted).

I used smartctl to check that sdj indeed had bad sectors and just failed 
it from the array and then lit it up by dd:ing from it, checked what drive 
it was, and replaced it. When I unplugged it and put in another drive it 
was indeed ata14.

I never really had a huge problem figuring out with high probability which 
drive it was, but I wanted to know if there was a 100% certain way of 
doing it. Seems there is not, am I the only one who is looking for this 
functionality? I would think this is a fairly common problem?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
