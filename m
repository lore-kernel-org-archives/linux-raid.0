From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: RAID1 repair GPF crash w/3.10-rc7
Date: Wed, 3 Jul 2013 17:49:51 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1307031634440.9749@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1307012118450.6694@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1307012118450.6694@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, 1 Jul 2013, Joe Lawrence wrote:

> Hi Kent & Neil,
> 
> I've hit a crash in MD during RAID1 repair while running 3.10-rc7:
>
> [ ... snip ... ]

Hi Neil,

Looking through the MD source, I'm trying to understand part of the
RAID1 repair path.  I came up with a few questions:

1 - During user initiated RAID1 repair, is the loop at the bottom of
sync_request(), under the bio_full label, responsible for submitting all
of the initial read bios?

2 - Does process_checks() later find the first uptodate read bio and
copy its data into the other r1_bio->bios[] for write repair to the
other disks?

If both are true, then perhaps the following applies to this crash...

Comments in commit f79ea416 "block: Refactor blk_update_request()" msg
include:

    Note that req_bio_endio() now always calls bio_advance() - which
    means it always loops over the biovec, not just on partial
    completions.  Don't expect it to affect performance, but worth
    noting.

Now that process_checks() has been further modified for immutable bio
prep (commit d3b45c2 "raid1: use bio_copy_data()"), it calls
bio_copy_data() to fill in the write repair bios... which starts
indexing the bi_bio_vec[] from wherever bi_idx happens to be.

If this is indeed the case, I'm having trouble coming up with a good
solution:

  - Immutable bios means drivers don't touch bi_idx.  So MD shouldn't
    "re-wind" the source bi_idx before calling bio_copy_data().

  - bio_copy_data() could copy the entire source bi_bio_vec[], as MD had
    done in the past, but that is that safe?  (ie, can we map bio
    vectors once they have been iterated over?)

Thanks,

-- Joe
