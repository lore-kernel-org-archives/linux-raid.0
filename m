From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: recover short-time-power-failure of raid 5?
Date: Mon, 25 Nov 2002 20:59:47 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15841.62611.118178.276815@notabene.cse.unsw.edu.au>
References: <15841.25746.94261.22043@notabene.cse.unsw.edu.au>
	<E18GFks-0001XZ-00@config8.kundenserver.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from krause@mogli-soft.de on Monday November 25
To: krause@mogli-soft.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 25, krause@mogli-soft.de wrote:
> 
> hello neilbrown, 
> 
> thanks a lot for your fast response!
> i tried the command as you suggested but i am not sure if it really
> worked, it seems that /dev/sdc2 is not yet used (but of course i may be
> wrong! ;-) )
.....
> 
> what about disk /dev/sdc2 ? i have tried to access /dev/sdc1 (a small
> ext2 partition) and the data there was correct, so it seems that the
> disk is accessable and did not got damaged by the shot power failure.
> 
> how can i get the third disk back into the raid system? or do i have to
> backup all reconstructed data from the two disks and reinit the raid
> from the start?

mdadm -A --force
will only 'force' into the array enough drives to make it work.  For
your 3 drive raid5 array, it ony needs to force in 2 drives, so it
takes the two most recent drives and uses them.  They will have all
the data on them, but no redundancy.

I suggest that after assembling the array, you 'fsck' the filesystem
on md0 just to make sure that the data is fine and then simply hot-add
the third device:
  mdadm /dev/md0 -a /dev/sdc

If fsck reports lots of error..... maybe try force the assmbly from a
different pair of drives. e.g.
   mdadm -A --force /dev/sda1 /dev/sdc2

and then do the fsck.

NeilBrown
