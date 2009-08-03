From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
Date: Mon, 3 Aug 2009 14:29:26 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0908031423140.7580@cobra.newdream.net>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
 <87prbcr46t.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87prbcr46t.fsf@basil.nowhere.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, stable@kernel.org
List-Id: linux-raid.ids

On Mon, 3 Aug 2009, Andi Kleen wrote:
> Sage Weil <sage@newdream.net> writes:
> 
> > The kzalloc mempool does not re-zero items that have been used and then
> > returned to the pool.  Manually zero the allocated multipath_bh instead.
> 
> Why not fix that in mempool instead? That would seem like the right place
> to fix such a bug, instead of adding workarounds to all callers.

That was my original proposal, but Andrew suggested it wasn't worth the 
added complexity for only 2 users (or actually, just 1).  See this thread:

http://marc.info/?l=linux-mm&m=124933189913260&w=2

sage
