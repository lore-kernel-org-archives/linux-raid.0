From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Wed, 4 Oct 2017 17:18:09 -0400
Message-ID: <5716615d-ae85-8822-0c21-da4e85dcff00@turmel.org>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
 <874ls0s7un.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
 <87lgkr3fgj.fsf@notabene.neil.brown.name>
 <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
 <076977d4-dfae-e8d3-7606-29e838f422ec@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <076977d4-dfae-e8d3-7606-29e838f422ec@intel.com>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, NeilBrown <neilb@suse.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/04/2017 07:23 AM, Artur Paszkiewicz wrote:
> On 10/04/2017 01:02 PM, Artur Paszkiewicz wrote:
>> Applications like mdadm can use this to hide/unhide their component
>> devices.
> 
> And here is an example patch for mdadm. It adds options to manually hide
> or unhide the component devices:
> 
> mdadm --hide-components /dev/md0
> mdadm --unhide-components /dev/md0
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

I am not at all in favor of these patches, as they break all kinds of
diagnostic tooling and certainly violate the principle of least
surprise.  Tools like "lsblk --tree" and my own "lsdrv" [1].

Please keep these out of the kernel, or better yet, explain to your
customers that visibility into the components is a key *advantage*
of software raid.

Regards,

Phil Turmel

[1] https://github.com/pturmel/lsdrv
