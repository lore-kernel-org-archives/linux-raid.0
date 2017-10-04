From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Wed, 4 Oct 2017 19:30:59 +0200
Message-ID: <20171004173059.GB3181@lazy.lzy>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
 <874ls0s7un.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
 <87lgkr3fgj.fsf@notabene.neil.brown.name>
 <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
 <076977d4-dfae-e8d3-7606-29e838f422ec@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <076977d4-dfae-e8d3-7606-29e838f422ec@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: NeilBrown <neilb@suse.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 04, 2017 at 01:23:02PM +0200, Artur Paszkiewicz wrote:
> On 10/04/2017 01:02 PM, Artur Paszkiewicz wrote:
> > Applications like mdadm can use this to hide/unhide their component
> > devices.
> 
> And here is an example patch for mdadm. It adds options to manually hide
> or unhide the component devices:
> 
> mdadm --hide-components /dev/md0
> mdadm --unhide-components /dev/md0

This seems to me already quite sensible.

> 
> And an option for mdadm.conf that automatically hides the array's member
> disks when assembling and when new disks are added:
> 
> ARRAY /dev/md/0  metadata=1.2 UUID=c2c4f8c6:cd775924:9cb2cc62:88fa45bd
> 	name=linux-ns31:0 hide-components=yes
> 
> Hidden disks (by mdadm --hide-components or by config) should unhide
> when the array is stopped or disks are removed. It only works for whole
> devices, not partitions.

Well, this, on the other hands, it makes
it not really useful.

Furthermore, how about "cat /proc/mdstat"?
Will this show what? In case of hidden components.

Thanks,

bye,

-- 

piergiorgio
