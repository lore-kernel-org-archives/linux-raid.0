From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [Patch 00/17] Autorebuild
Date: Thu, 9 Dec 2010 11:40:43 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E24D4A4@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
	<20101122131644.6ba971f2@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03A1F@irsmsx504.ger.corp.intel.com>
 <20101123123417.09397400@notabene.brown>
 <905EDD02F158D948B186911EB64DB3D174BA9762@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <905EDD02F158D948B186911EB64DB3D174BA9762@irsmsx503.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

Back to spares and domains...

> > > Note that we don't look at domains at all when we add a disk with
> > spare metadata. Here it is indeed very much needed.
> > > When someone creates some arrays and adds some spares, additionally
> > defines domains to keep all related disks together, then he may be
> > disappointed seeing that after reboot all spares end up in one
> > container anyway. This happens for imsm and because of this issue
> some
> > spare that was meant for a different array may be used in the first
> > array from config instead (all spares will be added there regardless
> of
> > domains).
> > >
> >
> > Presumably is required for both -I and -A.
> > Normally when assembling an array we ignore domains because if two
> > devices
> > claim to be in an array, then they need to be assembled together no
> > matter
> > what domains say.
> > But for truly global spares, the metadata doesn't tell us much, so we
> > only
> > add such a spare to an array for which the domain says it is OK.

The problem is: we don't know the domain of an array until it is fully assembled
(we know all devices in it).

So in Assembly we can either
	- mark the spares and try them later (when choosing devices for an array we
	skip spares in the first run and add a second run choosing
	spares for an array with domain check against all members found in first run)
	this could be done with uuid_match_any for spares.
or
	- put spares in separate container and let Monitor take them out when they are needed.
	Here spares can't match any array. 

In both cases we must stop giving all imsm spares the uuid of the first array from config.

> >
> > This is a little awkward for -I as if we get a spare first we have no
> > idea
> > what to do with it.
> > I think we had an idea once of having a container for global spares.
> > We
> > could proceed with that, putting spares in that container as they are
> > found.

This is easily achieved for Incremental by just giving one uuid to all imsm spares.
This uuid cannot be used by any array. Probably just 0:0:0:0 would do.
This solution requires adding a special case to
Assemble or else no spares will be assembled.

If uuid_match_any is used for spares in Incremental then we don't know where to add them and exit.
We could take the list of all arrays from mdstat (not config) and try matching domains 
but then the final result will depend on the order of devices as some arrays may appear later
and some may not have complete set of devices when we look at the spare.

Probably the simplest solution is to put all imsm spares in separate container.
We don't risk then that any of them will be used in an array that is in other domain
and Monitor can always move them to their domain when needed. 
Monitor could also clean out this container when starting, even if there were no degraded arrays.

> > and maybe have Monitor() move these spares to an active container if
> > one is
> > found with a domain match.  Maybe?
> 
> Sounds good. So after Monitor initial run all spares fall in the right
> container, and the ones left will have no match.
> Maybe it is easier then changing Incremental and Assembly to look for
> right container.

Assembly would still require modification.

> Once we have presented two phase assembly that solved that problem
> (adding spares after all disks are placed in containers).

This added spares where they should be. But would require dealing with spares properly also in Incremental.
Or should we try to do the right thing in Assemble but throw all imsm spares into one container in Incremental?
What do you think?

Anna


