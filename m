From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: duplicate entry in mdstat with RAID-5
Date: Fri, 18 Oct 2002 14:29:17 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15791.36381.562899.459791@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0210172230540.6331-100000@mail.accusense.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Karl Hiramoto on Thursday October 17
To: Karl Hiramoto <karl@mail.accusense.com>
Cc: linux-raid@vger.kernel.org, jakob@unthought.net, karl@hiramoto.org, rek2@linuxbusca.com, wlug@mail.wlug.org
List-Id: linux-raid.ids

On Thursday October 17, karl@mail.accusense.com wrote:
> 
> Can someone please help me fix this problem?  I don't know if my data is 
> safe at the moment.
> 
> 
> I have double entries for hde1 and hde in /proc/mdstat.  The problem arose
> when i did a raidhotadd for /dev/hde then again for /dev/hde1.  Doh. Is
> this a problem? How do i fix it?  I would like to be using hde1, hdf1,
> hdc1
> 
> The problem arose when the 60GB /dev/hde failed.  I replaced it with an 
> 80GB drive. 
> 
> I am running redhat 7.2 with their kernel 2.4.9-31
> 
> 
> # cat /proc/mdstat 
> Personalities : [raid5] 
> read_ahead 1024 sectors
> md0 : active raid5 hde1[3] hde[2] hdf1[1] hdc1[0]
>       120102912 blocks level 5, 64k chunk, algorithm 0 [3/3] [UUU]
>       
> unused devices: <none>

So the raid is made of hdc1 hdf1 hde, with hde1 as a hot spare.. Not
what you want.

   raidhotremove /dev/md0 /dev/hde1
   raidsetfaulty /dev/md0 /dev/hde
   raidhotremove /dev/md0 /dev/hde

Repartition hde correctly, the partition table will have been
corrupted.

   raidhotadd /dev/md0 /dev/hde1

and don't make a typo this time :-)

NeilBrown


