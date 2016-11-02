From: keld@keldix.com
Subject: Re: Issue with growing RAID10
Date: Wed, 2 Nov 2016 20:48:42 +0100
Message-ID: <20161102194842.GA25173@www5.open-std.org>
References: <CAANLjFrK25fUjMpif6m7y3PZ0phNa_zVLFWUVs2Yj1PtbkA_Qg@mail.gmail.com> <20161102181923.GA21325@www5.open-std.org> <CAANLjFqqTvs0Uh1R6Bvk9FyQUgQqhj+48uC4iiut_A3Uh6j6DA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFqqTvs0Uh1R6Bvk9FyQUgQqhj+48uC4iiut_A3Uh6j6DA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert LeBlanc <robert@leblancnet.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you want all your disks to be identical, then you only can chose between
raid1 and raid10 near. I believe then the raid10  near is the better layout, as some 
stats say you will have better random performance. I don't know why. Probably a driver issue
I believe you can have raid1 in a 3-disk solution. You should try it out, and then please report the
stats back to the list, then I will add it to the wiki (it seems unacessibe at the moment, tho)

best regards
Keld

On Wed, Nov 02, 2016 at 01:02:29PM -0600, Robert LeBlanc wrote:
> My boss basically wants RAID1 with all drives able to be read from. He
> has a requirement to have all the drives identical (minus the
> superblock) hence the 'near' option being used. From my rudimentary
> tests, sequential reds do seem to use all drives, but random reads
> don't. I wonder what logic is preventing the spreading out of random
> workloads for 'near'. 'far' is using all disks in random read and
> getting better performance on both random and sequential. I'm testing
> loopbacks on an NVME drive so seek latency should not be a major
> concern.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> 
> 
> On Wed, Nov 2, 2016 at 12:19 PM,  <keld@keldix.com> wrote:
> > There is some speed limits om raid10,n2 as also reported in
> > https://raid.wiki.kernel.org/index.php/Performance
> >
> > f you want speed, I suggest you use raid10,f2.
> >
> > Unfortunatlely you cannot grow "far" layouts, Neil says it is too complicated.
> >
> > But in your case you should be  able to disable one of your raid10,N2 drives,
> > then build a raid10,n2 array for 3 disks, but only with the disk you removed from
> > your N2 disk plus your new disk. Then you can copy the contents of the remaining
> > old disk to the new "far" disk, and when complete, add the old raid10,n2 disk to the
> > new Far raid, with 3 disks. This should give you about 3 times the speed
> > of your old raid10,n2 array.
> >
> > Best regards
> > keld
> >
> >
> >
> > On Wed, Nov 02, 2016 at 11:59:25AM -0600, Robert LeBlanc wrote:
> >> We would like to add read performance to our RAID10 volume by adding
> >> another drive (we don't care about space), so I did the following test
> >> with poor results.
> >>
> >> # mdadm --create /dev/md13 --level 10 --run --assume-clean -p n2
> >> --raid-devices 2 /dev/loop{2..3}
> >> mdadm: /dev/loop2 appears to be part of a raid array:
> >>       level=raid10 devices=3 ctime=Wed Nov  2 11:25:22 2016
> >> mdadm: /dev/loop3 appears to be part of a raid array:
> >>       level=raid10 devices=3 ctime=Wed Nov  2 11:25:22 2016
> >> mdadm: Defaulting to version 1.2 metadata
> >> mdadm: array /dev/md13 started.
> >>
> >> # mdadm --detail /dev/md13
> >> /dev/md13:
> >>        Version : 1.2
> >>  Creation Time : Wed Nov  2 11:47:48 2016
> >>     Raid Level : raid10
> >>     Array Size : 10477568 (9.99 GiB 10.73 GB)
> >>  Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
> >>   Raid Devices : 2
> >>  Total Devices : 2
> >>    Persistence : Superblock is persistent
> >>
> >>    Update Time : Wed Nov  2 11:47:48 2016
> >>          State : clean
> >> Active Devices : 2
> >> Working Devices : 2
> >> Failed Devices : 0
> >>  Spare Devices : 0
> >>
> >>         Layout : near=2
> >>     Chunk Size : 512K
> >>
> >>           Name : rleblanc-pc:13  (local to host rleblanc-pc)
> >>           UUID : 1eb66d7c:21308453:1e731c8b:1c43dd55
> >>         Events : 0
> >>
> >>    Number   Major   Minor   RaidDevice State
> >>       0       7        2        0      active sync set-A   /dev/loop2
> >>       1       7        3        1      active sync set-B   /dev/loop3
> >>
> >> # mdadm /dev/md13 -a /dev/loop4
> >> mdadm: added /dev/loop4
> >>
> >> # mdadm --detail /dev/md13
> >> /dev/md13:
> >>        Version : 1.2
> >>  Creation Time : Wed Nov  2 11:47:48 2016
> >>     Raid Level : raid10
> >>     Array Size : 10477568 (9.99 GiB 10.73 GB)
> >>  Used Dev Size : 10477568 (9.99 GiB 10.73 GB)
> >>   Raid Devices : 2
> >>  Total Devices : 3
> >>    Persistence : Superblock is persistent
> >>
> >>    Update Time : Wed Nov  2 11:48:13 2016
> >>          State : clean
> >> Active Devices : 2
> >> Working Devices : 3
> >> Failed Devices : 0
> >>  Spare Devices : 1
> >>
> >>         Layout : near=2
> >>     Chunk Size : 512K
> >>
> >>           Name : rleblanc-pc:13  (local to host rleblanc-pc)
> >>           UUID : 1eb66d7c:21308453:1e731c8b:1c43dd55
> >>         Events : 1
> >>
> >>    Number   Major   Minor   RaidDevice State
> >>       0       7        2        0      active sync set-A   /dev/loop2
> >>       1       7        3        1      active sync set-B   /dev/loop3
> >>
> >>       2       7        4        -      spare   /dev/loop4
> >>
> >> # mdadm --grow /dev/md13 -p n3 --raid-devices 3
> >> mdadm: Cannot change number of copies when reshaping RAID10
> >>
> >> I also tried to add the device, grow raid-devices, let it reshape,
> >> then try to change the number of copies and it didn't like that
> >> either. It would be nice to supply -p nX and --raid-devices X at the
> >> same time to prevent the reshape and only copy the data over to the
> >> new drive (or drop a drive out completely). I could see changing -p
> >> separately or at a different rate of drives added/removed could be
> >> difficult, but for lockstep changes, it seems that it would be rather
> >> easy.
> >>
> >> Any ideas?
> >>
> >> Thanks,
> >>
> >> ----------------
> >> Robert LeBlanc
> >> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
