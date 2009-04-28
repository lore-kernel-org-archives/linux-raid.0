From: Neil Brown <neilb@suse.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Wed, 29 Apr 2009 09:05:07 +1000
Message-ID: <18935.35747.471257.202356@notabene.brown>
References: <1240574900.4507.2076.camel@ezra>
	<87hc0axhg9.fsf@frosties.localdomain>
	<49F68CE0.2010906@zytor.com>
	<e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	<1240957153.18303.689.camel@ezra>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel Reurich on Wednesday April 29
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Reurich <daniel@centurion.net.nz>
Cc: Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 29, daniel@centurion.net.nz wrote:
> On Tue, 2009-04-28 at 11:24 -0700, Dan Williams wrote:
> 
> > 
> > ...or use a metadata format that your platform bios understands and
> > provides an int 13h vector.  See the new external metadata formats
> > supported by the mdadm devel-3.0 branch.
> 
> I don't think a metadata format is the right way either.  
> 
> What we need is a new version of the superblock with the first cylinder
> (32kb on 512b sectors x64 sectors per cylinder) being set aside for the
> bootloader, the superblock and w-i bitmap go in the second cylinder, and
> the raid data area starting in the 3rd cylinder.  
> 
> It should be the bootloaders responsibility to install the bootloader
> onto the disks 1st cylinder, but md/mdadm would have to replicate it on
> resync or adding of a new disk.  However we could consider remapping the
> bootloader 

While I agree with Dan that having a BIOS which understands RAID is a
good way to make this sort of thing "just work", I would be nice if it
could work for people without the bios too.

v1.x metadata has explicit knowledge of where the start of the data
is, so it is quite possible to leave the first few (dozen) sectors
unused (let's not talk about cylinders this century - OK?).
So mdadm could grow a --grub flag to use with --create which arranged
for data/bitmap to not use the first (say) 512 sectors of any device.
(1.1 and 1.2 would still use reserved blocks for the superblock).
[I can cut you a patch to experiment with if you like]

grub could then write whatever it wants to write to any of these
sectors.

That only leaves the question of what happens when a spare is added to
the array - how does the grub data get written to the space on the
spare.
I would rather that grub were responsible for this, than for md to
treat that unused space as RAID1.
We already have a notification system based on "mdadm --monitor" to
process events.  We could possibly plug grub in to that somehow so
that it gets told to re-write all it's special blocks every time
something significant changes in the array.

NeilBrown
