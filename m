From: Neil Brown <neilb@suse.de>
Subject: Re: MD or MDADM bug?
Date: Sat, 3 Sep 2005 13:52:40 +1000
Message-ID: <17177.7688.922030.788691@cse.unsw.edu.au>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
	<17176.2600.694418.472339@cse.unsw.edu.au>
	<018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH>
	<17176.4401.418417.56385@cse.unsw.edu.au>
	<019601c5af9b$23d8ce50$c100a8c0@NCNF5131FTH>
	<17176.7326.892297.381537@cse.unsw.edu.au>
	<01a101c5afa2$8b3f2060$c100a8c0@NCNF5131FTH>
	<17176.9057.119383.787644@cse.unsw.edu.au>
	<01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH>
	<17176.13548.477061.774536@cse.unsw.edu.au>
	<001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH>
	<17176.51414.689631.346198@cse.unsw.edu.au>
	<003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David M. Strang on Friday September 2
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 2, dstrang@shellpower.net wrote:
> >
> > Sorry.  Add
> >    -e 1
> 
> Well, I'm quite happy to report --- that worked!

Excellent!

> 
> So, once I get the bad drive replaced; and the array re-synced -- will I 
> want to stop the array, and execute:
> 
> mdadm -C /dev/md0 -e1 -l5 -n28 -c 128 --name=md/md0 -p la /dev/sd[a-z] 
> /dev/sda[ab]
> 
> Just so I don't have a problem with a disk 'not really' being part of the 
> array? IE; mdadm: /dev/sdm is identified as a member of /dev/md0,
> slot -1.

That shouldn't be necessary.  Providing you are using mdadm-2.0, you
should just be able to --add the drive and everything should work
fine.


> 
> Also, most of the drives -- have no partitions on them (ie; cfdisk 
> /dev/sda) -- Can I add them and set the type to FD so it will autodetect the 
> raid? Or must I do that prior to raid creation?

Type FD doesn't work with version-1 superblocks.  The kernel will not
auto-assemble them at all.  Just use mdadm to assemble them (in an
rc.d script).

NeilBrown
