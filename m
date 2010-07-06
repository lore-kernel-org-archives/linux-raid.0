From: Neil Brown <neilb@suse.de>
Subject: Re: A policy frame work for mdadm (incorporating domains and
 hotplug and such)
Date: Tue, 6 Jul 2010 15:19:42 +1000
Message-ID: <20100706151942.668dffe1@notabene.brown>
References: <66C59AD0932712458090B447266D638CD69A3E95@irsmsx504.ger.corp.intel.com>
	<20100512070231.17342f29@notabene.brown>
	<4BE9D7DC.6000306@intel.com>
	<20100512132624.7a189995@notabene.brown>
	<4BEAF416.5050509@intel.com>
	<66C59AD0932712458090B447266D638CD6A81248@irsmsx504.ger.corp.intel.com>
	<4BEC941A.8070508@intel.com>
	<905EDD02F158D948B186911EB64DB3D11E33E9DE@irsmsx503.ger.corp.intel.com>
	<66C59AD0932712458090B447266D638CD6D80FFF@irsmsx504.ger.corp.intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246FDA55FA48@irsmsx504.ger.corp.intel.com>
	<20100629113727.197a2002@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F5235D9@irsmsx503.ger.corp.intel.com>
	<4C2B97E3.2080309@intel.com>
	<20100701165007.4d0d51f7@notabene.brown>
	<4C2C5145.7070003@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C2C5145.7070003@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Healey, Douglas D" <douglas.d.healey@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 01 Jul 2010 01:26:45 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On 6/30/2010 11:50 PM, Neil Brown wrote:
> >        This requires that if there are overlapping domains, they must properly
> >        nest. i.e. the intersection of two domains must be empty, or one of the
> >        domains.It might make sense to have a domain 'global' which all
> >        devices have, and some other domains which just subsets have.
> 
> You lost me here "or one of the domains..." must be a superset of the other?

Yes, it is the mathematician in me: precise and obscure...

If the domains (sets of devices) are A and B then

  A intersect B    is-an-element-of    { {} , A , B }
(empty or one of the domains)
so either they are disjoint or one is a subset of the other.

> 
> How do we a priori know which domain an array belongs to?  Will we 
> require them to be tagged (makes our job easier at the cost of some 
> configuration file maintenance for the administrator).  Taking the 
> domain == controller example, if a user identifies an array as 	 
> belonging to controller1 in the configuration file and later moves a set 
> of member devices to controller2 I assume we ignore those devices right?

I'm not sure.  If the user asks for something that doesn't make sense, how
brutal should we be?

My tendency would be to use domains mainly as a guide.  If the user
explicitly ask to violate domain constraints, we let them and give a
warning.  If the metadata explicitly states a relationship between two devices
that cannot be united without violating a metadata constraint, we obey the
metadata (with a warning).  But mdadm never violates a metadata constraint
without something that explicit.

Possibly a policy assertion could add that certain devices must always obey
all domain constraints.  This would turn those warnings into errors.

But it is only a tendency....

> 
> This would simplify things for the imsm assembly case because it 
> requires the array-to-domain association to be identified ahead of time 
> rather than arbitrarily autodetected by where we happen to find the 
> first array member.
> 
> If an assembly statement is ambiguous we fail and ask for the domain to 
> be clarified.
> 
> >    There is probably room for other policies like whether to start an
> >    incrementally assembled degraded array early, or wait until it is not
> >    degraded.  Maybe some policy of handling "prodigal device" situations where
> >    two halfs of a mirror both this they are "it" and the other is "not".
> >
> > By now Doug (hope your back is feeling better) will have noticed that
> > partitions haven't been mentioned yet.  So it is time for them.
> >
> > Point 3: partitions become a new metadata type (or types).
> >
> > If we want mdadm to ensure there is a MBR partition table on a device, then
> > provide a policy statement like
> >     action=spare (mbr)
> 
> Where the metadata type is determined by the current arrays in the 
> domain where the device was attached if I am following correctly.

In the example the metadata (mbr) is explicitly included in the policy.
If you had a policy which just said "action=space" without identifying a
metadata type then yes: if all the other devices in the same domain had a
common metadata type that would be used.

> 
> [..]
> >  Point 6:  We probably have platform policy too. I'm not really sure what
> >  this will involve, and what if anything needs to be explicit.  Maybe just
> >
> >      platform-policy  imsm
> >
> >  in mdadm.conf tell mdadm to query the platform and deduce some policy
> >  statements or police rules.
> 
> I don't know if we need to add platform policy to the configuration 
> file, maybe we can revisit this when we have a metadata format where 
> "RAID mode" cannot be disabled in the firmware.  For now the policies 
> enforced by the platform really are not optional (lest we confuse 
> firmware), so I'd just as soon not allow them to be configured.  The 
> mitigations are turn off raid mode or set the environment variable which 
> should tell you that you are doing something tricky.  I'll come back if 
> I think of a non-critical platform dependent policy.

OK, we'll leave that aspect for future decision.


> 
> [..]
> > The part of this that I'm least confident of is assigning domains to arrays.
> 
> It would be nice if every array came pre-tagged with what domain it 
> belongs, but that can't be a requirement.  Conversely users that don't 
> set up a domain will sometimes find one forced upon them by the 
> metadata.  On such a platform where there are hardware defined domains I 
> think it would be reasonable for the user to identify which domain is 
> the context for the action.
> 
> Like the following, (assuming an empty mdadm.conf) sda has imsm metadata 
> attached to ahci and sdb has imsm metadata, but is attached to usb.
> 
> 	mdadm -A /dev/md0 /dev/sda /dev/sdb
> 
> ...we fail with an error message like "/dev/sda was tagged as a member 
> of the ahci domain while /dev/sdb is only a member of the global domain, 
> aborting".
> 
> 	mdadm -A /dev/md0 /dev/sda /dev/sdb --domain ahci
> 
> ...would succeed with a message like "/dev/sdb is not a member of the 
> ahci domain, ignoring."

If someone actually has two such devices which do constitute a valid imsm
array then either:
 - they are trying recover some some sort of failure (copied a failing device
   to a spare usb device?) and don't want mdadm to get in their way. or
 - they explicitly created it that way and jumped any hurdles at that point.
 - something else I haven't thought of.

In the first two cases I would rather assemble the array and just give a
warning.

When creating such an array it might be appropriate to give some warning,
and require confirmation but I cannot quite think how that should look yet.

I'm toying with the idea of recording the domains of an array in the 'map'
file.   They would be assessed when assembling the array and updated when
a spare was added etc.  They would be the unions of the domains of all
component devices plus anything explicitly configured for the array.
Not sure how much this would help yet though.

Maybe if something were explicitly configured, we would ignore the domains of
the component devices (?).

Thanks,
NeilBrown


> 
> > Extracting a list of policy statements for each device sounds a bit
> > cumbersome.  Maybe if I cache enough bits of it, it will work nicely.
> >
> > Comments, as always, are most welcome.
> 
> Thanks for the thoughtful write up, as always.
> 
> --
> Dan

