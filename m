From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: MD or MDADM bug?
Date: Fri, 2 Sep 2005 19:34:00 -0400
Message-ID: <003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH><17176.2600.694418.472339@cse.unsw.edu.au><018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH><17176.4401.418417.56385@cse.unsw.edu.au><019601c5af9b$23d8ce50$c100a8c0@NCNF5131FTH><17176.7326.892297.381537@cse.unsw.edu.au><01a101c5afa2$8b3f2060$c100a8c0@NCNF5131FTH><17176.9057.119383.787644@cse.unsw.edu.au><01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH><17176.13548.477061.774536@cse.unsw.edu.au><001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH> <17176.51414.689631.346198@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday September 2, dstrang@shellpower.net wrote:
> > Neil Brown wrote:
> > > On Friday September 2, dstrang@shellpower.net wrote:
> > > >
> > > > Does this mean I'm going to loose all my data?
> > > >
> > >
> > > No.
> > > At least, you shouldn't, and doing the --create won't make anything
> > > worse.
> > >
> > > So do the --create with the 'missing', and don't add any spares.
> > > Do a 'fsck' or whatever to check that everything is OK.
> > >
> > > If it isn't, we'll have to look again at exactly what happened and
> > > figure out which disks we should have created into the array.
> >
> > -(root@abyss)-(~)- # mdadm -C /dev/md0 -l5 -n28 -c 128 --name=md/md0 -p 
> > la
> > /dev/sd[a-l] missing /dev/sd[n-z] /dev/sda[ab]
> > mdadm: invalid number of raid devices: 28
>
> Sorry.  Add
>    -e 1

Well, I'm quite happy to report --- that worked!

###########
reiserfsck --check started at Fri Sep  2 12:29:18 2005
###########
Replaying journal..
Trans replayed: mountid 23, transid 172404, desc 3638, len 14, commit 3653, 
next trans offset 3636
Trans replayed: mountid 23, transid 172405, desc 3654, len 1, commit 3656, 
next trans offset 3639
Trans replayed: mountid 23, transid 172406, desc 3657, len 1, commit 3659, 
next trans offset 3642
Trans replayed: mountid 23, transid 172407, desc 3660, len 1, commit 3662, 
next trans offset 3645
Trans replayed: mountid 23, transid 172408, desc 3663, len 1, commit 3665, 
next trans offset 3648
Trans replayed: mountid 23, transid 172409, desc 3666, len 1, commit 3668, 
next trans offset 3651
Trans replayed: mountid 23, transid 172410, desc 3669, len 1, commit 3671, 
next trans offset 3654
Reiserfs journal '/dev/md0' in blocks [18..8211]: 7 transactions replayed
Checking internal tree..finished
Comparing bitmaps..finished
Checking Semantic tree:
finished
No corruptions found
There are on the filesystem:
        Leaves 279225
        Internal nodes 1696
        Directories 1962
        Other files 15922
        Data block pointers 280976644 (0 of them are zero)
        Safe links 0
###########
reiserfsck finished at Fri Sep  2 13:13:53 2005
###########

And, no data corruption!

So, once I get the bad drive replaced; and the array re-synced -- will I 
want to stop the array, and execute:

mdadm -C /dev/md0 -e1 -l5 -n28 -c 128 --name=md/md0 -p la /dev/sd[a-z] 
/dev/sda[ab]

Just so I don't have a problem with a disk 'not really' being part of the 
array? IE; mdadm: /dev/sdm is identified as a member of /dev/md0, slot -1.

Also, most of the drives -- have no partitions on them (ie; cfdisk 
/dev/sda) -- Can I add them and set the type to FD so it will autodetect the 
raid? Or must I do that prior to raid creation?

Thanks again for all the help Neil, once again -- I'm able to recover what 
seemed hopeless with zero dataloss.

-- David



