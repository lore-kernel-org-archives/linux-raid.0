From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Adding a mirror to a RAID1 Device
Date: Wed, 26 Nov 2003 09:01:45 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16323.53577.411117.6469@notabene.cse.unsw.edu.au>
References: <16323.732.390200.935640@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.44.0311251557120.1140-100000@redhat1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from jlewis@lewis.org on Tuesday November 25
To: jlewis@lewis.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 25, jlewis@lewis.org wrote:
> On Tue, 25 Nov 2003, Neil Brown wrote:
> 
> > What you should have done is make a raid1 with 2 drives, one of which
> > was missing/failed.  With mdadm, the command would be:
> > 
> >   mdadm -C /dev/md0 --level=raid1 --disks=2 /dev/hda3 missing
> > 
> > then you can hot-add the extra drive when it arrives.
> > 
> > What you have to do now is recreate the raid1 with two drives.  You
> > will have to have the filesystem unmounted and the raid stopped, but
> > you will not lose any data.
> 
> I have a somewhat related question.  Suppose I have a system with RAID1 
> (several md devices) using identical partitions on hda and hdc.  When a 
> card that works arrives, I want to move these two disks to the faster ATA 
> interfaces, which will likely make then hde and hdg.  
> 
> To do this, can I fail hdc, move it to hde, edit the raidtab on hde to say
> that the md devices are hde and hdg, start up that "new" RAID1 degraded,
> then pull hda, and hot add it to the new md devices and resync?
> 
> Is there a better way to get these 2 disks moved from the ATA33 
> motherboard interfaces to an ATA100 controller card?  Perhaps just boot in 
> rescue mode from a CD (system told me a bootfloppy could not be made due 
> to kernel/modules sizes) edit raidtab and then just reboot?

Just 
   power down the machine
   move the drives
   power up again

all is done.... unless you are using raidstart, but that is
universally a mistake.

If you are using "Linux RAID" partition types, the kernel will find
the partitions in their new location and assemble them for you just as
it is now.
If you are using mdadm to assemble you arrays (which I suspect you
aren't as you talk about 'raidtab') then it will find them just as
easily in the new location, providing you have include the new devices
in the "DEVICES" line of mdadm.conf.

If you are using raidstart to start your arrays, then stop doing that
straight away and us a reliable method.

You do not need to edit raidtab to reflect any changes you make.
raidtab is primarily use for *creating* raid arrays, not for managaing
them.

NeilBrown

