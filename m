From: Christoph Hellwig <hch@infradead.org>
Subject: Re: nonstandard raid(4-ish) scheme
Date: Tue, 24 Jan 2012 11:22:35 -0500
Message-ID: <20120124162235.GA15260@infradead.org>
References: <20120124030015.GQ11921@wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120124030015.GQ11921@wantstofly.org>
Sender: linux-raid-owner@vger.kernel.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 24, 2012 at 04:00:15AM +0100, Lennert Buytenhek wrote:
> The ideal way of doing this would be to take N-1 disks out of your N
> disk set, and create separate filesystems on each of the disks, and
> store different sets of files on them, while using the last disk,
> disk N, as a parity disk of the N-1 data disks.
> 
> This is equivalent to raid4 with the stripe size equal the size of
> one disk, and where the data disks get individual /dev/mdX entries
> instead of being concatenated into one large /dev/mdX.
> 
> Would this be easy to implement?

I think it would be fairly easy.  Take the existing RAID4 code, and
instead of striping over the data disks use them in a linear, concatenated
fashion.  Then make sure the filesystem places whole directories on
one of them.  Using the "filestreams" mount option in XFS, combined with
aligning the allocation groups to the data disk boundaries should do
that for you.

