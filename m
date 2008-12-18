From: Neil Brown <neilb@suse.de>
Subject: Re: [mdadm git pull] platform support v2 and other fixes
Date: Thu, 18 Dec 2008 17:07:20 +1100
Message-ID: <18761.59544.163344.177425@notabene.brown>
References: <1228786157.9780.19.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Monday December 8
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday December 8, dan.j.williams@intel.com wrote:
> Hi Neil,
> 
> So here is a second attempt at platform support.  I asked around about
> scanning for the option-rom and the solution I settled on was to port
> the kernel's "Adapter ROM" detection code to userspace (probe_roms.c
> from arch/x86/kernel/probe_roms_32.c).  This at least makes mdadm bug
> compatible with the kernel, and avoids scanning the entire region
> indiscriminately.
> 
> Create support got two major fixes:
> 1/ calculating a common start offset by merging get_extents() results
> 2/ explicitly passing the target member disks in the metadata update
> message
> 
> Despite the platform support and these fixes I am still investigating
> whether mdadm can create configurations that the option-rom does not
> understand.  Stay tuned...
> 
> Lastly I added a regression test to stress the overlapping create case,
> it adds some infrastructure for tests to define their own environment.
> 
> As always, please have a look.

Thanks.
I confess I haven't read all of the details, but I've looked at the
"interesting" parts (for some value of 'interesting') and they seem to
make sense.
Pulled and pushed.

Thanks.
NeilBrown
