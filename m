From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm + raid1 of 2 disks and now need to add more
Date: Mon, 17 Apr 2006 09:36:29 +1000
Message-ID: <17474.54525.984177.653827@cse.unsw.edu.au>
References: <e3edb0fa0604110741h355f4eft3f3d42a825cb4233@mail.gmail.com>
	<e3edb0fa0604120018y3e305d05td532034e546ab816@mail.gmail.com>
	<17468.46918.372777.583831@cse.unsw.edu.au>
	<e3edb0fa0604120210j1784a3cdlcf42cd2b22d1cfc7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Shai on Wednesday April 12
Sender: linux-raid-owner@vger.kernel.org
To: Shai <shaibn@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 12, shaibn@gmail.com wrote:
> yea! it is a testing server I use that is the same kernel as our main
> server... just for tests like these so we don't screw up .... I never
> run the real thing before I'm sure I know I've got it working on our
> test server.
> 
> Well... what I did was:
> --------------------------------
> 
> # cat do_changes.sh
> #!/bin/bash -x
> 
> umount /mnt/md0
> read
> mdadm --stop /dev/md0
> read
> mdadm --zero-super /dev/ide/host0/bus1/target1/lun0/part1
> read
> mdadm -C -n 4 -l 1 /dev/md0 /dev/ide/host0/bus1/target1/lun0/part1
> missing missing missing
> read
> ### end of script ###
> 
> What do you think?

Yes, that looks fine.

NeilBrown


> 
> Shai
> 
> On 4/12/06, Neil Brown <neilb@suse.de> wrote:
> > On Wednesday April 12, shaibn@gmail.com wrote:
> > > I now have the md0 raid1 with 2 disks and 1 spare:
> > >        0      22       65        0      active sync   /dev/hdd1
> > >        1      22       66        1      active sync   /dev/hdd2
> > >
> > >        2      22       67        2      spare   /dev/hdd3
> > >
> > > # /usr/local/sbin/mdadm -G -n 3 /dev/md0
> > > mdadm: Cannot set raid-devices for /dev/md0: File exists
> > >
> > > i'm using kernel 2.4.26
> >
> > You'll need a 2.6 kernel for that, I don't remember which one is the
> > minimum.
> >
> > If you are stuck with 2.4, you need to recreate the array:
> >  mdadm -S /dev/md0
> >  mdadm -C /dev/md0 -l1 -n3 --assume-clean /dev/hdd1 /dev/hdd2 missing
> >  mdadm /dev/md0 -a /dev/hdd3
> >
> > (is that really 3 partitions on the one device?  Just for testing,
> > right?
> >
> > NeilBrown
> >
> > >
> > > # /usr/local/sbin/mdadm -V
> > > mdadm - v2.4.1 -  4 April 2006
> > >
> > > On 4/11/06, Shai <shaibn@gmail.com> wrote:
> > > > Hi,
> > > >
> > > > I have two SCSI disks on raid1.
> > > > Since I have lots of reads from that raid, I want to add two more
> > > > disks to this raid so that read will be faster.
> > > >
> > > > How should I add the new disks?
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
