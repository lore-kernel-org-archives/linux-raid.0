From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH*2] mdadm works with uClibc from SVN
Date: Fri, 23 Jun 2006 18:12:52 +1000
Message-ID: <17563.41604.667253.877348@cse.unsw.edu.au>
References: <87wtbbjxd4.fsf@hades.wkstn.nix>
	<871wtgl419.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nix on Friday June 23
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 23, nix@esperi.org.uk wrote:
> On 20 Jun 2006, nix@esperi.org.uk prattled cheerily:
> > For some time, mdadm's been dumping core on me in my uClibc-built
> > initramfs. As you might imagine this is somewhat frustrating, not least
> > since my root filesystem's in LVM on RAID. Half an hour ago I got around
> > to debugging this.
> 
> Ping?

No, but I do know someone by that name.....

Yeh, it's on my todo list. 
I suspect I would rather make mdadm not dump core of ftw isn't
available.
Is there some #define in an include file which will allow me to tell
if the current uclibc supports ftw or not?

NeilBrown

(and I'm more like to reply to mail if it the "To" or "Cc" line
 mentions me specifically - it's less likely to get lost that way).
