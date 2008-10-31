From: Neil Brown <neilb@suse.de>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Fri, 31 Oct 2008 20:45:35 +1100
Message-ID: <18698.54207.663716.200113@notabene.brown>
References: <18692.62860.863118.727187@notabene.brown>
	<1225387127.26510.155.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Thursday October 30
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>, Kay Sievers <kay.sievers@vrfy.org>
List-Id: linux-raid.ids

On Thursday October 30, dledford@redhat.com wrote:
> On Mon, 2008-10-27 at 09:56 +1100, Neil Brown wrote:
> > Greeting.
> >  This is a Request For Comments....
> 
> OK, I've taken my time responding to this at least partially because I
> wanted to get you my current changes first.

You mean it isn't a law of the Internet the every email must be
replied to in less that 2 hour!  In never knew!!

Thanks for taking the time when the time was right.
> > 
> >  In 2.6.28, partitioned devices (mdp) wont be needed any more as md
> >  will make use of the "extended partition" functionality recently
> >  added.  All md devices can be partitioned.  The device number for the
> >  partitions will be very different to that of the whole device, but
> >  udev should hide all of that.  So we don't have to worry too much
> >  about mdp devices.
> 
> Back compatibility, and the ability to use current mdadm on older
> kernels may mean that we need to deal with mdp devices regardless.

True.  My thoughts were that the needs of mdp should not drive design
any more.  Certainly we keep back compatibility where practical and
fix bug (thanks!) and include support for mdp on at least and equal
level with md.  But any extra concerns don't need to drive design.

> 
> >  So I think the following is how I want things to work.  I am very
> >  open to comments and suggestions.  Particularly I want to know what
> >  (if anything) this will break.
> > 
> >  1/ The only device nodes created will be /dev/mdX and /dev/md_dX
> >     along with partitions /dev/mdXpY and /dev/md_dXpY as appropriate.
> >     These will be created by mdadm in accordance with the "--auto"
> >     flag unless something in mdadm.conf says to leave it to udev.
> >     In that case, mdadm will create a temporary node
> >     (/dev/.mdadm.whatever) and remove it once udev has created the
> >     real thing.
> 
> One thing I noticed in my work on the incremental stuff, is that the
> user friendly device naming method still wants to create
> these /dev/md_dX{pY} array names.  I'm actually in favor of doing away
> with the notion that an array needs to be numbered and exist in a
> numbered format in the /dev/ namespace.  If you have a user friendly
> name, such as /dev/md/root and /dev/md/boot, or /dev/md/root_p1
> and /dev/md/root_p2, I see no need to add additional numbered devices.
> Instead, just allow the device number of the named devices to be random.

I have considered dropping the "/dev/mdXX" names altogether, and I
think mdadm.2 sometimes does that.  But I've decided against it.
My reasons are:

 1/ udev is going to create them anyway, so there is no point trying
    to hide them.
 2/ those names appear in /proc/mdstat and despite all the rhetoric
    about naming policy not belonging in the kernel, the kernel does
    set some naming policy, "mdX" etc are part of that, and we cannot
    avoid it.
    Joe Sysadmin will see a name in /proc/mdstat and might want to
    access that device.  Having it easily available in /dev is good.

My current thought is that /dev/md/ provides human friendly names.
/dev/disk/by-id/md-whatever provides script-friendly names.  And /dev
directly contains kernel-friendly names.

> 
> >  2/ There will be various symlinks to these devices.
> >     a/ if "symlinks=yes" is given in mdadm.conf, symlinks from
> >          /dev/md/X or /dev/md/dX will be created.
> >     b/ if udev is configured like on Debian,
> >               /dev/disk/by-id/md-name-XXXX
> > 	and   /dev/disk/by-id/md-uuid-UUUU
> >        will be created (by udev).
> >     c/ If there is a 'name' associated with the array then
> >         /dev/md/name will be created as a link.
> >     d/ if an explicit device name of /dev/name was given,
> >         either on a -A, -B, -C, command or in mdadm.conf,
> > 	then the 'name' must match the name of the array,
> > 	and /dev/name will be used as well as /dev/md/name.
> 
> I think all these symlinks are problematic.  We have a naming
> consistency problem, and creating all these links just perpetuates that
> problem.  I would be in favor of standardizing the namespace location
> and semantics and doing away with all the symlinks.  Do that, and within
> one release cycle all the confusion will be gone.

Your last sentence is very pragmatic and sensible.  If confusion
exists, we really want to move firmly away from it, and people will
cope, particularly if things become cleared (even if they are
different to what they are used to).

