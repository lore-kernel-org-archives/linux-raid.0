From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: raid5: switching cache buffer size log spam
Date: Wed, 1 May 2002 15:33:53 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15567.32321.669421.949103@notabene.cse.unsw.edu.au>
References: <15525.35945.411587.185565@notabene.cse.unsw.edu.au>
	<Pine.LNX.4.44.0204281733550.9254-100000@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Sunday April 28
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 28, dean@arctic.org wrote:
> > >
> > > Mar 29 10:47:45 debian kernel: raid5: switching cache buffer size, 0 --> 512
> > > Mar 29 10:47:45 debian kernel: raid5: switching cache buffer size, 0 --> 4096
> > > Mar 29 10:47:45 debian kernel: raid5: switching cache buffer size, 4096 --> 512
> >
> 
> this is an operational concern to me now -- because even the act of
> creating an LVM snapshot results in the log spam... and this makes my
> machine grind to a halt if i attempt to do backups with snapshots.
> 
> i could pursue "fixing" LVM, mke2fs/etc. to all use 4096-byte buffer_heads
> if possible.  but i thought i'd also look into fixing md itself... is
> anyone working on this already?
> 
> i've thought of two solutions, let me know what you think.
> 
> (1) in raid5_make_request, do something like:
> 
> 	if (bh->b_size <= conf->buffer_size || conf->buffer_size == 0) {
> 		do what's in the code currently;
> 	}
> 	else {
> 		break up the request into
> 			(bh->b_size / conf->buffer_size) pieces;
> 	}
> 
>     this would mean i'd eventually end up with conf->buffer_size == 512
>     and my regular 4096 byte fs operations would end up being broken
>     into 8 pieces... as long as LVM is doing the smaller block size
>     requests.
> 
>     and if i see things right, eventually a sync would cause the
>     cache to 0, and at that point it would be possible to get back to
>     a 4096-byte cache.
> 
>     how hard is it to break up bh things like this?  i'm a newbie in
>     this area of the kernel :)

Look at
 http://www.cse.unsw.edu.au/~neilb/patches/linux-stable/2.4.19-pre3/patch-j-RaidSplit

It allows each raid module to say "split this for me" and md.c will
split the request and re-submit.
It should then be fairly easy to get raid5 to say 'split' if the
request is bigger than the current size.
However doing raid5 with 512 by blocks seems to be a lot slower than
with 4K blocks..  Try it and see.


> 
> (2) the differing size accesses are typically in disjoint regions of
>     the array.  for example, when creating an LVM snapshot there is LVM
>     metadata, there is a live filesystem, and there is the LVM snapshot
>     volume itself.  all of these are disjoint.
> 
>     instead of draining the entire cache in get_active_stripe(), we only
>     need to drain entries which overlap the sector we're interested
>     in.

and you need to make sure that new requests don't then conflict with
other new requests...  I suspect this approach would be quite hard.


I think the "right" way is to fix the cache size at 4K and handle
reads and writes from partial buffers.  It's probably end up like this
in 2.5.. eventually.

NeilBrown
