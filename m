From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How do we handle the same but uptodated data to disk cache?
Date: Fri, 30 May 2003 14:07:11 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16086.55535.905007.233783@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0305261738440.19678-100000@q7.q7.com>
	<004301c323f9$71916a10$6b01a8c0@bmoon>
	<16082.53674.340479.177651@notabene.cse.unsw.edu.au>
	<007c01c32491$43cf41e0$6b01a8c0@bmoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from bmoon on Tuesday May 27
To: bmoon <bo@anthologysolutions.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 27, bo@anthologysolutions.com wrote:
> Neil,
> 
> It improved a lot for the sync I/O.
> However, I am looking for a solution to handle
> the regular async I/O with a page data on the
> same sector repeatedly like writing the MD SB
> data to disk without flushing.

This is a filesystem question.  Not a raid question.

I would just:
   getblk
   copy new data in
   mark update
   mark dirty
   release block

and it will eventually be flushed to disk.
If you want to written sooner, call
   submit_bh


NeilBrown

> 
> The follwing is my simple algorithm for it;
> 
>         bh=getblk(dev, block, size);
>         if (buffer_uptodate(bh)) { /* still in cache, not flushed yet */
>               bh->b_data = "updated data";
>               brelse(bh);
>         }
>         else { /* all were flushed or new  */
>             .
>             .
>              mark_buffer_uptodate(bh,1);
>              mark_buffer_dirty(bh);
>             generic_make_request(rw, &bh);
>        }
> 
>  Please give me your suggestion or comment.
> 
> 
> Bo
> ----- Original Message -----
> From: "Neil Brown" <neilb@cse.unsw.edu.au>
> To: "bmoon" <bo@anthologysolutions.com>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Monday, May 26, 2003 7:47 PM
> Subject: Re: How do we handle the same but uptodated data to disk cache?
> 
> 
> > On Monday May 26, bo@anthologysolutions.com wrote:
> > > Hello,
> > >
> > > I want to write the data to the fixed sector with the same size
> frequently
> > > just like MD super block, but I do not want to sync and flush the dev
> > > on each write.
> > >
> > > For example, to write md super block in /drivers/md/md.c
> >
> > I suggest you look at a newer md.c.  With 2.4.21pre or 2.5.* have
> > "sync_page_io" which does what you want more effectively.
> >
> > NeilBrown
> >
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
