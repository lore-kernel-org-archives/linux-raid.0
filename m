From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Sat, 26 Nov 2005 17:08:37 +0100
Message-ID: <01ca01c5f2a3$ab6ebf00$0400a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at> <17282.22120.327672.720044@cse.unsw.edu.au> <20051122220531.GU26862@skl-net.de> <015c01c5f292$57e0e270$0400a8c0@dcccs> <5d96567b0511260756t3989df8ep8c98326fc394ca18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, Raz,

Think this is not cpu usage problem. :-)
The system is divided to 4 cpuset, and each cpuset uses only one disknode.
(CPU0->nb0, CPU1->nb1, ...)

this top is under cat /dev/md31 (raid0)

Thanks,
Janos

 17:16:01  up 14:19,  4 users,  load average: 7.74, 5.03, 4.20
305 processes: 301 sleeping, 4 running, 0 zombie, 0 stopped
CPU0 states:  33.1% user  47.0% system    0.0% nice   0.0% iowait  18.0%
idle
CPU1 states:  21.0% user  52.0% system    0.0% nice   6.0% iowait  19.0%
idle
CPU2 states:   2.0% user  74.0% system    0.0% nice   3.0% iowait  18.0%
idle
CPU3 states:  10.0% user  57.0% system    0.0% nice   5.0% iowait  26.0%
idle
Mem:  4149412k av, 3961084k used,  188328k free,       0k shrd,  557032k
buff
       911068k active,            2881680k inactive
Swap:       0k av,       0k used,       0k free                 2779388k
cached

  PID USER     PRI  NI  SIZE  RSS SHARE STAT %CPU %MEM   TIME CPU COMMAND
 2410 root       0 -19  1584  108    36 S <  48.3  0.0  21:57   3 nbd-client
16191 root      25   0  4832  820   664 R    48.3  0.0   3:04   0 grep
 2408 root       0 -19  1588  112    36 S <  47.3  0.0  24:05   2 nbd-client
 2406 root       0 -19  1584  108    36 S <  40.8  0.0  22:56   1 nbd-client
18126 root      18   0  5780 1604   508 D    38.0  0.0   0:12   1 dd
 2404 root       0 -19  1588  112    36 S <  36.2  0.0  22:56   0 nbd-client
  294 root      15   0     0    0     0 SW    7.4  0.0   3:22   1 kswapd0
 2284 root      16   0 13500 5376  3040 S     7.4  0.1   8:53   2 httpd
18307 root      16   0  6320 2232  1432 S     4.6  0.0   0:00   2 sendmail
16789 root      16   0  5472 1552   952 R     3.7  0.0   0:03   3 top
 2431 root      10  -5     0    0     0 SW<   2.7  0.0   7:32   2 md2_raid1
29076 root      17   0  4776  772   680 S     2.7  0.0   1:09   3 xfs_fsr
 6955 root      15   0  1588  108    36 S     2.7  0.0   0:56   2 nbd-client

----- Original Message ----- 
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Saturday, November 26, 2005 4:56 PM
Subject: Re: RAID0 performance question


> look at the cpu consumption.
>
> On 11/26/05, JaniD++ <djani22@dynamicweb.hu> wrote:
> > Hello list,
> >
> > I have searching the bottleneck of my system, and found something what i
> > cant cleanly understand.
> >
> > I have use NBD with 4 disk nodes. (raidtab is the bottom of mail)
> >
> > The cat /dev/nb# >/dev/null    makes ~ 350 Mbit/s on each nodes.
> > The cat /dev/nb0 + nb1 + nb2 + nb3 in one time parallel makes ~ 780-800
> > Mbit/s. - i think this is my network bottleneck.
> >
> > But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes) only makes
> > ~450-490 Mbit/s, and i dont know why....
> >
> > Somebody have an idea? :-)
> >
> > (the nb31,30,29,28 only possible mirrors)
> >
> > Thanks
> > Janos
> >
> > raiddev         /dev/md1
> > raid-level      1
> > nr-raid-disks   2
> > chunk-size      32
> > persistent-superblock 1
> > device          /dev/nb0
> > raid-disk       0
> > device          /dev/nb31
> > raid-disk       1
> > failed-disk     /dev/nb31
> >
> > raiddev         /dev/md2
> > raid-level      1
> > nr-raid-disks   2
> > chunk-size      32
> > persistent-superblock 1
> > device          /dev/nb1
> > raid-disk       0
> > device          /dev/hb30
> > raid-disk       1
> > failed-disk     /dev/nb30
> >
> > raiddev         /dev/md3
> > raid-level      1
> > nr-raid-disks   2
> > chunk-size      32
> > persistent-superblock 1
> > device          /dev/nb2
> > raid-disk       0
> > device          /dev/nb29
> > raid-disk       1
> > failed-disk     /dev/nb29
> >
> > raiddev         /dev/md4
> > raid-level      1
> > nr-raid-disks   2
> > chunk-size      32
> > persistent-superblock 1
> > device          /dev/nb3
> > raid-disk       0
> > device          /dev/nb28
> > raid-disk       1
> > failed-disk     /dev/nb28
> >
> > raiddev         /dev/md31
> > raid-level      0
> > nr-raid-disks   4
> > chunk-size      32
> > persistent-superblock 1
> > device          /dev/md1
> > raid-disk       0
> > device          /dev/md2
> > raid-disk       1
> > device          /dev/md3
> > raid-disk       2
> > device          /dev/md4
> > raid-disk       3
> >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
>
> --
> Raz

