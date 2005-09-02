From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: MD or MDADM bug?
Date: Fri, 2 Sep 2005 04:48:50 -0400
Message-ID: <019601c5af9b$23d8ce50$c100a8c0@NCNF5131FTH>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH><17176.2600.694418.472339@cse.unsw.edu.au><018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH> <17176.4401.418417.56385@cse.unsw.edu.au>
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
> >
> > > mdadm 2.0 had a fix for assembling version-1 arrays that would
> > > particularly affect raid5.  Try using that instead of -devel-3.
> >
> > No luck -- 
> >
> > -(root@abyss)-(~)- # mdadm -A /dev/md0 /dev/sda /dev/sdb /dev/sdc 
> > /dev/sdd
> > /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl
> > /dev/sdm /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt
> > /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdy /dev/sdz /dev/sdaa 
> > /dev/sdab -f
> > mdadm: /dev/md0 assembled from 26 drives - not enough to start the 
> > array.
> >
> > Any other suggestions?
> >
>
> Can you run that with '-v' for me?

mdadm: looking for devices for /dev/md0
mdadm: /dev/sda is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdb is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdc is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdd is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sde is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdf is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdg is identified as a member of /dev/md0, slot 6.
mdadm: /dev/sdh is identified as a member of /dev/md0, slot 7.
mdadm: /dev/sdi is identified as a member of /dev/md0, slot 8.
mdadm: /dev/sdj is identified as a member of /dev/md0, slot 9.
mdadm: /dev/sdk is identified as a member of /dev/md0, slot 10.
mdadm: /dev/sdl is identified as a member of /dev/md0, slot 11.
mdadm: /dev/sdm is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdn is identified as a member of /dev/md0, slot 13.
mdadm: /dev/sdo is identified as a member of /dev/md0, slot 14.
mdadm: /dev/sdp is identified as a member of /dev/md0, slot 15.
mdadm: /dev/sdq is identified as a member of /dev/md0, slot 16.
mdadm: /dev/sdr is identified as a member of /dev/md0, slot 17.
mdadm: /dev/sds is identified as a member of /dev/md0, slot 18.
mdadm: /dev/sdt is identified as a member of /dev/md0, slot 19.
mdadm: /dev/sdu is identified as a member of /dev/md0, slot 20.
mdadm: /dev/sdv is identified as a member of /dev/md0, slot 21.
mdadm: /dev/sdw is identified as a member of /dev/md0, slot 22.
mdadm: /dev/sdx is identified as a member of /dev/md0, slot 23.
mdadm: /dev/sdy is identified as a member of /dev/md0, slot 24.
mdadm: /dev/sdz is identified as a member of /dev/md0, slot 25.
mdadm: /dev/sdaa is identified as a member of /dev/md0, slot -1.
mdadm: /dev/sdab is identified as a member of /dev/md0, slot 27.
mdadm: added /dev/sdb to /dev/md0 as 1
mdadm: added /dev/sdc to /dev/md0 as 2
mdadm: added /dev/sdd to /dev/md0 as 3
mdadm: added /dev/sde to /dev/md0 as 4
mdadm: added /dev/sdf to /dev/md0 as 5
mdadm: added /dev/sdg to /dev/md0 as 6
mdadm: added /dev/sdh to /dev/md0 as 7
mdadm: added /dev/sdi to /dev/md0 as 8
mdadm: added /dev/sdj to /dev/md0 as 9
mdadm: added /dev/sdk to /dev/md0 as 10
mdadm: added /dev/sdl to /dev/md0 as 11
mdadm: no uptodate device for slot 12 of /dev/md0
mdadm: added /dev/sdn to /dev/md0 as 13
mdadm: added /dev/sdo to /dev/md0 as 14
mdadm: added /dev/sdp to /dev/md0 as 15
mdadm: added /dev/sdq to /dev/md0 as 16
mdadm: added /dev/sdr to /dev/md0 as 17
mdadm: added /dev/sds to /dev/md0 as 18
mdadm: added /dev/sdt to /dev/md0 as 19
mdadm: added /dev/sdu to /dev/md0 as 20
mdadm: added /dev/sdv to /dev/md0 as 21
mdadm: added /dev/sdw to /dev/md0 as 22
mdadm: added /dev/sdx to /dev/md0 as 23
mdadm: added /dev/sdy to /dev/md0 as 24
mdadm: added /dev/sdz to /dev/md0 as 25
mdadm: no uptodate device for slot 26 of /dev/md0
mdadm: added /dev/sdab to /dev/md0 as 27
mdadm: added /dev/sda to /dev/md0 as 0
mdadm: /dev/md0 assembled from 26 drives - not enough to start the array.

