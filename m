From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [BUG] raid1: barrier retry does not work correctly with write-behind
Date: Thu, 03 Aug 2006 23:09:14 -0400
Message-ID: <44D2BA5A.3020809@steeleye.com>
References: <44D219C6.3090505@steeleye.com> <17618.42801.411938.763485@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17618.42801.411938.763485@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

> sector, bdev, size are all remembered in r1_bio.
> That leaves bi_idx and an array od len/offset pairs that we need
> to preserve.
> 
> So I guess the first step is to change alloc_behind_pages to
> return a new 'struct bio_vec' array rather than just a list of pages,
> and we should keep that array attached to the raid1_bio.

I think bio_clone gives us that already. I may have missed something but 
I think we have everything we need:

When a bio comes into raid1's make_request we bio_clone for each drive 
and attach those to r1_bio->bios. We also have behind_pages, which 
contains the pages. I think maybe instead of cloning r1_bio->master_bio, 
we can just clone r1_bio->bios[i]. Does that make sense?

Let me try that.

--
Paul

