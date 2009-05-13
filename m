From: Neil Brown <neilb@suse.de>
Subject: Re: Change Chunk Size on Array?
Date: Wed, 13 May 2009 20:49:02 +1000
Message-ID: <18954.42398.147783.405948@notabene.brown>
References: <16137381.post@talk.nabble.com>
	<23514897.post@talk.nabble.com>
	<18954.20603.952706.467047@notabene.brown>
	<878wl1ihil.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Goswin von Brederlow on Wednesday May 13
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: SandeepKsinha <sandeepksinha@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 13, goswin-v-b@web.de wrote:
> Neil Brown <neilb@suse.de> writes:
> 
> > Online changing of chunk size for raid5 is very close to being
> > implemented.
> > All the kernel side support will be in 2.6.30.
> > I just need to spend some time getting mdadm to make it work.
> > Because data is being rearranged in-place, and because you don't want
> > to lose everything if your systems crashes, mdadm will have to work in
> > tandem with the kernel making a backup copy of a section of the array,
> > allowing the kernel to reshape that section, and then moving on to the
> > next section.  It will be slow, but it will be reliable.
> >
> > NeilBrown
> 
> Shouldn't mdadm create a file and pass the FD to the kernel or a
> loopback device and pass the major/minor and the kernel then moves
> data there itself? Seems like a bad idea to pass all the data of the
> raid to userspace just so it can be passed back to the kernel again.

The data doesn't really have to go to user-space.
If we use mmap instead of read, and pass the mmapped buffer to write,
then the data just lives in kernel buffers (I think) - it never gets
faulted in to the address space.

I want to keep the functionality in the kernel to a minimum and do any
fiddly bits in user-space.  I think keeping that back - and restoring
from it in the event of a crash - is definitely a fiddly bit that does
not belong in the kernel.

NeilBrown
