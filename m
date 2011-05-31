From: "Jiang, Dave" <dave.jiang@intel.com>
Subject: RE: creating degraded raid1 with imsm metadata
Date: Tue, 31 May 2011 07:36:42 -0700
Message-ID: <D010E79907AF0D4E90B603DE907837D504908C0B32@azsmsx504.amr.corp.intel.com>
References: <20110526074259.GA31623@r00t3d.com>
 <D010E79907AF0D4E90B603DE907837D50490856E0F@azsmsx504.amr.corp.intel.com>
 <20110528171354.GA9767@r00t3d.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110528171354.GA9767@r00t3d.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: FDi <fld@r00t3d.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: FDi [mailto:fld@r00t3d.com]
> Sent: Saturday, May 28, 2011 10:14 AM
> To: Jiang, Dave
> Cc: linux-raid@vger.kernel.org
> Subject: Re: creating degraded raid1 with imsm metadata
> 
> On Thu, May 26, 2011 at 09:40:16AM -0700, Jiang, Dave wrote:
> > > -----Original Message-----
> > > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > > owner@vger.kernel.org] On Behalf Of FDi
> > > Sent: Thursday, May 26, 2011 12:43 AM
> > > To: linux-raid@vger.kernel.org
> > > Subject: creating degraded raid1 with imsm metadata
> > >
> > > Hello *,
> > >
> > > Since Intel's Matrix Storage Manager option ROM doesn't support
> > > creating of degraded arrays I was wondering if I could use mdadm to
> > > make one? I had a very hard time finding documentation about how
> > > mdadm is supposed to work with imsm.
> > >
> > > The plan is to make a 2x1TB raid1 with one device missing and then
> > > later add the other disk in once all the data has been copied to the
> > > degraded array. So a typical raid1 migration scenario, which Intel
> > > oddly enough doesn't seem to support with their option ROM.
> >
> > Not sure if that's possible but have you looked at the Linux RAID wiki on
> IMSM information?
> > https://raid.wiki.kernel.org/index.php/RAID_setup#External_Metadata
> I wasn't able to figure out how to do what I wanted based on the wiki, but
> after lots of googling I found the exact commands:
> 
> mdadm --create --force -v -e imsm --level=container -n 1 /dev/md/imsm
> /dev/sdb
> 
> mdadm --create -v --level raid1 -n 2 /dev/md/myraid /dev/sdb missing
> 
> However I also learned that these commands have to be done on the target
> machine while its running with RAID mode selected from BIOS. Otherwise
> you will get this warning:
> 
> mdadm: imsm unable to enumerate platform support
>     array may not be compatible with hardware/firmware
> 	 Continue creating array?
> 
> And indeed if that warning is displayed during the create, Intel's option rom
> won't see a working array on the device. I'm kinda curious why is this exactly?
> What kind of information mdadm uses from the controller running in RAID
> mode?

It queries the table exported by the OROM regarding the capabilities of the OROM. Limits are checked such as chunk size, leve, number of devices and etc. This ensures that the OROM can recognize the RAID volume you created on Linux. You can also bypass the warning by doing: "export IMSM_NO_PLATFORM=1"
 
> When I created my array on the target machine using the commands from
> above it worked correctly and Intel option rom saw the array and was able to
> boot from the MBR I installed on the array as a test. Haven't tested rebuilding
> yet.
