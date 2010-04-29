From: Neil Brown <neilb@suse.de>
Subject: Re: More Hot Unplug/Plug work
Date: Thu, 29 Apr 2010 12:37:17 +1000
Message-ID: <20100429123717.2144a341@notabene.brown>
References: <4BD714A3.9020801@redhat.com>
	<905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
	<4BD874CB.5040803@redhat.com>
	<905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>
	<4BD8A336.7080309@redhat.com>
	<20100429110153.7148bb9b@notabene.brown>
	<4BD8DEB1.40801@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD8DEB1.40801@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Wed, 28 Apr 2010 18:19:45 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Neil Brown wrote:
> > I'm not sure how this fits with imposing platform constraints.
> > As platform constraints are closely tied to metadata types, it might be OK
> > to have a metadata-specific tags (imsm=???) and leave to details to the
> > metadata handler???
> > 
> > Dan: help me understand these platform constraints: what is the most complex
> >   constraint that you can think of that you might want to impose?
> 
> At this point we really only need one constraint: prevent controller 
> spanning.  If for example I take an existing imsm member off of ahci and 
> reattach it via a usb-to-sata enclosure mdadm needs a policy to prevent 
> associating that drive with anything on ahci.
> 
> In a pinch this policy can be disabled, but you wouldn't want to rebuild 
> across usb or any other controller because the option-rom only talks 
> ahci and will mark the drive missing.
> 
> So something like DOMAIN spanning=imsm, to tell mdadm to follow imsm 
> rules for this domain.  Where 'spanning' is policy tag??
>

Thanks.

So we have two different ideas here.

1/ A given set of devices (paths) are all attached to the one controller.
2/ A given array is not allowed to span controllers

The first statement is somewhat similar to a statement about sparegroups.
It groups devices together is some way.

The second is a policy statement, and is metadata specific to some extent.
If I create a native-metadata array using the controller, then adding other
devices from a different controller is a non-issue.  It is only when an
IMSM array is created that it is an issue (and then - only if the array is to
be used for boot for for multi-boot).

So the ARRAY line could have "exclusive-group=foo" where 'foo' is a group
name similar to those used for 'spare-group='
But that isn't much fun for auto-detect and auto-assembly.

Maybe we want to extend the 'auto' line.  It gives policy on a per-metadata
basis. Maybe:

  POLICY auto-assemble  +1.x -all
  POLICY same-group  imsm

where 'same-group' means that all the devices in an array must be in the
same spare-group.  The 'domain' lines assign spare-groups to devices.

Maybe "same-group" could be "same-$tag" so we could have different tags
for different metadatas....

Is this working for anyone else, or have I lost the plot??

NeilBrown
