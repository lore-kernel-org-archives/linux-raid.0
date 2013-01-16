From: chris <tknchris@gmail.com>
Subject: Re: Recovery/Access of imsm raid via mdadm?
Date: Wed, 16 Jan 2013 11:49:29 -0500
Message-ID: <CAKnNFz_5dsukFe1TP9E1X4P-XYAR0timuDq=Wjb1Q4sdXPa=tg@mail.gmail.com>
References: <CAKnNFz_25zLMquBphPb8xx=rrG2BquXjLuc1-ke+1ztoVaUOgA@mail.gmail.com>
	<84A937D219C2B44EB8EA44831ACA1E4916D902C5@PRN-MBX02-3.TheFacebook.com>
	<CAKnNFz8dZVgS7M_rmQx0c_S+jo46EGs2GWAHc99ziaAR5OQp+w@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB1904DF39@IRSMSX102.ger.corp.intel.com>
	<CAKnNFz-Gy7vJjErKijV3=HV16Br_uq4rxfbbB9sFHHVi3SWtOw@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB1904E2AC@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1904E2AC@IRSMSX102.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: Neil Brown <neilb@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>, Linux-RAID <linux-raid@vger.kernel.org>, Dan Williams <djbw@fb.com>
List-Id: linux-raid.ids

Hi, so after painfully imaging 4x2tb I have tried the suggestions of
the other 2 permutations and adding --force with no change

Other 2 permutations:
# mdadm --stop /dev/md/imsm
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
# mdadm --create --verbose /dev/md/Volume0 /dev/sdc missing /dev/sdb
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
# mdadm --create --verbose /dev/md/Volume0 missing /dev/sde /dev/sdb
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

Tried again with --force but same thing:

# mdadm --stop /dev/md/imsm
mdadm: stopped /dev/md/imsm
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
# mdadm --create --verbose --force /dev/md/Volume0 /dev/sdc missing
/dev/sdb /dev/sdd --raid-devices 4 --level=5
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

dmesg shows:
[522342.240901] md: md127 stopped.
[522342.240925] md: unbind<sde>
[522342.251221] md: export_rdev(sde)
[522342.251457] md: unbind<sdd>
[522342.267808] md: export_rdev(sdd)
[522342.267999] md: unbind<sdc>
[522342.281160] md: export_rdev(sdc)
[522342.281309] md: unbind<sdb>
[522342.291136] md: export_rdev(sdb)
[522351.758217] md: bind<sdb>
[522351.758409] md: bind<sdc>
[522351.758552] md: bind<sdd>
[522351.758690] md: bind<sde>
[522368.121090] md: bind<sdc>
[522368.122401] md: bind<sdb>
[522368.122577] md: bind<sdd>
[522368.147454] bio: create slab <bio-1> at 1
[522368.147477] md/raid:md126: not clean -- starting background reconstruction
[522368.147515] md/raid:md126: device sdd operational as raid disk 3
[522368.147520] md/raid:md126: device sdb operational as raid disk 2
[522368.147525] md/raid:md126: device sdc operational as raid disk 0
[522368.148651] md/raid:md126: allocated 4250kB
[522368.152966] md/raid:md126: cannot start dirty degraded array.
[522368.155245] RAID conf printout:
[522368.155259]  --- level:5 rd:4 wd:3
[522368.155269]  disk 0, o:1, dev:sdc
[522368.155275]  disk 2, o:1, dev:sdb
[522368.155281]  disk 3, o:1, dev:sdd
[522368.157095] md/raid:md126: failed to run raid set.
[522368.157102] md: pers->run() failed ...
[522368.157418] md: md126 stopped.
[522368.157435] md: unbind<sdd>
[522368.167883] md: export_rdev(sdd)
[522368.167922] md: unbind<sdb>
[522368.181259] md: export_rdev(sdb)
[522368.181302] md: unbind<sdc>
[522368.194576] md: export_rdev(sdc)
[522368.701814] device-mapper: table: 252:1: raid45: unknown target type
[522368.701820] device-mapper: ioctl: error adding target to table
[522368.775341] device-mapper: table: 252:1: raid45: unknown target type
[522368.775347] device-mapper: ioctl: error adding target to table
[522368.876314] quiet_error: 1116 callbacks suppressed
[522368.876324] Buffer I/O error on device dm-0, logical block 3907022720
[522368.876331] Buffer I/O error on device dm-0, logical block 3907022721
[522368.876335] Buffer I/O error on device dm-0, logical block 3907022722
[522368.876340] Buffer I/O error on device dm-0, logical block 3907022723
[522368.876344] Buffer I/O error on device dm-0, logical block 3907022724
[522368.876348] Buffer I/O error on device dm-0, logical block 3907022725
[522368.876352] Buffer I/O error on device dm-0, logical block 3907022726
[522368.876356] Buffer I/O error on device dm-0, logical block 3907022727
[522368.876362] Buffer I/O error on device dm-0, logical block 3907022720
[522368.876366] Buffer I/O error on device dm-0, logical block 3907022721
[522368.883428] device-mapper: table: 252:1: raid45: unknown target type
[522368.883434] device-mapper: ioctl: error adding target to table
[522371.066343] device-mapper: table: 252:1: raid45: unknown target type
[522371.066350] device-mapper: ioctl: error adding target to table

