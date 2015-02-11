From: Adam Thompson <athompso-gKoiEJA+T1nk1uMJSBkQmQ@public.gmane.org>
Subject: dead RAID6 array on CentOS6.6 / kernel 3.19
Date: Tue, 10 Feb 2015 19:53:24 -0600
Message-ID: <54DAB614.70302@athompso.net>
Reply-To: EL Repo General Mailing List <elrepo-XmKyDsxDEzbecEK0+Tl+uA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <elrepo-bounces-XmKyDsxDEzbecEK0+Tl+uA@public.gmane.org>
List-Unsubscribe: <http://lists.elrepo.org/mailman/options/elrepo>,
	<mailto:elrepo-request-XmKyDsxDEzbecEK0+Tl+uA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.elrepo.org/pipermail/elrepo/>
List-Post: <mailto:elrepo-XmKyDsxDEzbecEK0+Tl+uA@public.gmane.org>
List-Help: <mailto:elrepo-request-XmKyDsxDEzbecEK0+Tl+uA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.elrepo.org/mailman/listinfo/elrepo>,
	<mailto:elrepo-request-XmKyDsxDEzbecEK0+Tl+uA@public.gmane.org?subject=subscribe>
Sender: elrepo-bounces-XmKyDsxDEzbecEK0+Tl+uA@public.gmane.org
Errors-To: elrepo-bounces-XmKyDsxDEzbecEK0+Tl+uA@public.gmane.org
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Board, MUUG" <board-wsAeYLWIHPyw5LPnMra/2Q@public.gmane.org>, elrepo-XmKyDsxDEzbecEK0+Tl+uA@public.gmane.org
List-Id: linux-raid.ids

So, I was doing some work on the new server tonight, stopping/starting 
NFS caused a kernel panic, and I thought rebooting would be a good 
idea... Apparently not!

> Feb 10 18:48:57 muug kernel: md: kicking non-fresh sdd from array!
> Feb 10 18:48:57 muug kernel: md: unbind<sdd>
> Feb 10 18:48:57 muug kernel: md: export_rdev(sdd)
> Feb 10 18:48:57 muug kernel: md: kicking non-fresh sdb from array!
> Feb 10 18:48:57 muug kernel: md: unbind<sdb>
> Feb 10 18:48:57 muug kernel: md: export_rdev(sdb)
> Feb 10 18:48:57 muug kernel: md: kicking non-fresh sdc from array!
> Feb 10 18:48:57 muug kernel: md: unbind<sdc>
> Feb 10 18:48:57 muug kernel: md: export_rdev(sdc)
> Feb 10 18:48:57 muug kernel: md: kicking non-fresh sdh from array!
> Feb 10 18:48:57 muug kernel: md: unbind<sdh>
> Feb 10 18:48:57 muug kernel: md: export_rdev(sdh)
> Feb 10 18:48:57 muug kernel: md: kicking non-fresh sda from array!
> Feb 10 18:48:57 muug kernel: md: unbind<sda>
> Feb 10 18:48:57 muug kernel: md: export_rdev(sda)
> Feb 10 18:48:57 muug kernel: md: kicking non-fresh sdg from array!
> Feb 10 18:48:57 muug kernel: md: unbind<sdg>
> Feb 10 18:48:57 muug kernel: md: export_rdev(sdg)
> Feb 10 18:48:57 muug kernel: md: kicking non-fresh sdf from array!
> Feb 10 18:48:57 muug kernel: md: unbind<sdf>
> Feb 10 18:48:57 muug kernel: md: export_rdev(sdf)
> Feb 10 18:48:57 muug kernel: md: kicking non-fresh sde from array!
> Feb 10 18:48:57 muug kernel: md: unbind<sde>
> Feb 10 18:48:57 muug kernel: md: export_rdev(sde)
> Feb 10 18:48:57 muug kernel: md/raid:md127: not clean -- starting 
> background reconstruction
> Feb 10 18:48:57 muug kernel: md/raid:md127: device sdk operational as 
> raid disk 10
> Feb 10 18:48:57 muug kernel: md/raid:md127: device sdj operational as 
> raid disk 9
> Feb 10 18:48:57 muug kernel: md/raid:md127: device sdi operational as 
> raid disk 8
> Feb 10 18:48:57 muug kernel: md/raid:md127: device sdl operational as 
> raid disk 0
> Feb 10 18:48:57 muug kernel: md/raid:md127: allocated 0kB
> Feb 10 18:48:57 muug kernel: md/raid:md127: not enough operational 
> devices (8/12 failed)
> Feb 10 18:48:57 muug kernel: md/raid:md127: failed to run raid set.
> Feb 10 18:48:57 muug kernel: md: pers->run() failed ...

Sure enough, no array.
> [root@muug ~]# cat /proc/mdstat
> Personalities : [raid1] [raid6] [raid5] [raid4] [raid10]
> md0 : active raid1 sdm1[0] sdn1[1]
>       1048512 blocks super 1.0 [2/2] [UU]
>       bitmap: 0/1 pages [0KB], 65536KB chunk
>
> md127 : inactive sdk[10] sdj[9] sdi[8] sdl[12]
>       15627550048 blocks super 1.2
>
> unused devices: <none>

Much to my very great chagrin, I had moved some (un-backed-up) personal 
data onto that server temporarily, and [redacted] has some un-backed-up 
data on there as well, so while *most* of the data on there is our FTP 
mirror and can be recreated (at only the cost of bandwidth), there's a 
bunch of stuff (about 2 or 3 TB, out of the ~10-20TB used) on there I'd 
really, *really* rather not lose.

The server isn't backed up because it *is* the backup.  Except for some 
of the data, where this backup copy is currently the only copy.  Plus, 
where do you back up 40TB *to*?

For the linux-raid and elrepo mailing list readers, this is a CentOS 6.6 
(x86_64) server, running the kernel from 
kernel-ml-3.19.0-1.el6.elrepo.x86_64 to get support for the motherboard 
chipset (ie31200_edac, in particular) and mdadm from 
mdadm-3.3-6.el6_6.1.x86_64.

Array is a ~40TB XFS filesystem on LVM running on an md device composed 
12 x 4TB drives in RAID6 (no hotspares).  Mixture of HGST, Seagate and 
WD drives, all NAS series, all in an Asus RS300-H8-PS12 system, and thus 
spread across two SATA controllers.  Note complete lack of partition 
tables on RAID6 devices - this was deliberate, to work around 
limitations of the ASUS BIOS compat. layer when presented with so many 
partitioned devices.  The system is not booting in EFI mode, if that 
makes any difference.

/dev/sd[nm] are a pair of SSDs in RAID1 providing boot/root and 
lvmcache.  (No swap.)  I don't think the lvmcache is part of the problem 
here, since although the storage setup is moderately complex, it's 
cleanly layered - we're NOT using LVM's built-in RAID that somehow uses 
MD, we're using LVM on top of MD RAID.

Per the RAID Recovery wiki, I've already attempted to reassemble the 
array with --force, which didn't quite work.

I ran the assemble command a second time, with almost identical results 
- no messages about changing event counts or flags, but same 9-drive result.

Other than the kernel panic immediately prior to rebooting - which did 
not render the system unbootable, we've only seen very occasional 
glitches, with a few of the drives timing out once or twice.  I'd 
attributed that to vibration or controller starvation until now.  The 
reboot *appeared* to proceed successfully, there's no smoking gun in 
/var/log/messages that I can identify other than some I/O errors on one 
drive (/dev/sdc) during - AFAIK - the weekly "scrub".

Also per the RAID recovery wiki, at this point I'm stopping and 
soliciting help before continuing with the attempt to force re-creation 
of the md device.

I've included quite some data and output here, not sure what else will 
be helpful at this juncture.  Feel free to ask.

I'm noticing in the output that it looks like mdadm is trying to start 
the new array before all the drives have been bound... but I'm not sure 
what to do about that.

Thanks in advance for any useful insights that will enable me to recover 
any of the data.

-Adam Thompson
  System Administrator (for now), Past President,
  Manitoba UNIX User Group
  athompso-gKoiEJA+T1nk1uMJSBkQmQ@public.gmane.org




Output from mdadm --assemble --force :
> [root@muug ~]# mdadm --assemble --force /dev/md127 /dev/sd[lcbdhefgijka]
> Feb 10 19:10:15 muug kernel: md: md127 stopped.
> mdadm: forcing event count in /dev/sdc(1) from 26263 upto 26307
> mdadm: forcing event count in /dev/sdb(2) from 26263 upto 26307
> mdadm: forcing event count in /dev/sdd(3) from 26263 upto 26307
> mdadm: forcing event count in /dev/sdh(4) from 26263 upto 26307
> mdadm: forcing event count in /dev/sde(5) from 26263 upto 26307
> mdadm: clearing FAULTY flag for device 2 in /dev/md127 for /dev/sdc
> mdadm: clearing FAULTY flag for device 1 in /dev/md127 for /dev/sdb
> mdadm: clearing FAULTY flag for device 3 in /dev/md127 for /dev/sdd
> mdadm: clearing FAULTY flag for device 7 in /dev/md127 for /dev/sdh
> mdadm: clearing FAULTY flag for device 4 in /dev/md127 for /dev/sde
> mdadm: Marking array /dev/md127 as 'clean'
> Feb 10 19:10:18 muug kernel: md: bind<sdc>
> Feb 10 19:10:18 muug kernel: md: bind<sdb>
> Feb 10 19:10:18 muug kernel: md: bind<sdd>
> Feb 10 19:10:18 muug kernel: md: bind<sdh>
> Feb 10 19:10:18 muug kernel: md: bind<sde>
> Feb 10 19:10:18 muug kernel: md: bind<sdf>
> Feb 10 19:10:18 muug kernel: md: bind<sdg>
> Feb 10 19:10:18 muug kernel: md: bind<sdi>
> Feb 10 19:10:18 muug kernel: md: bind<sdj>
> mdadm: /dev/md127 assembled from 9 drives - not enough to start the array.
> Feb 10 19:10:18 muug kernel: md: bind<sdk>
> Feb 10 19:10:18 muug kernel: md: bind<sda>
> Feb 10 19:10:18 muug kernel: md: bind<sdl>
> Feb 10 19:10:18 muug kernel: md: md127 stopped.
> Feb 10 19:10:18 muug kernel: md: unbind<sdl>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sdl)
> Feb 10 19:10:18 muug kernel: md: unbind<sda>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sda)
> Feb 10 19:10:18 muug kernel: md: unbind<sdk>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sdk)
> Feb 10 19:10:18 muug kernel: md: unbind<sdj>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sdj)
> Feb 10 19:10:18 muug kernel: md: unbind<sdi>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sdi)
> Feb 10 19:10:18 muug kernel: md: unbind<sdg>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sdg)
> Feb 10 19:10:18 muug kernel: md: unbind<sdf>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sdf)
> Feb 10 19:10:18 muug kernel: md: unbind<sde>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sde)
> Feb 10 19:10:18 muug kernel: md: unbind<sdh>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sdh)
> Feb 10 19:10:18 muug kernel: md: unbind<sdd>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sdd)
> Feb 10 19:10:18 muug kernel: md: unbind<sdb>
> Feb 10 19:10:18 muug kernel: md: export_rdev(sdb)
> Feb 10 19:10:18 muug kernel: md: unbind<sdc>
> [root@muug ~]# Feb 10 19:10:18 muug kernel: md: export_rdev(sdc)


