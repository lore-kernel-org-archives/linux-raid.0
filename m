From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm-2.5.4 issues and 2.6.18.1 kernel md issues
Date: Thu, 16 Nov 2006 13:31:21 +1100
Message-ID: <17755.52601.646213.835255@cse.unsw.edu.au>
References: <1162479503.2898.338.camel@fc6.xsintricity.com>
	<17746.48465.156017.828602@cse.unsw.edu.au>
	<1163100824.4138.375.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Thursday November 9
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday November 9, dledford@redhat.com wrote:
> On Thu, 2006-11-09 at 16:32 +1100, Neil Brown wrote:
> > On Thursday November 2, dledford@redhat.com wrote:
> > > If I use mdadm 2.5.4 to create a version 1 superblock raid1 device, it
> > > starts a resync.  If I then reboot the computer part way through, when
> > > it boots back up, the resync gets cancelled and the array is considered
> > > clean.  This is against a 2.6.18.1 kernel.
> > 
> > I cannot reproduce that (I tried exactly 2.6.18.1).
> > Do you have kernel logs of the various stages?
> 
> No, I don't.  It could however be related to the fact that I built the
> array, let it sync completely, then rebuilt the array with a new
> superblock without doing an mdadm --zero-superblock on each device first
> (I was playing with different options).

mdadm effectively does the --zero-superblock for you - since 2.4.

>                                          After that second build, it was
> about 66% done resyncing when I decided to reboot and try out the
> "restart from where it left off" feature of the version 1 superblock and
> when I rebooted, to my dismay, it was marked as clean and no sync was in
> progress. 

The "restart from where it left off" feature of version-1 applies to
recovery (rebuilding onto a spare).  resync (making sure array is
consistent) restarts for all arrays since 2.6 - providing the shutdown
is clean.


>            So, I used mdadm to fail/remove/add the second device from
> the array.  To my surprise, it went in clean *again*.  This time I think
> that was intentional though, I don't think I had dirtied the array
> between the fail and add, so the generation counts matched and mdadm or
> the kernel decided it was safe to put it back in the array without a
> resync (I know a *lot* of our customers are going to question the safety
> of that...the logic may be sound, but it's going to make them nervous
> when a fail/remove/add cycle doesn't trigger a resync, so I don't know
> if you've documented the exact logic in use when doing that, but it's no
> doubt going to fall under scrutiny).  So, the next time I did a
> fail/remove/zero-superblock/add cycle and that triggered the full resync
> that I wanted.  So, my guess is that because I didn't zero the
> superblocks between the initial creation and recreation with a different
> --name option (I think that was the only thing I changed), it may have
> triggered something in the code path that detects what *should* be a
> safe remove/add cycle and stopped the resync on reboot from happening.

The second --create should have made a new uuid and there should have
been no possible confusion with the old.  If you can reproduce this I
would be very interested.

> 
> > > 
> > > If I create a version 1 superblock raid1 array, mdadm -D <constituent
> > > device> says that the device is not part of a raid array (and likewise
> > > the kernel autorun facility fails to find the device).
> > 
> >    mdadm -D <constituent device>
> > is incorrect usage.  You want
> >    mdadm -E <constituent device>
> > or
> >    mdadm -D <assembled array>
> > 
> > in-kernel autorun does not work with version 1 metadata as it does not
> > store a 'preferred minor'.
> 
> No, but it has a name, so theoretically, it could assemble it and use
> the name component without regard to the minor number.  Regardless, now
> that FC6 is out the door, I want to make some change for FC7 and I'm
> trying to get the changes in place so we don't use autorun, so it may
> very well be a moot point as far as we are concerned (although the
> messages from the kernel that the devices don't have a superblock might
> confuse people, I think it would be better to print out a kernel message
> to the effect that autorun doesn't work on version 1 superblocks:
> skipping instead of <sda1> no superblock found or whatever it says
> now).

I can certainly change it to "No version 0.90 superblock found"  I'm
not sure that I want to hunt around for all other possible
superblocks.

Yes, I guess it could assemble something, but the minor number
wouldn't be stable across reboots, so you would need some sort of
user-space interaction, so you may as well do all the assembly in
user-space.


