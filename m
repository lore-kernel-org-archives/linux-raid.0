From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: Recovery/Access of imsm raid via mdadm?
Date: Tue, 15 Jan 2013 10:25:13 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1904E2AC@IRSMSX102.ger.corp.intel.com>
References: <CAKnNFz_25zLMquBphPb8xx=rrG2BquXjLuc1-ke+1ztoVaUOgA@mail.gmail.com>
	<84A937D219C2B44EB8EA44831ACA1E4916D902C5@PRN-MBX02-3.TheFacebook.com>
	<CAKnNFz8dZVgS7M_rmQx0c_S+jo46EGs2GWAHc99ziaAR5OQp+w@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB1904DF39@IRSMSX102.ger.corp.intel.com>
 <CAKnNFz-Gy7vJjErKijV3=HV16Br_uq4rxfbbB9sFHHVi3SWtOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKnNFz-Gy7vJjErKijV3=HV16Br_uq4rxfbbB9sFHHVi3SWtOw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: chris <tknchris@gmail.com>
Cc: Neil Brown <neilb@suse.de>, "Jiang, Dave" <dave.jiang@intel.com>, Linux-RAID <linux-raid@vger.kernel.org>, Dan Williams <djbw@fb.com>
List-Id: linux-raid.ids

On Monday, January 14, 2013 4:25 PM chris <tknchris@gmail.com> wrote:
> Ok thanks for the tips, I am imaging the disks now and will try after
> that is done. Just out of curiousity what could become corrupted by
> forcing the assemble? I was under the impression that as long as I
> have one member missing that the only thing that would be touched is
> metadata, is that right?
> 
Yes, that is right. I meant that using --force option it may be possible to assembly an array in the wrong way and data can be incorrect, so it is better to be careful.

Lukasz

> On Mon, Jan 14, 2013 at 9:24 AM, Dorau, Lukasz <lukasz.dorau@intel.com>
> wrote:
> > On Monday, January 14, 2013 3:11 PM Dorau, Lukasz
> <lukasz.dorau@intel.com> wrote:
> >> On Monday, January 14, 2013 1:56 AM chris <tknchris@gmail.com> wrote:
> >> > [292295.923942] bio: create slab <bio-1> at 1
> >> > [292295.923965] md/raid:md126: not clean -- starting background
> >> > reconstruction
> >> > [292295.924000] md/raid:md126: device sdb operational as raid disk 2
> >> > [292295.924005] md/raid:md126: device sdc operational as raid disk 1
> >> > [292295.924009] md/raid:md126: device sde operational as raid disk 0
> >> > [292295.925149] md/raid:md126: allocated 4250kB
> >> > [292295.927268] md/raid:md126: cannot start dirty degraded array.
> >>
> >> Hi
> >>
> >> *Remember to backup the disks you have before trying the following! *
> >>
> >> You can try starting dirty degraded array using:
> >> #  mdadm --assemble --force ....
> >>
> >
> > I meant adding --force option to:
> > # mdadm --create --verbose --force /dev/md/Volume0 /dev/sdc missing
> /dev/sdb /dev/sdd --raid-devices 4 --level=5
> >
> > Be very careful using "--force" option, because it can cause data corruption!
> >
> > Lukasz
> >
> >
> >> See also the "Boot time assembly of degraded/dirty arrays" chapter in:
> >> http://www.kernel.org/doc/Documentation/md.txt
> >> (you can boot with option md-mod.start_dirty_degraded=1)
> >>
> >> Lukasz
> >>
> >>
> >> > [292295.929666] RAID conf printout:
> >> > [292295.929677]  --- level:5 rd:4 wd:3
> >> > [292295.929683]  disk 0, o:1, dev:sde
> >> > [292295.929688]  disk 1, o:1, dev:sdc
> >> > [292295.929693]  disk 2, o:1, dev:sdb
> >> > [292295.930898] md/raid:md126: failed to run raid set.
> >> > [292295.930902] md: pers->run() failed ...
> >> > [292295.931079] md: md126 stopped.
> >> > [292295.931096] md: unbind<sdb>
> >> > [292295.944228] md: export_rdev(sdb)
> >> > [292295.944267] md: unbind<sdc>
> >> > [292295.958126] md: export_rdev(sdc)
> >> > [292295.958167] md: unbind<sde>
> >> > [292295.970902] md: export_rdev(sde)
> >> > [292296.219837] device-mapper: table: 252:1: raid45: unknown target type
> >> > [292296.219845] device-mapper: ioctl: error adding target to table
> >> > [292296.291542] device-mapper: table: 252:1: raid45: unknown target type
> >> > [292296.291548] device-mapper: ioctl: error adding target to table
> >> > [292296.310926] quiet_error: 1116 callbacks suppressed
> >> > [292296.310934] Buffer I/O error on device dm-0, logical block
> 3907022720
> >> > [292296.310940] Buffer I/O error on device dm-0, logical block
> 3907022721
> >> > [292296.310944] Buffer I/O error on device dm-0, logical block
> 3907022722
> >> > [292296.310949] Buffer I/O error on device dm-0, logical block
> 3907022723
> >> > [292296.310953] Buffer I/O error on device dm-0, logical block
> 3907022724
> >> > [292296.310958] Buffer I/O error on device dm-0, logical block
> 3907022725
> >> > [292296.310962] Buffer I/O error on device dm-0, logical block
> 3907022726
> >> > [292296.310966] Buffer I/O error on device dm-0, logical block
> 3907022727
> >> > [292296.310973] Buffer I/O error on device dm-0, logical block
> 3907022720
> >> > [292296.310977] Buffer I/O error on device dm-0, logical block
> 3907022721
> >> > [292296.319968] device-mapper: table: 252:1: raid45: unknown target type
> >> > [292296.319975] device-mapper: ioctl: error adding target to table
> >> >
> >> > Any ideas from here? Am I up the creek without a paddle? :(
> >> >
> >> > thanks to everyone for all your help so far
> >> > chris
> >> >
> >> > On Sun, Jan 13, 2013 at 4:05 PM, Dan Williams <djbw@fb.com> wrote:
> >> > >
> >> > >
> >> > > On 1/13/13 11:00 AM, "chris" <tknchris@gmail.com> wrote:
> >> > >
> >> > >>Neil/Dave,
> >> > >>
> >> > >>Is it not possible to create imsm container with missing disk?
> >> > >>If not, Is there any way to recreate the array with all disks but
> >> > >>prevent any kind of sync which may overwrite array data?
> >> > >
> >> > > The example was in that link I sent:
> >> > >
> >> > > mdadm --create /dev/md/imsm /dev/sd[bde] -e imsm
> >> > > mdadm --create /dev/md/vol0 /dev/sde missing /dev/sdb /dev/sdd -n 4 -l
> 5
> >> > >
> >> > > The first command marks all devices as spares.  The second creates the
> >> > > degraded array.
> >> > >
> >> > > You probably want at least sdb and sdd in there since they have a copy of
> >> > > the metadata.
> >> > >
> >> > > --
> >> > > Dan
> >> > >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
