From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
Date: Mon, 14 Jan 2008 03:43:23 +0000
Message-ID: <20080114034322.GO27894@ZenIV.linux.org.uk>
References: <20080114123726.19968.patches@notabene> <1080114014531.20354@suse.de> <20080114020459.GN27894@ZenIV.linux.org.uk> <18314.54601.196877.828373@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18314.54601.196877.828373@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 14, 2008 at 02:21:45PM +1100, Neil Brown wrote:

> Maybe it isn't there any more....
> 
> Once upon a time, when I 
>    echo remove > /sys/block/mdX/md/dev-YYY/state

Egads.  And just what will protect you from parallel callers
of state_store()?  buffer->mutex does *not* do that - it only
gives you exclusion on given struct file.  Run the command
above from several shells and you've got independent open
from each redirect => different struct file *and* different
buffer for each => no exclusion whatsoever.

And _that_ is present right in the mainline tree - it's unrelated
to -mm kobject changes.

BTW, yes, you do have a deadlock there - kobject_del() will try to evict
children, which will include waiting for currently running ->store()
to finish, which will include the caller since .../state *is* a child of
that sucker.

The real problem is the lack of any kind of exclusion considerations in
md.c itself, AFAICS.  Fun with ordering is secondary (BTW, yes, it is
a problem - will sysfs ->store() to attribute between export_rdev() and
kobject_del() work correctly?)

