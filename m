From: Martin Cracauer <cracauer@cons.org>
Subject: Re: Giving top priority to a rebuild instead of serving userland?
Date: Mon, 9 Jan 2012 16:57:59 -0500
Message-ID: <20120109215759.GA85361@cons.org>
References: <20120109142116.GA34289@cons.org> <CAGRgLy65r4DsK0_tL57J9=iB+JvDiZ-0ZxZfbtkC44TcQvRa2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGRgLy65r4DsK0_tL57J9=iB+JvDiZ-0ZxZfbtkC44TcQvRa2Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: Martin Cracauer <cracauer@cons.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alexander Lyakas wrote on Mon, Jan 09, 2012 at 10:40:49PM +0200: 
> Hi,
> 
> Have you tried to play with:
> /proc/sys/dev/raid/speed_limit_max
> /proc/sys/dev/raid/speed_limit_min
> /sys/block/mdXXX/md/sync_speed_min
> /sys/block/mdXXX/md/sync_speed_max
> 
> For me these work very well. You can also set min > max, in which case
> max is totally ignored.
> According to the kernel code, md keeps submitting sync requests until
> it reaches the minimum speed, and then it checks the "userland" IO and
> the high speed limit.

Looks like what I need.  Thanks so much.

These two sets are identical in functionality (other than one being
per-set), right?

Martin

> Alex.
> 
> 
> On Mon, Jan 9, 2012 at 4:21 PM, Martin Cracauer <cracauer@cons.org> wrote:
> > I am doing a resize on a 4 x 1 TB raid5 array (going to 5x 1 TB).
> >
> > When there is no userland I/O it reports about 1000 minutes to
> > rebuild. ?However, minor amount of userland demand makes it shoot up
> > to 3500-4000 as the rebuild puts it's own interests behind.
> >
> > However, the I/O there is garbage, in this case a disk-noisy web
> > browser. ?Can I tell md to give priority to it's rebuild and serve
> > userland as it pleases with -say- a maximum of 10% rebuild time
> > increase? Yes I know that'll make the system very sluggy.
> >
> > I would be finished already but overnight I left a browser tab open
> > that caused according to iostat 400-500 Blk_wrtn contiguously. ?That
> > is when *not* actually using the browser (I'll report that as a bug).
> > Now I am still at 38% rebuild. ?Didn't seem worth the price I payed :-)
> >
> > Martin
> > --
> > %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
> > Martin Cracauer <cracauer@cons.org> ? http://www.cons.org/cracauer/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at ?http://vger.kernel.org/majordomo-info.html

-- 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Martin Cracauer <cracauer@cons.org>   http://www.cons.org/cracauer/
