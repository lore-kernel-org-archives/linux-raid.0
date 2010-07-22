From: Neil Brown <neilb@suse.de>
Subject: Re: Why is sb->size set to 0 with raid0?
Date: Thu, 22 Jul 2010 15:34:56 +1000
Message-ID: <20100722153456.04f751e7@notabene>
References: <slrni4e7bi.ced.Mario.Holbe@darkside.dyn.samba-tng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <slrni4e7bi.ced.Mario.Holbe@darkside.dyn.samba-tng.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 21 Jul 2010 18:16:46 +0200
Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:

> Hello,
> 
> while examining a raid0 v1.2 superblock I found "Used Dev Size" seems
> not to be set there, mdadm -E on a component device shows:
> 	          Magic : a92b4efc
> 	        Version : 1.2
> 	    Feature Map : 0x0
> 	...
> 	 Avail Dev Size : 2930274824 (1397.26 GiB 1500.30 GB)
> 	  Used Dev Size : 0
> 	    Data Offset : 16 sectors
> 	   Super Offset : 8 sectors
> 	          State : clean
> 
> Is this intentional?
> This is just to let you know and for my curiosity. I don't know whether
> this has negative side-effects or not. I found none until now.
> 
> Don't get me wrong, I like the (IMHO positive) side-effect of this: it
> makes totally sense to me, not to reserve bitmap-space for raid0 - I
> even downgraded to mdadm 3.1.1 for raid creation to get rid of the 1M
> alignment, and I was short thinking about patching super1.c for this
> array to get rid of the bitmap-space reservation as well.
> Thus, I was just positively surprised to see that in fact there *is* no
> bitmap-space reserved for raid0, wondered how and where this was
> managed, and tracked it down to sb->size being set to 0.
> 

The 'Used Dev Size' is the amount of each device that is used in the array.
For RAID0 (and linear), there is no such number.  The devices can be of
different sizes and in each case "all" of the available space is used.
So in this case '0' means 'all'.  I should probably just remove the number
as it doesn't mean anything.

This has nothing to do with the bitmap.  Space reserved for the bitmap is
out side of the 'Avail Dev Size'.

NeilBrown
