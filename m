From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] "--assemble --scan" support for imsm
Date: Tue, 4 Nov 2008 21:52:12 +1100
Message-ID: <18704.10588.526784.38341@notabene.brown>
References: <1225230241.5778.26.camel@dwillia2-linux.ch.intel.com>
	<18696.10925.969583.445231@notabene.brown>
	<e9c3a7c20810290912k6530790dv5cf7f6db8ff40389@mail.gmail.com>
	<18697.11562.810718.957829@notabene.brown>
	<1225667752.14396.22.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Sunday November 2
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday November 2, dan.j.williams@intel.com wrote:
> On Wed, 2008-10-29 at 20:42 -0700, Neil Brown wrote:
> > To fit the assembly of a specific member of a container into this
> > model, we need to have the 'container' in the list of available
> > devices.
> > If the identity specifies 'container=whatever' then we clearly select
> > all devices which match that.  You would expect at exactly one - the
> > container.  You would then need to call ->container_content on that
> > container and find the correct member array which matches the
> > 'member=' specifier (or any other specifier there might be?)
> > 
> > Exactly how updates and "--force" are passed though would need to be
> > sorted out.
> > Then the devices in the selected array from ->container_content could
> > be passed to sysfs_add_disk and the array started.
> > 
> > Auto-assembly would discover that the first unused-so-far device was a
> > container, and would need to load the list of arrays and assemble the
> > first one that was not yet assembled.
> > 
> 
> I had a go at this, and the result is pushed out to my scratch-devel
> branch.

Thanks.  I took your code, kept some bits, fixed some bits, rewrote
other bits and completely replaced some more :-)  And added some of my
code too.

I've just pushed the result to my devel-3.0 branch

  git pull git://neil.brown.name/mdadm devel-3.0

It get a clean "make everything" and the self tests all run (I hope -
it's late and I cannot wait for the final run).

Tomorrow I'm going to hack at the man page, and write some more test
scripts.

With the current code

  mdadm -As

should find and assemble all of your arrays.  And give fairly useful
names.

I haven't included your

   Let symlinks to standard devices count as standard names

patch because I don't think I agree with it, and I don't think it is
needed any more.

I also have left out your

     imsm: match_home(), document why it is stubbed out
    
because I don't understand.  Maybe some more words about how
'family_num' can distinguish between "Local" and "Foreign". ??

Thanks heaps,

NeilBrown
 
