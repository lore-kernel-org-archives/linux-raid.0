From: Marc MERLIN <marc_news@merlins.org>
Subject: Re: mdadm -A /dev/md3 fails
Date: Thu, 10 Oct 2002 08:34:07 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021010153407.GB14183@merlins.org>
References: <20020909054800.GV3806@merlins.org> <15740.15774.911597.853392@notabene.cse.unsw.edu.au> <20020909062737.GA3806@merlins.org> <15740.33238.383316.833368@notabene.cse.unsw.edu.au> <20020909054800.GV3806@merlins.org> <15740.15774.911597.853392@notabene.cse.unsw.edu.au> <20020909075559.GE3806@merlins.org> <15740.32983.311512.759757@notabene.cse.unsw.edu.au> <20020909075559.GE3806@merlins.org> <Pine.LNX.4.30.0209090115370.11702-100000@jaded.cynicism.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15740.33238.383316.833368@notabene.cse.unsw.edu.au> <15740.32983.311512.759757@notabene.cse.unsw.edu.au> <Pine.LNX.4.30.0209090115370.11702-100000@jaded.cynicism.com>
To: Derek Vadala <derek@cynicism.com>, Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I apologize for the really late answer, it looks like this message never
left my laptop.

On Mon, Sep 09, 2002 at 01:18:52AM -0700, Derek Vadala wrote:
> On Mon, 9 Sep 2002, Marc MERLIN wrote:
> 
> > gargamel:/etc/mdadm# mdadm -A  -v /dev/md3
> > mdadm: No identity information available for /dev/md3 - cannot assemble.
> 
> Try mdadm -Avs /dev/md3
> 
> -s or --scan tells mdadm to use the config file.

Yep, that worked fine, thanks.

On Mon, Sep 09, 2002 at 09:07:03PM +1000, Neil Brown wrote:
> On Monday September 9, marc_news@merlins.org wrote:
> > On Mon, Sep 09, 2002 at 04:20:14PM +1000, Neil Brown wrote:
> > > That is part of the reason that I wrote mdadm.  It can do the right
> > > thing for you.
> > 
> > Apparently it can, but I'm having issues with it:
> > 
> > My conf file says:
> > DEVICE /dev/scsi/host*/bus*/target*/lun*/part*
> > ARRAY /dev/md3 level=raid5 num-devices=7 UUID=7f69d69c:2d523219:4f3d1ea7:9b7f4057 devices=/dev/scsi/host3/bus0/target8/lun0/part1,/dev/scsi/host3/bus0/target9/lun0/part1,/dev/scsi/host3/bus0/target10/lun0/part1,/dev/scsi/host3/bus0/target11/lun0/part1,/dev/scsi/host3/bus0/target12/lun0/part1,/dev/scsi/host3/bus0/target13/lun0/part1,/dev/scsi/host3/bus0/target14/lun0/part1
> > 
> > gargamel:/etc/mdadm# mdadm -A  -v /dev/md3
> > mdadm: No identity information available for /dev/md3 - cannot assemble.
> > 
> > Any idea why 
> > mdadm -A -v /dev/md3 doesn't work?
> 
> As Derek says, add "--scan" to tell it that it is allowed to look in
> the config file.
> Also, get rid of the "devices=...." part of the ARRAY line or it will
> fail if any of the devices change address.
> 
> > 
> > Am I supposed to actually start the device with
> > mdadm -A  -v /dev/md3 /dev/scsi/host3/bus0/target*/lun0/part1 ?
> 
> That would probably work..
 
Yep, it works.
 
> > or
> > mdadm -A  -v -u 7f69d69c:2d523219:4f3d1ea7:9b7f4057 /dev/md3 ?
> 
> That wouldn't.  Would would need to to mdadm where the devices are:

