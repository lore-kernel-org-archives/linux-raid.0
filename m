From: Neil Brown <neilb@suse.de>
Subject: Re: Can't get md array to shut down cleanly
Date: Fri, 7 Jul 2006 17:53:48 +1000
Message-ID: <17582.4876.14646.245791@cse.unsw.edu.au>
References: <bb145bd20607060648p3776d335g55e4bdee4ecaf3c4@mail.gmail.com>
	<17581.35566.273512.814844@cse.unsw.edu.au>
	<bb145bd20607061807m7d3a2395hd75b5b338b86e259@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Christian Pernegger on Friday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 7, pernegger@gmail.com wrote:
> > How are you shutting down the machine?  If something sending SIGKILL
> > to all processes?
> 
> First SIGTERM, then SIGKILL, yes.
> 

That really should cause the array to be clean.  Once the md thread
gets SIGKILL (it ignores SIGTERM) it will mark the array as 'clean'
the moment there are no pending writes.

> > You could try the following patch.  I think it should be safe.
> 
> Hmm, it said chunk failed, so I replaced the line by hand. That didn't
> want to compile because "mode" supposedly wasn't defined ... was that
> supposed to be "mddev->safemode"? Closest thing to a mode I could find
> ...

That patch was against latest -mm.... For earlier kernels you want to
test 'ro'.

   if (!no && atomic_read(&mddev->active)>2) {
          printk("md: %s still ing use.\n" ....


> Anyway, this is much better: (lines with * are new)
> 
> Done unmounting local file systems.
> *md: md0 stopped
> *md: unbind <sdf>
> *md: export_rdev<sdf>
> *[last two lines for each disk.]
> *Stopping RAID arrays ... done (1 array(s) stopped).
> Mounting root filesystem read-only ... done

That isn't good. You've stopped the array before the filesystem is
readonly.  Switching to readonly could cause a write which won't work
as the array doesn't exist any more...

NeilBrown


> Will now halt.
> md: stopping all md devices
> * md: md0 switched to read-only mode
> Synchronizing SCSI cache for disk /dev/sdf:
> [...]
> 
> As you can see the error message is gone now. Much more interesting
> are the lines before the "Will now halt." line. Those were not there
> before -- apparently this first attempt by whatever to shutdown the
> array failed silently.
> 
> Not sure if this actually fixes the resync problem (I sure hope so,
> after the last of these no fs could be found anymore on the device)
> but it's 5 past 3 already, will try tomorrow.
> 
> Thanks,
> 
> C.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
