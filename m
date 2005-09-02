From: Neil Brown <neilb@suse.de>
Subject: Re: MD or MDADM bug?
Date: Sat, 3 Sep 2005 07:49:10 +1000
Message-ID: <17176.51414.689631.346198@cse.unsw.edu.au>
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
> Neil Brown wrote:
> > On Friday September 2, dstrang@shellpower.net wrote:
> > >
> > > Does this mean I'm going to loose all my data?
> > >
> >
> > No.
> > At least, you shouldn't, and doing the --create won't make anything
> > worse.
> >
> > So do the --create with the 'missing', and don't add any spares.
> > Do a 'fsck' or whatever to check that everything is OK.
> >
> > If it isn't, we'll have to look again at exactly what happened and
> > figure out which disks we should have created into the array.
> 
> -(root@abyss)-(~)- # mdadm -C /dev/md0 -l5 -n28 -c 128 --name=md/md0 -p la 
> /dev/sd[a-l] missing /dev/sd[n-z] /dev/sda[ab]
> mdadm: invalid number of raid devices: 28

Sorry.  Add
   -e 1

> 
> I'm using mdadm 2.0 now --- should I try 2.0-devel-3 ?

No.  -devel-3 should not be used anymore.

NeilBrown