> 
> ----
> # fdisk -l /dev/hde
> 
> Disk /dev/hde: 16 heads, 63 sectors, 155061 cylinders
> Units = cylinders of 1008 * 512 bytes
> 
> Disk /dev/hde doesn't contain a valid partition table
> -----
> 
> # fdisk -l /dev/hdc
> Disk /dev/hdc: 16 heads, 63 sectors, 119150 cylinders
> Units = cylinders of 1008 * 512 bytes
> 
>    Device Boot    Start       End    Blocks   Id  System
> /dev/hdc1   *         1    119150  60051568+  fd  Linux raid autodetect
> 
> ----
> # fdisk -l /dev/hdf
> Disk /dev/hdf: 16 heads, 63 sectors, 119150 cylinders
> Units = cylinders of 1008 * 512 bytes
> 
>    Device Boot    Start       End    Blocks   Id  System
> /dev/hdf1             1    119150  60051568+  fd  Linux raid autodetect
> 
> 
> -- 
> /var/log/messages  file
> when i tried to remove /dev/hde with raidhotremove
> 
> 
> Oct 17 22:17:15 data kernel: md: trying to remove hde from md0 ... 
> Oct 17 22:17:15 data kernel: md: bug in file md.c, line 2344
> Oct 17 22:17:15 data kernel: 
> Oct 17 22:17:15 data kernel: md:^I**********************************
> Oct 17 22:17:15 data kernel: md:^I* <COMPLETE RAID STATE PRINTOUT> *
> Oct 17 22:17:15 data kernel: md:^I**********************************
> Oct 17 22:17:15 data kernel: md0: <hde1><hde><hdf1><hdc1> array 
> superblock:
> Oct 17 22:17:15 data kernel: md:  SB: (V:0.90.0) 
> ID:<a595074f.25e94a64.bec4b48a.e946a7b6> CT:3bdeb7e7
> Oct 17 22:17:15 data kernel: md:     L5 S60051456 ND:4 RD:3 md0 LO:0 
> CS:65536
> Oct 17 22:17:15 data kernel: md:     UT:3daf6d69 ST:0 AD:3 WD:4 FD:0 SD:1 
> CSUM:99d87466 E:0000009c
> Oct 17 22:17:15 data kernel:      D  0:  DISK<N:0,hdc1(22,1),R:0,S:6>
> Oct 17 22:17:15 data kernel:      D  1:  DISK<N:1,hdf1(33,65),R:1,S:6>
> Oct 17 22:17:15 data kernel:      D  2:  DISK<N:2,hde(33,0),R:2,S:6>
> Oct 17 22:17:15 data kernel:      D  3:  DISK<N:3,hde1(33,1),R:3,S:0>
> Oct 17 22:17:15 data kernel: md:     THIS:  DISK<N:3,hde1(33,1),R:3,S:0>
> Oct 17 22:17:15 data kernel: md: rdev hde1: O:hde1, SZ:60051456 F:0 DN:3 
> md: rdev superblock:
> Oct 17 22:17:15 data kernel: md:  SB: (V:0.90.0) 
> ID:<a595074f.25e94a64.bec4b48a.e946a7b6> CT:3bdeb7e7
> Oct 17 22:17:15 data kernel: md:     L5 S60051456 ND:4 RD:3 md0 LO:0 
> CS:65536
> Oct 17 22:17:15 data kernel: md:     UT:3daf6d69 ST:0 AD:3 WD:4 FD:0 SD:1 
> CSUM:99d874aa E:0000009c
> Oct 17 22:17:15 data kernel:      D  0:  DISK<N:0,hdc1(22,1),R:0,S:6>
> Oct 17 22:17:15 data kernel:      D  1:  DISK<N:1,hdf1(33,65),R:1,S:6>
> Oct 17 22:17:15 data kernel:      D  2:  DISK<N:2,hde(33,0),R:2,S:6>
> Oct 17 22:17:15 data kernel:      D  3:  DISK<N:3,hde1(33,1),R:3,S:0>
> Oct 17 22:17:15 data kernel: md:     THIS:  DISK<N:3,hde1(33,1),R:3,S:0>
> Oct 17 22:17:15 data kernel: md: rdev hde: O:hde, SZ:78150656 F:0 DN:2 md: 
> rdev superblock:
> Oct 17 22:17:15 data kernel: md:  SB: (V:0.90.0) 
> ID:<a595074f.25e94a64.bec4b48a.e946a7b6> CT:3bdeb7e7
> Oct 17 22:17:15 data kernel: md:     L5 S60051456 ND:4 RD:3 md0 LO:0 
> CS:65536
> Oct 17 22:17:15 data kernel: md:     UT:3daf6d69 ST:0 AD:3 WD:4 FD:0 SD:1 
> CSUM:99d874ad E:0000009c
> 
> Oct 17 22:17:15 data kernel:      D  0:  DISK<N:0,hdc1(22,1),R:0,S:6>
> Oct 17 22:17:15 data kernel:      D  1:  DISK<N:1,hdf1(33,65),R:1,S:6>
> Oct 17 22:17:15 data kernel:      D  2:  DISK<N:2,hde(33,0),R:2,S:6>
> Oct 17 22:17:15 data kernel:      D  3:  DISK<N:3,hde1(33,1),R:3,S:0>
> Oct 17 22:17:15 data kernel: md:     THIS:  DISK<N:2,hde(33,0),R:2,S:6>
> Oct 17 22:17:15 data kernel: md: rdev hdf1: O:hdf1, SZ:60051456 F:0 DN:1 
> md: rdev superblock:
> Oct 17 22:17:15 data kernel: md:  SB: (V:0.90.0) 
> ID:<a595074f.25e94a64.bec4b48a.e946a7b6> CT:3bdeb7e7
> Oct 17 22:17:15 data kernel: md:     L5 S60051456 ND:4 RD:3 md0 LO:0 
> CS:65536
> Oct 17 22:17:15 data kernel: md:     UT:3daf6d69 ST:0 AD:3 WD:4 FD:0 SD:1 
> CSUM:99d874ec E:0000009c
> Oct 17 22:17:15 data kernel:      D  0:  DISK<N:0,hdc1(22,1),R:0,S:6>
> Oct 17 22:17:15 data kernel:      D  1:  DISK<N:1,hdf1(33,65),R:1,S:6>
> Oct 17 22:17:15 data kernel:      D  2:  DISK<N:2,hde(33,0),R:2,S:6>
> Oct 17 22:17:15 data kernel:      D  3:  DISK<N:3,hde1(33,1),R:3,S:0>
> Oct 17 22:17:15 data kernel: md:     THIS:  DISK<N:1,hdf1(33,65),R:1,S:6>
> Oct 17 22:17:15 data kernel: md: rdev hdc1: O:hdc1, SZ:60051456 F:0 DN:0 
> md: rdev superblock:
> Oct 17 22:17:15 data kernel: md:  SB: (V:0.90.0) 
> ID:<a595074f.25e94a64.bec4b48a.e946a7b6> CT:3bdeb7e7
> Oct 17 22:17:15 data kernel: md:     L5 S60051456 ND:4 RD:3 md0 LO:0 
> CS:65536
> Oct 17 22:17:15 data kernel: md:     UT:3daf6d69 ST:0 AD:3 WD:4 FD:0 SD:1 
> CSUM:99d8749f E:0000009c
> Oct 17 22:17:15 data kernel:      D  0:  DISK<N:0,hdc1(22,1),R:0,S:6>
> Oct 17 22:17:15 data kernel:      D  1:  DISK<N:1,hdf1(33,65),R:1,S:6>
> Oct 17 22:17:15 data kernel:      D  2:  DISK<N:2,hde(33,0),R:2,S:6>
> Oct 17 22:17:15 data kernel:      D  3:  DISK<N:3,hde1(33,1),R:3,S:0>
> Oct 17 22:17:15 data kernel: md:     THIS:  DISK<N:0,hdc1(22,1),R:0,S:6>
> Oct 17 22:17:15 data kernel: md:^I**********************************
> Oct 17 22:17:15 data kernel: 
> Oct 17 22:17:15 data kernel: md: cannot remove active disk hde from md0 
> ... 
> Oct 17 22:23:11 data kernel: md: interrupting MD-thread pid 130
> Oct 17 22:23:11 data kernel: md:   raid5d(130) flushing signals.
> Oct 17 22:23:11 data kernel: md: marking sb clean...
> Oct 17 22:23:11 data kernel: md: updating md0 RAID superblock on device
> Oct 17 22:23:11 data kernel: md: hde1 [events: 0000009d](write) hde1's sb 
> offset: 60051456
> Oct 17 22:23:11 data kernel: md: hde [events: 0000009d](write) hde's sb 
> offset: 78150656
> Oct 17 22:23:11 data kernel: md: hdf1 [events: 0000009d](write) hdf1's sb 
> offset: 60051456
> Oct 17 22:23:11 data kernel: md: hdc1 [events: 0000009d](write) hdc1's sb 
> offset: 60051456
> Oct 17 22:23:11 data kernel: md: md0 stopped.
> Oct 17 22:23:11 data kernel: md: unbind<hde1,3>
> Oct 17 22:23:11 data kernel: md: export_rdev(hde1)
> Oct 17 22:23:11 data kernel: md: unbind<hde,2>
> Oct 17 22:23:11 data kernel: md: export_rdev(hde)
> Oct 17 22:23:11 data kernel: md: unbind<hdf1,1>
> Oct 17 22:23:11 data kernel: md: export_rdev(hdf1)
> Oct 17 22:23:11 data kernel: md: unbind<hdc1,0>
> Oct 17 22:23:11 data kernel: md: export_rdev(hdc1)
> Oct 17 22:28:12 data dhcpd: DHCPREQUEST for 192.168.2.113 from 
> 00:50:fc:21:77:64 via eth0
> Oct 17 22:29:48 data kernel: (read) hdc1's sb offset: 60051456 [events: 
> 0000009d]
> Oct 17 22:29:48 data kernel: (read) hdf1's sb offset: 60051456 [events: 
> 0000009d]
> Oct 17 22:29:48 data kernel: (read) hde's sb offset: 78150656 [events: 
> 0000009d]
> Oct 17 22:29:49 data kernel: (read) hde1's sb offset: 60051456 [events: 
> 0000009d]
> Oct 17 22:29:49 data kernel: md: autorun ...
> Oct 17 22:29:49 data kernel: md: considering hde1 ...
> Oct 17 22:29:49 data kernel: md:  adding hde1 ...
> Oct 17 22:29:49 data kernel: md:  adding hde ...
> Oct 17 22:29:49 data kernel: md:  adding hdf1 ...
> Oct 17 22:29:49 data kernel: md:  adding hdc1 ...
> Oct 17 22:29:49 data kernel: md: created md0
> Oct 17 22:29:49 data kernel: md: bind<hdc1,1>
> Oct 17 22:29:49 data kernel: md: bind<hdf1,2>
> Oct 17 22:29:49 data kernel: md: bind<hde,3>
> Oct 17 22:29:49 data kernel: md0: WARNING: hde1 appears to be on the same 
> physical disk as hde. True
> Oct 17 22:29:49 data kernel:      protection against single-disk failure 
> might be compromised.
> Oct 17 22:29:49 data kernel: md: bind<hde1,4>
> Oct 17 22:29:49 data kernel: md: running: <hde1><hde><hdf1><hdc1>
> Oct 17 22:29:49 data kernel: md: hde1's event counter: 0000009d
> Oct 17 22:29:49 data kernel: md: hde's event counter: 0000009d
> Oct 17 22:29:49 data kernel: md: hdf1's event counter: 0000009d
> Oct 17 22:29:49 data kernel: md: hdc1's event counter: 0000009d
> Oct 17 22:29:49 data kernel: md0: max total readahead window set to 512k
> Oct 17 22:29:49 data kernel: md0: 2 data-disks, max readahead per 
> data-disk: 256k
> Oct 17 22:29:49 data kernel: raid5: spare disk hde1
> Oct 17 22:29:49 data kernel: raid5: device hde operational as raid disk 2
> Oct 17 22:29:49 data kernel: raid5: device hdf1 operational as raid disk 1
> Oct 17 22:29:49 data kernel: raid5: device hdc1 operational as raid disk 0
> Oct 17 22:29:49 data kernel: raid5: allocated 3291kB for md0
> Oct 17 22:29:49 data kernel: raid5: raid level 5 set md0 active with 3 out 
> of 3 devices, algorithm 0
> Oct 17 22:29:49 data kernel: RAID5 conf printout:
> Oct 17 22:29:49 data kernel:  --- rd:3 wd:3 fd:0
> Oct 17 22:29:49 data kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdc1
> Oct 17 22:29:49 data kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdf1
> Oct 17 22:29:49 data kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hde
> Oct 17 22:29:49 data kernel: RAID5 conf printout:
> Oct 17 22:29:49 data kernel:  --- rd:3 wd:3 fd:0
> Oct 17 22:29:49 data kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hdc1
> Oct 17 22:29:49 data kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdf1
> Oct 17 22:29:49 data kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hde
> Oct 17 22:29:49 data kernel: md: updating md0 RAID superblock on device
> Oct 17 22:29:49 data kernel: md: hde1 [events: 0000009e](write) hde1's sb 
> offset: 60051456
> Oct 17 22:29:49 data kernel: md: hde [events: 0000009e](write) hde's sb 
> offset: 78150656
> Oct 17 22:29:49 data kernel: md: hdf1 [events: 0000009e](write) hdf1's sb 
> offset: 60051456
> Oct 17 22:29:49 data kernel: md: hdc1 [events: 0000009e](write) hdc1's sb 
> offset: 60051456
> Oct 17 22:29:49 data kernel: md: ... autorun DONE.
> 
> 
> 
> 
> 
> Thanks,
> 
> 
> --------------------------------------------------------------------
> Karl Hiramoto  - Design Engineer
> Cambridge Accusense
> www.accusense.com
> Tel: 978-425-2090
> Toll Free in US: 1-800-313-9271
> Fax: 978-425-4062
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
