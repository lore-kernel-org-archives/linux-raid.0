From: Neil Brown <neilb@suse.de>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 10:23:38 +1100
Message-ID: <18694.19834.523955.697048@notabene.brown>
References: <18692.62860.863118.727187@notabene.brown>
	<ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kay Sievers on Monday October 27
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Monday October 27, kay.sievers@vrfy.org wrote:
> On Sun, Oct 26, 2008 at 23:56, Neil Brown <neilb@suse.de> wrote:
> >  Device naming in mdadm is a bit of a mess.
> 
> >  In 2.6.28, partitioned devices (mdp) wont be needed any more as md
> >  will make use of the "extended partition" functionality recently
> >  added.
> 
> You mean the extended minor space, right? Or the extended partitions,
> which are a format in a msdos table?
> 

Yes, the extended minor space.  Too many extensions here :-)

> >  1/ The only device nodes created will be /dev/mdX and /dev/md_dX
> >    along with partitions /dev/mdXpY and /dev/md_dXpY as appropriate.
> >    These will be created by mdadm in accordance with the "--auto"
> >    flag unless something in mdadm.conf says to leave it to udev.
> >    In that case, mdadm will create a temporary node
> >    (/dev/.mdadm.whatever) and remove it once udev has created the
> >    real thing.
> 
> Sounds fine, if mdadm needs a device node. It could also wait for udev
> to have the node created, but having a temporary node sounds fine, as
> long as it will not clash with anything udev is creating.

mdadm definitely does need a device node.  Currently opening a
block-special-device is the only way to create an md array.  I have
contemplated some approaches using sysfs, but I could never see that
they actually gained me anything.
It should not need to wait for anything though.  It can just keep
using the temporary node it created.

> 
> >  2/ There will be various symlinks to these devices.
> >    a/ if "symlinks=yes" is given in mdadm.conf, symlinks from
> >         /dev/md/X or /dev/md/dX will be created.
> >    b/ if udev is configured like on Debian,
> >              /dev/disk/by-id/md-name-XXXX
> >        and   /dev/disk/by-id/md-uuid-UUUU
> >       will be created (by udev).
> 
> Yes, almost all distros have that.

But in different places. 
Debian has /etc/udev/rules
openSUSE has /lib/udev/rules

I love standards.  There are so many to choose from. :-)

Is there anywhere else I should get 'make install' to check?

Debian doesn't get 'mdp' devices right.
openSUSE is already ready for 2.6.28 in which all md devices can be
partitions!

> 
> >    I'm contemplating creating a link based on the metadata type with
> >    a sequential number. e.g. /dev/md/ddf1 or /dev/md/imsm2.
> >    I'm not sure if there should be in /dev/md/ or directly in /dev/.
> >    I'm also not sure if I should leave the creation to udev, and
> >    whether I should use a small sequential number, or just whatever
> >    number was allocated as the minor number of the device.
> 
> There is intentionally no support for enumeration in udev, it will
> just not work and such numbers/links are not reproducible in hotplug
> environments, and therefore totally useless, and do much more harm
> than good.

I'm not entirely following your logic here.
The 'a' 'b' 'c' at the end of e.g. /dev/sda are not reproducible in
hotplug environments, but they are not totally useless.  I know they
will remain stable as long as the device is present, so once I found
out which /dev/sdX is my USB thingo I just plugged in, I can
repeatedly use that nice simple name to cfdisk, mkfs, mount, whatever
the device.

> 
> Nothing must ever depend on enumeration, or minor numbers, if these
> properties can not made persistent, attached  to the device itself, so
> that it will always show up with the same number forever. Better do
> not even start such an idea, and leave the kernel name as the primary
> "random" number, instead of creating new randomness on top.

I'm not entirely convinced.  However I can see a real difficulty in
introducing a new sequence number.  Thus if a 'ddf' array gets created
as /dev/md15, then if I want to create a name containing the string
'ddf', it should be 'ddf15'.  Maybe /dev/ddf15.  Maybe /dev/md/ddf15.


> 
> >  4/ When we stop an array, mdadm will remove anything from /dev that
> >    it probably created.
> 
> Sure, but only if mdadm has it created.

Why would it matter?

Hmmm... Does udev ever deleting things from /dev?  I notice that 'md'
devices don't seem to disappear.  Maybe that is because /sys/block/mdX
never disappears (last time I tried it was too racy).
Would there be any way to get udev to delete devices when 
  /sys/block/mdX/md/array_state 
becomes 'clear' (presumably on a CHANGE event) ??


> 
> >    In particular, it will remove the device node as described in 1,
> >    any partitions, and any symlinks in /dev or /dev/md which point to
> >    any of those.  I need to be certain that this won't confuse udev.
> 
> You must never touch anything that udev has created. It must be driven
> by kernel "add/remove/change" events.

Again - why?  I notice that if I do remove the device nodes when the
array is stopped, the still create nicely recreated when I restart the
array.
However I seem to have decided to make a clear distinction between
when udev is running or now, so I'll not remove anything if I think
udev is running.

> 
> > I'm also wondering if I should include a udev 'rules' file for md in
> > the mdadm distribution.  Obviously it would be no more than a
> > recommendation, but it might give me a voice in guiding how udev
> > interacted with mdadm.
> 
> Definitely, it should carry a udev rules file which instructs udev to
> create all intended symlinks and also supports the raid auto-assembly
> setup. It should not mount anything by default though.

But why is 'mounting' so much different to 'assembling' in people's
eyes?   Certainly mounting readonly should be OK if assembling is
seen as OK.

However I have no intention of automounting anything.

> 
> I'm happy, to see you working on next-generation mdadm. I like to see
> a better integration with udev, and especially, if mdadm detects a
> running udev, not to mess around in /dev in any way, but leave the
> names in /dev to instructions in udev rules. Temporary nodes are fine,
> as long as they don't conflict with anything else, and get removed
> after they are not needed anymore. All updates to symlinks and such
> should be done by "change" events from the kernel, which instructs
> udev to update all the links, and not by touching anything in /dev
> from mdadm.

Better late than never :-)

I asked it in another email, but for completeness:
  What is the best way to detect in udev is running?  And will it
  work the same in all distros (having discovered the /lib/udev vs
  /etc/udev difference, I'm a little worried).

> 
> Do you think mdadm will stay a program only, called by udev/the user,
> or will a port of its functionality live in a daemon?

What are you thinking here?

  mdadm --monitor runs as a daemon, emails interesting events, and
  sometimes moves spares between arrays.

  mdmon (a new program in mdadm-3.0) is a daemon that monitors a
  particular array (or more accurately, a set of related metadata,
  there might be several arrays) and updates the metadata
  accordingly.  This isn't used for v0.90 of v1.x metadata.

  mdadm -D and mdadm -E can be run from udev to help with hot plug
  events. 

These are all daemons or daemon-like functionality.  What else were
you thinking of?  A stand-alone daemon that supports HTTP and allows
arrays to be built and configured from a browser?  No.  I wouldn't
do that. ;-)

Thanks,
NeilBrown
