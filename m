From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Mon, 20 Apr 2009 17:23:01 +1000
Message-ID: <18924.8917.420265.477921@notabene.brown>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com>
	<cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com>
	<18899.61151.445765.360191@notabene.brown>
	<51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com>
	<18919.64597.426128.498393@notabene.brown>
	<D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Friday April 17
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday April 17, dledford@redhat.com wrote:
> On Apr 16, 2009, at 11:49 PM, Neil Brown wrote:
> > On Monday April 6, dledford@redhat.com wrote:
> >> On Apr 1, 2009, at 6:46 PM, Neil Brown wrote:
> 
> This appears to be the difference between a server setup and a desktop  
> setup.  Server admins want to list things and only have known actions  
> happen.  Desktop people want things to "just work".  I've had several  
> people tell me they thought the idea of mdadm.conf was completely out  
> of date and it should just go away entirely.  Not saying I agree, just  
> letting you know what I get.

:-)

> >  I'm not sure I'm happy with expecting people to do that
> > (though of course I'm happy to support it).
> 
> I really don't expect them to per se.  More like it's the *safe* thing  
> to do.  If you ever have a conflict in names, the one in the file  
> wins.  If you ever have a conflict in names without one of them in the  
> file, then it's whoever got there first.  In that sense, mdadm.conf is  
> just a backup for me.  Well, that and mkinitrd doesn't do incremental  
> assembly, so it's needed for boot in my case.  But that could be  
> changed.

So the safe thing to do is to create mdadm.conf.  But we all know that
the convenient thing to do is not to create mdadm.conf.

Thus safe and convenient are separate.  This sounds like bad design.

I like it that not creating mdadm.conf is a little bit inconvenient in
that you are more likely to get names with _N suffixes.  It (I hope)
motivates people to become safe, either by making sure homehost works,
or be creating mdadm.conf.

The case that I want to avoid is this:
  You have two machines that each boot off their own md0.
  Late one night machine A dies.  So you get called in, while half
  asleep, to get the data back on line.
  You shut down B, pull the drive out of A and plug them into B and
  then boot B.
  You find that it made a root filesytem from the drives that were in A
  rather than in B.

This could be just inconvenient, or it could be a serious mess.

I don't want people to discover these potential naming conflicts which
trying to recover from a disaster.  I want them to discover them when
initially setting up their array.

To achieve that, I should probably make the _N suffix truly random
rather than simply arbitrary.  But I haven't done that.  Yet.

> 
> > So the various parts of your algorithm which involve heuristics
> > based on the entries in mdadm.conf - or on the existence of mdadm.conf
> > itself - are parts that I don't feel comfortable with.
> >
> > What is left?  Well, the observation that moving an external
> > multi-drive enclosure between hosts causes confusing naming is a valid
> > and useful observation.
> >
> > Someone should be able to create an array on such a device called
> > 'foo' and get '/dev/md/foo' created on any host.
> > The best thought I have come to so far is to support (and document)
> > something like
> >  --create --homehost=any
> > or
> >  --create --homehost=*
> >
> > with the meaning that the array so created will get preferential
> > access to it's recorded name (i.e. no "_0" suffix).
> >
> > I also wonder if, when mdadm finds an array that is explicitly for
> > another host, we could use that host name rather than _0 to
> > disambiguate.  So
> >  --create /dev/md/foo --homehost=bob
> > when assembled on some other host is called
> >       /dev/md/foo_bob
> > that might at least make it more obvious what is happening.
> 
> This is probably where you and I disagree.  I don't think you are  
> disambiguating.  I think you are confounding the common case of no  
> conflict.  If someone has a non-portable array, like /, they commonly  
> use something like /dev/md0.  That, you will likely never get a  
> conflict on.

Except in the above scenario, when you least want it to happen.

>               On the other hand, if someone creates an array to be  
> mobile, it will likely have a higher number (or it could be 0, but  
> that implies they aren't using root raid arrays on their machines in  
> all likelihood).  So, if you make a mobile array, just give it any old  
> number you can remember other than the normal base numbers used by non- 
> portable arrays, and viola, no conflicts (note that this is also why I  
> was in favor of a completely numberless md setup, where device  
> major:minor do not impact name of the array at all, and you are free  
> to create something like /dev/md/root and there will be no access file  
> other than /dev/md/root, specifically no alias from /dev/md0 to /dev/ 
> md/root...it's much easier to remember names than numbers, and much  
> easier to create a scheme that avoids conflicts 100% of the time).  As  
> it stands though, the current code still won't honor random names as  
> though that was the official and canonical name of the array, it  
> insists on creating a /dev/md# device and then just symlinking the  
> name as though the /dev/md# device is canonical.  In one of your  
> previous emails you mentioned something about how bad design decisions  
> get entrenched and can never be rooted out, I would point to this
> ;-)

