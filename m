From: Neil Brown <neilb@suse.de>
Subject: Re: Spare drive won't spin down
Date: Wed, 12 May 2010 06:53:18 +1000
Message-ID: <20100512065318.44e934d4@notabene.brown>
References: <922812.29139.qm@web31703.mail.mud.yahoo.com>
	<20100507162034.1370d645@notabene.brown>
	<717013.48748.qm@web31703.mail.mud.yahoo.com>
	<20100507194704.3ffcf17e@notabene.brown>
	<4BE83B75.8050709@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE83B75.8050709@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Joe Bryant <tenminjoe@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 10 May 2010 12:59:33 -0400
Bill Davidsen <davidsen@tmr.com> wrote:

> Neil Brown wrote:
> > On Fri, 7 May 2010 00:40:40 -0700 (PDT)
> > Joe Bryant <tenminjoe@yahoo.com> wrote:
> >
> >   
> >>> I'll see about fixing that.
> >>>
> >>> Recreate the array with "--metadata 1.0" or "--metadata 1.2" and it should work better.
> >>>       
> >> That's great, thanks very much.
> >>
> >>     
> >
> > It turns out it is a bit more subtle than that, though that approach may work
> > for you.
> > If you make an odd number of changes to the metadata, it will switch from
> > doing what you want, to not.
> > e.g. if /dev/foo is your spare device, then
> >
> >   mdadm /dev/md0 -f /dev/foo
> >   mdadm /dev/md0 -r /dev/foo
> >   mdadm /dev/md0 -a /dev/foo
> >
> > will switch between working and not working.  v0.90 metadata starts out not
> > working.  v1.x start out working.
> >   
> 
> So we can assume that the little dance steps above will make 1.x 
> misbehave in the same way?

Yes.

> 
> Could you explain (point to an explanation) why this whole odd/even 
> thing exists?
> 

Maybe ....

For backwards compatibility, the event counts in all the devices in an array
must not differ by more than 1.  And if the information in the superblocks is
different, then the event counts must be different to ensure that the current
information is used when the array is restarted.

Consequently, if the event counts are uniform across an array it is safe to
just mark the superblocks on active drives as 'dirty' leaving spare drives
alone.
To then mark the array as 'clean' again we would need to either update the
metadata on the spares (which we don't want to do) or decrease the event
count on the active devices.
However there are cases where decreasing the event count on active devices is
not safe.
If the array was dirty and we failed a device that would update the event
count everywhere but on the failed device.
When we then want to mark the array as 'clean' it is *not* safe to decrement
the event count as then the failed drive could look like it is still a valid
member of the array.

I had the idea that I could encode this extra information in the odd/even
status of the event count.  However it seems that now I explain it out loud
it doesn't actually make a lot of sense.

I should keep the "it is safe to decrement the event count" state in some
internal state variable and assume it is 'false' when an array is started.
That would be heaps cleaner and would actually do the right thing.

Theoretically, when the spares are one behind the active array and we need to
update them all, we should update the spares first, then the rest.  If we
don't and there is a crash at the wrong time, some spares could be 2 events
behind the most recent device.  However that is a fairly unlikely race to
lose and the cost is only having a spare device fall out of the array, which
is quite easy to put back it, that I might not worry to much about it.

So if you haven't seen a patch to fix this in a week or two, please remind me.

Thanks,
NeilBrown
