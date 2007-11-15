From: Neil Brown <neilb@suse.de>
Subject: Re: [stable] [PATCH 000 of 2] md: Fixes for md in 2.6.23
Date: Thu, 15 Nov 2007 16:22:48 +1100
Message-ID: <18235.55208.76197.230486@notabene.brown>
References: <20071022171426.31103.patches@notabene>
	<20071114002214.GA31928@kroah.com>
	<20071114002308.GB31928@kroah.com>
	<e9c3a7c20711131936t3c5f858cm8937b24d97fe998c@mail.gmail.com>
	<20071114034325.GA25558@kroah.com>
	<e9c3a7c20711132136t6cc9a91avb1d1ddf257701331@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Tuesday November 13
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Stable <stable@kernel.org>
List-Id: linux-raid.ids

On Tuesday November 13, dan.j.williams@intel.com wrote:
> 
> raid5-fix-unending-write-sequence.patch is in -mm and I believe is
> waiting on an Acked-by from Neil?
> 

It seems to have just been sent on to Linus, so it probably will go in
without:

   Acked-By: NeilBrown <neilb@suse.de>

I'm beginning to think that I really should sit down and make sure I
understand exactly how those STRIPE_OP_ flags are uses.  They
generally make sense but there seem to be a number of corner cases
where they aren't quite handled properly..  Maybe they are all found
now, or maybe....

NeilBrown
