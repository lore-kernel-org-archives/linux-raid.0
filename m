From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Getting the spare disks back to being spare disks
Date: Sun, 24 Nov 2002 14:45:35 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15840.19295.608122.664212@notabene.cse.unsw.edu.au>
References: <3DE00F05.7050803@uclink4.berkeley.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeremy Huddleston on Saturday November 23
To: Jeremy Huddleston <jeremyhu@uclink4.berkeley.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 23, jeremyhu@uclink4.berkeley.edu wrote:
> I have moved to a RAID 5 setup in my linux box with 4 drives set to 
> master on 4 IDE channels, and one spare drive as the slave on one of 
> those channels.  In setting things up, I marked one of the 'master' 
> drives as 'failed-disk' in my raidtab so that I could copy the data from 
> that disk onto the raid then raidhotadd it in once the data had been 
> copied over and my system was running entirely on the raid.
> 
> So, when I mkraid'd the array, the spare disk was used in liu of the 
> failed disk as I would suspect.  I copied over all my data to the raid, 
> rebooted, partitioned the formerly 'failed-disk' properly, changed 
> 'failed-disk' to 'raid-disk' in /etc/raidtab, and 'raidhotadd'd it back 
> into the array.  I expected the array to reconstruct on this disk and 
> put the spare-disk back as a spare, but that's not the case.  Now, the 
> newly added disk seems to be the spare, and the 'slave' disk is still in 
> the array (which makes for bad performance).  How can I tell the array 
> to replace the slave disk with the disk that I just added?  I figure I 
> could just unplug the slave and let it reconstruct, but that doesn't sit 
> well with me.

You have to tell md that the device that you want to be spare has
failed.  Either by pulling it out (hopefully while the computer is
off) which I agree is not very nice, or with
   raidsetfaulty /dev/md0 /dev/hdXX
or
   mdadm /dev/md0 --fail /dev/hdXX

Then it will rebuild onto the spare.  Then you can remove and re-add
the device that you want to be a spare:

   raidhotremove /dev/md0 /dev/hdXX
   raidhotadd /dev/md0 /dev/hdXX
or
   mdadm /dev/md0 --remove /dev/hdXX --add /dev/hdXX

NeilBrown
