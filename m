From: jlewis@lewis.org
Subject: Re: Adding a mirror to a RAID1 Device
Date: Tue, 25 Nov 2003 16:03:20 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311251557120.1140-100000@redhat1.mmaero.com>
References: <16323.732.390200.935640@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16323.732.390200.935640@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 Nov 2003, Neil Brown wrote:

> What you should have done is make a raid1 with 2 drives, one of which
> was missing/failed.  With mdadm, the command would be:
> 
>   mdadm -C /dev/md0 --level=raid1 --disks=2 /dev/hda3 missing
> 
> then you can hot-add the extra drive when it arrives.
> 
> What you have to do now is recreate the raid1 with two drives.  You
> will have to have the filesystem unmounted and the raid stopped, but
> you will not lose any data.

I have a somewhat related question.  Suppose I have a system with RAID1 
(several md devices) using identical partitions on hda and hdc.  When a 
card that works arrives, I want to move these two disks to the faster ATA 
interfaces, which will likely make then hde and hdg.  

To do this, can I fail hdc, move it to hde, edit the raidtab on hde to say
that the md devices are hde and hdg, start up that "new" RAID1 degraded,
then pull hda, and hot add it to the new md devices and resync?

Is there a better way to get these 2 disks moved from the ATA33 
motherboard interfaces to an ATA100 controller card?  Perhaps just boot in 
rescue mode from a CD (system told me a bootfloppy could not be made due 
to kernel/modules sizes) edit raidtab and then just reboot?
 
----------------------------------------------------------------------
 Jon Lewis *jlewis@lewis.org*|  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |  
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________

