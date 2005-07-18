From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Recovery raid5 after sata cable failure.
Date: Mon, 18 Jul 2005 19:40:57 +1000
Message-ID: <17115.31017.434682.374811@cse.unsw.edu.au>
References: <17114.55130.211770.531178@cse.unsw.edu.au>
	<42db6a24.41ee84a1.3e8b.ffffa62b@mx.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Francisco Zafra on Monday July 18
Sender: linux-raid-owner@vger.kernel.org
To: Francisco Zafra <fzafra@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday July 18, fzafra@gmail.com wrote:
> I already tried that:
> 
> root@Torero-2:~ # cat /proc/mdstat
> Personalities : [linear] [raid5] 
> md0 : active raid5 sdg1[6] sdf1[5] sde1[4] sdd1[3] sdc1[2] sdb1[1] sda1[0]
>       1367507456 blocks level 5, 512k chunk, algorithm 2 [8/7] [UUUUUUU_]
>       
> unused devices: <none>
> root@Torero-2:~ # mdadm /dev/md0 -r /dev/sdh1
> mdadm: hot remove failed for /dev/sdh1: No such device or address
> root@Torero-2:~ # mdadm /dev/md0 -a /dev/sdh1
> mdadm: Cannot open /dev/sdh1: Device or resource busy


Uhm, you might have a buggy version of mdadm.  If you have 1.10.0, get
an upgrade.

Otherwise either sdh1 or sdh must be:
  open by some process with O_EXCL
  open via a /dev/raw/* device
  part of an md device (which it obviously isn't)
  part of a dm device
  mounted as a filesystem
  an external-journal device for a jfs or ext3 or xfs filesystem
  in use as a swap device
  open for writing under a security level of 1 (whatever that means..)
  an mtd device that is open

(those are all the places that I can find that take an exclusive lock
 on a block device).

NeilBrown
