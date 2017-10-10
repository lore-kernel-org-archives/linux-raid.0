From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Mon, 9 Oct 2017 20:07:02 -0400
Message-ID: <20171010000702.GA6038@animx.eu.org>
References: <22997.8664.67459.119616@quad.stoffel.home>
 <87a81637lq.fsf@notabene.neil.brown.name>
 <23002.37193.492253.120639@quad.stoffel.home>
 <87shetz207.fsf@notabene.neil.brown.name>
 <23002.53075.413063.6948@quad.stoffel.home>
 <87h8v9yn91.fsf@notabene.neil.brown.name>
 <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil Turmel wrote:
> On 10/09/2017 12:10 AM, NeilBrown wrote:
> 
> > If there is some action that mdadm can currently be told to perform, and
> > when it tries to perform that action it corrupts the array, then
> > it is certainly appropriate to teach mdadm not to perform that action.
> > It shouldn't even perform that action with --force.   I agree that
> > changing mdadm like this is complementary to changing the kernel.  Both
> > are useful.
> 
> A certain amount of the trouble with all of this is the english meaning
> of "grow" doesn't really match what mdadm allows.
> 
> Might it be reasonable to reject "--grow" operations that reduce the
> final array size, and introduce the complementary "--reduce" operation
> that rejects array size increases?
> 
> Both operations would share the current code, just apply a different
> sanity check before proceeding.
> 
> mdadm would then at least not violate the rule of least surprise.

As a general user of md raid and as a reader of the list, I would agree that
this would be a better solution.  Thinking in terms of lvm, there's lvreduce
and lvextend.  IMO, --force wouldn't be needed for --reduce (I was orginally
thinking of --shrink)

On a side note, is it possible for the lower layers to know what the last
used sector is?  IE lvm ontop of raid and has 10% allocated and the last
sector is around the 10% mark.  (If this were possible --force would be,
required if shrinking would result in inaccessible data)

I recently did a shrink of 4x 2tb drives so that I could replace the 2tb
drives with 80gb drives (yes, big shrink!)  Would have been nice for mdadm
to know the smallest size was that wouldn't destroy my lvm volumes that were
on top.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