Output from mdadm --examine /dev/sd[abcdefghijkl] *before* running 
--assemble --force :

> /dev/sda:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 85613308:17b75e83:7209c7e5:2dd2f59b
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 1bcd84d - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 11
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : ea2b9cb8:c2ad12e4:75d8b93b:0f752d85
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 52040b37 - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 2
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 56455a20:9fa5587d:1f61b896:43e5b8ef
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 1892155d - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 1
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdd:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : d60dd4e5:fb8565ee:1a348e5d:c5740d6a
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 904320b8 - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 3
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sde:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 55e6552e:f32eda98:44ed3844:1b831101
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : e869b0 - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 5
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdf:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : a8862067:9f25c7d1:55819755:54f0e781
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 4d501fb - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 6
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdg:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 8a747d19:da4f2e41:fc132de1:1e172e4a
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 7a74d389 - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 7
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdh:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 5cfa7095:2b13d03e:bed02e9a:cfb5b516
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 7993781c - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 4
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdi:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : fcf4686b:8bc3ed9b:1a88c898:f138d434
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:47 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : c93f5dc0 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 8
>    Array State : A.......AAA. ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdj:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : f069d226:cc3a580c:2ca5d244:2a53f3e6
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:47 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 533c8141 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 9
>    Array State : A.......AAA. ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdk:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 69da9e3f:f31bffff:022ce721:d73acdc3
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:47 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 199e4166 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 10
>    Array State : A.......AAA. ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdl:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : dc4dfde5:0e5c02e3:ba89e83f:e6d1664c
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:47 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 499ae9bd - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 0
>    Array State : A.......AAA. ('A' == active, '.' == missing, 'R' == 
> replacing)
> [root@muug ~]#


Output from same *after* --assemble --force:
> /dev/sda:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 85613308:17b75e83:7209c7e5:2dd2f59b
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 1bcd84d - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 11
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : ea2b9cb8:c2ad12e4:75d8b93b:0f752d85
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 52040b63 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 2
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 56455a20:9fa5587d:1f61b896:43e5b8ef
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 18921589 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 1
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdd:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : d60dd4e5:fb8565ee:1a348e5d:c5740d6a
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 904320e4 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 3
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sde:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 55e6552e:f32eda98:44ed3844:1b831101
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : e869dc - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 5
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdf:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : a8862067:9f25c7d1:55819755:54f0e781
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 4d501fb - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 6
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdg:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 8a747d19:da4f2e41:fc132de1:1e172e4a
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 7a74d389 - correct
>          Events : 26263
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 7
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdh:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 5cfa7095:2b13d03e:bed02e9a:cfb5b516
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:44 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 79937848 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 4
>    Array State : AAAAAAAAAAAA ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdi:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : fcf4686b:8bc3ed9b:1a88c898:f138d434
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:47 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : c93f5dc0 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 8
>    Array State : A.......AAA. ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdj:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : f069d226:cc3a580c:2ca5d244:2a53f3e6
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:47 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 533c8141 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 9
>    Array State : A.......AAA. ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdk:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : active
>     Device UUID : 69da9e3f:f31bffff:022ce721:d73acdc3
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:47 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 199e4166 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 10
>    Array State : A.......AAA. ('A' == active, '.' == missing, 'R' == 
> replacing)
> /dev/sdl:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : ca23c162:1ba5d5bd:e20e321a:54fc97e0
>            Name : muug.ca:ARRAY  (local to host muug.ca)
>   Creation Time : Thu Nov 20 09:35:10 2014
>      Raid Level : raid6
>    Raid Devices : 12
>
>  Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>      Array Size : 39068875120 (37258.98 GiB 40006.53 GB)
>     Data Offset : 262144 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=262056 sectors, after=0 sectors
>           State : clean
>     Device UUID : dc4dfde5:0e5c02e3:ba89e83f:e6d1664c
>
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Tue Feb 10 18:47:47 2015
>   Bad Block Log : 512 entries available at offset 72 sectors
>        Checksum : 49a7e9c4 - correct
>          Events : 26307
>
>          Layout : left-symmetric
>      Chunk Size : 4K
>
>    Device Role : Active device 0
>    Array State : AAAAAA..AAA. ('A' == active, '.' == missing, 'R' == 
> replacing)




