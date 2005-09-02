From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: MD or MDADM bug?
Date: Fri, 2 Sep 2005 06:08:17 -0400
Message-ID: <01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH><17176.2600.694418.472339@cse.unsw.edu.au><018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH><17176.4401.418417.56385@cse.unsw.edu.au><019601c5af9b$23d8ce50$c100a8c0@NCNF5131FTH><17176.7326.892297.381537@cse.unsw.edu.au><01a101c5afa2$8b3f2060$c100a8c0@NCNF5131FTH> <17176.9057.119383.787644@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday September 2, dstrang@shellpower.net wrote:
> > Neil Brown wrote:
> > > On Friday September 2, dstrang@shellpower.net wrote:
> > > > >
> > > > > Can you run that with '-v' for me?
> > > > >
> > > > > mdadm: looking for devices for /dev/md0
> > > > mdadm: /dev/sda is identified as a member of /dev/md0, slot 0.
> > > > mdadm: /dev/sdb is identified as a member of /dev/md0, slot 1.
> > > > mdadm: /dev/sdc is identified as a member of /dev/md0, slot 2.
> > > ...
> > >
> > > and just for completeness:
> > >
> > >  mdadm -E /dev/sdm /dev/sdaa
> > >
> >
> > -(root@abyss)-(~)- # mdadm -E /dev/sdm /dev/sdaa
>
> Thanks.
>
> Looks like --assemble is not going to work any more for you.
> However you should be able to recreate the array:
>
>  mdadm -C /dev/md0 -l5 -n28 -c 128 --name=md/md0 -p la  /dev/sd[a-l] 
> missing /dev/sd[n-z] /dev/sda[ab]
>
> should get it right. (You did deliberately choose left-asymmetric I 
> assume).
>
> I've put a note on my todo list to test out these failure modes
> and make sure it does the right thing next time.

Does this mean I'm going to loose all my data?

-- David 

