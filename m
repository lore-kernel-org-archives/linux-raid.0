From: NeilBrown <neilb@suse.de>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Thu, 28 Jul 2011 06:55:41 +1000
Message-ID: <20110728065541.3e2d5cac@notabene.brown>
References: <20110727141652.7511fc51@notabene.brown>
	<j0p0d6$aj6$1@dough.gmane.org>
	<4E300828.3000601@anonymous.org.uk>
	<j0p2g2$nmp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j0p2g2$nmp$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lutz Vieweg <lvml@5t9.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Jul 2011 15:06:10 +0200 Lutz Vieweg <lvml@5t9.de> wrote:

> On 07/27/2011 02:44 PM, John Robinson wrote:
> >> Can you describe the criteria for MD considering a block as faulty?
> >
> > I'll try to answer this having followed some of the discussion around it.
> 
> Thanks a lot for the explanation!

Yes John, thanks for posting.

> 
> > Once the controller or power issues are resolved, the bad block list can be
> > administratively modified or cleared.
> 
> Ah, that's good.

"administratively" probably isn't the right word.  You cannot tell md to
remove blocks from the list (except for testing purposes).

When md finds that it might be good to write to a known-bad-block it has two
options - to write or not.
It makes the choice based on whether it has seen any write errors on that
device since the array was assembled.
If it has - it just doesn't write and leaves the block 'bad'.
If it has not it tries to write.  On success it clears the record of the bad
block.  On failure it decides not to write to and more bad blocks on that
device.

So if you have a device that is incorrectly reporting errors and filling up
the bad block list, and you then stop the array, fix the hardware, and
re-assemble,  then the bad blocks will gradually disappear as writes try to
write to them again and succeed.  A 'check' pass should automatically fix
everything up as it tries to re-write bad blocks.

> 
> > I don't think mdadm knows whether its constituent devices are SSDs.
> 
> In block/cfq-iosched.c I see a test that looks like this:
> >         if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
> >                 return;
> 
> If that isn't conclusive, putting a note into the mdadm man-page is probably
> the best one can do.
> 

The idea of marking a device as 'rotational' always seemed dumb to me.
Because people assume that 'rotational' is a disk drive and '!rotational' is
an SSD.  But what if some other technology comes along with behaviour
somewhere between the two??

I think the primary meaning of 'rotational' as implemented is 'seek is
instant'.  This is quite a different meaning to 'blocks migrate around the
device' even though both are true of current SSDs.


I'm not sure that md can usefully do anything different on SSDs than on
spinning rust.
You certainly still want to record read errors.  If you get a write error it
probably means that a large part of the device is bad ... but I suspect you
will notice that soon enough anyway.

NeilBrown


> Regards,
> 
> Lutz Vieweg
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

