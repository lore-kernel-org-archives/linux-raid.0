From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 reshape
Date: Fri, 16 Jun 2006 16:41:03 +1000
Message-ID: <17554.21119.487820.638171@cse.unsw.edu.au>
References: <449250ED.7090302@irule.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tim on Thursday June 15
Sender: linux-raid-owner@vger.kernel.org
To: Tim <irule@irule.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 15, irule@irule.net wrote:
> Hello all,
> 
> I'm sorry if this is a silly question, but I've been digging around for
> a few days now and have not found a clear answer, so I'm tossing it out
> to those who know it best.
> 
> I see that as of a few rc's ago, 2.6.17 has had the capability of adding
> additional drives to an active raid 5 array (w/ the proper ver of mdadm,
> of course). I cannot, however, for the life of me find out exactly how
> one goes about doing it! I would love if someone could give a
> step-by-step on what needs to be changed in, say, mdadm.conf (if
> anything), and what args you need to throw at mdadm to start the reshape
> process.
> 
> As a point of reference, here's my current mdadm.conf:
> 
> 
> DEVICE /dev/sda1
> DEVICE /dev/sdb1
> DEVICE /dev/sdc1
> ARRAY /dev/md0 devices=/dev/sda1,/dev/sdb1,/dev/sdc1 level=5 num-devices=3
> 

May I suggest:

   DEVICE /dev/sd?1
   ARRAY /dev/md0 UUID=whatever

it would be a lot safer.

> 
> I will be adding the devices /dev/sde1 and /dev/sdf1 (when I can find
> out how :)

 mdadm /dev/md0 --add /dev/sde1 /dev/sdf1
 mdadm --grow /dev/md0 --raid-disks=5

NeilBrown
