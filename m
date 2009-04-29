From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 12:00:25 +1200
Message-ID: <1240963225.18303.858.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain>	<49F68CE0.2010906@zytor.com>
	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	 <1240957153.18303.689.camel@ezra>
	 <18935.35747.471257.202356@notabene.brown>  <49F78F26.2040909@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49F78F26.2040909@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2009-04-28 at 16:20 -0700, H. Peter Anvin wrote:
> Neil Brown wrote:
> > 
> > That only leaves the question of what happens when a spare is added to
> > the array - how does the grub data get written to the space on the
> > spare.
> > I would rather that grub were responsible for this, than for md to
> > treat that unused space as RAID1.
> > We already have a notification system based on "mdadm --monitor" to
> > process events.  We could possibly plug grub in to that somehow so
> > that it gets told to re-write all it's special blocks every time
> > something significant changes in the array.
> > 
> 
> I have multiple issues with this concept (including promoting Grub2, but
> let's not get into that.)
> 
It could be a call to a generic interface for reinstalling the
bootloader.  It's not intended to be grub specific, it just so happens
that grub2 is the closest to having a working boot from software raid
implementation.

> For this to be reliable, there is only one sensible configuration, which
> is for /boot to be a RAID-1, which is better handled by -- guess what --
> partitioning systems; and we already have quite a few of those that work
> just fine, thank you.  Otherwise there WILL be configurations -- caused
> by controller failures if nothing else -- that simply will not boot even
> though the system is otherwise functional.  Promoting this kind of stuff
> is criminally stupid.

I disagree.  Grub is quite capable of booting from and assembling a
raid5 volume and accessing it's partitions contents, even if the array
is degraded.  All I'm asking for is that the first 64 kbytes of the disk
be reserved and some of it possibly (but not necessarily) replicated so
that a bootloader capable of assembling a raid array can be installed on
the start of each member disk so that whatever disk the bios decides to
boot from, it will always boot.
 
-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

