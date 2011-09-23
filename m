From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: potentially lost largeish raid5 array..
Date: Fri, 23 Sep 2011 01:37:04 -0600
Message-ID: <201109230137.04843.thomas@fjellstrom.ca>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109222310.28684.tfjellstrom@shaw.ca> <j5hbc3$rh4$1@dough.gmane.org>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j5hbc3$rh4$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 23, 2011, David Brown wrote:
> On 23/09/2011 07:10, Thomas Fjellstrom wrote:
> > On September 22, 2011, Roman Mamedov wrote:
> >> On Thu, 22 Sep 2011 22:49:12 -0600
> >> 
> >> Thomas Fjellstrom<tfjellstrom@shaw.ca>  wrote:
> >>> Now I guess the question is, how to get that last drive back in? would:
> >>> 
> >>> mdadm --re-add /dev/md1 /dev/sdi
> >>> 
> >>> work?
> >> 
> >> It should, or at least it will not harm anything, but keep in mind that
> >> simply trying to continue using the array (raid5 with a largeish member
> >> count) on a flaky controller card is akin to playing with fire.
> > 
> > Yeah, I think I won't be using the 3.0 kernel after tonight. At least the
> > older kernel's would just lock up the card and not cause md to boot the
> > disks one at a time.
> > 
> > I /really really/ wish the driver for this card was more stable, but you
> > deal with what you've got (in my case a $100 2 port SAS/8 port SATA
> > card). I've been rather lucky so far it seems, I hope my luck keeps up
> > long enough for either the driver to stabilize, me to get a new card, or
> > at the very least, to get a third drive for my backup array, so if the
> > main array does go down, I have a recent daily sync.
> 
> My own (limited) experience with SAS is that you /don't/ get what you
> pay for.  I had a SAS drive on a server (actually a firewall) as the
> server salesman had persuaded me that it was more reliable than SATA,
> and therefore a good choice for a critical machine.  The SAS controller
> card died recently.  I replaced it with two SATA drives connected
> directly to the motherboard, with md raid - much more reliable and much
> cheaper (and faster too).

Well the driver for this card is known to be rather dodgy, especially with 
SATA disks. At one point it was panicking on SATA hotplug, would randomly kick 
one or more drives, the entire card would randomly lock up, and there were 
random long'ish pauses during access. It's a heck of a lot better now than it 
was 2 years ago. Except that those problems never caused the array to fall 
apart like it did today. I guess since the card /didn't/ lock up, md was able 
to notice that the drives were gone, and subsequently failed the disks.

I am worried about sdi though. the bay light on it is flickering a bit, and I 
think its the only one thats been kicked out lately (other than tonight). 
Maybe it is causing the card to behave worse than it would if nothing else was 
bad. Usually though, the card would lock up after the first boot, so a reboot 
was needed to get the card back in shape, then the array would resync (if 
needed), and the bitmap would make the resync only take a few minutes (20m the 
last time I think).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
