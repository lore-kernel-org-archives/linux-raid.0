From: Pol Hallen <raid2@fuckaround.org>
Subject: Re: check which disk is a problem
Date: Thu, 19 May 2011 16:17:30 +0200
Message-ID: <201105191617.30938.raid2@fuckaround.org>
References: <201105191234.39391.raid1@fuckaround.org> <4DD50356.50403@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD50356.50403@anonymous.org.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> You should look through your logs to see if you can see what happened to
> it. You should also check its SMART status with e.g.
>    smartctl -a /dev/sde

ok thanks :-)

My fear is also this:

May 19 11:02:47 lorna kernel: [220141.636031] ata9: SATA link up 1.5 Gbps 
(SStatus 113 SControl 310)
May 19 11:02:47 lorna kernel: [220141.708820] ata9.00: configured for UDMA/33
May 19 11:02:47 lorna kernel: [220141.710840] ata9: EH complete
May 19 11:03:13 lorna kernel: [220167.526518] ata9: exception Emask 0x10 SAct 
0x0 SErr 0x10000 action 0xe frozen
May 19 11:03:13 lorna kernel: [220167.528619] ata9: irq_stat 0x00400000, PHY 
RDY changed
May 19 11:03:13 lorna kernel: [220167.530664] ata9: SError: { PHYRdyChg }
May 19 11:03:13 lorna kernel: [220167.532735] ata9: hard resetting link
May 19 11:03:14 lorna kernel: [220168.263086] EXT4-fs error (device md0): 
ext4_ext_search_right: bad header/extent i
n inode #260441748: invalid extent entries - magic f30a, entries 125, max 340
(340), depth 0(0)
May 19 11:03:14 lorna kernel: [220168.464708] EXT4-fs (md0): delayed block 
allocation failed for inode 260441748 at
logical offset 130984 with max blocks 1 with error -5
May 19 11:03:14 lorna kernel: [220168.467005] This should not happen!!  Data 
will be lost

this shouldn't happen or no? On raid6 I've only a disk with problem.. or is it 
a ext4 problem?

I use default debian kernel 2.6.32-5-686-bigmem with debian stable.

Thanks!
 
Pol
