From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Thu, 19 May 2005 13:43:29 -0700
Message-ID: <428CFA71.6040202@h3c.com>
References: <428A09A3.9000802@heyjay.com> <428A81FB.1070201@home.se> <428CB19B.8010402@heyjay.com> <428CBB4A.8080900@h3c.com> <428CDD96.2070006@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428CDD96.2070006@heyjay.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jay Strauss <me@heyjay.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Jay Strauss wrote:

> Thanks for the reply Mike.  After some Googling and looking at my kernel
> config file,  it seems that SIS support is a module, like so:
> 
> CONFIG_BLK_DEV_SIS5513=m
> 
> I found this link but can't find any of the files that it references
> 
> http://kerneltrap.org/comment/reply/4925/129324

That message looks like the trick - the module doesn't have the right
PCI id for some reason, assuming you have the same chip

You may not have the kernel source, if you can't find the file with
locate. You'll need to fetch the kernel source first, then build a
custom kernel with that line changed.

This issue came up with my laptop when I first got it - a Dell Latitude
D800, it has an intel 5705M chipset that was supportable but had a new
PCI id and so didn't work. The custom kernel was a bit of a pain, but it
did work, and the patch made its way upstream really quickly. You can
help that along by posting it to linux-kernel even, most likely
(assuming it works)

If not, I will say that this is probably something that should be on
linux-ide at this point, as it really has nothing to do with raid
specifically other than this being a decent place to find folks trying
to help. The linux-ide folks will be closer to the code you're working
with so might be more capable

-Mike
