From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Fri, 18 Mar 2005 13:52:54 +0100
Message-ID: <6ivqg2-qsn.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
> On 2005-03-15T09:54:52, Neil Brown <neilb@cse.unsw.edu.au> wrote:
> > I think any scheme that involved multiple bitmaps would be introducing
> > too much complexity.  Certainly your examples sound very far fetched
> > (as I think you admitted yourself).  But I always try to be open to
> > new ideas.
> 
> For single node operations, yes. But disks appearing and reappearing is
> _mostly_ a cluster issue, and there it makes sense, because of the
> potentially diverging data in case both sides activate the mirrors.

Didn't we go through this once before, Lars :-). The bitmap is always
pesimistic, so splitting it would only be aimed at making it less so,
by dint of giving it a sharper focus on what's really what.

The question is how much one gains and how much one loses. When I
originally did FR1 0.1, I had multiple bitmaps, and one of the first
things Neil suggested was combining them - and magically, all the code
simplified away into nice little understandable trivialities.  So I
think it's a good idea from the maintenance point of view!

What would one lose? Does it matter if we resync more than needed, when
that is already 100 times less than we would have resynced without a
bitmap?

(proviso - I didn't read the post where you set out the error
situations, but surely, on theoretical grounds, all that can happen is
that the bitmap causes more to be synced than need be synced).

Peter

