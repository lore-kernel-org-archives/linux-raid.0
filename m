From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] md: avoid use of broken kzalloc mempool
Date: Mon, 03 Aug 2009 23:13:46 +0200
Message-ID: <87prbcr46t.fsf@basil.nowhere.org>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1249332888-13440-1-git-send-email-sage@newdream.net> (Sage Weil's message of "Mon,  3 Aug 2009 13:54:46 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>, stable@kernel.org
List-Id: linux-raid.ids

Sage Weil <sage@newdream.net> writes:

> The kzalloc mempool does not re-zero items that have been used and then
> returned to the pool.  Manually zero the allocated multipath_bh instead.

Why not fix that in mempool instead? That would seem like the right place
to fix such a bug, instead of adding workarounds to all callers.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