Actuallly, it does work, that's why I listed it.
gargamel:/etc/mdadm# mdadm -A  -v -u 7f69d69c:2d523219:4f3d1ea7:9b7f4057 /dev/md3
mdadm: looking for devices for /dev/md3
mdadm: /dev/scsi/host3/bus0/target9/lun0/part1 is identified as a member of /dev/md3, slot 1.
mdadm: /dev/scsi/host3/bus0/target8/lun0/part1 is identified as a member of /dev/md3, slot 0.
mdadm: /dev/scsi/host3/bus0/target14/lun0/part1 is identified as a member of /dev/md3, slot 6.
mdadm: /dev/scsi/host3/bus0/target13/lun0/part1 is identified as a member of /dev/md3, slot 5.
mdadm: /dev/scsi/host3/bus0/target12/lun0/part1 is identified as a member of /dev/md3, slot 4.
mdadm: /dev/scsi/host3/bus0/target11/lun0/part1 is identified as a member of /dev/md3, slot 3.
mdadm: /dev/scsi/host3/bus0/target10/lun0/part1 is identified as a member of /dev/md3, slot 2.
mdadm: /dev/scsi/host0/bus0/target4/lun0/part3 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target4/lun0/part2 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target4/lun0/part1 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target3/lun0/part3 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target3/lun0/part2 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target3/lun0/part1 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target10/lun0/part3 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target10/lun0/part2 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target10/lun0/part1 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target1/lun0/part3 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target1/lun0/part2 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target1/lun0/part1 has wrong uuid.
mdadm: no RAID superblock on /dev/scsi/host0/bus0/target0/lun0/part4
mdadm: /dev/scsi/host0/bus0/target0/lun0/part4 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target0/lun0/part3 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target0/lun0/part2 has wrong uuid.
mdadm: /dev/scsi/host0/bus0/target0/lun0/part1 has wrong uuid.
mdadm: added /dev/scsi/host3/bus0/target9/lun0/part1 to /dev/md3 as 1
mdadm: added /dev/scsi/host3/bus0/target10/lun0/part1 to /dev/md3 as 2
mdadm: added /dev/scsi/host3/bus0/target11/lun0/part1 to /dev/md3 as 3
mdadm: added /dev/scsi/host3/bus0/target12/lun0/part1 to /dev/md3 as 4
mdadm: added /dev/scsi/host3/bus0/target13/lun0/part1 to /dev/md3 as 5
mdadm: added /dev/scsi/host3/bus0/target14/lun0/part1 to /dev/md3 as 6
mdadm: added /dev/scsi/host3/bus0/target8/lun0/part1 to /dev/md3 as 0
mdadm: /dev/md3 has been started with 7 drives.

> mdadm -A  -v -u 7f69d69c:2d523219:4f3d1ea7:9b7f4057 /dev/md3 /dev/disk/*/part*
> would work.
 
I think it worked  without because I already had a  DEVICES line that listed
that in the config file.

> > (I thought mdadm would get that data from the config file)
> 
> Only when you tell it to.  If that isn't clear from a second reading
> of the man page, I would appreciate suggestions on how to make it more
> clear.

It is there, although that didn't sync in my brain at my first readings.
I think  it's just  very counter  intuitive that you  have to  provide a
command line option to use the config file.
If I  put something  in the  config file, I  expect it  to be  picked up
without giving any special command line option.
Would you consider making mdadm read anything in mdadm.conf by default?

On Mon, Sep 09, 2002 at 09:11:18PM +1000, Neil Brown wrote:
> On Sunday September 8, marc_news@merlins.org wrote:
> > 
> > That said, the problem occurs both with the kernel autorun and raidstart:
> > when I load the qla1280 module, the drives get detected, md wakes up and
> > tries to create md3 since the partitions have type 0xfd, and fails in the
> > same way:
> > (...)
> > kernel:  /dev/scsi/host3/bus0/target13/lun0: p1
> > kernel: SCSI device sdl: 354600001 512-byte hdwr sectors
> > kernel:  /dev/scsi/host3/bus0/target14/lun0: p1
> > kernel:  [events: 00000002]
> > kernel: md: could not lock sdm1, zero-size? Marking faulty.
> > (...)
> 
> I'm not sure what exactly is going on here, but it isn't regular
> auto-detect. That *only* happens at boot time.  Never after module
> load.
 
Interesting it would be separate code. Thanks for the info.
 
> > Is the kernel autorun code going to be fixed too or will I need to use mdadm
> > for the forseable future?
> 
> I use and recommend mdadm to all non-root devices.  For a raid
> containing the root filesystem I use kernel parameters:
>    md=0,/dev/xxxx,/dev/yyyy

Good to know, thanks.

> though in 2.6, I suspect that initramfs will mean that mdadm is the
> best choice for that too.  Don't do in kernel-space that which can
> effectively and efficiently be done in user-space.

Right :-)

Thanks for the answers.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking 
Home page: http://marc.merlins.org/   |   Finger marc_f@merlins.org for PGP key
