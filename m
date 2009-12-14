From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: RE: [patch 1/1] [mdadm] Add partition checks when creating a new
 array
Date: Mon, 14 Dec 2009 11:33:01 +0000
Message-ID: <EB332302649177439359CE520D92A0AFA284AFFC@irsmsx503.ger.corp.intel.com>
References: <EB332302649177439359CE520D92A0AF9F559760@irsmsx503.ger.corp.intel.com>
 <19196.51508.947560.851117@notabene.brown>
 <20091120170350.GA20882@maude.comedia.it> <4B241E28.8060706@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B241E28.8060706@shiftmail.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>, Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Asdo [mailto:asdo@shiftmail.org]
> Sent: Saturday, December 12, 2009 11:50 PM
> To: Neil Brown; Trela, Maciej; linux-raid@vger.kernel.org; Williams,
> Dan J; Ciechanowski, Ed
> Subject: Re: [patch 1/1] [mdadm] Add partition checks when creating a
> new array
> 
> Luca Berra wrote:
> > On Fri, Nov 13, 2009 at 01:49:24PM +1100, Neil Brown wrote:
> >> Is there a good library that we could use?
> >> libparted might be a possibility, but it seems rather over-weight.
> >> /lib/libparted-1.9.so.12.0.0 is larger than /sbin/mdadm !!!
> >>
> >> Are there any other libraries for reading different partition
> tables?
> >> I guess we can open-code it if we have to but I'd be happy if
> another
> >> solution could be found.
> >
> > i don't think so,
> > but there are two tools
> > partx from util-linux
> > kpartix from multipath-tools (which is based on the former)
> >
> > so we could either grab code from those or just invoke
> > partx -l (i believe every distro installs util-linux by default)
> >
> > L.
> 
> I'm probably missing something obvious but...
> why don't you use the kernel directly to detect if there are partitions
> on the device?
> 
> Like if the user wants to make a raid on /dev/sdg but the device
> /dev/sdg1 exists, that's a problem, you fail the creation. (*)
> 

It is ok to create an array if partition exists on a device.
We just want to check if the metadata will overwrite the existing partition data.
If there is not enough space for metadata, the user will be warned.
However, this check is reasonable only if the user may want to preserve the partition data,
like when creating Raid1...

Regards,
Maciek.




