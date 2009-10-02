From: Neil Brown <neilb@suse.de>
Subject: Re: raid0 failures
Date: Fri, 2 Oct 2009 15:28:37 +1000
Message-ID: <19141.36741.266151.675400@notabene.brown>
References: <5d96567b0910010731t513a84a5m1f85e715a69efab6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz on Thursday October 1
Sender: linux-raid-owner@vger.kernel.org
To: Raz <raziebe@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday October 1, raziebe@gmail.com wrote:
> Neil Hello
> I have noticed that raid0 cannot tell if an IO to a had disk failed or
> not. This is a problem in some cases because i need the raid to stop.
> I am thinking of fixing it. what is the best approach if any you
> believe is possible ?
> thank you
> raz

I'm not clear on why you would want to do this.
Surely the filesystem (or whatever) will detect any failure at the
same time that MD/RAID0 could, and it will handle or report it.

NeilBrown
