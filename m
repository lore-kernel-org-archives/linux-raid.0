From: "Marc Marais" <marcm@liquid-nexus.net>
Subject: Fw: Re: mdadm --grow failed
Date: Sun, 18 Feb 2007 19:57:28 +0800
Message-ID: <20070218115626.M47438@liquid-nexus.net>
References: <20070217030514.M74974@liquid-nexus.net> <17878.49009.771973.884472@notabene.brown> <20070218091504.M97223@liquid-nexus.net> <17880.7869.963793.706096@notabene.brown> <20070218105242.M29958@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070218105242.M29958@liquid-nexus.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 18 Feb 2007 20:39:09 +1100, Neil Brown wrote
> On Sunday February 18, marcm@liquid-nexus.net wrote:
> > Ok, I understand the risks which is why I did a full backup before doing 
> > this. I have subsequently recreated the array and restored my data from 
> > backup.
> 
> Could you still please tell me exactly what kernel/mdadm version you
> were using?
> 
> Thanks,
> NeilBrown

2.6.20 with the patch you supplied in response to the "md6_raid5 crash 
email" I posted in linux-raid a few days ago. Just as background, I replaced 
the failing drive and at the same time bought an additional drive in order 
to increase the array size.

mdadm -V = v2.6 - 21 December 2006. Compiled under Debian (stable).

Also, I've just noticed another drive failure with the new array with a 
similar error to what happened during the grow operation (although on a 
different drive) - I wonder if I should post this to linux-ide?

Feb 18 00:58:10 xerces kernel: ata4: command timeout
Feb 18 00:58:10 xerces kernel: ata4: no sense translation for status: 0x40
Feb 18 00:58:10 xerces kernel: ata4: translated ATA stat/err 0x40/00 to SCSI 
SK/ASC/ASCQ 0xb/00/00
Feb 18 00:58:10 xerces kernel: ata4: status=0x40 { DriveReady }
Feb 18 00:58:10 xerces kernel: sd 4:0:0:0: SCSI error: return code = 
0x08000002
Feb 18 00:58:10 xerces kernel: sdd: Current [descriptor]: sense key: Aborted 
Command
Feb 18 00:58:10 xerces kernel:     Additional sense: No additional sense 
information
Feb 18 00:58:10 xerces kernel: Descriptor sense data with sense descriptors 
(in hex):
Feb 18 00:58:10 xerces kernel:         72 0b 00 00 00 00 00 0c 00 0a 80 00 
00 00 00 00
Feb 18 00:58:10 xerces kernel:         00 00 00 00
Feb 18 00:58:10 xerces kernel: end_request: I/O error, dev sdd, sector 
35666775
Feb 18 00:58:10 xerces kernel: raid5: Disk failure on sdd1, disabling 
device. Operation continuing on 3 devices

Regards,
Marc

