From: Neil Brown <neilb@suse.de>
Subject: Re: How to recover from massive disk failure
Date: Fri, 10 Nov 2006 12:54:20 +1100
Message-ID: <17747.56268.653916.611540@cse.unsw.edu.au>
References: <200611100150.39878.jacob@mungo.dk>
	<17747.52672.339031.967070@cse.unsw.edu.au>
	<200611100206.22366.jacob@mungo.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jacob Schmidt Madsen on Friday November 10
Sender: linux-raid-owner@vger.kernel.org
To: Jacob Schmidt Madsen <jacob@mungo.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday November 10, jacob@mungo.dk wrote:
> Thank you very much for the quick answer!
> 
> One last one...
> 
> This is how my entry in mdadm.conf look:
> DEVICE /dev/sd[bcdefg]1
> ARRAY /dev/md5 level=raid5 num-devices=6 
> UUID=a4a5dae9:04a09c3a:cd3fd7be:b754f4fe 
> devices=/dev/sdb1,/dev/sdc1,/dev/sdd1,/dev/sde1,/dev/sdf1,/dev/sdg1
> 
> Do the order of the devices matter?

No, but it is best not to have them.
i.e. get rid of the "devices=" bit and change the DEVICE line to
   DEVICE /dev/sd?1
SCSI device names can change if the hardware config changes, and you
want mdadm to find the devices no matter where they are.

NeilBrown
