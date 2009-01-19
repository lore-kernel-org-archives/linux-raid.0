From: Neil Brown <neilb@suse.de>
Subject: Re: Roadmap for md/raid ???
Date: Mon, 19 Jan 2009 13:05:34 +1100
Message-ID: <18803.57326.591385.40711@nbeee.brown>
References: <18763.7881.300921.177207@notabene.brown>
	<496E4E59.4090505@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Wednesday January 14
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 14, davidsen@tmr.com wrote:
> Neil Brown wrote:
> > Not really a roadmap, more a few tourist attractions that you might
> > see on the way if you stick around (and if I stick around)...
> >
> >   
> Thanks for sharing, although that last comment is a little worrisome.

No one in irreplaceable... but I'm not planning on going anywhere
just now :-)

> 
> > Comments welcome.
> >
> >   
> Here's one, is this in some sense a prioritized list? If so I might 
> comment on the order, and I'm sure others would feel even more strongly 
> than I. ;-)

No, the list isn't prioritised.  I'll do things as the mood takes me.

> > - raid5->raid6 conversion.
> >    This is also a fairly commonly asked for feature.
> >    The first step would be to define a raid6 layout where the Q block
> >    was not rotated around the devices but was always on the last
> >    device.  Then we could change a raid5 to a singly-degraded raid6
> >    without moving any data.
> >
> >    The next step would be to implement in-place restriping. 
> >    This involves 
> >       - freezing a section of the array (all IO blocks)
> >       - copying the data out to a safe backup
> >       - copying it back in with the new layout
> >       - updating the metadata to indicate that the restripe has
> >         progressed.
> >       - repeat.
> >
> >   
> It would seem very safe, something like
>  1 - call the chunk on the new drive the available space
>  2 - determine what needs to be in the available space
>  3 - if data, copy the data chunk to the available chunk, mark the old 
> location avail, repeat step 2
>  4 - Q goes in the available chunk, calculate it and the stripe is done
> I don't see the move to a safe backup if you move one chunk at a time 
> until you are ready for Q, unless there are moves I'm missing. You 
> always have a free space to move one chunk, when all data is in the 
> right place and the P value is in place (does it move?), then Q is 
> calculated and saved. In other words, no out of stripe storage needed.

The difficulty is "How do you handle a crash?"
If you crash and restart in the middle of a reshape, you need to know
where all the data is.
To follow your scheme, you would need to update the metadata for
every block that is moved.

The value of having a large avail space is that you only update the
metadata only every time the space fills up.



Thanks for your thoughts.

NeilBrown
