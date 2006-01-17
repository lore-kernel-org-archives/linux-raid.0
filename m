From: Neil Brown <neilb@suse.de>
Subject: Re: blog entry on RAID limitation
Date: Tue, 17 Jan 2006 21:40:09 +1100
Message-ID: <17356.51593.481883.173707@cse.unsw.edu.au>
References: <8E5ACAE05E6B9E44A2903C693A5D4E8A097F6C86@hqemmail02.nvidia.com>
	<1137487538.309F9186@bd12.dngr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Breidenbach on Tuesday January 17
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday January 17, jeff@jab.org wrote:
> Is this a real issue or ignorable Sun propoganda?

Well.... the 'raid-5 write hole' is old news.  It's been discussed on
this list several times and doesn't seem to actually stop people
getting a lot of value out of software raid5.

Nonetheless, their raid-z certainly seems interesting, I though feel the
term is misleading.  raid-z doesn't provide a virtual storage device
in which you can store whatever filesystem you like.  raid-z is their
code name for a particular aspect of the ZFS filesystem.

Though some of these details are guessed and so might be wrong, it
probably goes something like this:

ZFS uses a 'variable block size' which is probably very similar to
what other filesystems call 'extents'.  When an extent is written, a
hash (aka checksum or MIC - message integrity check) is calculate and
stored, probably with the indexing information.  This makes it easy to
check for media errors.

Also the extent is possibly written over various devices, quite
possibly at different locations on the different devices.  It might be
written twice, thus producing effective mirroring.  It might be
chopped up into bits with the bits written to different devices and a
parity block written to another device.  This produces an effect
similar to raid5.
This layout can even be different for different blocks.

On a regular (Ext3 like) filesystem this would be very awkward as
updating a block would be confusingly hard.  However ZFS never updates
in place.  It is 'copy on write' so any change is written to a new
location and updating the indexing and MIC is all part of the package.

Not that not only data blocks, but also indirect block and all metadata
could be duplicated or striped with parity.

This is definitely a clever idea, as are lots of the ideas in ZFS.
But just because someone has had a clever idea, that doesn't reduce
the value of existing clever ideas like raid5.

In general, I think increasing the connection between the filesystem
and the volume manager/virtual storage is a good idea.  Finding the
right balance is not going to be trivial.  ZFS has taken one very
interesting approach.  There are others.

I have a feeling the above isn't as coherent as I would like.  Maybe I
should go to bed....



> 
> -----Original Message-----
> From: I-Gene Leong
> Subject: RE: [colo] OT: Server Hardware Recommendations
> Date: Mon, 16 Jan 2006 14:10:33 -0800
> 
> There was an interesting blog entry out in relation to Sun's RAID-Z
> talking about RAID-5 shortcomings:
> 
> http://blogs.sun.com/roller/page/bonwick?entry=raid_z
> 
> It sounds to me like RAID-1 would also be vulnerable to the write hole
> mentioned inside.

The 'write hole' exists for all raid levels with redundancy.  The
'resync' process after an unclean shutdown closes the hole,
eventually.

With raid-5, a drive failure while the hole is open means potential
undetectable data loss.  With raid-1, a drive failure doesn't imply
data loss even during the hole.

NeilBrown
