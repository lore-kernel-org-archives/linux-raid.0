From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 26 Jan 2011 08:16:16 +0100
Message-ID: <20110126071616.824BEBB0B9@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <20110125171017.GA24921@infradead.org> <20110125184115.1119FB187@gemini.denx.de> <20110125213523.GA14375@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20110125213523.GA14375@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Christoph Hellwig,

In message <20110125213523.GA14375@infradead.org> you wrote:
>
> > What exactly do you mean by "conatenation"? LVM striping?
> > At least the discussion here does not show any significant advantages
> > for this concept:
> > http://groups.google.com/group/ubuntu-user-community/web/pick-your-pleasure-raid-0-mdadm-striping-or-lvm-striping
> 
> No, concatenation means not using any striping, but just concatenating
> the disk linearly, e.g.
> 
>  +-----------------------------------+
>  |            Filesystem             |
>  +--------+--------+--------+--------+
>  | Disk 1 | Disk 2 | Disk 3 | Disk 4 |
>  +--------+--------+--------+--------+
> 
> This can be done using the using the MD linear target, or simply
> by having multiple PVs in a VG with LVM.

I will not have a single file system, but several, so I'd probably go
with LVM. But - when I then create a LV, eventually smaller than any
of the disks, will the data (and thus the traffic) be really distri-
buted over all drives, or will I not basicly see the same results as
when using a single drive?

> > Tests if done recently indicate that on the other hand nobarrier causes
> > a serious degradation of read and write performance (down to some 40%
> > of the values before).
> 
> Do you have a pointer to your results?

This was the first set of tests:

http://thread.gmane.org/gmane.linux.raid/31269/focus=31419

I've run some more tests on the system called 'B' in this list:


# lvcreate -L 32G -n test castor0
  Logical volume "test" created
# mkfs.xfs /dev/mapper/castor0-test 
meta-data=/dev/mapper/castor0-test isize=256    agcount=16, agsize=524284 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=8388544, imaxpct=25
         =                       sunit=4      swidth=16 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=4096, version=2
         =                       sectsz=512   sunit=4 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount /dev/mapper/castor0-test /mnt/tmp/
# mkdir /mnt/tmp/foo
# chown wd.wd /mnt/tmp/foo
# bonnie++ -d /mnt/tmp/foo -m xfs -u wd -g wd
Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
xfs             16G   425  98 182929  64 46956  41   955  97 201274  83 517.6  30
Latency             42207us    2377ms     195ms   33339us   86675us   84167us
Version  1.96       ------Sequential Create------ --------Random Create--------
xfs                 -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16    93   1 +++++ +++    90   1   123   1 +++++ +++   127   1
Latency               939ms    2279us    1415ms     307ms    1057us     724ms
1.96,1.96,xfs,1,1295938326,16G,,425,98,182929,64,46956,41,955,97,201274,83,517.6,30,16,,,,,93,1,+++++,+++,90,1,123,1,+++++,+++,127,1,42207us,2377ms,195ms,33339us,86675us,84167us,939ms,2279us,1415ms,307ms,1057us,724ms

[[Re-run with larger number of file creates / deletes]]

# bonnie++ -d /mnt/tmp/foo -n 128:65536:0:512 -m xfs1 -u wd -g wd
Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
xfs1            16G   400  98 175931  63 46970  40   781  99 181044  73 524.2  30
Latency             48299us    2501ms     210ms   20693us   83729us   85349us
Version  1.96       ------Sequential Create------ --------Random Create--------
xfs1                -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max            /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    128:65536:0/512    42   1 25607  99    71   1    38   1  8267  67    34   0
Latency              1410ms    2337us    2116ms    1240ms   44920us    4139ms
1.96,1.96,xfs1,1,1295942356,16G,,400,98,175931,63,46970,40,781,99,181044,73,524.2,30,128,65536,,,512,42,1,25607,99,71,1,38,1,8267,67,34,0,48299us,2501ms,210ms,20693us,83729us,85349us,1410ms,2337us,2116ms,1240ms,44920us,4139ms

[[Add delaylog,logbsize=262144]]

# mount | grep /mnt/tmp
/dev/mapper/castor0-test on /mnt/tmp type xfs (rw)
# mount -o remount,noatime,delaylog,logbsize=262144 /mnt/tmp
# mount | grep /mnt/tmp
/dev/mapper/castor0-test on /mnt/tmp type xfs (rw,noatime,delaylog,logbsize=262144)
Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
xfs1            16G   445  98 106201  43 35407  33   939  99 83545  42 490.4  30
Latency             43307us    4614ms     242ms   37420us     195ms     128ms
Version  1.96       ------Sequential Create------ --------Random Create--------
xfs1                -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max            /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    128:65536:0/512   308   4 24121  99  2393  30   321   5 22929  99   331   6
Latency             34842ms    1288us    6634ms   87944ms     195us   12239ms
1.96,1.96,xfs1,1,1295968991,16G,,445,98,106201,43,35407,33,939,99,83545,42,490.4,30,128,65536,,,512,308,4,24121,99,2393,30,321,5,22929,99,331,6,43307us,4614ms,242ms,37420us,195ms,128ms,34842ms,1288us,6634ms,87944ms,195us,12239ms


