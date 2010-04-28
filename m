From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: More Hot Unplug/Plug work
Date: Wed, 28 Apr 2010 17:08:09 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
References: <4BD714A3.9020801@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD714A3.9020801@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Doug Ledford [mailto:dledford@redhat.com]
> Sent: Tuesday, April 27, 2010 6:45 PM
> To: Linux RAID Mailing List; Neil Brown; Labun, Marcin; Williams, Dan J
> Subject: More Hot Unplug/Plug work
> 
> So I pulled down Neil's git repo and started working from his hotunplug
> branch, which was his version of my hotunplug patch.  I had to do a
> couple minor fixes to it to make it work.  I then simply continued on
> from there.  I have a branch in my git repo that tracks his hotunplug
> branch and is also called hotunplug.  That's where my current work is
> at.
> 
> What I've done since then:
> 
> 1) I've implemented a new config file line type: DOMAIN
>    a) Each DOMAIN line must have at least one valid path= entry, but
> may
>       have more than one path= entry.  path= entries are file globs and
>       must match something in /dev/disk/by-path

DOMAIN is defined per container or raid volume for native metadata.
Each DOMAIN can have more than one path, so actually list of path define if a given disk belongs to domain or not. 
Do you plan to allow for the same path to be assigned to different containers (so path is shared between domains)?
If so the domains will have some or all paths overlapped, and some containers will share some paths.
Going further, thus causes that a new disk can be potentially grabbed by more than one container (because of shared path).
For example:
DOMAIN1: path=a path=b path=c
DOMAIN2: path=a path=d
DOMAIN3: path=d path=c
In this example disks from path c can appear in DOMAIN 1 and DOMAIN 3, but not in DOMAIN 2.
So, in case of Monitor, sharing a spare device will be per path basis.
The same for new disks in hot-plug feature.


In your repo domain_ent is a struct that contains domain paths.
The function arrays_in_domain returns a list of mdstat entries that are in the same domain as the constituent device name.
(so it requires devname and domain as input parameter).
In which case two containers will share the same DOMAIN?
It seems that this function shall return a list of mdstat entries that share a path to which a devname device belongs.
So, a given new device is tried to be grabbed by a list of a containers (or native volumes).


Can you send a config file example?

Marcin Labun

