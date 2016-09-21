From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with
 xfs filesystem by accident
Date: Wed, 21 Sep 2016 19:15:11 +0200
Message-ID: <20160921171511.GA6381@metamorpher.de>
References: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
 <CAJCQCtR4NoCebcDLD-ovT+hZY=NKRtj1cP693wHQTbmiERDAXw@mail.gmail.com>
 <CAKA=zHpgVoNA5Y6MBmB4fnG85F-z=hj4FXEiUOggsWUn3tfWXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKA=zHpgVoNA5Y6MBmB4fnG85F-z=hj4FXEiUOggsWUn3tfWXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Becks <beckssimon5@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 21, 2016 at 06:56:43PM +0200, Simon Becks wrote:
>     Data Offset : 2048 sectors

Your RAID disks have a 1 MiB data offset there. 
If nothing was ever written on the XFS filesystem, 
it might still be intact.

If you have an overlay for these disks you can try your luck 
with mdadm --create /dev/md42 --metadata=1.2 --data-offset=1M --chunk=512 --level=5 ...
--assume-clean /dev/overlay/disk{1,2,3}

Check --examine if it says the same things for device size. 
You already verified partitions should be the same but still...

Then see if there is data on it or no (even if there is no filesystem, 
try a carver like photorec, if it gets an intact file larger than 3*512K 
the raid settings might be correct).

photorec won't work if the data was encrypted.

If there is no data, try a different disk order if you're not sure you got it right.

Good luck
Andreas Klauer
