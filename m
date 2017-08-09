From: Byungchul Park <byungchul.park@lge.com>
Subject: Re: [RESEND PATCH] bcache: Don't reinvent the wheel but use existing
 llist API
Date: Wed, 9 Aug 2017 15:42:42 +0900
Message-ID: <20170809064242.GT20323@X58A-UD3R>
References: <1502095121-14337-1-git-send-email-byungchul.park@lge.com>
 <b37c4038-d95f-ca81-5789-825ebfc6d425@coly.li>
 <20170808041233.GR20323@X58A-UD3R>
 <d99cc72b-833d-c8b1-4c44-923cb50d5d1f@coly.li>
 <20170808060056.GS20323@X58A-UD3R>
 <aa85a3ed-d9a0-e9d6-58e2-b6c9e4a63984@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aa85a3ed-d9a0-e9d6-58e2-b6c9e4a63984@suse.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Nikolay Borisov <nborisov@suse.com>
Cc: Coly Li <i@coly.li>, kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@lge.com
List-Id: linux-raid.ids

On Wed, Aug 09, 2017 at 09:39:09AM +0300, Nikolay Borisov wrote:
> 
> 
> On  8.08.2017 09:00, Byungchul Park wrote:
> > On Tue, Aug 08, 2017 at 01:28:39PM +0800, Coly Li wrote:
> >>>>> +	llist_for_each_entry_safe(cl, t, reverse, list) {
> >>>>
> >>>> Just wondering why not using llist_for_each_entry(), or you use the
> >>>> _safe version on purpose ?
> >>>
> >>> If I use llist_for_each_entry(), then it would change the original
> >>> behavior. Is it ok?
> 
> Generally, _safe versions of list primitives is used when you are going
> to perform removal in the iteration. I haven't looked at the code in
> bcache but if it's removing entries from the list then _safe version is
> required. If you are only iterating - then non-safe version is fine.

Thank you~ :)
