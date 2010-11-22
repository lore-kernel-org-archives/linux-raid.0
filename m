From: Neil Brown <neilb@suse.de>
Subject: Re: Devel 3.2 branch issues
Date: Mon, 22 Nov 2010 14:29:53 +1100
Message-ID: <20101122142953.7934c8ca@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE90089@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BE90089@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Fri, 19 Nov 2010 12:43:20 +0000
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> Hi Neil,
> Our validation team have reported problems with assembly on the devel 3.2 branch.
> I have verified that currently it is not possible to assemble any array.
> 
> Patch: Assemble - avoid including wayward devices
> It does not affect native metadata but breaks assembly of external arrays.
> Only one disk is assembled for any raid level. 

Thanks - fixed.

> 
> After patch: super_by_fd: return subarray info explicitly
> Assembly becomes much slower.

Yep .. I was calling 'strcpy' with a NULL as the source - bad.
Fixed, though a subsequent patch removed the strcpy anyway.


> 
> Patch: Assemble: small cleanup of error checking
> Breaks assembly for all metadata types. Nothing assembles after it is applied.
> 

I'm not sure this is true, but the test/03* tests of assembly certainly fail.
I've fixed that.  Thanks.


> These are just early modifications of Assemble.c. The impact of further changes
> can't be verified at the moment. 
> Are you aware of the above issues? This is stopping our further validation.
> I also mentioned issues with Incremental in previous mail.
> When are you planning to submit the rest of modified autorebuild code?

Shortly .. 

by the way, some of the changes in you of the patches you sent have not been
included in any form.  They include:

- the getinfo_super_disks method.  I couldn't see why you need this.  All the
  info about the state of the arrays should already be available.
  If there is something that you need that we don't have, please explain and
  we can see how best to add it back in.

- min_active_disk_size_in_array.  I don't think the minimum current size is
  really a good guide.  I've kept the code for letting the metadata handler
  check the size, but anything beyond that should be done with domains I
  think.
  E.g have a domain '2G-or-greater' which is assigned to all 2G or greater
  devices.  Then anything smaller will automatically be excluded from arrays
  with those devices.

- The remove_from_super method.  As Dan pointed out there seems to be
  something wrong there so I chose to just leave it out for now.  If you
  could explain again what is needed, we can find the best way to add that
  functionality.

Thanks,
NeilBrown

