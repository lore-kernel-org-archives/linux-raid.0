From: Christoph Hellwig <hch@lst.de>
Subject: Re: [md PATCH 0/5] Stop using bi_phys_segments as a counter
Date: Wed, 23 Nov 2016 09:45:40 +0100
Message-ID: <20161123084540.GE16966@lst.de>
References: <147969099621.5434.12384452255155063186.stgit@noble> <20161121234311.6qhwa2g3oa4uhcbi@kernel.org> <87mvgscqe7.fsf@notabene.neil.brown.name> <20161122010220.dcq6brjhsliw4io6@kernel.org> <87k2bwcl44.fsf@notabene.neil.brown.name> <20161122080127.rv4kgmeyluyfyxnd@kernel.org> <87zikraqxl.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87zikraqxl.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 23, 2016 at 01:08:38PM +1100, NeilBrown wrote:
> For raid1/raid10 we could do a very similar thing.  There is an
> awkwardness in raid1 w.r.t waiting for bi_phys_segments to reach 1, but
> that might disappear if Coly's resync changes go through.
> Alternately it might make sense to use bio_split so there is one r1_bio
> per bio.
> I might try the raid10 version and see what it looks like.

For RAID1 reads there already is one r1_bio per bio - in fact I have
a hack that doesn't allocate a r1_bio at all, but that one currently
does not handle reads from degraded arrays at all.  Due you remember
why we only mark a leg fail for a given bio instead of on a per-device
or at least per sector-range?

For writes it would make sense to allocate the new bio for each mirror
using a bio_set with front_pad for raid1-specific data, but I haven't
really looked into the details yet.
