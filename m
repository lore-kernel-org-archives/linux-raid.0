From: Adam Thompson <athompso@athompso.net>
Subject: Re: dead RAID6 array on CentOS6.6 / kernel 3.19
Date: Wed, 11 Feb 2015 12:21:49 -0600
Message-ID: <54DB9DBD.2040202@athompso.net>
References: <54DAB614.70302@athompso.net>	<54DAC0E2.2070303@turmel.org>	<54DAC42F.3090600@athompso.net>	<54DAC7A4.40407@turmel.org> <20150211152605.0c1bf94e@notabene.brown>
Reply-To: athompso@athompso.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150211152605.0c1bf94e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, "Cordes, Trevor" <trevor@tecnopolis.ca>
List-Id: linux-raid.ids

On 2015-02-10 10:26 PM, NeilBrown wrote:
>>> Also, kernel 3.19, which I mentioned we're running, pretty much *is* my
>>> definition of an up-to-date kernel... how much newer do you want me to
>>> try, and where would you recommend I find such a thing in a bootable image?
>> You're right, 3.19 should be fine.  I'm stumped.  Looks like a bug.
>> Adding Neil ....
> I think it is an mdadm bug.  I don't see a mention of mdadm version number
> (but I didn't look very hard).
> If you are using 3.3, update to at least 3.3.1
>
> (just
>    cd /tmp
>    git clone git://neil.brown.name/mdadm
>    cd mdadm
>    make
>    ./mdadm --assemble --force /dev/md127 .....
> )
>
> NeilBrown

So, I'm already running mdadm v3.3 from CentOS 6.6 (the precise package 
version# is in the original message).
I've tried building the latest-and-greatest, but fail on the RUN_DIR 
check.  Looks like it can be disabled with no downside... yup, compiles 
with no errors now.

Yay! mdadm from git was able to reassemble the array:
(I find it interesting that it bumped the event count up to 26307... 
*again*.  Old v3.3 mdadm already claims to have done exactly that.)

> [root@muug mdadm]# ./mdadm --verbose --assemble --force /dev/md127 
> /dev/sd[a-l]
> mdadm: looking for devices for /dev/md127
> mdadm: failed to get exclusive lock on mapfile - continue anyway...
> mdadm: /dev/sda is identified as a member of /dev/md127, slot 11.
> mdadm: /dev/sdb is identified as a member of /dev/md127, slot 2.
> mdadm: /dev/sdc is identified as a member of /dev/md127, slot 1.
> mdadm: /dev/sdd is identified as a member of /dev/md127, slot 3.
> mdadm: /dev/sde is identified as a member of /dev/md127, slot 5.
> mdadm: /dev/sdf is identified as a member of /dev/md127, slot 6.
> mdadm: /dev/sdg is identified as a member of /dev/md127, slot 7.
> mdadm: /dev/sdh is identified as a member of /dev/md127, slot 4.
> mdadm: /dev/sdi is identified as a member of /dev/md127, slot 8.
> mdadm: /dev/sdj is identified as a member of /dev/md127, slot 9.
> mdadm: /dev/sdk is identified as a member of /dev/md127, slot 10.
> mdadm: /dev/sdl is identified as a member of /dev/md127, slot 0.
> mdadm: forcing event count in /dev/sdf(6) from 26263 upto 26307
> mdadm: forcing event count in /dev/sdg(7) from 26263 upto 26307
> mdadm: forcing event count in /dev/sda(11) from 26263 upto 26307
> mdadm: clearing FAULTY flag for device 5 in /dev/md127 for /dev/sdf
> mdadm: clearing FAULTY flag for device 6 in /dev/md127 for /dev/sdg
> mdadm: clearing FAULTY flag for device 0 in /dev/md127 for /dev/sda
> mdadm: Marking array /dev/md127 as 'clean'
> mdadm: added /dev/sdc to /dev/md127 as 1
> mdadm: added /dev/sdb to /dev/md127 as 2
> mdadm: added /dev/sdd to /dev/md127 as 3
> mdadm: added /dev/sdh to /dev/md127 as 4
> mdadm: added /dev/sde to /dev/md127 as 5
> mdadm: added /dev/sdf to /dev/md127 as 6
> mdadm: added /dev/sdg to /dev/md127 as 7
> mdadm: added /dev/sdi to /dev/md127 as 8
> mdadm: added /dev/sdj to /dev/md127 as 9
> mdadm: added /dev/sdk to /dev/md127 as 10
> mdadm: added /dev/sda to /dev/md127 as 11
> mdadm: added /dev/sdl to /dev/md127 as 0
> mdadm: /dev/md127 has been started with 12 drives.
> [root@muug mdadm]# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
> md127 : active raid6 sdl[12] sda[13] sdk[10] sdj[9] sdi[8] sdg[7] 
> sdf[6] sde[5] sdh[4] sdd[3] sdb[2] sdc[1]
>       39068875120 blocks super 1.2 level 6, 4k chunk, algorithm 2 
> [12/12] [UUUUUUUUUUUU]
>       bitmap: 0/30 pages [0KB], 65536KB chunk
>
> md0 : active raid1 sdm1[0] sdn1[1]
>       1048512 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>
> unused devices: <none>

Kernel messages accompanying this:
> Feb 11 11:53:46 muug kernel: md: md127 stopped.
> Feb 11 11:53:47 muug kernel: md: bind<sdc>
> Feb 11 11:53:47 muug kernel: md: bind<sdb>
> Feb 11 11:53:47 muug kernel: md: bind<sdd>
> Feb 11 11:53:47 muug kernel: md: bind<sdh>
> Feb 11 11:53:47 muug kernel: md: bind<sde>
> Feb 11 11:53:47 muug kernel: md: bind<sdf>
> Feb 11 11:53:47 muug kernel: md: bind<sdg>
> Feb 11 11:53:47 muug kernel: md: bind<sdi>
> Feb 11 11:53:47 muug kernel: md: bind<sdj>
> Feb 11 11:53:47 muug kernel: md: bind<sdk>
> Feb 11 11:53:47 muug kernel: md: bind<sda>
> Feb 11 11:53:47 muug kernel: md: bind<sdl>
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdl operational as 
> raid disk 0
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sda operational as 
> raid disk 11
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdk operational as 
> raid disk 10
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdj operational as 
> raid disk 9
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdi operational as 
> raid disk 8
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdg operational as 
> raid disk 7
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdf operational as 
> raid disk 6
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sde operational as 
> raid disk 5
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdh operational as 
> raid disk 4
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdd operational as 
> raid disk 3
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdb operational as 
> raid disk 2
> Feb 11 11:53:47 muug kernel: md/raid:md127: device sdc operational as 
> raid disk 1
> Feb 11 11:53:47 muug kernel: md/raid:md127: allocated 0kB
> Feb 11 11:53:47 muug kernel: md/raid:md127: raid level 6 active with 
> 12 out of 12 devices, algorithm 2
> Feb 11 11:53:47 muug kernel: created bitmap (30 pages) for device md127
> Feb 11 11:53:47 muug kernel: md127: bitmap initialized from disk: read 
> 2 pages, set 280 of 59615 bits
> Feb 11 11:53:48 muug kernel: md127: detected capacity change from 0 to 
> 40006528122880
> Feb 11 11:53:48 muug kernel: md127: unknown partition table

Then, since it's an LVM PV:
> [root@muug ~]# pvscan
>   PV /dev/sdm2    VG vg00   lvm2 [110.79 GiB / 0    free]
>   PV /dev/sdn2    VG vg00   lvm2 [110.79 GiB / 24.00 MiB free]
>   PV /dev/md127   VG vg00   lvm2 [36.39 TiB / 0    free]
>   Total: 3 [36.60 TiB] / in use: 3 [36.60 TiB] / in no VG: 0 [0 ]
> [root@muug ~]# vgscan
>   Reading all physical volumes.  This may take a while...
>   Found volume group "vg00" using metadata type lvm2
> [root@muug ~]# lvscan
>   ACTIVE            '/dev/vg00/root' [64.00 GiB] inherit
>   ACTIVE            '/dev/vg00/swap' [32.00 GiB] inherit
>   inactive          '/dev/vg00/ARRAY' [36.39 TiB] inherit
>   inactive          '/dev/vg00/cache' [30.71 GiB] inherit
> [root@muug ~]# lvchange -a y /dev/vg00/ARRAY
> Feb 11 12:04:15 muug kernel: md/raid1:mdX: active with 2 out of 2 mirrors
> Feb 11 12:04:15 muug kernel: created bitmap (31 pages) for device mdX
> Feb 11 12:04:15 muug kernel: mdX: bitmap initialized from disk: read 2 
> pages, set 636 of 62904 bits
> Feb 11 12:04:15 muug kernel: md/raid1:mdX: active with 2 out of 2 mirrors
> Feb 11 12:04:15 muug kernel: created bitmap (1 pages) for device mdX
> Feb 11 12:04:15 muug kernel: mdX: bitmap initialized from disk: read 1 
> pages, set 1 of 64 bits
> Feb 11 12:04:15 muug kernel: device-mapper: cache-policy-mq: version 
> 1.3.0 loaded
> Feb 11 12:04:16 muug lvm[1418]: Monitoring RAID device 
> vg00-cache_cdata for events.
> Feb 11 12:04:16 muug lvm[1418]: Monitoring RAID device 
> vg00-cache_cmeta for events.
> [root@muug ~]# lvs
>   LV    VG   Attr       LSize  Pool  Origin        Data%  Meta% Move 
> Log Cpy%Sync Convert
>   ARRAY vg00 Cwi-a-C--- 36.39t cache [ARRAY_corig]
>   cache vg00 Cwi---C--- 30.71g
>   root  vg00 rwi-aor--- 
> 64.00g                                            100.00
>   swap  vg00 -wi-ao---- 32.00g
> [root@muug ~]# mount -oro /dev/vg00/ARRAY /ARRAY
> Feb 11 12:04:37 muug kernel: XFS (dm-17): Mounting V4 Filesystem
> Feb 11 12:04:38 muug kernel: XFS (dm-17): Ending clean mount
> [root@muug ~]# umount /ARRAY
> [root@muug ~]# mount /ARRAY
> Feb 11 12:04:45 muug kernel: XFS (dm-17): Mounting V4 Filesystem
> Feb 11 12:04:45 muug kernel: XFS (dm-17): Ending clean mount
> [root@muug ~]# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/mapper/vg00-root
>                        63G   22G   39G  36% /
> tmpfs                  16G     0   16G   0% /dev/shm
> /dev/md0             1008M , 278M  680M  29% /boot
> /dev/mapper/vg00-ARRAY
>                        37T   16T   21T  43% /ARRAY

Wow... xfs_check (xfs_db, actually) needed ~40GB of RAM to check the 
filesystem... but it thinks everything's OK.

The big question I have now:
     If it's a bug in:
          mdadm v3.3 and/or
          CentOS 6.6 rc scripts and/or
          kernel 3.19,
      what should I do to prevent future re-occurrences of the same 
problem?  I don't want to have to keep buying new underwear... ;-)


-- 
-Adam Thompson
  athompso@athompso.net
  +1 (204) 291-7950 - cell
  +1 (204) 489-6515 - fax

