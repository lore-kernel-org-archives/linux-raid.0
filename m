From: NeilBrown <neilb@suse.de>
Subject: Re: Raid 5 to 6 grow stalled
Date: Mon, 11 Apr 2011 07:52:16 +1000
Message-ID: <20110411075216.1da3a3a0@notabene.brown>
References: <1302366232.12096.1439264077@webmail.messagingengine.com>
	<20110410073039.2d9683ac@notabene.brown>
	<1302447763.8724.1439486933@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1302447763.8724.1439486933@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Siefker <hatta00@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 10 Apr 2011 08:02:43 -0700 "Edward Siefker" <hatta00@fastmail.fm>
wrote:

> 
> > 
> > Doesn't look good..
> > What version of mdadm?  What kernel?
> > 
> > NeilBrown
> > 
> 
> 
> 
> root@iblis:~# mdadm --version
> mdadm - v3.1.4 - 31st August 2010
> root@iblis:~# uname -a
> Linux iblis 2.6.38-2-amd64 #1 SMP Tue Mar 29 16:45:36 UTC 2011 x86_64
> GNU/Linux
> 
> Did you see the other post I made?  The array still
> reports as clean, but I haven't tried to mount it yet. 
> This array started out as a RAID1, which I changed to
> RAID5, added a disk, reshaped, and added a spare to. 
> This worked great and I used it for a couple weeks 
> before deciding to go to RAID6. 
> 
> 
> Looking at the output of 'mdadm -E' and 'mdadm -D'
> (again in the other post), it looks like there's 
> some inconsistency in the raid device for /dev/sde1.
> -E reports it as number 4 and raid device 4. But,
> -D says /dev/sde1 is number 4 and raid device 3.
> Don't know if that means anything, but it's the 
> only thing I see that looks unusual. 
> 
> Since the array is clean, is it safe to mount it?
> It's actually a luks volume, fwiw.  Thanks


That inconsistency is expected.  The v0.90 metadata isn't able to represent
some state information that the running kernel can represent.  So when the
metadata is written out it looks a bit different just as you noticed.

Your data is safe and it is easy to make it all happy again.
There are a couple of options...

The state of your array is that it has been converted to RAID6 in a special
layout where the Q blocks (the second parity block) are all on the last drive
instead of spread among all the drives.

mdadm then tried to start the process of converting this to a more normal
layout but because the array was "auto-read-only" (which means you hadn't
even tried to mount it or anything) it got confused and aborted.
This left some sysfs settings in an unusual state.
In particular:
   sync_max is 16385  (sectors) so when the rebuilt started it paused at 8192K
   suspend_hi is 65536 so any IO lower than this address will block.

The simplest thing to is:

   echo max > /sys/block/md0/md/sync_max
   echo 0 > /sys/block/md0/md/suspend_hi

this will allow the recovery of sde1 to complete and you will have full access
to your data.
This will result in the array being in the unusual layout with non-rotated Q.
This can then be fixed with
    mdadm --grow /dev/md0 --layout=normalise --backup=/whatever


If you don't want to wait for both the recovery and the subsequent
reshape you could do them both at once:
   - issue the above two 'echo' commands.
   - fail and remove sde1
      mdadm /dev/md0 -f /dev/sde1
      mdadm /dev/md0 -r /dev/sde1
   - then freeze recovery in the array, add the device back in, and start the
     grow, so:

      echo frozen > /sys/block/md0/md/sync_action
      mdadm /dev/md0 --add /dev/sde1
      mdadm --grow /dev/md0 --layout=normalise --backup=/whereever

You don't need to use the same backup file as before - and make sure you
give the name of a file which doesn't exist, or mdadm will complain,
unfreeze the array and it will start recovery - which isn't a big problem,
just not part of the plan.


And you did exactly the right thing to ask instead of fiddling with the
array!!  It was in quite an unusual state and while I is unlikely you would
have corrupted any date - waiting for a definitive answer is safest!

The next version of mdadm will check for arrays that are 'auto-readonly' and
not get confused by them.

Thanks,
NeilBrown

 
