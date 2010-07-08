From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: A policy frame work for mdadm (incorporating domains and
 hotplug and such)
Date: Thu, 8 Jul 2010 08:54:01 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11F5E93E3@irsmsx503.ger.corp.intel.com>
References: <66C59AD0932712458090B447266D638CD69A3E95@irsmsx504.ger.corp.intel.com>
	<20100512070231.17342f29@notabene.brown>	<4BE9D7DC.6000306@intel.com>
	<20100512132624.7a189995@notabene.brown>	<4BEAF416.5050509@intel.com>
	<66C59AD0932712458090B447266D638CD6A81248@irsmsx504.ger.corp.intel.com>
	<4BEC941A.8070508@intel.com>
	<905EDD02F158D948B186911EB64DB3D11E33E9DE@irsmsx503.ger.corp.intel.com>
	<66C59AD0932712458090B447266D638CD6D80FFF@irsmsx504.ger.corp.intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246FDA55FA48@irsmsx504.ger.corp.intel.com>
	<20100629113727.197a2002@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F5235D9@irsmsx503.ger.corp.intel.com>
	<4C2B97E3.2080309@intel.com>	<20100701165007.4d0d51f7@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D11F5E88DC@irsmsx503.ger.corp.intel.com>
 <20100707084011.53cabc11@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100707084011.53cabc11@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, Doug Ledford <dledford@redhat.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Healey, Douglas D" <douglas.d.healey@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Is there a chance to see policy framework code?
