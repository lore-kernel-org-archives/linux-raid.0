From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: More Hot Unplug/Plug work
Date: Wed, 28 Apr 2010 19:34:11 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>
References: <4BD714A3.9020801@redhat.com>
 <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
 <4BD874CB.5040803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD874CB.5040803@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

> > Going further, thus causes that a new disk can be potentially grabbed
> by more than one container (because of shared path).
> > For example:
> > DOMAIN1: path=a path=b path=c
> > DOMAIN2: path=a path=d
> > DOMAIN3: path=d path=c
> > In this example disks from path c can appear in DOMAIN 1 and DOMAIN
> 3, but not in DOMAIN 2.
> 
> What exactly is the use case for overlapping paths in different
> domains?

OK, makes sense.
But if they are overlapped, will the config functions assign path are requested by configuration file
or treat it as misconfiguration?
So, do you plan to make changes similar to incremental in assembly to serve DOMAIN?
Should an array be split (not assembled) if a domain paths are dividing array into two separate DOMAIN?

>  I'm happy to rework the code to support it if there's a valid use
> case, but so far my design goal has been to have a path only appear in
> one domain, and to then perform the appropriate action based upon that
> domain.
What is then the purpose of metadata keyword?
My initial plan was to create a default configuration for a specific metadata, where user specifies actions 
but without paths letting metadata handler to use default ones.
In your description, I can see that the path are required.

> add it to.  Only if there are no degraded arrays would we add it as a
> spare to one of the arrays (non-deterministic which one).  If we add it
> as a spare to one of the arrays, then monitor mode can move that spare
> around as needed later based upon the spare-group settings.  Currently,
> there is no correlation between spare-group and DOMAIN entries, but
> that might change.

A spare should go to any container controlled by mdmon, so any that contains redundant volumes.

> 
> > So, in case of Monitor, sharing a spare device will be per path
> basis.
> 
> Currently, monitor mode still uses spare-group for controlling what
> arrays can share spares.  It does not yet check any DOMAIN information.

Yes, and I am now adding support for domains in monitor and for spare-groups for external metadata.

> 
> > The same for new disks in hot-plug feature.
> >
> >
> > In your repo domain_ent is a struct that contains domain paths.
> > The function arrays_in_domain returns a list of mdstat entries that
> are in the same domain as the constituent device name.
> > (so it requires devname and domain as input parameter).
> > In which case two containers will share the same DOMAIN?
> 
> You get the list of containers, not just one.  See above about
> searching the list for a degraded container and adding to it before a
> healthy container.
OK.

