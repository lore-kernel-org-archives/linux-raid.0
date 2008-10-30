From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] "--assemble --scan" support for imsm
Date: Thu, 30 Oct 2008 14:42:34 +1100
Message-ID: <18697.11562.810718.957829@notabene.brown>
References: <1225230241.5778.26.camel@dwillia2-linux.ch.intel.com>
	<18696.10925.969583.445231@notabene.brown>
	<e9c3a7c20810290912k6530790dv5cf7f6db8ff40389@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Wednesday October 29
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday October 29, dan.j.williams@intel.com wrote:
> 
> What about container=<container uuid> as we can never really discern
> with certainty the name of the container device at
> ->brief_examine_super() time?

Yes, could do that.  It feels a bit ugly, but it probably makes sense.

But I've had another look at your 'provisional' thing and understand it
better and want to suggest some enhancements (Which might look like a
complete rewrite, but the important part of noticing the problem is
still yours :-)

You call Incremental_container from Assemble and that really isn't
right.  Each call to 'Assemble'  should assemble just one array, but
Incremental_container might assemble several.

Assemble() has the following basic structure:

 1/ walk through list of available devices determining which ones
    match the 'identity' of the required array.
 2/ Check the set of devices for consistency and make any updates that
    have been requested
 3/ Assemble the array from the selected devices, and start it.

With a slight variation for the 'auto-assemble' case wherein the
'identity' to match is taken from the first device that is found to be
part of an array that is not already assembled.

To fit the assembly of a specific member of a container into this
model, we need to have the 'container' in the list of available
devices.
If the identity specifies 'container=whatever' then we clearly select
all devices which match that.  You would expect at exactly one - the
container.  You would then need to call ->container_content on that
container and find the correct member array which matches the
'member=' specifier (or any other specifier there might be?)

Exactly how updates and "--force" are passed though would need to be
sorted out.
Then the devices in the selected array from ->container_content could
be passed to sysfs_add_disk and the array started.

Auto-assembly would discover that the first unused-so-far device was a
container, and would need to load the list of arrays and assemble the
first one that was not yet assembled.

I think that is the 'right' thing to do, but it seems like a lot of
work just for now, so I might leave it for a while and see if
something else occurs to me.

Thanks,
NeilBrown
