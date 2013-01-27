From: Christoph Hellwig <hch@infradead.org>
Subject: Re: fsync() on read-only RAID triggers BUG
Date: Sun, 27 Jan 2013 11:39:42 -0500
Message-ID: <20130127163942.GA28572@infradead.org>
References: <1358707492.24121.210.camel@deadeye.wl.decadent.org.uk>
 <5102A01B.7000407@profitbricks.com>
 <1359229480.2894.21.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1359229480.2894.21.camel@deadeye.wl.decadent.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, 696650@bugs.debian.org
List-Id: linux-raid.ids

On Sat, Jan 26, 2013 at 07:44:40PM +0000, Ben Hutchings wrote:
> I applied this on top of 3.2.37 and it certainly fixes the crash.
> However I wonder whether fsync() should fail or should immediately
> succeed.  I don't know whether the installer expects it to succeed.

It should succeed.