any idea why it wont assemble? I thought even if data was corrupt I
should be able to force it to assemble and look at it to determine if
it is corrupt or in tact

thanks
chris

On Tue, Jan 15, 2013 at 5:25 AM, Dorau, Lukasz <lukasz.dorau@intel.com> wrote:
> On Monday, January 14, 2013 4:25 PM chris <tknchris@gmail.com> wrote:
>> Ok thanks for the tips, I am imaging the disks now and will try after
>> that is done. Just out of curiousity what could become corrupted by
>> forcing the assemble? I was under the impression that as long as I
>> have one member missing that the only thing that would be touched is
>> metadata, is that right?
>>
> Yes, that is right. I meant that using --force option it may be possible to assembly an array in the wrong way and data can be incorrect, so it is better to be careful.
>
> Lukasz
>
>> On Mon, Jan 14, 2013 at 9:24 AM, Dorau, Lukasz <lukasz.dorau@intel.com>
>> wrote:
>> > On Monday, January 14, 2013 3:11 PM Dorau, Lukasz
>> <lukasz.dorau@intel.com> wrote:
>> >> On Monday, January 14, 2013 1:56 AM chris <tknchris@gmail.com> wrote:
>> >> > [292295.923942] bio: create slab <bio-1> at 1
>> >> > [292295.923965] md/raid:md126: not clean -- starting background
>> >> > reconstruction
>> >> > [292295.924000] md/raid:md126: device sdb operational as raid disk 2
>> >> > [292295.924005] md/raid:md126: device sdc operational as raid disk 1
>> >> > [292295.924009] md/raid:md126: device sde operational as raid disk 0
>> >> > [292295.925149] md/raid:md126: allocated 4250kB
>> >> > [292295.927268] md/raid:md126: cannot start dirty degraded array.
>> >>
>> >> Hi
>> >>
>> >> *Remember to backup the disks you have before trying the following! *
>> >>
>> >> You can try starting dirty degraded array using:
>> >> #  mdadm --assemble --force ....
>> >>
>> >
>> > I meant adding --force option to:
>> > # mdadm --create --verbose --force /dev/md/Volume0 /dev/sdc missing
>> /dev/sdb /dev/sdd --raid-devices 4 --level=5
>> >
>> > Be very careful using "--force" option, because it can cause data corruption!
>> >
>> > Lukasz
>> >
>> >
>> >> See also the "Boot time assembly of degraded/dirty arrays" chapter in:
>> >> http://www.kernel.org/doc/Documentation/md.txt
>> >> (you can boot with option md-mod.start_dirty_degraded=1)
>> >>
>> >> Lukasz
>> >>
>> >>
>> >> > [292295.929666] RAID conf printout:
>> >> > [292295.929677]  --- level:5 rd:4 wd:3
>> >> > [292295.929683]  disk 0, o:1, dev:sde
>> >> > [292295.929688]  disk 1, o:1, dev:sdc
>> >> > [292295.929693]  disk 2, o:1, dev:sdb
>> >> > [292295.930898] md/raid:md126: failed to run raid set.
>> >> > [292295.930902] md: pers->run() failed ...
>> >> > [292295.931079] md: md126 stopped.
>> >> > [292295.931096] md: unbind<sdb>
>> >> > [292295.944228] md: export_rdev(sdb)
>> >> > [292295.944267] md: unbind<sdc>
>> >> > [292295.958126] md: export_rdev(sdc)
>> >> > [292295.958167] md: unbind<sde>
>> >> > [292295.970902] md: export_rdev(sde)
>> >> > [292296.219837] device-mapper: table: 252:1: raid45: unknown target type
>> >> > [292296.219845] device-mapper: ioctl: error adding target to table
>> >> > [292296.291542] device-mapper: table: 252:1: raid45: unknown target type
>> >> > [292296.291548] device-mapper: ioctl: error adding target to table
>> >> > [292296.310926] quiet_error: 1116 callbacks suppressed
>> >> > [292296.310934] Buffer I/O error on device dm-0, logical block
>> 3907022720
>> >> > [292296.310940] Buffer I/O error on device dm-0, logical block
>> 3907022721
>> >> > [292296.310944] Buffer I/O error on device dm-0, logical block
>> 3907022722
>> >> > [292296.310949] Buffer I/O error on device dm-0, logical block
>> 3907022723
>> >> > [292296.310953] Buffer I/O error on device dm-0, logical block
>> 3907022724
>> >> > [292296.310958] Buffer I/O error on device dm-0, logical block
>> 3907022725
>> >> > [292296.310962] Buffer I/O error on device dm-0, logical block
>> 3907022726
>> >> > [292296.310966] Buffer I/O error on device dm-0, logical block
>> 3907022727
>> >> > [292296.310973] Buffer I/O error on device dm-0, logical block
>> 3907022720
>> >> > [292296.310977] Buffer I/O error on device dm-0, logical block
>> 3907022721
>> >> > [292296.319968] device-mapper: table: 252:1: raid45: unknown target type
>> >> > [292296.319975] device-mapper: ioctl: error adding target to table
>> >> >
>> >> > Any ideas from here? Am I up the creek without a paddle? :(
>> >> >
>> >> > thanks to everyone for all your help so far
>> >> > chris
>> >> >
>> >> > On Sun, Jan 13, 2013 at 4:05 PM, Dan Williams <djbw@fb.com> wrote:
>> >> > >
>> >> > >
>> >> > > On 1/13/13 11:00 AM, "chris" <tknchris@gmail.com> wrote:
>> >> > >
>> >> > >>Neil/Dave,
>> >> > >>
>> >> > >>Is it not possible to create imsm container with missing disk?
>> >> > >>If not, Is there any way to recreate the array with all disks but
>> >> > >>prevent any kind of sync which may overwrite array data?
>> >> > >
>> >> > > The example was in that link I sent:
>> >> > >
>> >> > > mdadm --create /dev/md/imsm /dev/sd[bde] -e imsm
>> >> > > mdadm --create /dev/md/vol0 /dev/sde missing /dev/sdb /dev/sdd -n 4 -l
>> 5
>> >> > >
>> >> > > The first command marks all devices as spares.  The second creates the
>> >> > > degraded array.
>> >> > >
>> >> > > You probably want at least sdb and sdd in there since they have a copy of
>> >> > > the metadata.
>> >> > >
>> >> > > --
>> >> > > Dan
>> >> > >
>> >> > --
>> >> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> >> > the body of a message to majordomo@vger.kernel.org
>> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
