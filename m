From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID1 always resyncs at boot???
Date: Fri, 28 Nov 2003 15:40:03 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16326.53667.624406.368072@notabene.cse.unsw.edu.au>
References: <hp0nmt.3pm23q@mail.drtebi.com>
	<16326.34106.78894.57151@notabene.cse.unsw.edu.au>
	<hp1alh.rftuxt@mail.drtebi.com>
	<16326.36888.900928.183987@notabene.cse.unsw.edu.au>
	<hp1on7.90c5en@mail.drtebi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from drtebi@drtebi.com on Thursday November 27
To: drtebi@drtebi.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday November 27, drtebi@drtebi.com wrote:
> 
> in my log:
> Nov 28 04:41:44 [kernel] hda: dma_intr: status=0x51 { DriveReady SeekComplete
> Error }
> Nov 28 04:41:44 [kernel] md: (skipping faulty
> ide/host0/bus0/target0/lun0/part1 )
> Nov 28 04:41:45 [kernel] hda: dma_intr: status=0x51 { DriveReady SeekComplete
> Error }
>                 - Last output repeated 8 times -
> Nov 28 04:41:56 [kernel] md: md_do_sync() got signal ... exiting
> Nov 28 04:41:56 [kernel] raid1: mirror resync was not fully finished,
> restarting next time.
> 
> Does this mean one of the drives is bad?

Well, it means one of your drives return an error, so it was kicked
out of the array.
Whether it is the drive that is bad, or the controller, or the
power-supply, I cannot know.
You could try removing it from the array and putting it back, and let
it rebuild, and see if the problem happens again.

> 
> -------------
> bully@drtebi: mdadm --query /dev/md0
> /dev/md0: 114.49GiB raid1 2 devices, 0 spares. Use mdadm --detail for more
> detail.
> /dev/md0: No md super block found, not an md component.
> 
> The last message is weird... no md super block?

That is proper.  /dev/md0 is not a component of another md, so it
doesn't have a superblock on it (the individual drives have
superblocks, not the array).

> 
> Thanks,
> DrTebi
> 
> P.S.: I don't really like IDE drives :(
> 
Me neither.

NeilBrown