I had forgotten about this...
The kernel supports this.  We just need to make sure it works with
udev and get mdadm to use it.

 echo md_foo > /sys/modules/md_mod/parameters/new_array
 ls -l /dev/md_foo

no numbers at all.

Maybe we can start using this in 3.1.
But I'm not sure how this relates to the current problem of how to
choose a name based on the contents of the metadata.



You draw a distinction between mobile and non-mobile arrays.  Quite
possibly that is a useful distinction to pursue.

It is the non-mobile arrays that I am particularly concerned about.
If someone plugs in a mobile array I'm happy to give them whatever
name seems like a good idea - conflicts aren't such a problem.

But how can we tell the difference???

Well, we could look in /etc/fstab (unless the same people who think
/etc/mdadm.conf is old fashioned manage to get rid of /etc/fstab as
well).

How about this:
  A name is 'local' if:
    it is associated with the array via mdadm.conf or
    it is associated with this host via 'homehost' 
  A name is 'non-mobile' if:
    it is associated with some use in /dev/fstab

Then if a name is either 'local' or not 'non-mobile', then we feel free to
use it as it stands, otherwise we add a _N suffix.
I think this is fairly close to using 'my' rules for things listed in
/etc/fstab, and 'your' rules for everything else.

This is tempting, but feels like it might be a bit fragile.
Does anything other than /etc/fstab depend on device names to
find things that are stored on devices?

One fragility would appear when running "mdadm -As" in an initrd.
You might not have an /etc/fstab at all, so everything might get
assembled using the wrong set of rules.

Maybe there is a safe way to detect "in initrd" and impose the
conservative rules in that case.

> 
> > Note that 0.90 metadata does contain homehost information to some
> > extent.  When homehost is set, the last few bytes of the uuid is set
> > from a hash of the homehost name.  That makes it possible to test if a
> > 0.90 array was created for 'this' host, but not to find out what host
> > it was created for.  So the above expedient won't work for 0.90
> > arrays, but the rest of the homehost concept (including any possible
> > 'homehost=any' option) does.
> >
> > You note that arrays with no homehost are treated as foreign with not
> > always being a good thing.  In 3.0, homehost is no longer optional.
> > If it is not explicitly set, it will default to `uname -n`.  So newly
> > created arrays will not suffer from this problem.  Arrays created with
> > mdadm 2.x do.  They can be 'upgraded' with
> >    --assemble --update=homehost
> > which is a suggestion that should be put in the man page.
> 
> This is a bad idea, and just reinforces my thought that we shouldn't  
> be paying attention to homehost.  Amongst the most important aspects  
> are machines that are booted up, installed, raid arrays created during  
> install, then shut down and moved, likely changing dhcp hostnames in  
> the process.  Now all your homehosts belong to some hostname in some  
> IT guys install network instead of in your final network.  At install  
> time, it's actually fairly common that the hostname is not yet set,  
> especially at raid array creation time.

But it should be fairly straight forward for the IT guys to arrange
that an mdadm.conf creates created which record the UUID of the array.
If the UUID is in mdadm.conf, you don't need homehost.

> 
> > Your idea of allowing the names "/dev/md0" and "md0" to connect with  
> > the
> > minor number '0' in the same way that the name "0" does is a good
> > one.  I have implemented that.
> >
> > I think I am leaning towards 'homehost=any' rather than 'homehost=*'
> > and will implement that. (No one would have a computer called 'any'
> > would they?).
> >
> > Thanks again for your input.
> 
> No problem.


Maybe a summary is in order.
We have:

 A - arrays that clearly belong on 'this' machine.  Either they are
     unambiguously listed in mdadm.conf, or they container homehost
     information that ties them to this computers.
 B - arrays that explicitly list another host in their metadata
 C - arrays that don't explicitly list a host.

and

 a - devices name that are explicitly record, e.g. in /etc/fstab
 b - device name that are not explicit used and so are only
     interesting to people.
  
We have:

 1 - boot time, when we want to be cautious about not assembling
    the wrong thing
 2 - normal run time when we have mounted all the really important
    filesystems and  we can be less cautious.

and we have:

 i  - cases when we want to explicitly not assemble certain arrays,
      such as SAN environments
 ii - cases when we want to assemble anything that appears

And various combinations that different people feel strongly about.
And the question is:  can we actually please all the people all the
time?

I think that if we can make a reliable and meaningful distinction
between 1 and 2, and between a and b,  and if we assemble only A in
case 1, and never assemble 'a' which is not 'A', and if we support
disabling of autoassembly for everything, or specific metadata types,
or specific arrays, in mdadm.conf - then we come pretty close.

Does anyone have thoughts on the 1 vs 2 distinction?? or the a vs b
distinction. 

I'm not sure that the B vs C distinction is of any value, but I
thought I would mention it for completeness.

Thanks,
NeilBrown
