From: Iustin Pop <iusty@k1024.org>
Subject: Re: One Large md or Many Smaller md for Better Peformance?
Date: Sun, 20 Jan 2008 22:57:34 +0100
Message-ID: <20080120215734.GD17584@teal.hq.k1024.org>
References: <4793AE0E.609@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4793AE0E.609@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 20, 2008 at 02:24:46PM -0600, Moshe Yudkowsky wrote:
> Question: with the same number of physical drives,  do I get better  
> performance with one large md-based drive, or do I get better  
> performance if I have several smaller md-based drives?

No expert here, but my opinion:
  - md code works better if it's only one array per physical drive,
    because it keeps statistics per array (like last accessed sector,
    etc.) and if you combine two arrays on the same drive these
    statistics are not exactly true anymore
  - simply separating 'application work areas' into different
    filesystems is IMHO enogh, no need to separate the raid arrays too
  - if you download torrents, fragmentation is a real problem, so use a
    filesystem that knows how to preallocate space (XFS and maybe ext4;
    for XFS use xfs_io to set a bigger extend size for where you
    download)

regards,
iustin
