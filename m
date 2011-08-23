From: NeilBrown <neilb@suse.de>
Subject: Re: external bitmaps on block devices?
Date: Tue, 23 Aug 2011 14:04:37 +1000
Message-ID: <20110823140437.6be50c9d@notabene.brown>
References: <20110823035155.GA12299@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110823035155.GA12299@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 22 Aug 2011 23:51:55 -0400 Christoph Hellwig <hch@infradead.org>
wrote:

> Is there any specific reason to require the external bitmap to be on
> a file?  Currently the code requires regular files to call bmap on them,
> which is a fairly dangerous thing to start with.  But why don't we just
> allow using block devices to store the bitmap directly?

No, no specific reason.
The original requirement was for storage in a file so that is that was
focused on.
I can see no reason not to add support for storing directly to a block device.

NeilBrown