[[Note: Block write: drop to 60%, Block read drops to <50%]]

[[Add nobarriers]]

# mount -o remount,nobarriers /mnt/tmp
# mount | grep /mnt/tmp
/dev/mapper/castor0-test on /mnt/tmp type xfs (rw,noatime,delaylog,logbsize=262144,nobarriers)
# bonnie++ -d /mnt/tmp/foo -n 128:65536:0:512 -m xfs2 -u wd -g wd
Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
xfs2            16G   427  98 193950  65 52848  45   987  99 198110  83 496.5  25
Latency             41543us     128ms     186ms   14678us   67639us   76024us
Version  1.96       ------Sequential Create------ --------Random Create--------
xfs2                -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
files:max            /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
    128:65536:0/512   352   6 24513  99  2604  32   334   5 24921  99   333   6
Latency             32152ms    2307us    4148ms   31036ms     493us   23065ms
1.96,1.96,xfs2,1,1295966513,16G,,427,98,193950,65,52848,45,987,99,198110,83,496.5,25,128,65536,,,512,352,6,24513,99,2604,32,334,5,24921,99,333,6,41543us,128ms,186ms,14678us,67639us,76024us,32152ms,2307us,4148ms,31036ms,493us,23065ms


[[Much better.  But now compare ext4]]

# mkfs.ext4 /dev/mapper/castor0-test
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=4 blocks, Stripe width=16 blocks
2097152 inodes, 8388608 blocks
419430 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
256 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
        4096000, 7962624

Writing inode tables: done                            
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 22 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.
# mount /dev/mapper/castor0-test /mnt/tmp
# mount | grep /mnt/tmp
/dev/mapper/castor0-test on /mnt/tmp type ext4 (rw)
# mkdir /mnt/tmp/foo
# chown wd.wd /mnt/tmp/foo
# bonnie++ -d /mnt/tmp/foo -m ext4 -u wd -g wd
...
Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ext4            16G   248  99 128657  49 61267  49  1026  97 236552  85 710.9  35
Latency             78833us     567ms    2586ms   37539us   61572us   88413us
Version  1.96       ------Sequential Create------ --------Random Create--------
ext4                -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 14841  52 +++++ +++ 23164  70 20409  78 +++++ +++ 23441  73
Latency               206us    2384us    2372us    2322us      78us    2335us
1.96,1.96,ext4,1,1295954392,16G,,248,99,128657,49,61267,49,1026,97,236552,85,710.9,35,16,,,,,14841,52,+++++,+++,23164,70,20409,78,+++++,+++,23441,73,78833us,567ms,2586ms,37539us,61572us,88413us,206us,2384us,2372us,2322us,78us,2335us

[[Only 2/3 of the speed of XFS for block write, but nearly 20% faster
for block read.  But magnitudes faster for file creates / deletes!]]

[[add nobarrier]]

# mount -o remount,nobarrier /mnt/tmp
# mount | grep /mnt/tmp
/dev/mapper/castor0-test on /mnt/tmp type ext4.2 (rw,nobarrier)
# bonnie++ -d /mnt/tmp/foo -m ext4 -u wd -g wd
Version  1.96       ------Sequential Output------ --Sequential Input- --Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
ext4.2          16G   241  99 125446  50 57726  55   945  97 215698  87 509.2  54
Latency             81198us    1085ms    2479ms   46401us     111ms   83051us
Version  1.96       ------Sequential Create------ --------Random Create--------
ext4                -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16 12476  63 +++++ +++ 23990  66 21185  82 +++++ +++ 23039  82
Latency               440us    1019us    1094us     238us      25us     215us
1.96,1.96,ext4.2,1,1295996176,16G,,241,99,125446,50,57726,55,945,97,215698,87,509.2,54,16,,,,,12476,63,+++++,+++,23990,66,21185,82,+++++,+++,23039,82,81198us,1085ms,2479ms,46401us,111ms,83051us,440us,1019us,1094us,238us,25us,215us

[[Again, degradation of about 10% for block read; with only minod
advantages for seq. delete and random create]]



Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
For those who like this sort of thing, this is the sort of thing they
like.                                               - Abraham Lincoln
