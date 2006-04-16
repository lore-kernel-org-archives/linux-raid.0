From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Mon, 17 Apr 2006 08:46:03 +1000
Message-ID: <17474.51499.479497.322081@cse.unsw.edu.au>
References: <1145106091.18173.18.camel@nemo.qabal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nathanial Byrnes on Saturday April 15
Sender: linux-raid-owner@vger.kernel.org
To: Nathanial Byrnes <nate@qabal.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 15, nate@qabal.org wrote:
> Hi All,
> 	Recently I lost a disk in my raid5 SW array. It seems that it took a
> second disk with it. The other disk appears to still be funtional (from
> an fdisk perspective...). I am trying to get the array to work in
> degraded mode via failed-disk in raidtab, but am always getting the
> following error:
> 
> md: could not bd_claim hde.
> md: autostart failed!
> 
> When I try to raidstart the array. Is it the case tha I had been running
> in degraded mode before the disk failure, and then lost the other disk?
> if so, how can I tell. 

raidstart is deprecated.  It doesn't work reliably.  Don't use it.

> 
> I have been messing about with mkraid -R and I have tried to
> add /dev/hdf (a new disk) back to the array. However, I am fairly
> confident that I have not kicked off the recovery process, so I am
> imagining that once I get the superblocks in order, I should be able to
> recover to the new disk?
> 
> My system and raid config are:
> Kernel 2.6.13.1
> Slack 10.2
> RAID 5 which originally looked like:
> /dev/hde
> /dev/hdg
> /dev/hdi
> /dev/hdk
> 
> but when I moved the disks to another box with fewer IDE controllers
> /dev/hde
> /dev/hdf
> /dev/hdg
> /dev/hdh
> 
> How should I approach this?

mdadm --assemble /dev/md0 --uuid=38081921:59a998f9:64c1a001:ec534ef2 /dev/hd*

If that doesn't work, add "--force" but be cautious of the data - do
an fsck atleast.

NeilBrown
