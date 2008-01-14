From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
Date: Mon, 14 Jan 2008 02:04:59 +0000
Message-ID: <20080114020459.GN27894@ZenIV.linux.org.uk>
References: <20080114123726.19968.patches@notabene> <1080114014531.20354@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1080114014531.20354@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 14, 2008 at 12:45:31PM +1100, NeilBrown wrote:
> 
> Due to possible deadlock issues we need to use a schedule work to
> kobject_del an 'rdev' object from a different thread.
> 
> A recent change means that kobject_add no longer gets a refernce, and
> kobject_del doesn't put a reference.  Consequently, we need to
> explicitly hold a reference to ensure that the last reference isn't
> dropped before the scheduled work get a chance to call kobject_del.
> 
> Also, rename delayed_delete to md_delayed_delete to that it is more
> obvious in a stack trace which code is to blame.

I don't know...  You still get kobject_del() and export_rdev()
in unpredictable order; sure, it won't be freed under you, but...

What is that deadlock problem, anyway?  I don't see anything that
would look like an obvious candidate in the stuff you are delaying...
