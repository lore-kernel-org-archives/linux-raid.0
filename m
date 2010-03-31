From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 018 of 29] md: Support changing rdev size on running
 arrays.
Date: Wed, 31 Mar 2010 16:41:14 +1100
Message-ID: <20100331164114.307a57aa@notabene.brown>
References: <20080627164503.9671.patches@notabene>
	<200806271809.29768.Markus@hochholdinger.net>
	<18533.31375.280387.666514@notabene.brown>
	<201003301652.16622.Markus@hochholdinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201003301652.16622.Markus@hochholdinger.net>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Hochholdinger <Markus@hochholdinger.net>
Cc: linux-raid@vger.kernel.org, Chris Webb <chris@arachsys.com>
List-Id: linux-raid.ids

On Tue, 30 Mar 2010 16:52:13 +0200
Markus Hochholdinger <Markus@hochholdinger.net> wrote:

> Hello,
> 
> Am 28.06.2008 um 01:41 Uhr schrieb Neil Brown <neilb@suse.de>:
> > On Friday June 27, Markus@hochholdinger.net wrote:
> > > Am Freitag, 27. Juni 2008 08:51 schrieb NeilBrown:
> > > > From: Chris Webb <chris@arachsys.com>
> > > > Allow /sys/block/mdX/md/rdY/size to change on running arrays, moving
> > > > the superblock if necessary for this metadata version. We prevent the
> > > > available space from shrinking to less than the used size, and allow it
> > > > to be set to zero to fill all the available space on the underlying
> > > > device.
> > > I'm very happy of this new feature. But I'm a little confused how to use
> > > it correctly.
> > > Can md now recognize the change by itself and I only have to run mdadm
> > > --grow? Or have I manually update /sys/block/mdX/md/rdY/size and
> > > afterwards run mdadm --grow?
> > No, md does not recognise the change by itself.
> > Currently you need to update ..../size yourself before using
> >    "mdadm --grow"
> > This should probably be incorporated into mdadm at some stage, but it
> > hasn't yet.
> 
> it's some time ago but today i'm able to test this (because now i have a xen 
> kernel which recognizes size changes).
> I tested with metadata version 0.9, 1.0 and 1.1 but didn't get it to work. I 
> create a raid1:
> mdadm --create /dev/md1 --level=1 --raid-disks=2 --metadata=1.0 /dev/xvda1 /dev/xvdb1
> 
> Then I change the size of xvda1 and get the following kernel message:
> [ 3281.905317] Setting capacity to 4194304
> [ 3281.905317] xvda1: detected capacity change from 1073741824 to 2147483648
> 
> After this i do:
> echo "0" > /sys/block/md1/md/rd0/size
> No kernel message so far and
>   cat /sys/block/md1/md/rd0/size
> still shows 1048570.

That is very odd.  The number printed out in the "detected capacity change"
line is exactly the name that should be used when you write to "md/rd0/size".

You could try
   strace echo 0 > /sys/block/md1/md/rd0/size

to be sure there is no error return.
And maybe
   blockdev --getsz /dev/xvda1
and
   blockdev --getsz /dev/xvda

to double check that the block size looks right.

Are you sure the message didn't say "xvda: detected capacity change...", and
you still need to change the size of the partition?

NeilBrown


> 
> Then the same for xvdb1.
> 
> And then I tried to grow md1 in the hope it will somehow detect the new size 
> correct, but i only get a very little grow:
> [ 3345.133882] md1: detected capacity change from 1073729536 to 1073735680
> [ 3345.140087] md: resync of RAID array md1
> [ 3345.140098] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [ 3345.140105] md: using maximum available idle IO bandwidth (but not more 
> than 200000 KB/sec) for resync.
> [ 3345.140121] md: using 128k window, over a total of 1048570 blocks.
> [ 3345.140129] md: resuming resync of md1 from checkpoint.
> [ 3345.140412] md: md1: resync done.
> [ 3345.160064] RAID1 conf printout:
> [ 3345.160071]  --- wd:2 rd:2
> [ 3345.160076]  disk 0, wo:0, o:1, dev:xvda1
> [ 3345.160081]  disk 1, wo:0, o:1, dev:xvdb1
> 
> Especially "md1: detected capacity change from 1073729536 to 1073735680" makes 
> me wonder.
> 
> 
> I also tried to set values to /sys/block/md1/md/rd1/size, but all i got was
>   echo: write error: Invalid argument
> 
> And the output of /sys/block/md1/md/rd1/size never changes.

That is very odd.
> 
> 
> > > To be on the safe side I'd first lvresize one disk of the raid1, then do
> > > mdadm --grow to let md update/move the superblock of this disk. And after
> > > this is successful, lvresize the other disk and do mdadm --grow. So in
> > > case of a failure i wouldn't loose the whole raid1!?
> > > Am I correct or am I missing something?
> > You don't want to "mdadm --grow" until everything has been resized.
> > First lvresize one disk, then write '0' to the .../size file.
> > Then do the same for the other disk.
> > Then "mdadm --grow /dev/mdX --size max".
> 
> I tried mdadm version 3.0.3 and 3.1.1. Is it possible that something has 
> changed inside mdadm?
> I used kernel 2.6.32-4-xen-amd64 (debian squeeze).
> 
> Are am I doing something wrong? Has something changed so i'm on the wrong way? 
> Is there another way to do online grow of an raid1 without full resync? 
> Anyone any ideas?
> 
> Many thanks in advance.
> 
> 

