From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 05/24] fs: move the putname from filename_lookup to the
 callers
Date: Mon, 20 Jul 2020 19:11:07 +0100
Message-ID: <20200720181107.GQ2786714@ZenIV.linux.org.uk>
References: <20200720155902.181712-1-hch@lst.de>
 <20200720155902.181712-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200720155902.181712-6-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 20, 2020 at 05:58:43PM +0200, Christoph Hellwig wrote:
> This allows reusing the struct filename for retries, and will also allow
> pushing the getname up the stack for a few places to allower for better
> handling of kernel space filenames.

You are complicating the callers for no good reason.  NAK.  The same goes
for the previous patch in the series.

Keep the cleanup rules simple.  Sure, I understand wanting to avoid
special rules for early bootstrap, but that's a corner case; don't
make fs/namei.c harder to follow.