> > >                              It also prints the mdadm device in the
> > > ARRAY line as /dev/md/# where as mdadm -D --brief prints the device
> > > as /dev/md#.  Consistency would be nice.
> > 
> > It would be nice .... but how important is it really?
> > If you create the same array with --name=fred, then
> > -Eb with give /dev/md/fred, while -Db will give /dev/md2.
> > Both a right in a sense.
> > 
> > Ofcourse if you say
> >   mdadm -Db /dev/md/2
> > then you get /dev/md/2.
> > You only have /dev/md2 force on you with 
> >   mdadm -Ds
> > In that case mdadm doesn't really know what name you want to use for
> > the md device....  I guess it could scan /dev.
> 
> Well, given the clarification above about the difference between -D and
> -E, and that no minor information is stored in version 1 superblocks, I
> can see where -Eb has no choice but to use the name and omit the minor
> information entirely (unless you did something like checked to see if
> that array was currently assembled, and if so what minor it is currently
> on, but that's overkill IMO).  However, what that means to me is that in
> future products, I need to teach the OS to ignore major/minor of the
> device and *only* use the name if we switch to version 1 superblocks
> (which I would like to do).  The reason is that if you ever loose your
> mdadm.conf file, you can't get consistent major/minor information back
> by going to the device, only the name information.  So, ignore
> major/minor completely, let the md stack use whatever minor it wants
> from boot to boot, and rely entirely on the name the device would get
> under /dev/md/ for uses in things like lvm2 configs, fstab, etc.

Yes, I think that is the right direction.  It is certainly consistent
with host SCSI (aka sata aka USB ...) drives are handled.

> 
> Now, the only question that leaves for me is some way to tell a
> partitioned device from a normal device.  Obviously, this isn't
> something that needs to be in upstream, but a standardized way of
> telling the difference for the purpose of rescue disks and the like will
> be necessary for our distribution I think.  I'm thinking that if the
> name ends in _p# where # is some integer, then lop off the _p# part from
> the part of the name we use when making the whole device and make a
> partitioned array with that number of partitions ending in _p1 to _p#.
> It would preclude the use of certain possible names, but I think that
> should be sufficient.

I guess...

> > I would recommend that if you want to do everything automatically,
> > then assemble all arrays as partitionable.  Then you can use it with
> > or without partitions.
> 
> I'd prefer not to go this route just in case a non-partitioned array
> might end up having some bogus info that looks similar to a partitioned
> array and results in out of range partitions.

How is this a problem exactly?  It can cause some occasional confusing
error messages, but nothing worse than that?

> 
> Well, the main thing I was pointing out was that if the name matches the
> filesystem's label on the device, aka /boot for the boot partition and
> firewall:/boot for the md device, that mdadm double prints the slash.
> That wasn't a typo in my comment, that's what mdadm does.

He.... and if you made the name "host:/home/foo" then mdadm would try to
assemble it as "/dev/md//home/foo" which probably wouldn't work.

I'm not sure path names is quite the right sort of thing to use.
Certainly 'host:/' isn't going to be useful.  I would expect/encourage
names like "root" "boot" "home" "usr" "bigstorage" "mirror" "scratch".

> 
> On a separate note, can you let me know what difference the version 1.0,
> 1.1, and 1.2 superblocks would make to the possible size of internal
> write intent bitmaps?  With my particular disks I'm testing on, they're
> about 320G each, and the intent bitmap is limited to 5 pages with
> internal and superblock format 1.0.  For larger arrays, I could see
> wanting a larger internal bitmap.  Do any of the other superblock
> options allow for that?

version 1 superblocks allow for an arbitrarily large internal bitmap.
It does this by explicitly given the data-start and data-size. So e.g.
a 1.1 superblock could make 
    data-start==1Gig
    data-size == devicesize minus 1Gig
and put the bitmap after the superblock (which is at the start) and
use nearly one Gig for the bitmap.

However mdadm isn't quite so accommodating.  It should:
  - when creating an array without a bitmap, leave a reasonable
    amount of space for one to be added in the future (32-64k).
  - When dynamically adding a bitmap, see how much space is available 
    and use up to that much
  - when creating an array with a bitmap, honour any --bitmap-chunk-size
    or default and reserve an appropriate amount of space.

I think it might do the first.  I think it doesn't do the second two.
Maybe in 2.6.. .or 2.7.

> 
> Another thing I'm thinking about doing is defaulting to an mdadm setup
> that precludes the information from being easily accessible when the
> array isn't running.  Aka, a superblock at the beginning of the array
> instead of at the end. 

I think this is probably a good idea.  The "can use separate devices"
this is kind-of nice, but it irrelevant for all levels but raid1 and
isn't really convincing even for raid1.

> 
> The only real problem I see with this approach is getting grub/lilo to
> work with the /boot partition.

Yes.  I think grub/lilo need to be re-educated about the current
realities of md.... I wonder if that would be a fun project.

> 
> The difference in geometry also precludes doing a whole device md array
> with the superblock at the end and the partition table where the normal
> device partition table would be.  Although that sort of setup is risky
> in terms of failure to assemble like I pointed out above, it does have
> it's appeal for certain situations like multipath or the ability to have
> a partitioned raid1 device with /boot in the array without needing to
> modify grub, especially on machines that don't have built in SATA raid
> that dm-raid could make use of.

My home-server has exactly this : a partitioned md whole-device raid1
pair.
Getting grub to work with it was not as stright forward as I would
have liked.
I got it working by running "grub-install" while booted of a single
drive, then switch to an md config without telling grub... not ideal.

NeilBrown
