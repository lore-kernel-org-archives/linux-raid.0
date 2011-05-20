From: Gordon Henderson <gordon@drogon.net>
Subject: Re: why should I "initialize" JBOD disks?
Date: Fri, 20 May 2011 15:34:55 +0100 (BST)
Message-ID: <alpine.DEB.2.00.1105201532030.5319@unicorn.drogon.net>
References: <20110520133244.GA13330@apartia.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110520133244.GA13330@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 20 May 2011, Louis-David Mitterrand wrote:

> Hi,
>
> I just installed an Adaptec SAS 4805 and plugged 8 disks previously used
> "as is" (no raid) on an LSI adapter but none are recongnized as boot
> disk ("no bios installed").
>
> It seems I need to "initialize" (read: wipe) them in the Adaptec bios
> menu before being able to use them as JBOD.
>
> What the fuck?!
>
> By my defintion JBOD should means "just get out of the way and let me
> use my disks as they are".
>
> Does that "initlialization" mean that disks become unusable when plugged
> to an adapter of any other brand or model?
>
> What is the underlying format of JBOD disks. Can they be read by a
> straight, non-raid adapter?
>
> These hardware raid cards suck on so many levels...

Yup.

I don't know about that, but I had something similar with a Dell 
controller - I wanted a box of 15 x 500GB drives - but the only way to get 
it was to buy it with their PERC RAID controller cards, however I was 
assured that I didn't need to use the card RAID functions and I could use 
them "just as a box of disks" ...

It wasn't having it and in the end, I had to create 15 RAID-0 arrays of 
one disk each, which I could them assemble as a RAID-6 drive underLinux 
MD.

It worked fine, but would have been a PITA to anyone else changing a drive 
(fortunately it never broke in it's lifetime) but the down-side was that 
the controler hid all the SMART information from the host )-:

Bah!

Gordon
