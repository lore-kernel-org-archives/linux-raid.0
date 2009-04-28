From: Daniel Reurich <daniel@centurion.net.nz>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 11:41:59 +1200
Message-ID: <1240962119.18303.826.camel@ezra>
References: <1240574900.4507.2076.camel@ezra>
	 <87hc0axhg9.fsf@frosties.localdomain> <49F68CE0.2010906@zytor.com>
	 <e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	 <1240957153.18303.689.camel@ezra>
	 <18935.35747.471257.202356@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18935.35747.471257.202356@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 
> v1.x metadata has explicit knowledge of where the start of the data
> is, so it is quite possible to leave the first few (dozen) sectors
> unused (let's not talk about cylinders this century - OK?).
> So mdadm could grow a --grub flag to use with --create which arranged
> for data/bitmap to not use the first (say) 512 sectors of any device.
> (1.1 and 1.2 would still use reserved blocks for the superblock).
> [I can cut you a patch to experiment with if you like]

That would be nice.  The 1.1 superblock is no good as the bootsector
goes in the same place, and 1.2 is where I expect grub would be writing
data too.  I'll check this though.  Grub still needs patching to
understand v1.X superblocks, so that could include blacklisting the
location of a v1.2 superblock location and some for the write-intent
bitmap. (Is there a way to determine where the w-i bitmap gets located
and how big it is from the super block.)

I'd say put lets reserve the first 64K (2 cylinders) for boot and
superblock.


> grub could then write whatever it wants to write to any of these
> sectors.
> 
> That only leaves the question of what happens when a spare is added to
> the array - how does the grub data get written to the space on the
> spare.
> I would rather that grub were responsible for this, than for md to
> treat that unused space as RAID1.

Fair enough for the short term, but I imagine in the long run it would
be a better way then calling an external application.  Isn't this
already done for the w-i bitmap anyway?

> We already have a notification system based on "mdadm --monitor" to
> process events.  We could possibly plug grub in to that somehow so
> that it gets told to re-write all it's special blocks every time
> something significant changes in the array.

If mdmon can call external commands, it should only need to call the
appropriate grub-install [/dev/md/dX | "(md0)", and it would rewrite the
superblock on all the devices.

-- 
Daniel Reurich

Centurion Computer Technology (2005) Ltd
Ph 021 797 722

