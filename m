From: chris <tknchris@gmail.com>
Subject: Re: Recovery/Access of imsm raid via mdadm?
Date: Sun, 13 Jan 2013 19:56:27 -0500
Message-ID: <CAKnNFz8dZVgS7M_rmQx0c_S+jo46EGs2GWAHc99ziaAR5OQp+w@mail.gmail.com>
References: <CAKnNFz_25zLMquBphPb8xx=rrG2BquXjLuc1-ke+1ztoVaUOgA@mail.gmail.com>
	<84A937D219C2B44EB8EA44831ACA1E4916D902C5@PRN-MBX02-3.TheFacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A937D219C2B44EB8EA44831ACA1E4916D902C5@PRN-MBX02-3.TheFacebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <djbw@fb.com>
Cc: Neil Brown <neilb@suse.de>, Dave Jiang <dave.jiang@intel.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Dan,

OK so the container comes up just fine now:

# mdadm --create --verbose /dev/md/imsm /dev/sdb /dev/sdc /dev/sdd
/dev/sde --raid-devices 4 --metadata=imsm
mdadm: /dev/sdb appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdb.
mdadm: /dev/sdc appears to be part of a raid array:
    level=raid0 devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdc.
mdadm: /dev/sdd appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdd.
mdadm: /dev/sde appears to be part of a raid array:
    level=raid0 devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sde.
mdadm: size set to 1953511431K
Continue creating array? y
mdadm: container /dev/md/imsm prepared.
root@Microknoppix:/mnt/external# cat /proc/mdstat
Personalities :
md126 : inactive sde[3](S) sdd[2](S) sdc[1](S) sdb[0](S)
      4420 blocks super external:imsm

Upon review it all looks good
# mdadm --detail /dev/md/imsm
/dev/md/imsm:
        Version : imsm
     Raid Level : container
  Total Devices : 4

Working Devices : 4

  Member Arrays :

    Number   Major   Minor   RaidDevice

       0       8       16        -        /dev/sdb
       1       8       32        -        /dev/sdc
       2       8       48        -        /dev/sdd
       3       8       64        -        /dev/sde


Now when I try all the permutations of disks, they all fail with
"mdadm: failed to activate array."

ATTEMPT #1
# export IMSM_NO_PLATFORM=1
# mdadm --create --verbose /dev/md/imsm /dev/sdb /dev/sdc /dev/sdd
/dev/sde --raid-devices 4 --metadata=imsm
mdadm: /dev/sdb appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdb.
mdadm: /dev/sdc appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdc.
mdadm: /dev/sdd appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdd.
mdadm: /dev/sde appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sde.
mdadm: size set to 1953511431K
Continue creating array? y
mdadm: container /dev/md/imsm prepared.
# mdadm --create --verbose /dev/md/Volume0 /dev/sde missing /dev/sdb
/dev/sdd --raid-devices 4 --level=5
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: super1.x cannot open /dev/sde: Device or resource busy
mdadm: chunk size defaults to 128K
mdadm: /dev/sde appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sde but will be lost or
       meaningless after creating array
mdadm: /dev/sdb appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sdb but will be lost or
       meaningless after creating array
mdadm: /dev/sdd appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sdd but will be lost or
       meaningless after creating array
mdadm: size set to 1953511424K
Continue creating array? y
mdadm: Creating array inside imsm container /dev/md/imsm
mdadm: failed to activate array.
# mdadm --stop /dev/md/imsm
mdadm: stopped /dev/md/imsm
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
unused devices: <none>