Thanks,
Marcin

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Wednesday, July 07, 2010 12:40 AM
> To: Labun, Marcin
> Cc: Williams, Dan J; Doug Ledford; Czarnowska, Anna; Hawrylewicz
> Czarnowski, Przemyslaw; Ciechanowski, Ed; Healey, Douglas D; Neubauer,
> Wojciech; linux-raid@vger.kernel.org
> Subject: Re: A policy frame work for mdadm (incorporating domains and
> hotplug and such)
> 
> On Tue, 6 Jul 2010 15:03:07 +0100
> "Labun, Marcin" <Marcin.Labun@intel.com> wrote:
> 
> >
> > > -----Original Message-----
> > > From: Neil Brown [mailto:neilb@suse.de]
> > > Sent: Thursday, July 01, 2010 8:50 AM
> > > To: Williams, Dan J; Doug Ledford
> > > Cc: Labun, Marcin; Czarnowska, Anna; Hawrylewicz Czarnowski,
> > > Przemyslaw; Ciechanowski, Ed; Healey, Douglas D; Neubauer,
> Wojciech;
> > > linux-raid@vger.kernel.org
> > > Subject: A policy frame work for mdadm (incorporating domains and
> > > hotplug and such)
> >
> > [cut]
> >
> >
> > >
> > >  Point 2 is that policy revolves primarily around devices (rather
> than
> > >  arrays) and to a lesser extent around metadata types.
> > >  It is devices that are migrated, devices that arrays are built
> from,
> > > devices
> > >  that are automatically made into spares etc.
> > >  Metadata types often encode some specific policy in the metadata,
> so
> > > they
> > >  need some fairly strong role in the policy framework too.  Often
> the
> > >  metadata type is like a parameter to a policy.  "You can
> incorporate
> > > this
> > >  device in any imsm array".
> > >
> > >  So Abstraction 1 is a "Policy statement".
> > >
> > >  A policy statement applies to a particular device, possibly in the
> > > context
> > >  of a particular metadata, and asserts that a particular name has a
> > >  particular value.
> > >      action=spare (ddf1)
> > >  might be a policy statement about a device.  It says that where
> ddf1
> > >  metadata is involved, the device can be made a hot-spare when it
> is
> > >  hot-plugged.
> > >      auto=homehost (0.90)
> > >  might be another which says that auto-assembly may use a non-
> > > disambiguated
> > >  name (no trailing _NN) when assembling this device into a
> > > metadata=0.90
> > >  array providing the homehost information in the metadata matches
> this
> > > host.
> > >
> > >  A statement might not have any metadata type associated.
> > >      action=ignore
> > >  applies irrespective of metadata type.
> > >
> > >  The policy names that I currently envisage are:
> > >
> > >    action=  ignore, include, spare, force-spare
> > >
> > >      which covers the hotplug actions that --incremental might
> perform.
> > >
> > >    auto=  yes, homehost, no
> > >
> > >      which covers the functionality currently in the AUTO
> mdadm.conf
> > > line
> > >
> > >    domain=  arbitrary-string
> > >
> > >      This provides the 'domain' isolation functionality.
> > >      The semantics I have in mind (and the precise details here are
> > > fairly
> > >      important so this cannot be changed lightly) are:
> > >        A device can have a number of domains, possibly from various
> > > sources.
> > >        An array can have a number of domains, from the devices plus
> > > from
> > >        spare-group
> > >
> > >       A device may be attached to an array if all of the domains of
> the
> > > device
> > >       are also domains of the array.  The array may have extra
> domains.
> > > The
> > >       device may not.
> > >
> > >       This requires that if there are overlapping domains, they
> must
> > > properly
> > >       nest. i.e. the intersection of two domains must be empty, or
> one
> > > of the
> > >       domains.  It might make sense to have a domain 'global' which
> all
> > >       devices have, and some other domains which just subsets have.
> > >
> >
> > What is the usage of domain name?
> 
> They determine whether a device may be attached to an array.
> Both the device and the array have domain names.
> A device may only be attached to an array if all of the domain names
> it has also belong to the array.
> 
> The exact mechanism for assigning domain names to arrays is not
> finalised,
> but the first-estimate is that it is the union of the domain names of
> all
> current members.
> 
> > I understand that each policy line can have a domain token.
> 
> "can" yes.  However some policy lines may not.
> 
> > In this case each device that matches "match" keyword gains another
> domain.
> > But how it can use it?
> 
> The domains will typically be subset one of another.
> 
> We might have three sets of devices.
> All are given domain=global
> First set is given domain=first
> second set is given domain=second
> 
> Then we create two arrays, one from devices in the first set, one from
> devices in the second set.
> Now any spare in the first set can be use in the first array
> Any spare in the second set can be used in the second array
> Any spare in the third set can be used in any array.
> 
> >
> > If each policy line has its own domain, so we have explicit relation
> > one-to-one between POLICY line and domain name.
> 
> No, each policy line does not its own domain.  Some do, some don't.
> 
> > Can different POLICY line share the same domain name?
> 
> Definitely.
> 
> >
> > Another questions is domain intersection.
> > It seems to me that the plan is test if "matching" keyword intersect.
> 
> I don't currently foresee any explicit testing for intersection.
> Certainly some devices will match several policy lines, and those
> policy
> lines might make related statements - e.g. that might both give
> different
> domains to the device, or they might even give the same domain to a
> device.
> 
> In generally policy can accumulate.  As mentioned above having multiple
> domains associated with a device is perfectly fine.
> 
> I'm not sure yet how "action=" policies would accumulate.  I suspect
> that the
> most permissive would apply, but I'm not satisfied that I have explored
> all
> the possibilities yet so I'm not sure.
> 
> > In case domain would have non-empty intersection if the path globs
> overlap?
> 
> Yes, domains can have non-empty intersections.  This will normally mean
> that
> one is a subset of another, though that isn't strictly necessary.
> 
> > What else? Type (disk, partition) Metadata name?
> 
> Sorry, I don't know what you are asking here.
> 
> >
> >
> > Matching multiple policy lines that define conflicting policy names
> assignment is invalid configuration, right?
> > (for instance one policy defines action=ignore and the other include
> and disk matches both POLICY line)
> > How to deal with it?
> 
> Good question.
> I'm beginning to think that "action=ignore" isn't something we really
> want.
> It seems appropriate at first glance, but it is inconsistent with the
> other
> possible actions as it forbids rather than allows.
> So we might just discard 'action=ignore'.  If we don't want to consider
> certain devices for md at all, then tell udev not to run mdadm -I on
> them.
> 
> That leave
>   action=include    # include this in the array if it appears to be a
> current
>                     # member
>   action=re-add     # include this in the array if it appears to be a
> current
>                     # member or a member that was recently removed
>   action=spare      # include this if either of the above apply, or if
> it is
>                     # a bare device, make it a spare
>   action=force-space# as above, but if that doesn't succeed, make is a
> spare
>                     # anyway
> 
> Then if multiple action policies apply to the same device, we simply
> take
> the most permissive - the last one in the above list.
> 
> I'm actually wondering if these 'action's should apply during --
> assemble as
> well.
> Normally Assemble will only include devices that are current members.
> Anything that is a bit old is rejected (by the kernel). i.e.
> action=include.
> Probably if action=re-add were in-force, then those rejected devices
> should be
> immediately re-added.
> Can that be extended to other devices? If there are other devices which
> don't
> have a domain conflict and which are bare and have action=spare, should
> they
> be immediately added as spare devices?
> 
> I'm not at all sure about force-space though... it seems just too easy
> for it
> to destroy data.
> 
> Thanks,
> NeilBrown
