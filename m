From: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
Subject: RE: mdadm-3.2.5 coming soon :-(
Date: Thu, 17 May 2012 11:52:43 +0000
Message-ID: <679865E03F4C71419D9847EA3AACB163157E29EF@IRSMSX102.ger.corp.intel.com>
References: <20120503142201.649766de@notabene.brown>
	<20120515215020.76fd9c6f@notabene.brown>	<4FB274B3.8040907@intel.com>
 <20120517154449.2eeb0512@notabene.brown>
 <679865E03F4C71419D9847EA3AACB163157E2858@IRSMSX102.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <679865E03F4C71419D9847EA3AACB163157E2858@IRSMSX102.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, NeilBrown <neilb@suse.de>, "Naruszewicz, Maciej" <maciej.naruszewicz@intel.com>
Cc: linux RAID <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Doug Ledford <dledford@redhat.com>, Michael Tokarev <mjt@tls.msk.ru>, "Williams, Dan J" <dan.j.williams@intel.com>, "Dorau, Lukasz" <lukasz.dorau@intel.com>, Clint Byrum <clint@ubuntu.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Tomczak, Marcin" <marcin.tomczak@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Patelczyk, Maciej
> Sent: Thursday, May 17, 2012 10:28 AM
> To: NeilBrown; Naruszewicz, Maciej
> Cc: linux RAID; Jes Sorensen; Doug Ledford; Michael Tokarev; Williams,
> Dan J; Dorau, Lukasz; Clint Byrum; Danecki, Jacek; Tomczak, Marcin
> Subject: RE: mdadm-3.2.5 coming soon :-(
> 
> > -----Original Message-----
> > From: NeilBrown [mailto:neilb@suse.de]
> > Sent: Thursday, May 17, 2012 7:45 AM
> > To: Naruszewicz, Maciej
> > Cc: linux RAID; Jes Sorensen; Doug Ledford; Michael Tokarev;
> Williams,
> > Dan J; Dorau, Lukasz; Clint Byrum; Danecki, Jacek; Patelczyk, Maciej;
> > Tomczak, Marcin
> > Subject: Re: mdadm-3.2.5 coming soon :-(
> >
> > On Tue, 15 May 2012 17:22:27 +0200 Maciej Naruszewicz
> > <maciej.naruszewicz@intel.com> wrote:
> >
> > > > If anyone knows of any other issues that have cropped up wit
> > > > 3.2.4, please let me know.
> > > >
> > > > Thanks,
> > > > NeilBrown
> > >
> > > Since mdadm-3.2.4 creating volumes using IMSM containers is
> > impossible
> > > (segfaults), unless the kernel is 3.1.x or higher (for instance
> > > everything SEEMS to work in RHEL 7.0 Alpha and openSUSE 12.1). Full
> > > story from SLES 11 SP2 (kernel-3.0.13-0.27-default) with mdadm-
> 3.2.4
> > :
> > >
> > > $ mdadm --zero-superblock /dev/sd[cd] $ mdadm -C /dev/md/imsm0 -a
> md
> > > -e imsm -n 2 /dev/sd[cd] -R
> > >
> > >      [...]
> > >
> > > $ tail /var/log/messages
> > >
> > >      May 15 17:16:10 gklab-128-174 kernel: [  317.653470] md:
> > bind<sdc>
> > >      May 15 17:16:10 gklab-128-174 kernel: [  317.653519] md:
> > bind<sdd>
> > >      May 15 17:16:11 gklab-128-174 udevd-work[5249]: '/sbin/mdadm
> > > --detail --export /dev/md127' unexpected exit with status 0x000b
> > >      May 15 17:16:11 gklab-128-174 kernel: [  317.701434]
> > mdadm[5250]:
> > > segfault at 78 ip 0000000000450c4f sp 00007fff6c99ada0 error 4 in
> > > mdadm[400000+69000]
> > >
> > > $ mdadm -C /dev/md/raid1_2disks -a md -l 1  --size 1500000 -n 2
> > > /dev/sd[cd] -R -f
> > >
> > >      mdadm: cannot open device: 11:0
> > >      [...]
> > >      mdadm: cannot open device: 11:0
> > >      [...]
> > >      Segmentation fault
> > >
> > > $ tail /var/log/messages
> > >
> > >      May 15 17:18:36 gklab-128-174 kernel: [  463.291235]
> > mdadm[5298]:
> > > segfault at 78 ip 0000000000450c4f sp 00007fff8ad887e0 error 4 in
> > > mdadm[400000+69000]
> > >
> > > Similiar story in RHEL 6.3 Beta, those errors don't happen with
> > kernel
> > > >= 3.1.x though (or mdadm-3.2.3 :)).
> > >
> > > Maciek N
> >
> > Could the difference be that fact that 3.2.4 default to using /run,
> > which doens't exist on SLES11 and may on in RHEL 6.3?
> > If you compile with
> >    make MAP_DIR=/var/run/mdadm
> > does it work better?
> >
> > However I think this will fix the crash you are seeing.
> >
> > diff --git a/mapfile.c b/mapfile.c
> > index b890ed2..70ff355 100644
> > --- a/mapfile.c
> > +++ b/mapfile.c
> > @@ -404,6 +404,8 @@ void RebuildMap(void)
> >  			if (ok != 0)
> >  				continue;
> >  			info = st->ss->container_content(st, subarray);
> > +			if (!info)
> > +				continue;
> >
> >  			if (md->devnum >= 0)
> >  				path = map_dev(MD_MAJOR, md->devnum, 0);
> >
> > Thanks,
> > NeilBrown
> 
> Thanks Neil,
> Yes, this prevents mdadm from segfault but there's still some strange
> behavior.
> 

'mkdir /run' solves it even without fix above.

maciej
