From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: [PATCH] md: new bitmap sysfs interface
Date: Wed, 26 Jul 2006 23:36:28 -0400
Message-ID: <170fa0d20607262036i30ab9f12qf64c0fc7b90b9eca@mail.gmail.com>
References: <44C5BA6F.3010404@steeleye.com>
	 <170fa0d20607261430n3e9d3962xeef50669ce0d1996@mail.gmail.com>
	 <44C8248B.7010501@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44C8248B.7010501@steeleye.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On 7/26/06, Paul Clements <paul.clements@steeleye.com> wrote:
> Mike Snitzer wrote:
>
> > I tracked down the thread you referenced and these posts (by you)
> > seems to summarize things well:
> > http://marc.theaimsgroup.com/?l=linux-raid&m=111116563016418&w=2
> > http://marc.theaimsgroup.com/?l=linux-raid&m=111117515400864&w=2
> >
> > But for clarity's sake, could you elaborate on the negative
> > implications of not merging the bitmaps on the secondary server?  Will
> > the previous primary's dirty blocks get dropped on the floor because
> > the secondary (now the primary) doesn't have awareness of the previous
> > primary's dirty blocks once it activates the raid1?
>
> Right. At the time of the failover, there were (probably) blocks that
> were out of sync between the primary and secondary. Now, after you've
> failed over to the secondary, you've got to overwrite those blocks with
> data from the secondary in order to make the primary disk consistent
> again. This requires that either you do a full resync from secondary to
> primary (if you don't know what differs), or you merge the two bitmaps
> and resync just that data.

I took more time to read the later posts in the original thread; that
coupled with your detailed response has helped a lot. thanks.

> > Also, what is the interface one should use to collect dirty bits from
> > the primary's bitmap?
>
> Whatever you'd like. scp the bitmap file over or collect the ranges into
> a file and scp that over, or something similar.

OK, so regardless of whether you are using an external or internal
bitmap; how does one collect the ranges from an array's bitmap?

Generally speaking I think others would have the same (naive) question
given that we need to know what to use as input for the sysfs
interface you've kindly provided.   If it is left as an exercise to
the user that is fine; I'd imagine neilb will get our backs with a
nifty new mdadm flag if need be.

thanks again,
Mike
