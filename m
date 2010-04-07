From: Neil Brown <neilb@suse.de>
Subject: Re: linux raid recreate
Date: Wed, 7 Apr 2010 23:15:21 +1000
Message-ID: <20100407231521.72aec109@notabene.brown>
References: <S1753093Ab0CYHZE/20100325072504Z+37@vger.kernel.org>
	<2E4545D6-8F4E-4779-9103-960C52983A72@brillgene.com>
	<4877c76c1003250437r346e18en8da0f6f804bef634@mail.gmail.com>
	<DFC0232A-8DCD-4815-AA08-DA7065F01221@brillgene.com>
	<4877c76c1003252038o655b2a29p9d994df27b5d2afd@mail.gmail.com>
	<6093BE49-EE3B-41B5-9519-C6D5D0496C64@brillgene.com>
	<4877c76c1003261204h2777547dn67a8e692864ff26a@mail.gmail.com>
	<D332CDBC-0D5D-4BF7-8876-7A4B1B3ED45E@brillgene.com>
	<45872BBE-0957-43E4-8D31-54B28F5F5936@brillgene.com>
	<20100329053227.GA21664@maude.comedia.it>
	<4877c76c1003282341s15f181b0m6a0327bc947dc456@mail.gmail.com>
	<B3E0E48F-88C0-4D6F-8E23-B1344BC1C82C@brillgene.com>
	<20100407085545.7673be70@notabene.brown>
	<47263FDF-D252-485E-A867-4FD0D10E4297@brillgene.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47263FDF-D252-485E-A867-4FD0D10E4297@brillgene.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman@brillgene.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 7 Apr 2010 12:57:20 +0530
Anshuman Aggarwal <anshuman@brillgene.com> wrote:

> 
> On 07-Apr-2010, at 4:25 AM, Neil Brown wrote:
> 
> > On Tue, 6 Apr 2010 23:37:02 +0530
> > Anshuman Aggarwal <anshuman@brillgene.com> wrote:
> > 
> >> I've just had to recreate my raid5 device by using 
> >> mdadm --create --assume-clean -n4 -l5 -e1.2 -c64 
> >> 
> >> in order to recover my data (because --assemble would not work with force etc.). 
> >> The problem:
> >> *  Data Offset in the new array is much larger. 
> >> * Internal Bitmap is starting at a different # sectors from superblock.
> >> * Array Size is smaller though the disks are the same. 
> >> 
> >> How can I get these to be the same as what they were in the original array???
> > 
> > Use the same version of mdadm and you used to originally create the array.
> > Probably 2.6.9 from the data, though 3.1.1 seems to create the same layout.
> > So anything before 3.1.2
> > 
> > I really should write a "--recreate" for mdadm which uses whatever parameters
> > if it finds already on the devices.
> > 
> > NeilBrown
> > 
> 
> 
> Since I already tried to recreate using 3.1.2, with super block 1.2, would it have overwritten much other data on the device? Also is the superblock format documented somewhere such as a graph explaining where what is stored?

I don't think it will have overwritten any data, but I don't have enough info
to be 100% certain.

If you used --assume-clean, and did not write anything to the array, then
only the superblock and bitmap will have been written.

The superblock that you wrote will be the same location as the old
superblock, so writing that will not corrupt data.

The bitmap will have been written 8 sectors from superblock rather than 2,
but it will probably have been a smaller bitmap.
If you report
  mdadm -X /dev/sdb5
I can tell you how big the bitmap is, and so whether it would have extended
in to the data which was at 272 sectors from the start of the device.
So the bitmap would have to exceed 266 sectors for it to over-write any data.

The only superblock documentation I know of is in the source code for mdadm
and the kernel.

NeilBrown



> 
> Thanks,
> 
> > 
> >> 
> >> I have tried to make sure that nothing gets written to the md device except the metadata during create. 
> >> All of these are important because the fs on top of the LVM on top of the md would need all the data it can to fsck properly and I don't want it starting on the wrong offset. 
> >> 
> >> I am including the output from mdadm --examine from before and after the create
> >> 
> >> Originally...
> >> 
> >>>>> /dev/sdb5:
> >>>>>       Magic : a92b4efc
> >>>>>     Version : 1.2
> >>>>> Feature Map : 0x1
> >>>>>  Array UUID : 42c56ea0:2484f566:387adc6c:b3f6a014
> >>>>>        Name : GATEWAY:127  (local to host GATEWAY)
> >>>>> Creation Time : Sat Aug 22 09:44:21 2009
> >>>>>  Raid Level : raid5
> >>>>> Raid Devices : 4
> >>>>> 
> >>>>> Avail Dev Size : 586099060 (279.47 GiB 300.08 GB)
> >>>>>  Array Size : 1758296832 (838.42 GiB 900.25 GB)
> >>>>> Used Dev Size : 586098944 (279.47 GiB 300.08 GB)
> >>>>> Data Offset : 272 sectors
> >>>>> Super Offset : 8 sectors
> >>>>>       State : clean
> >>>>> Device UUID : f8ebb9f8:b447f894:d8b0b59f:ca8e98eb
> >>>>> 
> >>>>> Internal Bitmap : 2 sectors from superblock
> >>>>> Update Time : Fri Mar 19 00:56:15 2010
> >>>>>    Checksum : 1005cfbc - correct
> >>>>>      Events : 3796145
> >>>>> 
> >>>>>      Layout : left-symmetric
> >>>>>  Chunk Size : 64K
> >>>>> 
> >>>>> Device Role : Active device 2
> >>>>> Array State : .AA. ('A' == active, '.' == missing)
> >> 
> >> New...
> >> 
> >> /dev/sdb5:
> >>          Magic : a92b4efc
> >>        Version : 1.2
> >>    Feature Map : 0x1
> >>     Array UUID : 8588b69c:c0579680:8a63486a:cbcb0e7d
> >>           Name : GATEWAY:511  (local to host GATEWAY)
> >>  Creation Time : Tue Apr  6 01:53:25 2010
> >>     Raid Level : raid5
> >>   Raid Devices : 4
> >> 
> >> Avail Dev Size : 586097284 (279.47 GiB 300.08 GB)
> >>     Array Size : 1758290688 (838.42 GiB 900.24 GB)
> >>  Used Dev Size : 586096896 (279.47 GiB 300.08 GB)
> >>    Data Offset : 2048 sectors
> >>   Super Offset : 8 sectors
> >>          State : clean
> >>    Device UUID : 13d6a075:c1cad6dc:c13c3d98:e4b980e9
> >> 
> >> Internal Bitmap : 8 sectors from superblock
> >>    Update Time : Tue Apr  6 23:23:07 2010
> >>       Checksum : df3cb34f - correct
> >>         Events : 4
> >> 
> >>         Layout : left-symmetric
> >>     Chunk Size : 64K
> >> 
> >>   Device Role : Active device 2
> >>   Array State : .AAA ('A' == active, '.' == missing)
> >> 
> >> 
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 

