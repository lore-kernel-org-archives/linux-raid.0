From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: *terrible* direct-write performance with raid5
Date: Tue, 22 Feb 2005 15:08:06 -0800 (PST)
Message-ID: <Pine.LNX.4.62.0502221507160.25248@twinlark.arctic.org>
References: <421B6E5D.6030004@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <421B6E5D.6030004@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 22 Feb 2005, Michael Tokarev wrote:

> When debugging some other problem, I noticied that
> direct-io (O_DIRECT) write speed on a software raid5
> is terrible slow.  Here's a small table just to show
> the idea (not numbers by itself as they vary from system
> to system but how they relate to each other).  I measured
> "plain" single-drive performance (sdX below), performance
> of a raid5 array composed from 5 sdX drives, and ext3
> filesystem (the file on the filesystem was pre-created
> during tests).  Speed measurements performed with 8Kbyte
> buffer aka write(fd, buf, 8192*1024), units a Mb/sec.

with O_DIRECT you told the kernel it couldn't cache anything... you're 
managing the cache.  you should either be writing 64KiB or you should 
change your chunksize to 8KiB (if it goes that low).

-dean
