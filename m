From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2.6.20-rc6] md: expose uuid and degraded attributes in
 sysfs
Date: Mon, 12 Feb 2007 16:05:55 +1100
Message-ID: <17871.62899.607699.364145@notabene.brown>
References: <20070127015948.GA24479@teal.hq.k1024.org>
	<20070210111836.GA7953@teal.hq.k1024.org>
	<45CE0A5D.6040409@tmr.com>
	<17870.13811.570367.617924@notabene.brown>
	<45CFF256.8000609@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Sunday February 11
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org, iusty@k1024.org
List-Id: linux-raid.ids

On Sunday February 11, davidsen@tmr.com wrote:
> I don't think moving it would get much argument, but having it visible 
> has advantages as noted in the original post, and opens the door to 
> someone writing code to allow the uuid to be changed with a write to a 
> sys file. We had a discussion of setting uuid a few months ago, I think 
> you agreed it was a reasonable thing to do.

Current mdadm lets you change the uuid while assembling an array
   mdadm -A /dev/mdX --update=uuid --uuid=whatever /dev/......
This was in response to our discussion that you mention.

Changing the uuid while the array is active is a somewhat different
consideration.  It's hard to see it being a good idea.

Filesystems have UUIDs.  They are visible via the 'blkid' command.
md arrays have UUIDs.  They are visible via 'mdadm'.

sysfs isn't the only place to make things visible, and sometimes it
isn't the best.

> > The UUID isn't an intrinsic aspect of the array.  It is simply part of
> > the metadata that is used to match up different devices from the same
> > array.
> > I plan to add support for the 'DDF' metadata format (an 'industry
> > standard') and that will be managed entirely in user-space.  The
> > kernel won't know the uuid at all.
> >   
> Outside of forcing changes for all of us using uuid, what does this 
> standard compliance buy us as users? Or you as a maintainer? Does this 
> let Linux get run on a million computers which can't now because of lack 
> or standard compliance? I'm always worried when things change without a 
> visible benefit, so feel free to make the benefits visible. Managed in 
> user space is not a big item for me, it means there will be more more 
> places for errors to creep in.

Supporting DDF means we can tick the 'Supports DDF' check-box and sell
in to thousands of new potential customers who don't really need it
...... no, just kidding.

Supporting DDF means we can move drives from a DDF based hardware RAID
card only a regular SATA card and still access the data.  It means we
can dual-boot with another OS that does DDF/raid and have access to
the same data.  It means that a fakeraid card that has bios support
for booting off a RAID array can have the same perspective of the RAID
arrays as the kernel has.

Or at least, that is the theory.

I don't actually know of anything card that definitely used DDF raid
yet, but I suspect they will start appearing.

And 'DDF' isn't the only reason that in-kernel UUIDs don't always make
sense.  If you create an array with no superblock there is likewise no
UUID to provide from kernel-space.

> > So any solution for easy access to uuids should be done in user-space.
> > Maybe mdadm could create a link
> >    /dev/md/by-uuid/xxxxxxxx -> /dev/whatever.
> > ??
> >
> >   
> Which would be kept in sync how when the uuid is changed?

Don't change the UUID on an active array.

NeilBrown
