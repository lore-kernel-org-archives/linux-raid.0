From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [BUG] raid1: barrier retry does not work correctly with write-behind
Date: Thu, 03 Aug 2006 23:35:33 -0400
Message-ID: <44D2C085.7010109@steeleye.com>
References: <44D219C6.3090505@steeleye.com> <17618.42801.411938.763485@cse.unsw.edu.au> <44D2BA5A.3020809@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44D2BA5A.3020809@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Paul Clements wrote:

> I think bio_clone gives us that already. I may have missed something but 
> I think we have everything we need:
> 
> When a bio comes into raid1's make_request we bio_clone for each drive 
> and attach those to r1_bio->bios. We also have behind_pages, which 
> contains the pages. I think maybe instead of cloning r1_bio->master_bio, 
> we can just clone r1_bio->bios[i]. Does that make sense?

Never mind, of course that won't work...it's basically the same as using 
the failed bio.

Yes, so we need a copy of the bvec too. Would it be easier, or less 
risky just to create an entire "spare" bio, cloned from the master bio 
during make_request as the other r1_bio->bios[] are, and then use that 
if we need it? Maybe too much overhead, but it should guarantee that 
none of the fields have been monkey-ed with by an underlying disk. May 
be easier than trying to allocate and construct bvecs by hand?

--
Paul
