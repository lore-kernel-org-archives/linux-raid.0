From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm degraded RAID5 failure
Date: Thu, 6 Nov 2008 16:41:55 +1100
Message-ID: <18706.33699.188905.82732@notabene.brown>
References: <6cc8e9ed0810221350o2b8b3aedm3d1c229fe7e66163@mail.gmail.com>
	<6cc8e9ed0810221352y7427cb7dmfc7c3fcefd495bb9@mail.gmail.com>
	<18690.48372.369694.309381@notabene.brown>
	<6cc8e9ed0810291516p46cb24a7pdd230e222797d06e@mail.gmail.com>
	<6cc8e9ed0811041335u1aeac632xafdae1892c418d95@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Steve Evans on Tuesday November 4
Sender: linux-raid-owner@vger.kernel.org
To: Steve Evans <jeeping@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 4, jeeping@gmail.com wrote:
> Hi Neil and others,
> 
> Just a couple of questions, I know you're busy -
> 
> Do you recommend that I attempt to upgrade mdadm to a more recent
> version before any other recovery attempts? If so, which version?

Yes.  2.6.7.1 (the latest).

> 
> I noted my replacement drive (sdc1) got a smart error (during the
> rebuild?), would you recommend replacing it or removing it altogether
> until I get the other 2 drives back online (if I even can)?

There seem to be different opinion on how much weight to put on SMART
errors.   So I make no recommendations based on them.

> 
> Is there a way to correct the drive names -

When you assemble the array again, it will update the device names to
what they are at the time.

As you have 2 devices that think they are 'spare', you won't be able
to assemble a working array using "--assemble".

What you will need to do is recreate the array over just two devices
and make sure you get them in the right order.

The one that claims to be device '2' (sdb1 below) certainly is device
2 (i.e. the last device: they are numbered 0,1,2).  The others I can
not be so sure of.

So I would recreate the array with e.g.

  mdadm -C /dev/md0 -l5 -n2 /dev/sdc1 missing /dev/sdb1

And check it with e.g.
  fsck -n -f /dev/md0

If fsck is happy: good.  If not, try again with a different
arrangement:

   mdadm -C /dev/md0 -l5 -n2 missing /dev/sdc1 /dev/sdb1

etc.  I don't know which of c1 and d1 is more likely to have good
data.   Keep going until you get a good 'fsck'.

Make very sure to use the "-n" option to fsck to ensure it doesn't try
to 'fix' the mess it finds.

Also, before doing the above, run "mdadm --examine /dev/sdb1" and keep
a record of that.  Check the 'chunksize'.  If it isn't 64, you will
need to explicitly give then number to "mdadm -C".  Also check the
layout and possibly set that explicitly when doing "mdadm -C".

good luck.

NeilBrown


> 
> > /dev/sdb1:
> > this     2       8       49        2      active sync   /dev/sdd1
> 
> 
> > /dev/sdc1:
> > this     3       8       33        3      spare   /dev/sdc1
> 
> 
> > /dev/sdd1:
> > this     3       8       33        3      spare   /dev/sdc1
> 
> I'm inclined to believe (but am not sure at all) that -
> 
> sdb1 should be sdd1
> sdc1 is correct
> sdd1 should be sdb1
> 
> Thanks!
> Steve..
> 
