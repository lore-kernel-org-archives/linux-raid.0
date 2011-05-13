From: NeilBrown <neilb@suse.de>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 07:33:47 +1000
Message-ID: <20110514073347.15dae0b8@notabene.brown>
References: <20110513202900.GA1926@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110513202900.GA1926@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 13 May 2011 22:29:01 +0200 Louis-David Mitterrand
<vindex+lists-linux-raid@apartia.org> wrote:

> Hi,
> 
> I've been having very bad performance with an LSISAS2008 controller
> attached to 8 WD Caviar Black 1TB disks.
> 
> So I swapped it out for an Apaptec RAID 6805 with the same disks and now
> my /dev/md2 won't start.
> 
> 	May 13 17:14:37 zenon kernel: md: sdh3 does not have a valid v1.2 superblock, no
> 	t importing!
> 	May 13 17:14:37 zenon kernel: md: md_import_device returned -22
> 	May 13 17:14:37 zenon kernel: md: sda3 does not have a valid v1.2 superblock, no
> 	t importing!
> 	May 13 17:14:37 zenon kernel: md: md_import_device returned -22
> 	May 13 17:14:37 zenon kernel: md: sdf3 does not have a valid v1.2 superblock, no
> 	t importing!
> 
> 	Etc...
> 
> Both controllers are used without any configuration. I just use the
> separate disks for soft raid.
> 
> Each disk is configured thus:
> 
> 	Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
> 	255 heads, 63 sectors/track, 121601 cylinders
> 	Units = cylinders of 16065 * 512 = 8225280 bytes
> 	Sector size (logical/physical): 512 bytes / 512 bytes
> 	I/O size (minimum/optimal): 512 bytes / 512 bytes
> 	Disk identifier: 0x05022e04
> 
> 	   Device Boot      Start         End      Blocks   Id  System
> 	/dev/sda1               1          32      257008+  fd  Linux raid autodetect
> 	/dev/sda2              33       17500   140311710   fd  Linux raid autodetect
> 	/dev/sda3           17501      121601   836191282+  fd  Linux raid autodetect
> 

Is this the config reported with the old controller or with the new
controller?

Because my guess is that the new controller makes the devices look a little
bit smaller.  That would cause the kernel to reject them, but quite possibly
allow mdadm to think they look OK.

It would also explain why the first 2 partitions work fine and only the last
one is a problem.

If this were the case I would expect a message like:
         "%s: p%d size %llu extends beyond EOD

to appear during boot-up.


NeilBrown



> And my raid config used to be:
> 
> 	Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] [faulty] 
> 	md2 : active raid6 sdc3[0] sdd3[7] sdf3[6] sdb3[5] sdh3[4] sda3[3] sdg3[2] sde3[1]
> 		  5017138176 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]
> 		  bitmap: 0/7 pages [0KB], 65536KB chunk
> 
> 	md1 : active raid6 sdc2[0] sdd2[7] sdf2[8] sdb2[5] sdg2[4] sdh2[3] sda2[2] sde2[1]
> 		  841863168 blocks super 1.2 level 6, 512k chunk, algorithm 2 [8/8] [UUUUUUUU]
> 		  bitmap: 2/2 pages [8KB], 65536KB chunk
> 
> 	md0 : active raid1 sdc1[0] sdd1[7] sdf1[6] sdh1[5] sde1[4] sdb1[3] sda1[2] sdg1[1]
> 		  256896 blocks [8/8] [UUUUUUUU]
> 		  bitmap: 0/1 pages [0KB], 65536KB chunk
> 
> 	unused devices: <none>
> 
> 
> Going back to the LSISAS2008 controller makes /dev/md2 come back.
> 
> Any idea why the Adaptec wont let me use /dev/md2? Going into its
> bios configuration menu I see a JBOD mode but it seems each disk has to
> be "initialized" in order to be used in that mode.
> 
> Meanwhile the disks are used in "legacy" mode:
> 
> 	May 13 17:09:57 zenon kernel: scsi 0:0:0:0: Direct-Access     Adaptec  6805 Legacy      V1.0 PQ: 0 ANSI: 2
> 
> 
> Thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