ATTEMPT #2
# export IMSM_NO_PLATFORM=1
# mdadm --create --verbose /dev/md/imsm /dev/sdb /dev/sdc /dev/sdd
/dev/sde --raid-devices 4 --metadata=imsm
mdadm: /dev/sdb appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdb.
mdadm: /dev/sdc appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdc.
mdadm: /dev/sdd appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdd.
mdadm: /dev/sde appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sde.
mdadm: size set to 1953511431K
Continue creating array? y
mdadm: container /dev/md/imsm prepared.
# mdadm --create --verbose /dev/md/Volume0 missing /dev/sdc /dev/sdb
/dev/sdd --raid-devices 4 --level=5
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: super1.x cannot open /dev/sdc: Device or resource busy
mdadm: chunk size defaults to 128K
mdadm: /dev/sdc appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sdc but will be lost or
       meaningless after creating array
mdadm: /dev/sdb appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sdb but will be lost or
       meaningless after creating array
mdadm: /dev/sdd appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sdd but will be lost or
       meaningless after creating array
mdadm: size set to 1953511424K
Continue creating array? y
mdadm: Creating array inside imsm container /dev/md/imsm
mdadm: failed to activate array.
# mdadm --stop /dev/md/imsm
mdadm: stopped /dev/md/imsm
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
unused devices: <none>

ATTEMPT #3
# export IMSM_NO_PLATFORM=1
# mdadm --create --verbose /dev/md/imsm /dev/sdb /dev/sdc /dev/sdd
/dev/sde --raid-devices 4 --metadata=imsm
mdadm: /dev/sdb appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdb.
mdadm: /dev/sdc appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdc.
mdadm: /dev/sdd appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdd.
mdadm: /dev/sde appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sde.
mdadm: size set to 1953511431K
Continue creating array? y
mdadm: container /dev/md/imsm prepared.
# mdadm --create --verbose /dev/md/Volume0 /dev/sde /dev/sdc missing
/dev/sdd --raid-devices 4 --level=5
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: super1.x cannot open /dev/sde: Device or resource busy
mdadm: chunk size defaults to 128K
mdadm: /dev/sde appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sde but will be lost or
       meaningless after creating array
mdadm: /dev/sdc appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sdc but will be lost or
       meaningless after creating array
mdadm: /dev/sdd appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sdd but will be lost or
       meaningless after creating array
mdadm: size set to 1953511424K
Continue creating array? y
mdadm: Creating array inside imsm container /dev/md/imsm
mdadm: failed to activate array.
# mdadm --stop /dev/md/imsm
mdadm: stopped /dev/md/imsm
# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
unused devices: <none>

ATTEMPT #4
# export IMSM_NO_PLATFORM=1
# mdadm --create --verbose /dev/md/imsm /dev/sdb /dev/sdc /dev/sdd
/dev/sde --raid-devices 4 --metadata=imsm
mdadm: /dev/sdb appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdb.
mdadm: /dev/sdc appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdc.
mdadm: /dev/sdd appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sdd.
mdadm: /dev/sde appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: metadata will over-write last partition on /dev/sde.
mdadm: size set to 1953511431K
Continue creating array? y
mdadm: container /dev/md/imsm prepared.
# mdadm --create --verbose /dev/md/Volume0 /dev/sde /dev/sdc /dev/sdb
missing --raid-devices 4 --level=5
mdadm: layout defaults to left-symmetric
mdadm: layout defaults to left-symmetric
mdadm: super1.x cannot open /dev/sde: Device or resource busy
mdadm: chunk size defaults to 128K
mdadm: /dev/sde appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sde but will be lost or
       meaningless after creating array
mdadm: /dev/sdc appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sdc but will be lost or
       meaningless after creating array
mdadm: /dev/sdb appears to be part of a raid array:
    level=container devices=0 ctime=Thu Jan  1 00:00:00 1970
mdadm: partition table exists on /dev/sdb but will be lost or
       meaningless after creating array
mdadm: size set to 1953511424K
Continue creating array? y
mdadm: Creating array inside imsm container /dev/md/imsm
mdadm: failed to activate array.

Also noticed this in dmesg, all the attemps generate the same output
but heres the dmesg output related to attempt #4:

[292271.903919] md: md127 stopped.
[292271.903938] md: unbind<sde>
[292271.914179] md: export_rdev(sde)
[292271.914424] md: unbind<sdd>
[292271.927499] md: export_rdev(sdd)
[292271.927728] md: unbind<sdc>
[292271.940823] md: export_rdev(sdc)
[292271.940979] md: unbind<sdb>
[292271.954153] md: export_rdev(sdb)
[292289.371545] md: bind<sdb>
[292289.371731] md: bind<sdc>
[292289.371877] md: bind<sdd>
[292289.372024] md: bind<sde>
[292295.910881] md: bind<sde>
[292295.911130] md: bind<sdc>
[292295.911314] md: bind<sdb>
[292295.923942] bio: create slab <bio-1> at 1
[292295.923965] md/raid:md126: not clean -- starting background reconstruction
[292295.924000] md/raid:md126: device sdb operational as raid disk 2
[292295.924005] md/raid:md126: device sdc operational as raid disk 1
[292295.924009] md/raid:md126: device sde operational as raid disk 0
[292295.925149] md/raid:md126: allocated 4250kB
[292295.927268] md/raid:md126: cannot start dirty degraded array.
[292295.929666] RAID conf printout:
[292295.929677]  --- level:5 rd:4 wd:3
[292295.929683]  disk 0, o:1, dev:sde
[292295.929688]  disk 1, o:1, dev:sdc
[292295.929693]  disk 2, o:1, dev:sdb
[292295.930898] md/raid:md126: failed to run raid set.
[292295.930902] md: pers->run() failed ...
[292295.931079] md: md126 stopped.
[292295.931096] md: unbind<sdb>
[292295.944228] md: export_rdev(sdb)
[292295.944267] md: unbind<sdc>
[292295.958126] md: export_rdev(sdc)
[292295.958167] md: unbind<sde>
[292295.970902] md: export_rdev(sde)
[292296.219837] device-mapper: table: 252:1: raid45: unknown target type
[292296.219845] device-mapper: ioctl: error adding target to table
[292296.291542] device-mapper: table: 252:1: raid45: unknown target type
[292296.291548] device-mapper: ioctl: error adding target to table
[292296.310926] quiet_error: 1116 callbacks suppressed
[292296.310934] Buffer I/O error on device dm-0, logical block 3907022720
[292296.310940] Buffer I/O error on device dm-0, logical block 3907022721
[292296.310944] Buffer I/O error on device dm-0, logical block 3907022722
[292296.310949] Buffer I/O error on device dm-0, logical block 3907022723
[292296.310953] Buffer I/O error on device dm-0, logical block 3907022724
[292296.310958] Buffer I/O error on device dm-0, logical block 3907022725
[292296.310962] Buffer I/O error on device dm-0, logical block 3907022726
[292296.310966] Buffer I/O error on device dm-0, logical block 3907022727
[292296.310973] Buffer I/O error on device dm-0, logical block 3907022720
[292296.310977] Buffer I/O error on device dm-0, logical block 3907022721
[292296.319968] device-mapper: table: 252:1: raid45: unknown target type
[292296.319975] device-mapper: ioctl: error adding target to table

Any ideas from here? Am I up the creek without a paddle? :(

thanks to everyone for all your help so far
chris

On Sun, Jan 13, 2013 at 4:05 PM, Dan Williams <djbw@fb.com> wrote:
>
>
> On 1/13/13 11:00 AM, "chris" <tknchris@gmail.com> wrote:
>
>>Neil/Dave,
>>
>>Is it not possible to create imsm container with missing disk?
>>If not, Is there any way to recreate the array with all disks but
>>prevent any kind of sync which may overwrite array data?
>
> The example was in that link I sent:
>
> mdadm --create /dev/md/imsm /dev/sd[bde] -e imsm
> mdadm --create /dev/md/vol0 /dev/sde missing /dev/sdb /dev/sdd -n 4 -l 5
>
> The first command marks all devices as spares.  The second creates the
> degraded array.
>
> You probably want at least sdb and sdd in there since they have a copy of
> the metadata.
>
> --
> Dan
>
