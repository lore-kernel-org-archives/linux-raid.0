From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Subject: Re: bonnie++ benchmarks for ext2,ext3,ext4,jfs,reiserfs,xfs,zfs on
	software raid 5
Date: Mon, 30 Jul 2007 15:11:06 -0500
Message-ID: <1185826266.9448.5.camel@kleikamp.austin.ibm.com>
References: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707301021090.12456@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2007-07-30 at 10:29 -0400, Justin Piszcz wrote:

> Overall JFS seems the fastest but reviewing the mailing list for JFS it 
> seems like there a lot of problems, especially when people who use JFS > 1 
> year, their speed goes to 5 MiB/s over time and the defragfs tool has been 
> removed(?) from the source/Makefile and on Google it says not to use it 
> due to corruption.

The defragfs tool was an unported holdover from OS/2, which is why it
was removed.  There never was a working Linux version.  I have some
ideas to improve jfs allocation to avoid fragmentation problems, but jfs
isn't my full-time job anymore, so I can't promise anything.  I'm not
sure about the corruption claims.  I'd like to hear some specifics on
that.

Anyway, for enterprise use, I couldn't recommend jfs, since there is no
full-time maintainer.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

