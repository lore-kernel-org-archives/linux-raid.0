From: dean gaudet <dean@arctic.org>
Subject: Re: raid5: switching cache buffer size log spam
Date: Sun, 28 Apr 2002 18:32:45 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0204281733550.9254-100000@twinlark.arctic.org>
References: <15525.35945.411587.185565@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15525.35945.411587.185565@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 30 Mar 2002, Neil Brown wrote:

> On Friday March 29, dean-list-linux-kernel@arctic.org wrote:
> > 2.4.19-pre3-ac1
> >
> > /dev/md1 is a raid5 of 4 disks
> > [creating snapshot volumes] results in lots of log spam of the form:
> >
> > Mar 29 10:47:45 debian kernel: raid5: switching cache buffer size, 0 --> 512
> > Mar 29 10:47:45 debian kernel: raid5: switching cache buffer size, 0 --> 4096
> > Mar 29 10:47:45 debian kernel: raid5: switching cache buffer size, 4096 --> 512
>
> The current raid5 requires all requests that is recieves to be the
> same size.  If it gets requests of different sizes, it does cope but
> it needs to flush its stripe cache and start again.  This effectively
> serialises all requests around a request-size change.
> So it is probably fair to say that what you are trying to do is
> currently not a supported option.  It may be in 2.6 if we ever get
> raid5 working again in 2.5 :-)

this is an operational concern to me now -- because even the act of
creating an LVM snapshot results in the log spam... and this makes my
machine grind to a halt if i attempt to do backups with snapshots.

i could pursue "fixing" LVM, mke2fs/etc. to all use 4096-byte buffer_heads
if possible.  but i thought i'd also look into fixing md itself... is
anyone working on this already?

i've thought of two solutions, let me know what you think.

(1) in raid5_make_request, do something like:

	if (bh->b_size <= conf->buffer_size || conf->buffer_size == 0) {
		do what's in the code currently;
	}
	else {
		break up the request into
			(bh->b_size / conf->buffer_size) pieces;
	}

    this would mean i'd eventually end up with conf->buffer_size == 512
    and my regular 4096 byte fs operations would end up being broken
    into 8 pieces... as long as LVM is doing the smaller block size
    requests.

    and if i see things right, eventually a sync would cause the
    cache to 0, and at that point it would be possible to get back to
    a 4096-byte cache.

    how hard is it to break up bh things like this?  i'm a newbie in
    this area of the kernel :)

(2) the differing size accesses are typically in disjoint regions of
    the array.  for example, when creating an LVM snapshot there is LVM
    metadata, there is a live filesystem, and there is the LVM snapshot
    volume itself.  all of these are disjoint.

    instead of draining the entire cache in get_active_stripe(), we only
    need to drain entries which overlap the sector we're interested in.

    i'm still puzzling out an efficient change to the hash which
    accomplishes this...

    one idea is to change conf->buffer_size to conf->max_buffer_size.
    in this case we drain the entire cache any time max_buffer_size
    changes, and allow entries in the cache which are any size
    <= conf->max_buffer_size.

    if max_buffer_size is 4096 (as i expect it to be) then 512-byte
    accesses will potentially require hash chains 8x longer than
    they would be today... but this could be a total non-issue.
    i suspect it works for my situation, but may not work in
    general when folks want to mix and match filesystem or
    database block sizes on an array.

    the cache could use a tree instead of a hash ... but that's not
    so nice for n-way scaling :)

thanks
-dean

