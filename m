From: Marc MERLIN <marc_news@merlins.org>
Subject: Re: SW Raid doesn't play nice with devfs?
Date: Sun, 8 Sep 2002 23:27:37 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020909062737.GA3806@merlins.org>
References: <20020909054800.GV3806@merlins.org> <15740.15774.911597.853392@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <15740.15774.911597.853392@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 09, 2002 at 04:20:14PM +1000, Neil Brown wrote:
> Yep, raidstart is broken by design.  It depends on device number being
> stable, and SCSI device number aren't, especially if they are added
> after boot time.
> 
> That is part of the reason that I wrote mdadm.  It can do the right
> thing for you.
> 
>   http://www.cse.unsw.edu.au/~neilb/source/mdadm/

I will try this, thanks (I can't reboot the system this exact minute)

That said, the problem occurs both with the kernel autorun and raidstart:
when I load the qla1280 module, the drives get detected, md wakes up and
tries to create md3 since the partitions have type 0xfd, and fails in the
same way:
(...)
kernel:  /dev/scsi/host3/bus0/target13/lun0: p1
kernel: SCSI device sdl: 354600001 512-byte hdwr sectors
kernel:  /dev/scsi/host3/bus0/target14/lun0: p1
kernel:  [events: 00000002]
kernel: md: could not lock sdm1, zero-size? Marking faulty.
(...)

Is the kernel autorun code going to be fixed too or will I need to use mdadm
for the forseable future?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking 
Home page: http://marc.merlins.org/   |   Finger marc_f@merlins.org for PGP key
