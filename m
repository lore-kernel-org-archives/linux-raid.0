From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: Raid 4 resize, raid0 limit question
Date: Sat, 4 Feb 2006 13:33:09 +0100
Message-ID: <00b101c62987$29376da0$9d00a8c0@dcccs>
References: <04b801c62854$d2365da0$9d00a8c0@dcccs> <17378.40947.719361.616481@cse.unsw.edu.au> <04dd01c62858$3c068090$9d00a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--cut--

> > > I plan to resize (grow) one raid4 array.
> > >
> > > 1. stop the array.
> > > 2. resize the partition on all disks to fit the maximum size.
> >
> > The approach is currently not supported.  It would need a change to
> > mdadm to find the old superblock and relocate it to the new end of the
> > partition.
> >
> > The only currently 'supported' way it to remove devices one at a time,
> > resize them, and add them back in as new devices, waiting for the
> > resync.
>
> Good news! :-)
> This takes about 1 weeks for me... :-(
> I should recreate....
>
>
> >
> > NeilBrown

Neil!

What do you think about making 2 files into proc or sys, as 2 margin for
raid sync?
The default value is 0 and sectorcount. (or KiB of the array)

The user can set this befor the sync is starts, or when the sync is run, and
if the sync is done, the default values are set again automatically.
The sync is move between the two value only.

This is easy to write - i think-, not too dangerous, and some times (or
often) very practical.

This will help for me often, including this time, to raid4 resize from 2TB
to 3.6TB.


> >
> >
> > >
> > > After this restart(assemble) the array is possiple?
> > > I mean, how can the kernel find the superblock fits on the half of the
> new
> > > partitions?
> > > I need to recreate the array instead of using -G option?
> > > Can i force raid to resync only the new area?
> > >
> > > The raid0 in 2.6.16-rc1 supports 4x 3.6TB soure devices? :-)
> >
> > ... maybe?
> > I think it does, but I cannot promise anything.
>
> Anyway, i will test it on the weekend, and i dont need to grow the FS too
on
> it.
>
> How can i safe test it (and NBD >2TB) to work well, without data lost?

Anybody know any good tool to test the 13.4TB raid0 array inside 8TB live,
and valuable fs without data lost?

I need to test the raid0 and NBD before resize the FS to fit to the array.

I can think only to dd with skip=NN option, but at this time i did'nt trust
the dd enough. :-)

Thanks,
Janos


>
> Thanks,
> Janos
>
> >
> > NeilBrown
> >
> >
> > >
> > > Thanks,
> > > Janos
> > >
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

