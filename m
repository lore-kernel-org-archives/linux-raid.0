From: "Andrew Herdman" <andrew@whine.com>
Subject: Re: RAID1 VS RAID5
Date: Mon, 27 Oct 2003 10:52:46 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00da01c39ca2$5da252e0$0180a8c0@what>
References: <1067179519.1222.107.camel@cala> <200310270933.37564.dusty@strike.wu-wien.ac.at> <Pine.LNX.4.56.0310270916270.5277@unicorn.drogon.net> <200310271201.10418.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My P4-2.4GHz with 3 WD80G 8MB caches does significantly better with RAID5

hdparm -tT /dev/md/3

/dev/md/3:
 Timing buffer-cache reads:   1844 MB in  2.00 seconds = 921.08 MB/sec
 Timing buffered disk reads:  166 MB in  3.00 seconds =  55.26 MB/sec

md3 : active raid5 ide/host4/bus0/target0/lun0/part3[1]
                            ide/host2/bus1/target0/lun0/part3[2]
                            ide/host2/bus0/target0/lun0/part3[0]
      143713280 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

Linux why 2.4.22-ck2-blackbox-aph-21 #1 Wed Sep 17 09:41:14 EDT 2003 i686
GNU/Linux

This kernel also has the low latency and preempt patches applied and running
at 500hz.

Andrew


----- Original Message ----- 
From: "Hermann Himmelbauer" <dusty@strike.wu-wien.ac.at>
To: "Gordon Henderson" <gordon@drogon.net>; <linux-raid@vger.kernel.org>
Sent: Monday, October 27, 2003 6:01 AM
Subject: Re: RAID1 VS RAID5


> On Monday 27 October 2003 10:19, Gordon Henderson wrote:
> > On Mon, 27 Oct 2003, Hermann Himmelbauer wrote:
> > > My experience is that software RAID5 is quite slow.
> >
> > My experiences are the opposite to yours I'm afraid - I've not found it
> > any slower than a single drive and in some cases a lot faster!
> >
> > A lot depends on exactly what you are doing with it though, but I'm
> > willing to sacrifice some speed for data integrity.
> >
> > Most of my systems are network servers with 100Mb Network cards fitted -
> > as long as my disk systems are faster than 12.5MB/sec I'm happy. In
> > practice I can stream 50MB/sec+ out of some simple RAID5 IDE systems I
> > have.
>
> Well - I have an old Dual P-II-266 System with an onboard SCSI-Controller
with
> 3 Ultra SCSI-disks connected, building a RAID5. I did a simple Test with
> "hdparm -tT" to provide you with numbers:
>
> /dev/sdb:
>  Timing buffer-cache reads:   128 MB in  1.46 seconds = 87.67 MB/sec
>  Timing buffered disk reads:  64 MB in  5.07 seconds = 12.62 MB/sec
>
> /dev/sdc:
>  Timing buffer-cache reads:   128 MB in  1.47 seconds = 87.07 MB/sec
>  Timing buffered disk reads:  64 MB in  4.78 seconds = 13.39 MB/sec
>
> /dev/sdd:
>  Timing buffer-cache reads:   128 MB in  1.49 seconds = 85.91 MB/sec
>  Timing buffered disk reads:  64 MB in  5.05 seconds = 12.67 MB/sec
>
> So you see, the seperate disks achieve ~ 13MB/s. My RAID5 raidtab looks
like
> this:
> raiddev /dev/md0
>         raid-level              5
>         nr-raid-disks           3
>         nr-spare-disks          0
>         chunk-size              4
>         persistent-superblock   1
>         parity-algorithm        left-symmetric
>         device                  /dev/sdb2
>         raid-disk               0
>         device                  /dev/sdc2
>         raid-disk               1
>         device                  /dev/sdd2
>         raid-disk               2
>
> And "hdparm -tT" looks like this:
>
> /dev/md0:
>  Timing buffer-cache reads:   128 MB in  1.45 seconds = 88.28 MB/sec
>  Timing buffered disk reads:  64 MB in 13.85 seconds =  4.62 MB/sec
>
> So this is ~ 1/3rd of the read performance of a single disk. And this is
what
> a appr. measure when copying files etc.
>
> My kernel version is 2.4.20 and the CPU-Load during the hdparm test is
only at
> ~ 30%.
>
> Best Regards,
> Hermann
>
> -- 
> x1@aon.at
> GPG key ID: 299893C7 (on keyservers)
> FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

