From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: A policy frame work for mdadm (incorporating domains and
 hotplug and such)
Date: Tue, 6 Jul 2010 15:03:07 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11F5E88DC@irsmsx503.ger.corp.intel.com>
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
	<4C2B97E3.2080309@intel.com> <20100701165007.4d0d51f7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100701165007.4d0d51f7@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>, Doug Ledford <dledford@redhat.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Healey, Douglas D" <douglas.d.healey@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Thursday, July 01, 2010 8:50 AM
> To: Williams, Dan J; Doug Ledford
> Cc: Labun, Marcin; Czarnowska, Anna; Hawrylewicz Czarnowski,
> Przemyslaw; Ciechanowski, Ed; Healey, Douglas D; Neubauer, Wojciech;
> linux-raid@vger.kernel.org
> Subject: A policy frame work for mdadm (incorporating domains and
> hotplug and such)

[cut]


> 
>  Point 2 is that policy revolves primarily around devices (rather than
>  arrays) and to a lesser extent around metadata types.
>  It is devices that are migrated, devices that arrays are built from,
> devices
>  that are automatically made into spares etc.
>  Metadata types often encode some specific policy in the metadata, so
> they
>  need some fairly strong role in the policy framework too.  Often the
>  metadata type is like a parameter to a policy.  "You can incorporate
> this
>  device in any imsm array".
> 
>  So Abstraction 1 is a "Policy statement".
> 
>  A policy statement applies to a particular device, possibly in the
> context
>  of a particular metadata, and asserts that a particular name has a
>  particular value.
>      action=spare (ddf1)
>  might be a policy statement about a device.  It says that where ddf1
>  metadata is involved, the device can be made a hot-spare when it is
>  hot-plugged.
>      auto=homehost (0.90)
>  might be another which says that auto-assembly may use a non-
> disambiguated
>  name (no trailing _NN) when assembling this device into a
> metadata=0.90
>  array providing the homehost information in the metadata matches this
> host.
> 
>  A statement might not have any metadata type associated.
>      action=ignore
>  applies irrespective of metadata type.
> 
>  The policy names that I currently envisage are:
> 
>    action=  ignore, include, spare, force-spare
> 
>      which covers the hotplug actions that --incremental might perform.
> 
>    auto=  yes, homehost, no
> 
>      which covers the functionality currently in the AUTO mdadm.conf
> line
> 
>    domain=  arbitrary-string
> 
>      This provides the 'domain' isolation functionality.
>      The semantics I have in mind (and the precise details here are
> fairly
>      important so this cannot be changed lightly) are:
>        A device can have a number of domains, possibly from various
> sources.
>        An array can have a number of domains, from the devices plus
> from
>        spare-group
> 
>       A device may be attached to an array if all of the domains of the
> device
>       are also domains of the array.  The array may have extra domains.
> The
>       device may not.
> 
>       This requires that if there are overlapping domains, they must
> properly
>       nest. i.e. the intersection of two domains must be empty, or one
> of the
>       domains.  It might make sense to have a domain 'global' which all
>       devices have, and some other domains which just subsets have.
> 

What is the usage of domain name? 
I understand that each policy line can have a domain token.
In this case each device that matches "match" keyword gains another domain. 
But how it can use it?

If each policy line has its own domain, so we have explicit relation 
one-to-one between POLICY line and domain name.
Can different POLICY line share the same domain name?

Another questions is domain intersection. 
It seems to me that the plan is test if "matching" keyword intersect. 
In case domain would have non-empty intersection if the path globs overlap? 
What else? Type (disk, partition) Metadata name?


Matching multiple policy lines that define conflicting policy names assignment is invalid configuration, right?
(for instance one policy defines action=ignore and the other include and disk matches both POLICY line)
How to deal with it? 




Thanks,
Marcin Labun



