From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: I just trashed my RAID5 array - recovery possible?
Date: Thu, 20 Mar 2003 20:55:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15993.36889.254497.789214@notabene.cse.unsw.edu.au>
References: <20030320000358.ALLYOURBASEAREBELONGTOUS.A6336@bla.fasel.org>
	<15993.2378.97234.342504@notabene.cse.unsw.edu.au>
	<20030320075133.ALLYOURBASEAREBELONGTOUS.B4264@bla.fasel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wolfram Schlich on Thursday March 20
To: Wolfram Schlich <lists@schlich.org>
Cc: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday March 20, lists@schlich.org wrote:
> 
> And when I try to mount the array:
> --8<--
> EXT3-fs error (device md(9,1)): ext3_check_descriptors: Block bitmap for group 509 not in group (block 4294967295)!
> EXT3-fs: group descriptors corrupted !
> --8<--
> 
> What should I do now? Raidhotadd the 4th device? Run e2fsck prior to
> that or afterwards?

I would 
   fsck -n /dev/md1
to non-distructively see how much damage there is.

If that shows an uncomfortable large amount of damage, you could
assembling the array from a different triple of devices.
It is currently assemble from
   /dev/hd[gki]1

If you want to try g, k and e for example, use
  mdadm -Af /dev/md1 /dev/hd[gke]1

and then try "fsck -n" on that.

I wouldn't hot-add the fourth drive until you have decided you will
live with whatever you have.

NeilBrown
