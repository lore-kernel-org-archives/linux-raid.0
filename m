From: Nathanial Byrnes <nate@qabal.org>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Sun, 16 Apr 2006 22:54:18 -0400
Message-ID: <1145242458.18173.49.camel@nemo.qabal.org>
References: <1145106091.18173.18.camel@nemo.qabal.org>
	 <17474.51499.479497.322081@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17474.51499.479497.322081@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Nathanial Byrnes <nate@nemo.qabal.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
	Thanks for your reply. I tried that, but here is there error I
received:

root@finn:/etc# mdadm --assemble /dev/md0
--uuid=38081921:59a998f9:64c1a001:ec53 4ef2 /dev/hd[efgh]
mdadm: failed to add /dev/hdf to /dev/md0: Device or resource busy
mdadm: /dev/md0 assembled from 2 drives and -1 spares - not enough to
start the array.

The output from lsraid against each device is as follows (I think that I
messed up my superblocks pretty well...): 

root@finn:/etc# lsraid -d /dev/hde
[dev   9,   0] /dev/md/0        38081921.59A998F9.64C1A001.EC534EF2
offline
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000
missing
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000
missing
[dev  34,  64] /dev/hdh         38081921.59A998F9.64C1A001.EC534EF2 good
[dev  34,   0] /dev/hdg         38081921.59A998F9.64C1A001.EC534EF2 good
[dev  33,  64] (unknown)        38081921.59A998F9.64C1A001.EC534EF2
unknown
[dev  33,   0] (unknown)        38081921.59A998F9.64C1A001.EC534EF2
unknown

[dev  33,   0] /dev/hde         38081921.59A998F9.64C1A001.EC534EF2
unbound
root@finn:/etc# lsraid -d /dev/hdf
[dev   9,   0] /dev/md/0        38081921.59A998F9.64C1A001.EC534EF2
offline
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000
missing
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000
missing
[dev  34,  64] /dev/hdh         38081921.59A998F9.64C1A001.EC534EF2 good
[dev  34,   0] /dev/hdg         38081921.59A998F9.64C1A001.EC534EF2 good
[dev  33,  64] (unknown)        38081921.59A998F9.64C1A001.EC534EF2
unknown
[dev  33,   0] (unknown)        38081921.59A998F9.64C1A001.EC534EF2
unknown

[dev  33,  64] /dev/hdf         38081921.59A998F9.64C1A001.EC534EF2
unbound
root@finn:/etc# lsraid -d /dev/hdg
[dev   9,   0] /dev/md/0        38081921.59A998F9.64C1A001.EC534EF2
offline
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000
missing
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000
missing
[dev  34,  64] /dev/hdh         38081921.59A998F9.64C1A001.EC534EF2 good
[dev  34,   0] /dev/hdg         38081921.59A998F9.64C1A001.EC534EF2 good
[dev  33,  64] (unknown)        38081921.59A998F9.64C1A001.EC534EF2
unknown
[dev  33,   0] (unknown)        38081921.59A998F9.64C1A001.EC534EF2
unknown

root@finn:/etc# lsraid -d /dev/hdh
[dev   9,   0] /dev/md/0        38081921.59A998F9.64C1A001.EC534EF2
offline
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000
missing
[dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000
missing
[dev  34,  64] /dev/hdh         38081921.59A998F9.64C1A001.EC534EF2 good
[dev  34,   0] /dev/hdg         38081921.59A998F9.64C1A001.EC534EF2 good
[dev  33,  64] (unknown)        38081921.59A998F9.64C1A001.EC534EF2
unknown
[dev  33,   0] (unknown)        38081921.59A998F9.64C1A001.EC534EF2
unknown


Thanks again,
Nate

On Mon, 2006-04-17 at 08:46 +1000, Neil Brown wrote:
> On Saturday April 15, nate@qabal.org wrote:
> > Hi All,
> > 	Recently I lost a disk in my raid5 SW array. It seems that it took a
> > second disk with it. The other disk appears to still be funtional (from
> > an fdisk perspective...). I am trying to get the array to work in
> > degraded mode via failed-disk in raidtab, but am always getting the
> > following error:
> > 
> > md: could not bd_claim hde.
> > md: autostart failed!
> > 
> > When I try to raidstart the array. Is it the case tha I had been running
> > in degraded mode before the disk failure, and then lost the other disk?
> > if so, how can I tell. 
> 
> raidstart is deprecated.  It doesn't work reliably.  Don't use it.
> 
> > 
> > I have been messing about with mkraid -R and I have tried to
> > add /dev/hdf (a new disk) back to the array. However, I am fairly
> > confident that I have not kicked off the recovery process, so I am
> > imagining that once I get the superblocks in order, I should be able to
> > recover to the new disk?
> > 
> > My system and raid config are:
> > Kernel 2.6.13.1
> > Slack 10.2
> > RAID 5 which originally looked like:
> > /dev/hde
> > /dev/hdg
> > /dev/hdi
> > /dev/hdk
> > 
> > but when I moved the disks to another box with fewer IDE controllers
> > /dev/hde
> > /dev/hdf
> > /dev/hdg
> > /dev/hdh
> > 
> > How should I approach this?
> 
> mdadm --assemble /dev/md0 --uuid=38081921:59a998f9:64c1a001:ec534ef2 /dev/hd*
> 
> If that doesn't work, add "--force" but be cautious of the data - do
> an fsck atleast.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> !DSPAM:4442c93863991804284693!
> 