I am dropping support for the "--symlinks" option and matching
mdadm.conf entry. 
/dev/mdXXX will always be the device node.  There will always be (at
most) one entry in /dev/md/ which points to it.  It might be e.g.
/dev/md/0, but only if no better name is available.

Hopefully this will be clear if documented well.

I think having a large number of symlinks from different places in
/dev is inevitable.   But if we come up with clear definitions of
meaning, purpose, and behaviour, we should be safe.

> 
> There's no need to make autostarted arrays that we can't identify as
> being intended solely for this host hard to find.  It's a little tricky
> if there's no homehost in the array, so let's skip that for a second.
> If there *is* a homehost, and we don't list the array in mdadm.conf or
> it doesn't match our homehost, then I think the answer is to just start
> the array auto-readonly with the name /dev/md/homehost:name.  Since we
> are assuming that homehost:name is unique even if it isn't our device,
> then that means it's sufficient for naming the device uniquely in
> our /dev/md space.  Now, if we don't have a homehost on the array, then
> I would do as you suggest and use a random high device number and have
> udev create any appropriate links.  Of course, udev would make those
> same links on devices with a homehost, so the final difference is just
> that you create a homehost:name device when possible, skip it when not.
> All the rest is the same.

I agree.  I think I have implemented some of this, but not all.  In
particular the idea of not starting unexpectedly-degraded arrays which
are foreign is not implemented I don't think.  I will do that.
I also now create e.g. /dev/md/homehost:name when that might be
appropriate.  However it isn't always the case that the name of the
homehost is known.  For 0.90, I can tell if a particular homehost
matches, but I cannot tell the correct homehost name.

But yes, we can still assemble the array and provide some sort of
meaningful name in /dev/md.

> > 
> >  2/ Auto-assembly of new arrays must not conflict with auto-assembly
> >     of previously existing arrays, even if the devices comprising the
> >     new arrays are discovered earlier.  This is what the 'homehost'
> >     concept is for.  Your array will only get assembled with a
> >     predictable name if it is known to be attached to 'this' host.
> 
> Really, with the advent of mount-by-label filesystem usage, this
> argument has become less legitimate.  That's not to say that using
> homehost intelligently isn't desirable, but even if there is a name
> conflict, and the wrong array gets assembled first, it really doesn't
> matter since the upper layers will detect the proper filesystem by
> filesystem label or uuid and use whatever device contains the filesystem
> they want.  So, I would treat homehost as a convenience and a hint, but
> I wouldn't allow lack of homehost or wrong homehost to prevent assembly.

Agreed.  auto-read-only and not starting unexpectedly-degraded foreign
arrays make me more comfortable about this.

> >  4/ auto-assembly needs to do the right thing on a SAN where multiple
> >     hosts can each see multiple arrays.  Clearly only one host should
> >     write to any one array at one time (until I get some
> >     cluster-awareness going, which I had hoped to work on this year,
> >     but it doesn't look like I will).
> >     In this case, I don't think read-auto is enough.  We either need
> >     to not assemble arrays when aren't known to belong to us, or we
> >     need to assemble them read-only and require and explicit
> >     read-write setting.
> > 
> >     So we need some way to know which devices could be visible to
> >     other hosts.
> >     I could have a global flag in mdadm.conf "Options SAN"
> >     I could have a SAN-DEVICES to match "DEVICES", but as just about
> >     everything is "/dev/sd*" these days, I don't know if that would
> >     work.
> > 
> >     Any suggestions concerning this would be welcome.
> 
> The scariest suggestion, but probably the most complete and automated,
> would be to have mdadm do a search on any constituent devices to find
> out what the eventual low level driver is.  If it's a fiber channel
> driver, or iSCSI, then don't auto assemble.  If it's sata/e-sata, or
> local SAS, then it's more likely auto assemble is fine.  But, that level
> of mucking around in /sys for each device would probably be quite ugly.


Quite.  And I'd almost certainly get it wrong.  One day someone might
come up with a solution that can be automated.  For now I think I
stick with configuration in mdadm.conf

> 
> > I'm also wondering if I should include a udev 'rules' file for md in
> > the mdadm distribution.  Obviously it would be no more than a
> > recommendation, but it might give me a voice in guiding how udev
> > interacted with mdadm.
> 
> Actually, this would probably be very helpful.  For instance, that udev
> rules file is probably the way you decide whether mdadm or udev
> creates/deletes all the links.  The actions of mdadm and udev have to be
> synchronized in order to avoid confusion about responsibilities.

Good.  I'm feeling quite positive about the idea of distributing an
mdadm.rules file.  I'm now even starting to understand udev rules
files!


Thanks for your thoughtful contributions.

NeilBrown
