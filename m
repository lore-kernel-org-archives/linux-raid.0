From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch 00/17] Autorebuild
Date: Mon, 13 Dec 2010 11:21:02 +1100
Message-ID: <20101213112102.4a39c1b3@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
	<20101122131644.6ba971f2@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03A1F@irsmsx504.ger.corp.intel.com>
	<20101123123417.09397400@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D174BA9762@irsmsx503.ger.corp.intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010E24D4A4@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E24D4A4@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

On Thu, 9 Dec 2010 11:40:43 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> Back to spares and domains...
> 
> > > > Note that we don't look at domains at all when we add a disk with
> > > spare metadata. Here it is indeed very much needed.
> > > > When someone creates some arrays and adds some spares, additionally
> > > defines domains to keep all related disks together, then he may be
> > > disappointed seeing that after reboot all spares end up in one
> > > container anyway. This happens for imsm and because of this issue
> > some
> > > spare that was meant for a different array may be used in the first
> > > array from config instead (all spares will be added there regardless
> > of
> > > domains).
> > > >
> > >
> > > Presumably is required for both -I and -A.
> > > Normally when assembling an array we ignore domains because if two
> > > devices
> > > claim to be in an array, then they need to be assembled together no
> > > matter
> > > what domains say.
> > > But for truly global spares, the metadata doesn't tell us much, so we
> > > only
> > > add such a spare to an array for which the domain says it is OK.
> 
> The problem is: we don't know the domain of an array until it is fully assembled
> (we know all devices in it).
> 
> So in Assembly we can either
> 	- mark the spares and try them later (when choosing devices for an array we
> 	skip spares in the first run and add a second run choosing
> 	spares for an array with domain check against all members found in first run)
> 	this could be done with uuid_match_any for spares.
> or
> 	- put spares in separate container and let Monitor take them out when they are needed.
> 	Here spares can't match any array. 
> 
> In both cases we must stop giving all imsm spares the uuid of the first array from config.
> 
> > >
> > > This is a little awkward for -I as if we get a spare first we have no
> > > idea
> > > what to do with it.
> > > I think we had an idea once of having a container for global spares.
> > > We
> > > could proceed with that, putting spares in that container as they are
> > > found.
> 
> This is easily achieved for Incremental by just giving one uuid to all imsm spares.
> This uuid cannot be used by any array. Probably just 0:0:0:0 would do.
> This solution requires adding a special case to
> Assemble or else no spares will be assembled.
> 
> If uuid_match_any is used for spares in Incremental then we don't know where to add them and exit.
> We could take the list of all arrays from mdstat (not config) and try matching domains 
> but then the final result will depend on the order of devices as some arrays may appear later
> and some may not have complete set of devices when we look at the spare.
> 
> Probably the simplest solution is to put all imsm spares in separate container.
> We don't risk then that any of them will be used in an array that is in other domain
> and Monitor can always move them to their domain when needed. 
> Monitor could also clean out this container when starting, even if there were no degraded arrays.
> 
> > > and maybe have Monitor() move these spares to an active container if
> > > one is
> > > found with a domain match.  Maybe?
> > 
> > Sounds good. So after Monitor initial run all spares fall in the right
> > container, and the ones left will have no match.
> > Maybe it is easier then changing Incremental and Assembly to look for
> > right container.
> 
> Assembly would still require modification.
> 
> > Once we have presented two phase assembly that solved that problem
> > (adding spares after all disks are placed in containers).
> 
> This added spares where they should be. But would require dealing with spares properly also in Incremental.
> Or should we try to do the right thing in Assemble but throw all imsm spares into one container in Incremental?
> What do you think?
> 
> Anna
> 

I like the idea of using a uuid of 0:0:0:0 for the container of spares.
There might need to be some subtleties in there to ensure spares with
different metadata stay separate, but I doubt that would be much of a
complication.

I don't know what you mean by trying to "do the right thing in Assemble".
It isn't clear that there is always one correct place to put a spare, though
there could be several suitable places.  So you could do "a right thing", but
not necessarily "the right thing" ??


While I like the idea of always having a separate container for all spares, I
see one problem with it.
It should work fine when using --incremental or auto assembly (-As), but if
you explicitly identify an array to start, it would be started without any
spares which might not be what you would expect.

Assemble already has a mechanism to collect all devices that could possibly
be part of an array, and then to reject those that don't fit - typically
because there is another device which claims the same slot but has a newer
event count.

We could use the same mechanism to include any global spare found into an
array being assembled.  Then once we are nearly ready to go, we determine the
domain of the array based on the domains of the non-spares and reject any
spares that don't match that domain.  I think this is similar two the
two-pass approach that was suggested previously, but fits more cleanly into
the existing infrastructure.
This would me that any spare would be associated with the first array to be
assembled for which it was compatible.  This is a little non-deterministic,
but I don't think that is a problem.

For --incremental we would still need global spare to go into a separate
container, though when it comes time to start an array, would could at that
point migrate spares from the spare-container to the new array...

I suggest we start out by just having a single container for imsm spares and
make sure that --monitor can move devices out of there as required.  Once
that works reliably we can worry about making the unusual cases work better,
and possibly migrating spares more proactively.

NeilBrown