Dmesg:
> Initializing cgroup subsys cpuset
> Initializing cgroup subsys cpu
> Initializing cgroup subsys cpuacct
> Linux version 3.19.0-1.el6.elrepo.x86_64 (mockbuild@Build64R6) (gcc 
> version 4.4.7 20120313 (Red Hat 4.4.7-11) (GCC) ) #1 SMP Mon Feb 9 
> 11:00:58 EST 2015
> Command line: ro root=/dev/mapper/vg00-root rd_LVM_LV=vg00/swap 
> LANG=en_CA.UTF-8 rd_LVM_LV=vg00/root SYSFONT=latarcyrheb-sun16 
> crashkernel=auto  KEYBOARDTYPE=pc KEYTABLE=us
> e820: BIOS-provided physical RAM map:
> BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
> BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
> BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> BIOS-e820: [mem 0x0000000000100000-0x000000006e1d0fff] usable
> BIOS-e820: [mem 0x000000006e1d1000-0x000000006e1d7fff] ACPI NVS
> BIOS-e820: [mem 0x000000006e1d8000-0x000000007d7effff] usable
> BIOS-e820: [mem 0x000000007d7f0000-0x000000007da0bfff] reserved
> BIOS-e820: [mem 0x000000007da0c000-0x000000007da26fff] ACPI data
> BIOS-e820: [mem 0x000000007da27000-0x000000007daf0fff] ACPI NVS
> BIOS-e820: [mem 0x000000007daf1000-0x000000007effefff] reserved
> BIOS-e820: [mem 0x000000007efff000-0x000000007effffff] usable
> BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] reserved
> BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
> BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
> BIOS-e820: [mem 0x0000000100000000-0x000000087fffffff] usable
> NX (Execute Disable) protection: active
> SMBIOS 2.7 present.
> DMI: ASUSTeK COMPUTER INC. RS300-H8-PS12/P9D-MH Series, BIOS 0701 
> 07/03/2014
> e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> e820: remove [mem 0x000a0000-0x000fffff] usable
> AGP: No AGP bridge found
> e820: last_pfn = 0x880000 max_arch_pfn = 0x400000000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-CBFFF write-protect
>   CC000-E7FFF uncachable
>   E8000-FFFFF write-protect
> MTRR variable ranges enabled:
>   0 base 0000000000 mask 7800000000 write-back
>   1 base 0800000000 mask 7F80000000 write-back
>   2 base 0080000000 mask 7F80000000 uncachable
>   3 disabled
>   4 disabled
>   5 disabled
>   6 disabled
>   7 disabled
>   8 disabled
>   9 disabled
> PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC
> original variable MTRRs
> reg 0, base: 0GB, range: 32GB, type WB
> reg 1, base: 32GB, range: 2GB, type WB
> reg 2, base: 2GB, range: 2GB, type UC
> total RAM covered: 32768M
> Found optimal setting for mtrr clean up
>  gran_size: 64K     chunk_size: 64K     num_reg: 5      lose cover RAM: 0G
> New variable MTRRs
> reg 0, base: 0GB, range: 2GB, type WB
> reg 1, base: 4GB, range: 4GB, type WB
> reg 2, base: 8GB, range: 8GB, type WB
> reg 3, base: 16GB, range: 16GB, type WB
> reg 4, base: 32GB, range: 2GB, type WB
> e820: update [mem 0x80000000-0xffffffff] usable ==> reserved
> e820: last_pfn = 0x7f000 max_arch_pfn = 0x400000000
> found SMP MP-table at [mem 0x000fd960-0x000fd96f] mapped at 
> [ffff8800000fd960]
> Base memory trampoline at [ffff880000096000] 96000 size 28672
> Using GB pages for direct mapping
> init_memory_mapping: [mem 0x00000000-0x000fffff]
>  [mem 0x00000000-0x000fffff] page 4k
> BRK [0x0211e000, 0x0211efff] PGTABLE
> BRK [0x0211f000, 0x0211ffff] PGTABLE
> BRK [0x02120000, 0x02120fff] PGTABLE
> init_memory_mapping: [mem 0x87fe00000-0x87fffffff]
>  [mem 0x87fe00000-0x87fffffff] page 1G
> init_memory_mapping: [mem 0x860000000-0x87fdfffff]
>  [mem 0x860000000-0x87fdfffff] page 1G
> init_memory_mapping: [mem 0x00100000-0x6e1d0fff]
>  [mem 0x00100000-0x001fffff] page 4k
>  [mem 0x00200000-0x6dffffff] page 2M
>  [mem 0x6e000000-0x6e1d0fff] page 4k
> init_memory_mapping: [mem 0x6e1d8000-0x7d7effff]
>  [mem 0x6e1d8000-0x6e1fffff] page 4k
>  [mem 0x6e200000-0x7d5fffff] page 2M
>  [mem 0x7d600000-0x7d7effff] page 4k
> BRK [0x02121000, 0x02121fff] PGTABLE
> init_memory_mapping: [mem 0x7efff000-0x7effffff]
>  [mem 0x7efff000-0x7effffff] page 4k
> BRK [0x02122000, 0x02122fff] PGTABLE
> init_memory_mapping: [mem 0x100000000-0x85fffffff]
>  [mem 0x100000000-0x85fffffff] page 1G
> RAMDISK: [mem 0x36a98000-0x37feffff]
> ACPI: Early table checksum verification disabled
> ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
> ACPI: XSDT 0x000000007DA110A0 0000B4 (v01 ALASKA A M I 01072009 AMI  
> 00010013)
> ACPI: FACP 0x000000007DA20A28 00010C (v05 ALASKA A M I 01072009 AMI  
> 00010013)
> ACPI: DSDT 0x000000007DA111E8 00F83B (v02 ALASKA A M I 00000010 INTL 
> 20091112)
> ACPI: FACS 0x000000007DAEF080 000040
> ACPI: APIC 0x000000007DA20B38 000092 (v03 ALASKA A M I 01072009 AMI  
> 00010013)
> ACPI: FPDT 0x000000007DA20BD0 000044 (v01 ALASKA A M I 01072009 AMI  
> 00010013)
> ACPI: SSDT 0x000000007DA20C18 000539 (v01 PmRef  Cpu0Ist 00003000 INTL 
> 20120711)
> ACPI: SSDT 0x000000007DA21158 000AD8 (v01 PmRef  CpuPm 00003000 INTL 
> 20120711)
> ACPI: SSDT 0x000000007DA21C30 0002DE (v01 PmRef  Cpu0Tst 00003000 INTL 
> 20120711)
> ACPI: SSDT 0x000000007DA21F10 000348 (v01 PmRef  ApTst 00003000 INTL 
> 20120711)
> ACPI: MCFG 0x000000007DA22258 00003C (v01 ALASKA A M I 01072009 MSFT 
> 00000097)
> ACPI: PRAD 0x000000007DA22298 0000BE (v02 PRADID PRADTID 00000001 MSFT 
> 03000001)
> ACPI: HPET 0x000000007DA22358 000038 (v01 ALASKA A M I 01072009 AMI. 
> 00000005)
> ACPI: SSDT 0x000000007DA22390 00036D (v01 SataRe SataTabl 00001000 
> INTL 20120711)
> ACPI: SSDT 0x000000007DA22700 003562 (v01 SaSsdt SaSsdt 00003000 INTL 
> 20091112)
> ACPI: BERT 0x000000007DA26188 000030 (v01 AMI    AMI BERT 
> 00000000      00000000)
> ACPI: SPMI 0x000000007DA25CC0 000040 (v05 A M I  OEMSPMI 00000000 AMI. 
> 00000000)
> ACPI: DMAR 0x000000007DA25D00 000080 (v01 INTEL  HSW 00000001 INTL 
> 00000001)
> ACPI: EINJ 0x000000007DA25D80 000130 (v01 AMI    AMI EINJ 
> 00000000      00000000)
> ACPI: ERST 0x000000007DA25EB0 000230 (v01 AMIER  AMI ERST 
> 00000000      00000000)
> ACPI: HEST 0x000000007DA260E0 0000A8 (v01 AMI    AMI HEST 
> 00000000      00000000)
> ACPI: Local APIC address 0xfee00000
> No NUMA configuration found
> Faking a node at [mem 0x0000000000000000-0x000000087fffffff]
> NODE_DATA(0) allocated [mem 0x87ffd8000-0x87fffdfff]
> kexec: crashkernel: memory value expected
>  [ffffea0000000000-ffffea0021ffffff] PMD -> 
> [ffff88085f600000-ffff88087f5fffff] on node 0
> Zone ranges:
>   DMA      [mem 0x00001000-0x00ffffff]
>   DMA32    [mem 0x01000000-0xffffffff]
>   Normal   [mem 0x100000000-0x87fffffff]
> Movable zone start for each node
> Early memory node ranges
>   node   0: [mem 0x00001000-0x0009cfff]
>   node   0: [mem 0x00100000-0x6e1d0fff]
>   node   0: [mem 0x6e1d8000-0x7d7effff]
>   node   0: [mem 0x7efff000-0x7effffff]
>   node   0: [mem 0x100000000-0x87fffffff]
> Initmem setup node 0 [mem 0x00001000-0x87fffffff]
> On node 0 totalpages: 8378246
>   DMA zone: 64 pages used for memmap
>   DMA zone: 22 pages reserved
>   DMA zone: 3996 pages, LIFO batch:0
>   DMA32 zone: 7968 pages used for memmap
>   DMA32 zone: 509930 pages, LIFO batch:31
>   Normal zone: 122880 pages used for memmap
>   Normal zone: 7864320 pages, LIFO batch:31
> ACPI: PM-Timer IO Port: 0x1808
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
> ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
> ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
> ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
> ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
> ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
> ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ9 used by override.
> Using ACPI (MADT) for SMP configuration information
> ACPI: HPET id: 0x8086a701 base: 0xfed00000
> smpboot: Allowing 8 CPUs, 0 hotplug CPUs
> PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
> PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
> PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
> PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
> PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
> PM: Registered nosave memory: [mem 0x6e1d1000-0x6e1d7fff]
> PM: Registered nosave memory: [mem 0x7d7f0000-0x7da0bfff]
> PM: Registered nosave memory: [mem 0x7da0c000-0x7da26fff]
> PM: Registered nosave memory: [mem 0x7da27000-0x7daf0fff]
> PM: Registered nosave memory: [mem 0x7daf1000-0x7effefff]
> PM: Registered nosave memory: [mem 0x7f000000-0xdfffffff]
> PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
> PM: Registered nosave memory: [mem 0xf0000000-0xfebfffff]
> PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
> PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
> PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
> PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
> PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
> PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
> PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
> PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
> PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
> e820: [mem 0x7f000000-0xdfffffff] available for PCI devices
> Booting paravirtualized kernel on bare hardware
> setup_percpu: NR_CPUS:8192 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
> PERCPU: Embedded 31 pages/cpu @ffff88087fc00000 s86336 r8192 d32448 
> u262144
> pcpu-alloc: s86336 r8192 d32448 u262144 alloc=1*2097152
> pcpu-alloc: [0] 0 1 2 3 4 5 6 7
> Built 1 zonelists in Node order, mobility grouping on.  Total pages: 
> 8247312
> Policy zone: Normal
> Kernel command line: ro root=/dev/mapper/vg00-root rd_LVM_LV=vg00/swap 
> LANG=en_CA.UTF-8 rd_LVM_LV=vg00/root SYSFONT=latarcyrheb-sun16 
> crashkernel=auto  KEYBOARDTYPE=pc KEYTABLE=us
> PID hash table entries: 4096 (order: 3, 32768 bytes)
> xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
> AGP: Checking aperture...
> AGP: No AGP bridge found
> Memory: 32881732K/33512984K available (6652K kernel code, 1412K 
> rwdata, 3316K rodata, 1960K init, 1832K bss, 631252K reserved, 0K 
> cma-reserved)
> Hierarchical RCU implementation.
>     RCU restricting CPUs from NR_CPUS=8192 to nr_cpu_ids=8.
> RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
> NR_IRQS:524544 nr_irqs:488 16
>     Offload RCU callbacks from all CPUs
>     Offload RCU callbacks from CPUs: 0-7.
> Console: colour VGA+ 80x25
> console [tty0] enabled
> hpet clockevent registered
> tsc: Fast TSC calibration using PIT
> spurious 8259A interrupt: IRQ7.
> tsc: Detected 3292.465 MHz processor
> Calibrating delay loop (skipped), value calculated using timer 
> frequency.. 6584.93 BogoMIPS (lpj=3292465)
> pid_max: default: 32768 minimum: 301
> ACPI: Core revision 20141107
> ACPI: All ACPI Tables successfully acquired
> Security Framework initialized
> SELinux:  Initializing.
> SELinux:  Starting in permissive mode
> Dentry cache hash table entries: 4194304 (order: 13, 33554432 bytes)
> Inode-cache hash table entries: 2097152 (order: 12, 16777216 bytes)
> Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
> Mountpoint-cache hash table entries: 65536 (order: 7, 524288 bytes)
> Initializing cgroup subsys memory
> Initializing cgroup subsys devices
> Initializing cgroup subsys freezer
> Initializing cgroup subsys net_cls
> Initializing cgroup subsys blkio
> Initializing cgroup subsys perf_event
> Initializing cgroup subsys net_prio
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> mce: CPU supports 9 MCE banks
> CPU0: Thermal monitoring enabled (TM1)
> Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
> Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
> Freeing SMP alternatives memory: 24K (ffffffff81f4c000 - ffffffff81f52000)
> ftrace: allocating 27349 entries in 107 pages
> dmar: Host address width 39
> dmar: DRHD base: 0x000000fed90000 flags: 0x1
> dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap d2008c20660462 ecap 
> f010da
> dmar: RMRR base: 0x0000007d98a000 end: 0x0000007d996fff
> IOAPIC id 8 under DRHD base  0xfed90000 IOMMU 0
> HPET id 0 under DRHD base 0xfed90000
> Queued invalidation will be enabled to support x2apic and Intr-remapping.
> Enabled IRQ remapping in x2apic mode
> Enabling x2apic
> Enabled x2apic
> Switched APIC routing to cluster x2apic.
> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> smpboot: CPU0: Intel(R) Xeon(R) CPU E3-1230 v3 @ 3.30GHz (fam: 06, 
> model: 3c, stepping: 03)
> TSC deadline timer enabled
> Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, 
> full-width counters, Intel PMU driver.
> ... version:                3
> ... bit width:              48
> ... generic registers:      4
> ... value mask:             0000ffffffffffff
> ... max period:             0000ffffffffffff
> ... fixed-purpose events:   3
> ... event mask:             000000070000000f
> x86: Booting SMP configuration:
> .... node  #0, CPUs:      #1
> NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU 
> counter.
>  #2 #3 #4 #5 #6 #7
> x86: Booted up 1 node, 8 CPUs
> smpboot: Total of 8 processors activated (52679.44 BogoMIPS)
> devtmpfs: initialized
> PM: Registering ACPI NVS region [mem 0x6e1d1000-0x6e1d7fff] (28672 bytes)
> PM: Registering ACPI NVS region [mem 0x7da27000-0x7daf0fff] (827392 bytes)
> NET: Registered protocol family 16
> cpuidle: using governor ladder
> cpuidle: using governor menu
> ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
> ACPI: bus type PCI registered
> PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
> 0xe0000000-0xefffffff] (base 0xe0000000)
> PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
> PCI: Using configuration type 1 for base access
> ACPI: Added _OSI(Module Device)
> ACPI: Added _OSI(Processor Device)
> ACPI: Added _OSI(3.0 _SCP Extensions)
> ACPI: Added _OSI(Processor Aggregator Device)
> ACPI: Executed 1 blocks of module-level executable AML code
> [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT 0xFFFF88085B926400 0003D3 (v01 PmRef  Cpu0Cst 00003001 INTL 
> 20120711)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT 0xFFFF88085B413800 0005AA (v01 PmRef  ApIst 00003000 INTL 
> 20120711)
> ACPI: Dynamic OEM Table Load:
> ACPI: SSDT 0xFFFF88085B921800 000119 (v01 PmRef  ApCst 00003000 INTL 
> 20120711)
> ACPI: Interpreter enabled
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] 
> (20141107/hwxface-580)
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] 
> (20141107/hwxface-580)
> ACPI: (supports S0 S3 S4 S5)
> ACPI: Using IOAPIC for interrupt routing
> HEST: Table parsing has been initialized.
> PCI: Using host bridge windows from ACPI; if necessary, use 
> "pci=nocrs" and report a bug
> ACPI: Power Resource [FN00] (off)
> ACPI: Power Resource [FN01] (off)
> ACPI: Power Resource [FN02] (off)
> ACPI: Power Resource [FN03] (off)
> ACPI: Power Resource [FN04] (off)
> ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
> acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM 
> Segments MSI]
> acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER 
> PCIeCapability]
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: root bus resource [bus 00-fe]
> pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
> pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
> pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
> pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
> pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
> pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
> pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
> pci_bus 0000:00: root bus resource [mem 0x80000000-0xfeafffff]
> pci 0000:00:00.0: [8086:0c08] type 00 class 0x060000
> pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
> pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:01.0: System wakeup disabled by ACPI
> pci 0000:00:01.2: [8086:0c09] type 01 class 0x060400
> pci 0000:00:01.2: PME# supported from D0 D3hot D3cold
> pci 0000:00:01.2: System wakeup disabled by ACPI
> pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
> pci 0000:00:14.0: reg 0x10: [mem 0xde600000-0xde60ffff 64bit]
> pci 0000:00:14.0: PME# supported from D3hot D3cold
> pci 0000:00:14.0: System wakeup disabled by ACPI
> pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
> pci 0000:00:16.0: reg 0x10: [mem 0xde615000-0xde61500f 64bit]
> pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:16.1: [8086:8c3b] type 00 class 0x078000
> pci 0000:00:16.1: reg 0x10: [mem 0xde614000-0xde61400f 64bit]
> pci 0000:00:16.1: PME# supported from D0 D3hot D3cold
> pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
> pci 0000:00:1a.0: reg 0x10: [mem 0xde612000-0xde6123ff]
> pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:1a.0: System wakeup disabled by ACPI
> pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
> pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.0: Enabling MPC IRBNCE
> pci 0000:00:1c.0: Intel PCH root port ACS workaround enabled
> pci 0000:00:1c.0: System wakeup disabled by ACPI
> pci 0000:00:1c.1: [8086:8c12] type 01 class 0x060400
> pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.1: Enabling MPC IRBNCE
> pci 0000:00:1c.1: Intel PCH root port ACS workaround enabled
> pci 0000:00:1c.1: System wakeup disabled by ACPI
> pci 0000:00:1c.2: [8086:8c14] type 01 class 0x060400
> pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
> pci 0000:00:1c.2: Enabling MPC IRBNCE
> pci 0000:00:1c.2: Intel PCH root port ACS workaround enabled
> pci 0000:00:1c.2: System wakeup disabled by ACPI
> pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
> pci 0000:00:1d.0: reg 0x10: [mem 0xde611000-0xde6113ff]
> pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> pci 0000:00:1d.0: System wakeup disabled by ACPI
> pci 0000:00:1f.0: [8086:8c54] type 00 class 0x060100
> pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
> pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
> pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
> pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
> pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
> pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
> pci 0000:00:1f.2: reg 0x24: [mem 0xde610000-0xde6107ff]
> pci 0000:00:1f.2: PME# supported from D3hot
> pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
> pci 0000:00:1f.3: reg 0x10: [mem 0x7ffff01000-0x7ffff010ff 64bit]
> pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
> pci 0000:01:00.0: [1000:0087] type 00 class 0x010700
> pci 0000:01:00.0: reg 0x10: [io  0xe000-0xe0ff]
> pci 0000:01:00.0: reg 0x14: [mem 0xde240000-0xde24ffff 64bit]
> pci 0000:01:00.0: reg 0x1c: [mem 0xde200000-0xde23ffff 64bit]
> pci 0000:01:00.0: reg 0x30: [mem 0xde100000-0xde1fffff pref]
> pci 0000:01:00.0: supports D1 D2
> pci 0000:01:00.0: System wakeup disabled by ACPI
> pci 0000:00:01.0: PCI bridge to [bus 01]
> pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
> pci 0000:00:01.0:   bridge window [mem 0xde100000-0xde2fffff]
> pci 0000:02:00.0: [14e4:16a1] type 00 class 0x020000
> pci 0000:02:00.0: reg 0x10: [mem 0xdb000000-0xdb7fffff 64bit pref]
> pci 0000:02:00.0: reg 0x18: [mem 0xda800000-0xdaffffff 64bit pref]
> pci 0000:02:00.0: reg 0x20: [mem 0xdb810000-0xdb81ffff 64bit pref]
> pci 0000:02:00.0: reg 0x30: [mem 0xde580000-0xde5fffff pref]
> pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:02:00.0: System wakeup disabled by ACPI
> pci 0000:02:00.1: [14e4:16a1] type 00 class 0x020000
> pci 0000:02:00.1: reg 0x10: [mem 0xda000000-0xda7fffff 64bit pref]
> pci 0000:02:00.1: reg 0x18: [mem 0xd9800000-0xd9ffffff 64bit pref]
> pci 0000:02:00.1: reg 0x20: [mem 0xdb800000-0xdb80ffff 64bit pref]
> pci 0000:02:00.1: reg 0x30: [mem 0xde500000-0xde57ffff pref]
> pci 0000:02:00.1: PME# supported from D0 D3hot D3cold
> pci 0000:00:01.2: PCI bridge to [bus 02]
> pci 0000:00:01.2:   bridge window [mem 0xde500000-0xde5fffff]
> pci 0000:00:01.2:   bridge window [mem 0xd9800000-0xdb8fffff 64bit pref]
> pci 0000:03:00.0: [1a03:1150] type 01 class 0x060400
> pci 0000:03:00.0: supports D1 D2
> pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:03:00.0: System wakeup disabled by ACPI
> pci 0000:00:1c.0: PCI bridge to [bus 03-04]
> pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
> pci 0000:00:1c.0:   bridge window [mem 0xdc000000-0xde0fffff]
> pci 0000:04:00.0: [1a03:2000] type 00 class 0x030000
> pci 0000:04:00.0: reg 0x10: [mem 0xdc000000-0xddffffff]
> pci 0000:04:00.0: reg 0x14: [mem 0xde000000-0xde01ffff]
> pci 0000:04:00.0: reg 0x18: [io  0xd000-0xd07f]
> pci 0000:04:00.0: supports D1 D2
> pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:03:00.0: PCI bridge to [bus 04]
> pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
> pci 0000:03:00.0:   bridge window [mem 0xdc000000-0xde0fffff]
> pci 0000:05:00.0: [8086:1533] type 00 class 0x020000
> pci 0000:05:00.0: reg 0x10: [mem 0xde400000-0xde47ffff]
> pci 0000:05:00.0: reg 0x18: [io  0xc000-0xc01f]
> pci 0000:05:00.0: reg 0x1c: [mem 0xde480000-0xde483fff]
> pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:05:00.0: System wakeup disabled by ACPI
> pci 0000:00:1c.1: PCI bridge to [bus 05]
> pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
> pci 0000:00:1c.1:   bridge window [mem 0xde400000-0xde4fffff]
> pci 0000:06:00.0: [8086:1533] type 00 class 0x020000
> pci 0000:06:00.0: reg 0x10: [mem 0xde300000-0xde37ffff]
> pci 0000:06:00.0: reg 0x18: [io  0xb000-0xb01f]
> pci 0000:06:00.0: reg 0x1c: [mem 0xde380000-0xde383fff]
> pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:06:00.0: System wakeup disabled by ACPI
> pci 0000:00:1c.2: PCI bridge to [bus 06]
> pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
> pci 0000:00:1c.2:   bridge window [mem 0xde300000-0xde3fffff]
> acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupported)
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 14 15)
> ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, 
> disabled.
> ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, 
> disabled.
> ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
> ACPI: Enabled 5 GPEs in block 00 to 3F
> vgaarb: setting as boot device: PCI:0000:04:00.0
> vgaarb: device added: 
> PCI:0000:04:00.0,decodes=io+mem,owns=io+mem,locks=none
> vgaarb: loaded
> vgaarb: bridge control possible 0000:04:00.0
> SCSI subsystem initialized
> libata version 3.00 loaded.
> ACPI: bus type USB registered
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> PCI: Using ACPI for IRQ routing
> PCI: pci_cache_line_size set to 64 bytes
> pci 0000:00:1f.3: can't claim BAR 0 [mem 0x7ffff01000-0x7ffff010ff 
> 64bit]: no compatible bridge window
> e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
> e820: reserve RAM buffer [mem 0x6e1d1000-0x6fffffff]
> e820: reserve RAM buffer [mem 0x7d7f0000-0x7fffffff]
> e820: reserve RAM buffer [mem 0x7f000000-0x7fffffff]
> NetLabel: Initializing
> NetLabel:  domain hash size = 128
> NetLabel:  protocols = UNLABELED CIPSOv4
> NetLabel:  unlabeled traffic allowed by default
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> Switched to clocksource hpet
> pnp: PnP ACPI init
> system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
> system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
> system 00:01: [io  0x0680-0x069f] has been reserved
> system 00:01: [io  0xffff] has been reserved
> system 00:01: [io  0xffff] has been reserved
> system 00:01: [io  0xffff] has been reserved
> system 00:01: [io  0x1c00-0x1cfe] has been reserved
> system 00:01: [io  0x1d00-0x1dfe] has been reserved
> system 00:01: [io  0x1e00-0x1efe] has been reserved
> system 00:01: [io  0x1f00-0x1ffe] has been reserved
> system 00:01: [io  0x1800-0x18fe] could not be reserved
> system 00:01: [io  0x164e-0x164f] has been reserved
> system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
> system 00:03: [io  0x1854-0x1857] has been reserved
> system 00:03: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> system 00:04: [io  0x0290-0x029f] has been reserved
> system 00:04: [io  0x02a0-0x02af] has been reserved
> system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp 00:05: [dma 0 disabled]
> pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
> pnp 00:06: [dma 0 disabled]
> pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
> system 00:07: [io  0x04d0-0x04d1] has been reserved
> system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp 00:08: Plug and Play ACPI device, IDs IPI0001 (active)
> system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
> system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
> system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
> system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
> system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
> system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
> system 00:09: [mem 0xfed90000-0xfed93fff] could not be reserved
> system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
> system 00:09: [mem 0xff000000-0xffffffff] has been reserved
> system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
> system 00:09: [mem 0xdffdf000-0xdffdffff] has been reserved
> system 00:09: [mem 0xdffe0000-0xdffeffff] has been reserved
> system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
> pnp: PnP ACPI: found 10 devices
> pci 0000:00:1f.3: BAR 0: assigned [mem 0x80000000-0x800000ff 64bit]
> pci 0000:00:01.0: PCI bridge to [bus 01]
> pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
> pci 0000:00:01.0:   bridge window [mem 0xde100000-0xde2fffff]
> pci 0000:00:01.2: PCI bridge to [bus 02]
> pci 0000:00:01.2:   bridge window [mem 0xde500000-0xde5fffff]
> pci 0000:00:01.2:   bridge window [mem 0xd9800000-0xdb8fffff 64bit pref]
> pci 0000:03:00.0: PCI bridge to [bus 04]
> pci 0000:03:00.0:   bridge window [io  0xd000-0xdfff]
> pci 0000:03:00.0:   bridge window [mem 0xdc000000-0xde0fffff]
> pci 0000:00:1c.0: PCI bridge to [bus 03-04]
> pci 0000:00:1c.0:   bridge window [io  0xd000-0xdfff]
> pci 0000:00:1c.0:   bridge window [mem 0xdc000000-0xde0fffff]
> pci 0000:00:1c.1: PCI bridge to [bus 05]
> pci 0000:00:1c.1:   bridge window [io  0xc000-0xcfff]
> pci 0000:00:1c.1:   bridge window [mem 0xde400000-0xde4fffff]
> pci 0000:00:1c.2: PCI bridge to [bus 06]
> pci 0000:00:1c.2:   bridge window [io  0xb000-0xbfff]
> pci 0000:00:1c.2:   bridge window [mem 0xde300000-0xde3fffff]
> pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> pci_bus 0000:00: resource 7 [mem 0x000cc000-0x000cffff]
> pci_bus 0000:00: resource 8 [mem 0x000d0000-0x000d3fff]
> pci_bus 0000:00: resource 9 [mem 0x000d4000-0x000d7fff]
> pci_bus 0000:00: resource 10 [mem 0x000d8000-0x000dbfff]
> pci_bus 0000:00: resource 11 [mem 0x000dc000-0x000dffff]
> pci_bus 0000:00: resource 12 [mem 0x000e0000-0x000e3fff]
> pci_bus 0000:00: resource 13 [mem 0x000e4000-0x000e7fff]
> pci_bus 0000:00: resource 14 [mem 0x80000000-0xfeafffff]
> pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
> pci_bus 0000:01: resource 1 [mem 0xde100000-0xde2fffff]
> pci_bus 0000:02: resource 1 [mem 0xde500000-0xde5fffff]
> pci_bus 0000:02: resource 2 [mem 0xd9800000-0xdb8fffff 64bit pref]
> pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
> pci_bus 0000:03: resource 1 [mem 0xdc000000-0xde0fffff]
> pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
> pci_bus 0000:04: resource 1 [mem 0xdc000000-0xde0fffff]
> pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
> pci_bus 0000:05: resource 1 [mem 0xde400000-0xde4fffff]
> pci_bus 0000:06: resource 0 [io  0xb000-0xbfff]
> pci_bus 0000:06: resource 1 [mem 0xde300000-0xde3fffff]
> NET: Registered protocol family 2
> TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
> TCP: Hash tables configured (established 262144 bind 65536)
> TCP: reno registered
> UDP hash table entries: 16384 (order: 7, 524288 bytes)
> UDP-Lite hash table entries: 16384 (order: 7, 524288 bytes)
> NET: Registered protocol family 1
> pci 0000:04:00.0: Video device with shadowed ROM
> PCI: CLS 64 bytes, default 64
> Trying to unpack rootfs image as initramfs...
> Freeing initrd memory: 21856K (ffff880036a98000 - ffff880037ff0000)
> DMAR: No ATSR found
> IOMMU: dmar0 using Queued invalidation
> IOMMU: Setting RMRR:
> IOMMU: Setting identity map for device 0000:00:14.0 [0x7d98a000 - 
> 0x7d996fff]
> IOMMU: Setting identity map for device 0000:00:1a.0 [0x7d98a000 - 
> 0x7d996fff]
> IOMMU: Setting identity map for device 0000:00:1d.0 [0x7d98a000 - 
> 0x7d996fff]
> IOMMU: Prepare 0-16MiB unity mapping for LPC
> IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
> PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
> RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 
> fixed counters 655360 ms ovfl timer
> futex hash table entries: 2048 (order: 5, 131072 bytes)
> audit: initializing netlink subsys (disabled)
> audit: type=2000 audit(1423615719.608:1): initialized
> HugeTLB registered 2 MB page size, pre-allocated 0 pages
> zpool: loaded
> zbud: loaded
> VFS: Disk quotas dquot_6.5.2
> VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> SELinux:  Registering netfilter hooks
> alg: No test for stdrng (krng)
> Key type asymmetric registered
> Asymmetric key parser 'x509' registered
> bounce: pool size: 64 pages
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
> pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
> pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
> pcieport 0000:00:01.2: Signaling PME through PCIe PME interrupt
> pci 0000:02:00.0: Signaling PME through PCIe PME interrupt
> pci 0000:02:00.1: Signaling PME through PCIe PME interrupt
> pcie_pme 0000:00:01.2:pcie01: service driver pcie_pme loaded
> pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
> pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
> pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
> pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
> pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
> pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
> pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
> pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
> pci 0000:06:00.0: Signaling PME through PCIe PME interrupt
> pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
> pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> intel_idle: MWAIT substates: 0x42120
> intel_idle: v0.4 model 0x3C
> intel_idle: lapic_timer_reliable_states 0xffffffff
> input: Power Button as 
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> ACPI: Power Button [PWRB]
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> ACPI: Power Button [PWRF]
> thermal LNXTHERM:00: registered as thermal_zone0
> ACPI: Thermal Zone [TZ00] (28 C)
> thermal LNXTHERM:01: registered as thermal_zone1
> ACPI: Thermal Zone [TZ01] (30 C)
> ERST: Error Record Serialization Table (ERST) support is initialized.
> pstore: Registered erst as persistent store backend
> GHES: APEI firmware first mode is enabled by APEI bit and WHEA _OSC.
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> 00:06: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> [drm] Initialized drm 1.1.0 20060810
> brd: module loaded
> loop: module loaded
> libphy: Fixed MDIO Bus: probed
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> ehci-pci: EHCI PCI platform driver
> ehci-pci 0000:00:1a.0: EHCI Host Controller
> ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
> ehci-pci 0000:00:1a.0: debug port 2
> ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> ehci-pci 0000:00:1a.0: irq 20, io mem 0xde612000
> ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: EHCI Host Controller
> usb usb1: Manufacturer: Linux 3.19.0-1.el6.elrepo.x86_64 ehci_hcd
> usb usb1: SerialNumber: 0000:00:1a.0
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 2 ports detected
> ehci-pci 0000:00:1d.0: EHCI Host Controller
> ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
> ehci-pci 0000:00:1d.0: debug port 2
> ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> ehci-pci 0000:00:1d.0: irq 23, io mem 0xde611000
> ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb2: Product: EHCI Host Controller
> usb usb2: Manufacturer: Linux 3.19.0-1.el6.elrepo.x86_64 ehci_hcd
> usb usb2: SerialNumber: 0000:00:1d.0
> hub 2-0:1.0: USB hub found
> hub 2-0:1.0: 2 ports detected
> ehci-platform: EHCI generic platform driver
> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> ohci-pci: OHCI PCI platform driver
> ohci-platform: OHCI generic platform driver
> uhci_hcd: USB Universal Host Controller Interface driver
> i8042: PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mousedev: PS/2 mouse device common for all mice
> rtc_cmos 00:02: RTC can wake from S4
> rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
> rtc_cmos 00:02: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> Intel P-state driver initializing.
> ledtrig-cpu: registered to indicate activity on CPUs
> hidraw: raw HID events driver (C) Jiri Kosina
> usbcore: registered new interface driver usbhid
> usbhid: USB HID core driver
> TCP: cubic registered
> Initializing XFRM netlink socket
> NET: Registered protocol family 17
> registered taskstats version 1
> ima: No TPM chip found, activating TPM-bypass!
> rtc_cmos 00:02: setting system clock to 2015-02-11 00:48:40 UTC 
> (1423615720)
> Freeing unused kernel memory: 1960K (ffffffff81d62000 - ffffffff81f4c000)
> Write protecting the kernel read-only data: 12288k
> Freeing unused kernel memory: 1528K (ffff880001682000 - ffff880001800000)
> Freeing unused kernel memory: 780K (ffff880001b3d000 - ffff880001c00000)
> dracut: dracut-004-356.el6
> device-mapper: uevent: version 1.0.3
> device-mapper: ioctl: 4.29.0-ioctl (2014-10-28) initialised: 
> dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> udev: starting version 147
> udevd (135): /proc/135/oom_adj is deprecated, please use 
> /proc/135/oom_score_adj instead.
> [drm] AST 2300 detected
> [drm] Analog VGA only
> [drm] dram 1632000000 6 32 02000000
> [TTM] Zone  kernel: Available graphics memory: 16486916 kiB
> [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
> [TTM] Initializing pool allocator
> [TTM] Initializing DMA pool allocator
> fbcon: astdrmfb (fb0) is primary device
> Console: switching to colour frame buffer device 128x48
> ast 0000:04:00.0: fb0: astdrmfb frame buffer device
> ast 0000:04:00.0: registered panic notifier
> [drm] Initialized ast 0.1.0 20120228 for 0000:04:00.0 on minor 0
> dracut: Starting plymouth daemon
> usb 1-1: new high-speed USB device number 2 using ehci-pci
> usb 2-1: new high-speed USB device number 2 using ehci-pci
> mpt2sas version 18.100.00.00 loaded
> mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (32973832 kB)
> mpt2sas0: MSI-X vectors supported: 8, no of cores: 8, max_msix_vectors: 8
> mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 30
> mpt2sas0-msix1: PCI-MSI-X enabled: IRQ 31
> mpt2sas0-msix2: PCI-MSI-X enabled: IRQ 32
> mpt2sas0-msix3: PCI-MSI-X enabled: IRQ 33
> mpt2sas0-msix4: PCI-MSI-X enabled: IRQ 34
> mpt2sas0-msix5: PCI-MSI-X enabled: IRQ 35
> mpt2sas0-msix6: PCI-MSI-X enabled: IRQ 36
> mpt2sas0-msix7: PCI-MSI-X enabled: IRQ 37
> mpt2sas0: iomem(0x00000000de240000), mapped(0xffffc90013980000), 
> size(65536)
> mpt2sas0: ioport(0x000000000000e000), size(256)
> usb 1-1: New USB device found, idVendor=8087, idProduct=8008
> usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> hub 1-1:1.0: USB hub found
> hub 1-1:1.0: 6 ports detected
> usb 2-1: New USB device found, idVendor=8087, idProduct=8000
> usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> hub 2-1:1.0: USB hub found
> hub 2-1:1.0: 6 ports detected
> mpt2sas0: sending diag reset !!
> tsc: Refined TSC clocksource calibration: 3292.393 MHz
> mpt2sas0: diag reset: SUCCESS
> mpt2sas0: Allocated physical memory: size(16361 kB)
> mpt2sas0: Current Controller Queue Depth(7931), Max Controller Queue 
> Depth(8192)
> mpt2sas0: Scatter Gather Elements per IO(128)
> mpt2sas0: LSISAS2308: FWVersion(15.00.00.00), ChipRevision(0x05), 
> BiosVersion(07.29.00.00)
> mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot 
> Buffer,Diag Trace Buffer,Task Set Full,NCQ)
> scsi host0: Fusion MPT SAS Host
> mpt2sas0: sending port enable !!
> Switched to clocksource tsc
> mpt2sas0: host_add: handle(0x0001), sas_addr(0x5e8611f000009558), phys(8)
> mpt2sas0: port enable: SUCCESS
> scsi 0:0:0:0: Direct-Access     ATA      WDC WD40EFRX-68W 0A82 PQ: 0 
> ANSI: 6
> scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221100000000), 
> phy(0), device_name(0x50014ee2b56c689d)
> scsi 0:0:0:0: SATA: enclosure_logical_id(0x5e8611f000009558), slot(0)
> scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), 
> sw_preserve(y)
> scsi 0:0:1:0: Direct-Access     ATA      WDC WD40EFRX-68W 0A80 PQ: 0 
> ANSI: 6
> scsi 0:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221107000000), 
> phy(7), device_name(0x50014ee25fe9eb7c)
> scsi 0:0:1:0: SATA: enclosure_logical_id(0x5e8611f000009558), slot(7)
> scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), 
> sw_preserve(y)
> scsi 0:0:2:0: Direct-Access     ATA      WDC WD40EFRX-68W 0A80 PQ: 0 
> ANSI: 6
> scsi 0:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221106000000), 
> phy(6), device_name(0x50014ee25feacd73)
> scsi 0:0:2:0: SATA: enclosure_logical_id(0x5e8611f000009558), slot(6)
> scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), 
> sw_preserve(y)
> scsi 0:0:3:0: Direct-Access     ATA      WDC WD40EFRX-68W 0A80 PQ: 0 
> ANSI: 6
> scsi 0:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221103000000), 
> phy(3), device_name(0x50014ee25feaa1a3)
> scsi 0:0:3:0: SATA: enclosure_logical_id(0x5e8611f000009558), slot(3)
> scsi 0:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), 
> sw_preserve(y)
> scsi 0:0:4:0: Direct-Access     ATA      ST4000VN000-1H41 SC44 PQ: 0 
> ANSI: 6
> scsi 0:0:4:0: SATA: handle(0x000d), sas_addr(0x4433221102000000), 
> phy(2), device_name(0x5000c5007918aac1)
> scsi 0:0:4:0: SATA: enclosure_logical_id(0x5e8611f000009558), slot(2)
> scsi 0:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), 
> sw_preserve(y)
> scsi 0:0:5:0: Direct-Access     ATA      ST4000VN000-1H41 SC44 PQ: 0 
> ANSI: 6
> scsi 0:0:5:0: SATA: handle(0x000e), sas_addr(0x4433221104000000), 
> phy(4), device_name(0x5000c50079182a14)
> scsi 0:0:5:0: SATA: enclosure_logical_id(0x5e8611f000009558), slot(4)
> scsi 0:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), 
> sw_preserve(y)
> scsi 0:0:6:0: Direct-Access     ATA      ST4000VN000-1H41 SC44 PQ: 0 
> ANSI: 6
> scsi 0:0:6:0: SATA: handle(0x000f), sas_addr(0x4433221105000000), 
> phy(5), device_name(0x5000c5007919413d)
> scsi 0:0:6:0: SATA: enclosure_logical_id(0x5e8611f000009558), slot(5)
> scsi 0:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), 
> sw_preserve(y)
> scsi 0:0:7:0: Direct-Access     ATA      HGST HDN724040AL A5E0 PQ: 0 
> ANSI: 6
> scsi 0:0:7:0: SATA: handle(0x0010), sas_addr(0x4433221101000000), 
> phy(1), device_name(0x5000cca24cd8834e)
> scsi 0:0:7:0: SATA: enclosure_logical_id(0x5e8611f000009558), slot(1)
> scsi 0:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), 
> sw_preserve(y)
> ahci 0000:00:1f.2: version 3.0
> ahci 0000:00:1f.2: SSS flag set, parallel bus scan disabled
> ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl 
> SATA mode
> ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems 
> apst
> scsi host1: ahci
> scsi host2: ahci
> scsi host3: ahci
> scsi host4: ahci
> scsi host5: ahci
> scsi host6: ahci
> ata1: SATA max UDMA/133 abar m2048@0xde610000 port 0xde610100 irq 38
> ata2: SATA max UDMA/133 abar m2048@0xde610000 port 0xde610180 irq 38
> ata3: SATA max UDMA/133 abar m2048@0xde610000 port 0xde610200 irq 38
> ata4: SATA max UDMA/133 abar m2048@0xde610000 port 0xde610280 irq 38
> ata5: SATA max UDMA/133 abar m2048@0xde610000 port 0xde610300 irq 38
> ata6: SATA max UDMA/133 abar m2048@0xde610000 port 0xde610380 irq 38
> ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata1.00: ATA-9: ST4000VN000-1H4168, SC44, max UDMA/133
> ata1.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> ata1.00: configured for UDMA/133
> scsi 1:0:0:0: Direct-Access     ATA      ST4000VN000-1H41 SC44 PQ: 0 
> ANSI: 5
> ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> ata2.00: ATA-9: WDC WD40EFRX-68WT0N0, 80.00A80, max UDMA/133
> ata2.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> ata2.00: configured for UDMA/133
> scsi 2:0:0:0: Direct-Access     ATA      WDC WD40EFRX-68W 0A80 PQ: 0 
> ANSI: 5
> ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> ata3.00: ATA-8: HGST HDN724040ALE640, MJAOA5E0, max UDMA/133
> ata3.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> ata3.00: configured for UDMA/133
> scsi 3:0:0:0: Direct-Access     ATA      HGST HDN724040AL A5E0 PQ: 0 
> ANSI: 5
> ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata4.00: ATA-9: ST4000VN000-1H4168, SC44, max UDMA/133
> ata4.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> ata4.00: configured for UDMA/133
> scsi 4:0:0:0: Direct-Access     ATA      ST4000VN000-1H41 SC44 PQ: 0 
> ANSI: 5
> ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
> ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) 
> filtered out
> ata5.00: ATA-8: KINGSTON SHFS37A120G, 560ABBF0, max UDMA/133
> ata5.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
> ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
> ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) 
> filtered out
> ata5.00: configured for UDMA/133
> scsi 5:0:0:0: Direct-Access     ATA      KINGSTON SHFS37A BBF0 PQ: 0 
> ANSI: 5
> ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
> ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) 
> filtered out
> ata6.00: ATA-8: KINGSTON SV300S37A120G, 580ABBF0, max UDMA/133
> ata6.00: 234441648 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
> ata6.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
> ata6.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
> ata6.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) 
> filtered out
> ata6.00: configured for UDMA/133
> scsi 6:0:0:0: Direct-Access     ATA      KINGSTON SV300S3 BBF0 PQ: 0 
> ANSI: 5
> sd 1:0:0:0: [sdi] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 2:0:0:0: [sdj] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 2:0:0:0: [sdj] 4096-byte physical blocks
> sd 2:0:0:0: [sdj] Write Protect is off
> sd 2:0:0:0: [sdj] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdk] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 3:0:0:0: [sdk] 4096-byte physical blocks
> sd 2:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 4:0:0:0: [sdl] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 4:0:0:0: [sdl] 4096-byte physical blocks
> sd 3:0:0:0: [sdk] Write Protect is off
> sd 3:0:0:0: [sdk] Mode Sense: 00 3a 00 00
> sd 4:0:0:0: [sdl] Write Protect is off
> sd 4:0:0:0: [sdl] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 4:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 5:0:0:0: [sdm] 234441648 512-byte logical blocks: (120 GB/111 GiB)
> sd 5:0:0:0: [sdm] Write Protect is off
> sd 5:0:0:0: [sdm] Mode Sense: 00 3a 00 00
> sd 6:0:0:0: [sdn] 234441648 512-byte logical blocks: (120 GB/111 GiB)
> sd 5:0:0:0: [sdm] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 6:0:0:0: [sdn] Write Protect is off
> sd 6:0:0:0: [sdn] Mode Sense: 00 3a 00 00
> sd 6:0:0:0: [sdn] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 0:0:0:0: [sda] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 0:0:0:0: [sda] 4096-byte physical blocks
> sd 0:0:1:0: [sdb] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 0:0:1:0: [sdb] 4096-byte physical blocks
> sd 0:0:2:0: [sdc] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 0:0:2:0: [sdc] 4096-byte physical blocks
> sd 0:0:5:0: [sdf] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 0:0:5:0: [sdf] 4096-byte physical blocks
> sd 0:0:3:0: [sdd] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 0:0:3:0: [sdd] 4096-byte physical blocks
> sd 0:0:6:0: [sdg] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 0:0:6:0: [sdg] 4096-byte physical blocks
> sd 0:0:4:0: [sde] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 0:0:4:0: [sde] 4096-byte physical blocks
>  sdn: sdn1 sdn2
> sd 6:0:0:0: [sdn] Attached SCSI disk
> sd 0:0:7:0: [sdh] 7814037168 512-byte logical blocks: (4.00 TB/3.63 TiB)
> sd 0:0:7:0: [sdh] 4096-byte physical blocks
>  sdk: unknown partition table
> sd 3:0:0:0: [sdk] Attached SCSI disk
>  sdm: sdm1 sdm2
> sd 5:0:0:0: [sdm] Attached SCSI disk
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 7f 00 10 08
> sd 0:0:1:0: [sdb] Write Protect is off
> sd 0:0:1:0: [sdb] Mode Sense: 7f 00 10 08
> sd 0:0:2:0: [sdc] Write Protect is off
> sd 0:0:2:0: [sdc] Mode Sense: 7f 00 10 08
> sd 0:0:3:0: [sdd] Write Protect is off
> sd 0:0:3:0: [sdd] Mode Sense: 7f 00 10 08
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
> sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
> sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
> sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
>  sdl: unknown partition table
> sd 4:0:0:0: [sdl] Attached SCSI disk
>  sdj: unknown partition table
> sd 2:0:0:0: [sdj] Attached SCSI disk
> sd 1:0:0:0: [sdi] 4096-byte physical blocks
> sd 1:0:0:0: [sdi] Write Protect is off
> sd 1:0:0:0: [sdi] Mode Sense: 00 3a 00 00
> sd 1:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
>  sdc: unknown partition table
>  sdb: unknown partition table
>  sdd: unknown partition table
>  sda: unknown partition table
> sd 0:0:2:0: [sdc] Attached SCSI disk
>  sdi: unknown partition table
> sd 0:0:1:0: [sdb] Attached SCSI disk
> sd 1:0:0:0: [sdi] Attached SCSI disk
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 0:0:3:0: [sdd] Attached SCSI disk
> sd 0:0:4:0: [sde] Write Protect is off
> sd 0:0:4:0: [sde] Mode Sense: 7f 00 10 08
> sd 0:0:6:0: [sdg] Write Protect is off
> sd 0:0:6:0: [sdg] Mode Sense: 7f 00 10 08
> sd 0:0:4:0: [sde] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
> sd 0:0:6:0: [sdg] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
> sd 0:0:5:0: [sdf] Write Protect is off
> sd 0:0:5:0: [sdf] Mode Sense: 7f 00 10 08
> sd 0:0:5:0: [sdf] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
>  sde: unknown partition table
> random: nonblocking pool is initialized
>  sdg: unknown partition table
>  sdf: unknown partition table
> sd 0:0:7:0: [sdh] Write Protect is off
> sd 0:0:7:0: [sdh] Mode Sense: 7f 00 10 08
> sd 0:0:7:0: [sdh] Write cache: enabled, read cache: enabled, supports 
> DPO and FUA
> sd 0:0:4:0: [sde] Attached SCSI disk
> sd 0:0:6:0: [sdg] Attached SCSI disk
> sd 0:0:5:0: [sdf] Attached SCSI disk
>  sdh: unknown partition table
> sd 0:0:7:0: [sdh] Attached SCSI disk
> md: bind<sde>
> md: bind<sdf>
> md: bind<sdg>
> md: bind<sdn1>
> md: bind<sdm1>
> md: raid1 personality registered for level 1
> md/raid1:md0: active with 2 out of 2 mirrors
> created bitmap (1 pages) for device md0
> md0: bitmap initialized from disk: read 1 pages, set 0 of 16 bits
> md0: detected capacity change from 0 to 1073676288
>  md0: unknown partition table
> md: bind<sdl>
> md: bind<sda>
> md: bind<sdh>
> md: bind<sdc>
> md: bind<sdb>
> md: bind<sdi>
> md: bind<sdj>
> md: bind<sdk>
> md: bind<sdd>
> dracut: Scanning devices sdm2 sdn2  for LVM logical volumes vg00/swap 
> vg00/root
> dracut: Couldn't find device with uuid 
> Cnh3S6-xbqX-v0o7-G9B1-0jQ7-YLFo-edps3D.
> dracut: inactive '/dev/vg00/root' [64.00 GiB] inherit
> dracut: inactive '/dev/vg00/swap' [32.00 GiB] inherit
> dracut: inactive '/dev/vg00/ARRAY' [36.39 TiB] inherit
> dracut: inactive '/dev/vg00/cache' [30.71 GiB] inherit
> dracut: Couldn't find device with uuid 
> Cnh3S6-xbqX-v0o7-G9B1-0jQ7-YLFo-edps3D.
> async_tx: api initialized (async)
> xor: automatically using best checksumming function:
>    avx       : 33704.000 MB/sec
> raid6: sse2x1   11054 MB/s
> raid6: sse2x2   14019 MB/s
> raid6: sse2x4   16148 MB/s
> raid6: using algorithm sse2x4 (16148 MB/s)
> raid6: using ssse3x2 recovery algorithm
> md: raid6 personality registered for level 6
> md: raid5 personality registered for level 5
> md: raid4 personality registered for level 4
> md: raid10 personality registered for level 10
> device-mapper: raid: Loading target version 1.6.0
> md/raid1:mdX: active with 2 out of 2 mirrors
> created bitmap (64 pages) for device mdX
> mdX: bitmap initialized from disk: read 5 pages, set 31 of 131072 bits
> EXT4-fs (dm-4): mounted filesystem with ordered data mode. Opts: (null)
> dracut: Mounted root filesystem /dev/mapper/vg00-root
> SELinux:  Disabled at runtime.
> SELinux:  Unregistering netfilter hooks
> audit: type=1404 audit(1423615732.033:2): selinux=0 auid=4294967295 
> ses=4294967295
> dracut:
> dracut: Switching root
> readahead: starting
> udev: starting version 147
> WARNING! power/level is deprecated; use power/control instead
> EDAC MC: Ver: 3.0.0
> EDAC MC0: Giving out device to module ie31200_edac controller IE31200: 
> DEV 0000:00:00.0 (POLLED)
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> sd 0:0:1:0: Attached scsi generic sg1 type 0
> sd 0:0:2:0: Attached scsi generic sg2 type 0
> sd 0:0:3:0: Attached scsi generic sg3 type 0
> sd 0:0:4:0: Attached scsi generic sg4 type 0
> sd 0:0:5:0: Attached scsi generic sg5 type 0
> sd 0:0:6:0: Attached scsi generic sg6 type 0
> sd 0:0:7:0: Attached scsi generic sg7 type 0
> sd 1:0:0:0: Attached scsi generic sg8 type 0
> sd 2:0:0:0: Attached scsi generic sg9 type 0
> sd 3:0:0:0: Attached scsi generic sg10 type 0
> sd 4:0:0:0: Attached scsi generic sg11 type 0
> sd 5:0:0:0: Attached scsi generic sg12 type 0
> sd 6:0:0:0: Attached scsi generic sg13 type 0
> pps_core: LinuxPPS API ver. 1 registered
> pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti 
> <giometti-k2GhghHVRtY@public.gmane.org>
> PTP clock support registered
> bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ethernet Driver 
> bnx2x 1.710.51-0 (2014/02/10)
> bnx2x 0000:02:00.0: msix capability found
> bnx2x 0000:02:00.0: part number 394D4342-34383735-30345430-473030
> bnx2x 0000:02:00.1: msix capability found
> bnx2x 0000:02:00.1: part number 394D4342-34383735-30345430-473030
> xhci_hcd 0000:00:14.0: xHCI Host Controller
> xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
> xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
> usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb3: Product: xHCI Host Controller
> usb usb3: Manufacturer: Linux 3.19.0-1.el6.elrepo.x86_64 xhci-hcd
> usb usb3: SerialNumber: 0000:00:14.0
> hub 3-0:1.0: USB hub found
> hub 3-0:1.0: 12 ports detected
> xhci_hcd 0000:00:14.0: xHCI Host Controller
> xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
> usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb4: Product: xHCI Host Controller
> usb usb4: Manufacturer: Linux 3.19.0-1.el6.elrepo.x86_64 xhci-hcd
> usb usb4: SerialNumber: 0000:00:14.0
> hub 4-0:1.0: USB hub found
> hub 4-0:1.0: 6 ports detected
> mei_me 0000:00:16.0: Device doesn't have valid ME Interface
> shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
> dca service started, version 1.12.1
> igb: Intel(R) Gigabit Ethernet Network Driver - version 5.2.15-k
> igb: Copyright (c) 2007-2014 Intel Corporation.
> igb 0000:05:00.0: added PHC on eth2
> igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network Connection
> igb 0000:05:00.0: eth2: (PCIe:2.5Gb/s:Width x1) 40:16:7e:36:09:a6
> igb 0000:05:00.0: eth2: PBA No: 001300-000
> igb 0000:05:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
> igb 0000:06:00.0: added PHC on eth3
> igb 0000:06:00.0: Intel(R) Gigabit Ethernet Network Connection
> igb 0000:06:00.0: eth3: (PCIe:2.5Gb/s:Width x1) 40:16:7e:36:09:a7
> igb 0000:06:00.0: eth3: PBA No: 001300-000
> igb 0000:06:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
> ipmi message handler version 39.2
> IPMI System Interface driver.
> ipmi_si: probing via ACPI
> ipmi_si 00:08: [io  0x0ca2] regsize 1 spacing 1 irq 0
> ipmi_si: Adding ACPI-specified kcs state machine
> ipmi_si: probing via SMBIOS
> ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
> ipmi_si: Adding SMBIOS-specified kcs state machine duplicate interface
> ipmi_si: probing via SPMI
> ipmi_si: SPMI: io 0xca2 regsize 1 spacing 1 irq 0
> ipmi_si: Adding SPMI-specified kcs state machine duplicate interface
> ipmi_si: Trying ACPI-specified kcs state machine at i/o address 0xca2, 
> slave address 0x0, irq 0
> ipmi_si 00:08: Found new BMC (man_id: 0x001043, prod_id: 0x0d63, 
> dev_id: 0x20)
> ipmi_si 00:08: IPMI kcs interface initialized
> ipmi device interface
> ACPI Warning: SystemIO range 0x000000000000f000-0x000000000000f01f 
> conflicts with OpRegion 0x000000000000f000-0x000000000000f00f 
> (\_SB_.PCI0.SBUS.SMBI) (20141107/utaddress-258)
> ACPI: If an ACPI driver is available for this device, you should use 
> it instead of the native driver
> input: PC Speaker as /devices/platform/pcspkr/input/input5
> microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x17
> microcode: Microcode Update Driver: v2.00 
> <tigran-ppwZ4lME3+KI6QP4U9MhSdBc4/FLrbF6@public.gmane.org>, Peter Oruba
> iTCO_vendor_support: vendor-support=0
> iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
> iTCO_wdt: Found a Lynx Point TCO device (Version=2, TCOBASE=0x1860)
> iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
> microcode: CPU0 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU0 updated to revision 0x1a, date = 2014-05-23
> microcode: CPU1 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU1 updated to revision 0x1a, date = 2014-05-23
> microcode: CPU2 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU2 updated to revision 0x1a, date = 2014-05-23
> microcode: CPU3 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU3 updated to revision 0x1a, date = 2014-05-23
> microcode: CPU4 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU4 updated to revision 0x1a, date = 2014-05-23
> microcode: CPU5 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU5 updated to revision 0x1a, date = 2014-05-23
> microcode: CPU6 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU6 updated to revision 0x1a, date = 2014-05-23
> microcode: CPU7 sig=0x306c3, pf=0x2, revision=0x17
> microcode: CPU7 updated to revision 0x1a, date = 2014-05-23
> usb 3-3: new high-speed USB device number 2 using xhci_hcd
> usb 3-3: New USB device found, idVendor=046b, idProduct=ff01
> usb 3-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 3-3: Product: Virtual Hub
> usb 3-3: Manufacturer: American Megatrends Inc.
> usb 3-3: SerialNumber: serial
> hub 3-3:1.0: USB hub found
> hub 3-3:1.0: 5 ports detected
> usb 3-3.1: new low-speed USB device number 3 using xhci_hcd
> usb 3-3.1: New USB device found, idVendor=046b, idProduct=ff10
> usb 3-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> usb 3-3.1: Product: Virtual Keyboard and Mouse
> usb 3-3.1: Manufacturer: American Megatrends Inc.
> input: American Megatrends Inc. Virtual Keyboard and Mouse as 
> /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1:1.0/0003:046B:FF10.0001/input/input6
> hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1.10 Keyboard 
> [American Megatrends Inc. Virtual Keyboard and Mouse] on 
> usb-0000:00:14.0-3.1/input0
> input: American Megatrends Inc. Virtual Keyboard and Mouse as 
> /devices/pci0000:00/0000:00:14.0/usb3/3-3/3-3.1/3-3.1:1.1/0003:046B:FF10.0002/input/input7
> hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1.10 Mouse 
> [American Megatrends Inc. Virtual Keyboard and Mouse] on 
> usb-0000:00:14.0-3.1/input1
> usb 3-3.2: new high-speed USB device number 4 using xhci_hcd
> usb 3-3.2: New USB device found, idVendor=046b, idProduct=ff20
> usb 3-3.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 3-3.2: Product: Virtual Cdrom Device
> usb 3-3.2: Manufacturer: American Megatrends Inc.
> usb 3-3.2: SerialNumber: AAAABBBBCCCC1
> usb-storage 3-3.2:1.0: USB Mass Storage device detected
> scsi host7: usb-storage 3-3.2:1.0
> usbcore: registered new interface driver usb-storage
> usbcore: registered new interface driver uas
> usb 3-3.3: new high-speed USB device number 5 using xhci_hcd
> usb 3-3.3: New USB device found, idVendor=046b, idProduct=ff40
> usb 3-3.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 3-3.3: Product: Virtual Floppy Device
> usb 3-3.3: Manufacturer: American Megatrends Inc.
> usb 3-3.3: SerialNumber: AAAABBBBCCCC2
> usb-storage 3-3.3:1.0: USB Mass Storage device detected
> usb-storage 3-3.3:1.0: Quirks match for vid 046b pid ff40: 200
> scsi host8: usb-storage 3-3.3:1.0
> usb 3-3.4: new high-speed USB device number 6 using xhci_hcd
> md: kicking non-fresh sdd from array!
> md: unbind<sdd>
> md: export_rdev(sdd)
> md: kicking non-fresh sdb from array!
> md: unbind<sdb>
> md: export_rdev(sdb)
> md: kicking non-fresh sdc from array!
> md: unbind<sdc>
> md: export_rdev(sdc)
> md: kicking non-fresh sdh from array!
> md: unbind<sdh>
> md: export_rdev(sdh)
> md: kicking non-fresh sda from array!
> md: unbind<sda>
> md: export_rdev(sda)
> md: kicking non-fresh sdg from array!
> md: unbind<sdg>
> md: export_rdev(sdg)
> md: kicking non-fresh sdf from array!
> md: unbind<sdf>
> md: export_rdev(sdf)
> md: kicking non-fresh sde from array!
> md: unbind<sde>
> md: export_rdev(sde)
> md/raid:md127: not clean -- starting background reconstruction
> md/raid:md127: device sdk operational as raid disk 10
> md/raid:md127: device sdj operational as raid disk 9
> md/raid:md127: device sdi operational as raid disk 8
> md/raid:md127: device sdl operational as raid disk 0
> md/raid:md127: allocated 0kB
> md/raid:md127: not enough operational devices (8/12 failed)
> RAID conf printout:
>  --- level:6 rd:12 wd:4
>  disk 0, o:1, dev:sdl
>  disk 8, o:1, dev:sdi
>  disk 9, o:1, dev:sdj
>  disk 10, o:1, dev:sdk
> md/raid:md127: failed to run raid set.
> md: pers->run() failed ...
> usb 3-3.4: New USB device found, idVendor=046b, idProduct=ff31
> usb 3-3.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> usb 3-3.4: Product: Virtual HardDisk Device
> usb 3-3.4: Manufacturer: American Megatrends Inc.
> usb 3-3.4: SerialNumber: AAAABBBBCCCC3
> usb-storage 3-3.4:1.0: USB Mass Storage device detected
> scsi host9: usb-storage 3-3.4:1.0
> EXT4-fs (dm-4): re-mounted. Opts: (null)
> SGI XFS with ACLs, security attributes, no debug enabled
> Adding 33554428k swap on /dev/mapper/vg00-swap.  Priority:-1 extents:1 
> across:33554428k SSFS
> NET: Registered protocol family 10
> scsi 7:0:0:0: CD-ROM            AMI      Virtual CDROM0   1.00 PQ: 0 
> ANSI: 0 CCS
> scsi 7:0:0:0: Attached scsi generic sg14 type 5
> sr 7:0:0:0: [sr0] scsi-1 drive
> cdrom: Uniform CD-ROM driver Revision: 3.20
> sr 7:0:0:0: Attached scsi CD-ROM sr0
> scsi 8:0:0:0: Direct-Access     AMI      Virtual Floppy0  1.00 PQ: 0 
> ANSI: 0 CCS
> sd 8:0:0:0: Attached scsi generic sg15 type 0
> sd 8:0:0:0: [sdo] Attached SCSI removable disk
> IPv6: ADDRCONF(NETDEV_UP): eth2: link is not ready
> scsi 9:0:0:0: Direct-Access     AMI      Virtual HDISK0   1.00 PQ: 0 
> ANSI: 0 CCS
> sd 9:0:0:0: Attached scsi generic sg16 type 0
> sd 9:0:0:0: [sdp] Attached SCSI removable disk
> IPMI Watchdog: Unable to register misc device
> IPMI Watchdog: set timeout error: -22
> IPMI Watchdog: driver initialized
> Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
> IPMI poweroff: Power cycle is enabled.
> IPMI poweroff: ATCA Detect mfg 0x1043 prod 0xD63
> IPMI poweroff: Found a chassis style poweroff function
> 8021q: 802.1Q VLAN Support v1.8
> 8021q: adding VLAN 0 to HW filter on device eth2
> igb 0000:05:00.0 eth2: igb: eth2 NIC Link is Up 1000 Mbps Full Duplex, 
> Flow Control: RX/TX
> IPv6: ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
> Process accounting resumed
> RPC: Registered named UNIX socket transport module.
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> Installing knfsd (copyright (C) 1996 okir-pn4DOG8n3UYbFoVRYvo4fw@public.gmane.org).
> svc: failed to register nfsdv2 RPC service (errno 111).
> svc: failed to register nfsaclv2 RPC service (errno 111).
> svc: failed to register nfsdv2 RPC service (errno 97).
> svc: failed to register nfsaclv2 RPC service (errno 97).
> md: md127 stopped.
> md: unbind<sdk>
> md: export_rdev(sdk)
> md: unbind<sdj>
> md: export_rdev(sdj)
> md: unbind<sdi>
> md: export_rdev(sdi)
> md: unbind<sdl>
> md: export_rdev(sdl)
> md: md127 stopped.
> md: bind<sdc>
> md: bind<sdb>
> md: bind<sdd>
> md: bind<sdh>
> md: bind<sde>
> md: bind<sdf>
> md: bind<sdg>
> md: bind<sdi>
> md: bind<sdj>
> md: bind<sdk>
> md: bind<sda>
> md: bind<sdl>
> md: md127 stopped.
> md: unbind<sdl>
> md: export_rdev(sdl)
> md: unbind<sda>
> md: export_rdev(sda)
> md: unbind<sdk>
> md: export_rdev(sdk)
> md: unbind<sdj>
> md: export_rdev(sdj)
> md: unbind<sdi>
> md: export_rdev(sdi)
> md: unbind<sdg>
> md: export_rdev(sdg)
> md: unbind<sdf>
> md: export_rdev(sdf)
> md: unbind<sde>
> md: export_rdev(sde)
> md: unbind<sdh>
> md: export_rdev(sdh)
> md: unbind<sdd>
> md: export_rdev(sdd)
> md: unbind<sdb>
> md: export_rdev(sdb)
> md: unbind<sdc>
> md: export_rdev(sdc)
> md: md127 stopped.
> md: bind<sdc>
> md: bind<sdb>
> md: bind<sdd>
> md: bind<sdh>
> md: bind<sde>
> md: bind<sdf>
> md: bind<sdg>
> md: bind<sdi>
> md: bind<sdj>
> md: bind<sdk>
> md: bind<sda>
> md: bind<sdl>
> md: md127 stopped.
> md: unbind<sdl>
> md: export_rdev(sdl)
> md: unbind<sda>
> md: export_rdev(sda)
> md: unbind<sdk>
> md: export_rdev(sdk)
> md: unbind<sdj>
> md: export_rdev(sdj)
> md: unbind<sdi>
> md: export_rdev(sdi)
> md: unbind<sdg>
> md: export_rdev(sdg)
> md: unbind<sdf>
> md: export_rdev(sdf)
> md: unbind<sde>
> md: export_rdev(sde)
> md: unbind<sdh>
> md: export_rdev(sdh)
> md: unbind<sdd>
> md: export_rdev(sdd)
> md: unbind<sdb>
> md: export_rdev(sdb)
> md: unbind<sdc>
> md: export_rdev(sdc)



-- 
-Adam Thompson
  athompso-gKoiEJA+T1nk1uMJSBkQmQ@public.gmane.org
  +1 (204) 291-7950 - cell
  +1 (204) 489-6515 - fax
