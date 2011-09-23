From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: potentially lost largeish raid5 array..
Date: Thu, 22 Sep 2011 23:10:28 -0600
Message-ID: <201109222310.28684.tfjellstrom@shaw.ca>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109222249.12892.tfjellstrom@shaw.ca> <20110923105834.71fc7c78@natsu>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110923105834.71fc7c78@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 22, 2011, Roman Mamedov wrote:
> On Thu, 22 Sep 2011 22:49:12 -0600
> 
> Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:
> > Now I guess the question is, how to get that last drive back in? would:
> > 
> > mdadm --re-add /dev/md1 /dev/sdi
> > 
> > work?
> 
> It should, or at least it will not harm anything, but keep in mind that
> simply trying to continue using the array (raid5 with a largeish member
> count) on a flaky controller card is akin to playing with fire.

Yeah, I think I won't be using the 3.0 kernel after tonight. At least the 
older kernel's would just lock up the card and not cause md to boot the disks 
one at a time.

I /really really/ wish the driver for this card was more stable, but you deal 
with what you've got (in my case a $100 2 port SAS/8 port SATA card). I've 
been rather lucky so far it seems, I hope my luck keeps up long enough for 
either the driver to stabilize, me to get a new card, or at the very least, to 
get a third drive for my backup array, so if the main array does go down, I 
have a recent daily sync.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
