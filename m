From: Tide <lovetide@qq.com>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size
Date: Thu, 27 Mar 2014 02:44:35 +0000 (UTC)
Message-ID: <loom.20140327T033039-0@post.gmane.org>
References: <tencent_66C345191B9B49B92956F243@qq.com> <alpine.DEB.2.02.1403261937480.747@uplift.swm.pp.se> <loom.20140326T205013-837@post.gmane.org> <53334347.4050108@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stan Hoeppner <stan <at> hardwarefreak.com> writes:

> 
> On 3/26/2014 3:00 PM, Tide wrote:
> ...
> > =================
> > Array 2 (RAID 6):
> > =================
> > # mdadm --examine /dev/sdb1
> ...
> >      Raid Level : raid6
> >    Raid Devices : 5
> ...
> >   Bad Block Log : 512 entries available at offset 72 sectors
> 
> The RAID6 array has sectors on each drive reserved for bad block
> reassignment.  The RAID5 array does not.
> 
> This is the answer to your mystery.

"The RAID6/RAID5 array", do you mean my RAID array (just this instance), or
you mean "all RAID6/RAID5 arrays created by mdadm" ?

I also did created another RAID 5 & RAID 6 testing arrays using loopback
devices in both CentOS 6.5 and Fedora 20, and found out: array size of RAID
5 & RAID 6 are identical in same OS (in CentOS or in Fedora), but they are
different between OSes. That's what I still feel mysterious.

So is it different behaviour between mdadm v3.2 and v3.3, or it's just the 
compilation parameters of mdadm are different between CentOS 6.x and Fedora
19/20?

Testing script:
MAKEDEV /dev/loop; truncate -s 10M hdd5{1..5} hdd6{1..5}; for hdd in {1..5};
do losetup /dev/loop5$hdd hdd5$hdd; losetup /dev/loop6$hdd hdd6$hdd; done;
mdadm -C /dev/md5 -l 5 -n 4 -x 1 /dev/loop5{1..5}; mdadm -C /dev/md6 -l 6 -n
5 /dev/loop6{1..5}; mdadm -D /dev/md5; mdadm -D /dev/md6

> 
> Cheers,
> 
> Stan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo <at> vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 




