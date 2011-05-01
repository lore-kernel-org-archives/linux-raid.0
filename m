From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Date: Sun, 1 May 2011 12:48:18 -0400
Message-ID: <20110501164818.GA5391@infradead.org>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
 <20110501082717.5116e575@notabene.brown>
 <ipjtup$47u$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ipjtup$47u$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 01, 2011 at 05:24:09PM +0200, David Brown wrote:
> I suppose it also makes sense to put the write-intent bitmap for md
> raid on such a raid1 pair (typically SSD's).

Note that right now you can't actually put the bitmap on a device,
but it requires a file on a filesystem, which seems rather confusing.

Also make sure that you don't already max out the solid state devices
IOP rate with the log writes, in which case putting the bitmap on
it as well will slow it down.

