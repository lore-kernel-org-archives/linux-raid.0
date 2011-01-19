From: Cory Coager <ccoager@gmail.com>
Subject: Re: support for external persistent cache
Date: Tue, 18 Jan 2011 22:34:58 -0500
Message-ID: <4D365BE2.9020300@gmail.com>
References: <4D365551.7090207@gmail.com>	<AANLkTimTnaHEA0+==hs7Ew0Zzvdr1EOtxEqH=EfgdN-7@mail.gmail.com> <AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim3BJVbHdtByAni2ObUf0Qjece9jkd1_MSkT56P@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/18/2011 10:17 PM, Roberto Spadim wrote:
> reading again... should you use a good ups system with information
> about % of batery, like a notebook?
> read/write cache can be change with async or sync options on filesystem mount
> batery support is done with ups system
> maybe with some time of use (10 years) the baterry of you ramdisk
> should be replaced, will you replace it? is easier replace a ups
> batery or a ramdisk specific batery?
> check at internet about 12vdc atx power supply, and use a charger and
> a car batery to supply power to your computer, it's a very nice
> solution =)
Sure, I'll replace the battery in the ram disk.  Not much different than 
a hardware raid card with a battery in it.

I think you're missing my point.  A UPS isn't going to save your file 
system if the machine dies mid-write.

