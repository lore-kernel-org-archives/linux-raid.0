From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch 00/17] Autorebuild
Date: Mon, 22 Nov 2010 13:16:44 +1100
Message-ID: <20101122131644.6ba971f2@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Thu, 18 Nov 2010 23:14:49 +0000
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> Hi Neil,
> I started testing new code today. Just the Incremental part.
> 
> There are few problems:
> 1. Cookie file is cleared before it is read so spare-same-slot can't work. It should be just open for reading. (probably a typo)

Yes, just a typo.  Fixed.


> 2. Container uuid instead of subarray uuid is written in cookie file, so for ddf it may not be clear which subarray used the slot.

This is deliberate.  It is really up to the ddf spare-assignment handler (in
super-ddf ... though it isn't written yet) to decide which sub array gets
which part of the new disk.  If an admin wants more control they need to do
it at a different level - probably having separate ddf containers in separate
domains.

> 3. Incremental fail does not work for external metadata. Przemek's original patch did fail the disk in subarrays. Now Manage_subdevs tries to fail a disk in container while subarray is expected. Do you intend to change Manage_subdevs to take a container?

Yes... I didn't notice that change in the patch.  This is one of the reasons
I like each patch to just make one change.
I have added a new patch which fails all the contained arrays before removing
from the container (though I haven't tested it yet).


> 4. With spare-same-slot when there is a cookie and disk has no metadata then we probably shouldn't look at domains. Just add.
> 

I disagree.  We must always check domains.
Why do you think we should ignore domains in that case?

Thanks for the testing.  I'll push a new devel-3.2 out later today.

NeilBrown


