From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Thu, 30 Mar 2006 08:02:07 -0800
Message-ID: <442C00FF.1010302@h3c.com>
References: <442BFB2B.6090903@stams.strath.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442BFB2B.6090903@stams.strath.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Thurlbeck <ian@stams.strath.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Addonics adst114 was the cheapest one I've found that works. I found it
for $41 at thenerds.net but you may be better at the price searching
than me.

It's a Silicon Images 3114 chip, driven by the sata_sil driver

I honestly don't recall if it was out-of-the-box working on FC4, but the
updated kernels drive it fine, and FC5 (with 2.6.16+) should be fine
with it.

-Mike

Ian Thurlbeck wrote:
> 
> Dear All
> 
> I have 4x500GB Maxtor SATA drives and I want to attach
> these to a 4-port SATA PCI card and RAID5 them using "md"
> 
> Could anybody recommend a card that will have out of
> box support on a Fedora system ?
> 
> Many thanks
> 
> Ian
