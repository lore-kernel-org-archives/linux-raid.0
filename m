From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Best way to achieve large, expandable, cheap storage?
Date: Mon, 03 Oct 2005 13:19:17 +1000
Message-ID: <4340A335.7070502@nighthawkrad.net>
References: <dhje16$tmq$1@sea.gmane.org> <433F63BB.3020008@nighthawkrad.net> <433F8792.6040106@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <433F8792.6040106@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tyler wrote:
> What case and power supply(s)are you using?  What raid cards are you 
> using also?

The case is a no-name job I picked up from a local PC seller:

http://www.pcicase.com.au/sub_files01.htm

It's main attraction to me was the large number of 5.25" drive bays.

The PSU is just a bog-standard 450W Antec (although since I've recently 
ugpraded the machine to dual Xeons, I should get a beefier unit).

Currently the machine has 2xPromise S150 TX4.  Previously, as the 120GB 
drives were PATA, it also had a Promise TX4000.  However, since that 
card wouldn't work with a 2.6 kernel, I used it as an excuse to get more 
drives and upgrade to a newer distro :).  The TX4s are 32 bit, 66Mhz PCI 
cards and are in 64/133Mhz PCI-X slots, so they handle four 7200rpm SATA 
drives each quite well.  I toyed with getting a single 8 port SATA card, 
but all the ones I've seen are full-blown hardware RAID, making them 
quite expensive and since I use software RAID and have 5 PCI-X slots on 
the motherboard, not worth it.  I'll run out of physical space in the 
case before I run out of PCI-X slots to drop 4-port cards into.

CS
