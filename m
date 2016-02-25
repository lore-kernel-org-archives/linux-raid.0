From: Shaohua Li <shli@kernel.org>
Subject: Re: raid5d hangs when stopping an array during reshape
Date: Thu, 25 Feb 2016 10:42:06 -0800
Message-ID: <20160225184206.GA9755@kernel.org>
References: <5683E00C.1050005@intel.com>
 <CAA9_cmc3Ps2KZ6Ry-RRb96HRJxVHg51Rbnh5ckKpfhzShDnJDg@mail.gmail.com>
 <20160225000300.GA16254@kernel.org>
 <87r3g1ljg7.fsf@notabene.neil.brown.name>
 <20160225011710.GA27642@kernel.org>
 <56CF263D.9020803@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56CF263D.9020803@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: NeilBrown <neilb@suse.com>, Dan Williams <dan.j.williams@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Feb 25, 2016 at 05:05:17PM +0100, Artur Paszkiewicz wrote:
> On 02/25/2016 02:17 AM, Shaohua Li wrote:
> > On Thu, Feb 25, 2016 at 11:31:04AM +1100, Neil Brown wrote:
> >> On Thu, Feb 25 2016, Shaohua Li wrote:
> >>
> >>>
> >>> As for the bug, write requests run in raid5d, mddev_suspend() waits for all IO,
> >>> which waits for the write requests. So this is a clear deadlock. I think we
> >>> should delete the check_reshape() in md_check_recovery(). If we change
> >>> layout/disks/chunk_size, check_reshape() is already called. If we start an
> >>> array, the .run() already handles new layout. There is no point
> >>> md_check_recovery() check_reshape() again.
> >>
> >> Are you sure?
> >> Did you look at the commit which added that code?
> >> commit b4c4c7b8095298ff4ce20b40bf180ada070812d0
> >>
> >> When there is an IO error, reshape (or resync or recovery) will abort
> >> and then possibly be automatically restarted.
> > 
> > thanks pointing out this. 
> >> Without the check here a reshape might be attempted on an array which
> >> has failed.  Not sure if that would be harmful, but it would certainly
> >> be pointless.
> >>
> >> But you are right that this is causing the problem.
> >> Maybe we should keep track of the size of the 'scribble' arrays and only
> >> call resize_chunks if the size needs to change?  Similar to what
> >> resize_stripes does.
> > 
> > yep, this is my first solution, but think check_reshape() is useless here
> > later, apparently miss the restart case. I'll go this way.
> 
> My idea was to replace mddev_suspend()/mddev_resume() in resize_chunks()
> with a rw lock that would prevent collisions with raid_run_ops(), since
> scribble is used only there. But if the parity operations are executed
> asynchronously this would also need to wait until all the submitted
> operations have completed. Seems a bit overkill, but I came up with
> this:

Looks it should work, but it's overkill indead, especially the extra lock, we
can replace it with srcu though. The 'track scribble array size' is much
simpler, so I'd prefer that way. In the future, we probably should move
resize_stripes()/resize_chunks() to .start_reshape().
resize_stripes()/resize_chunks() sounds not qualified as .check_reshape().

Thanks,
Shaohua
