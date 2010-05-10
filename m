From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
Date: Mon, 10 May 2010 12:20:33 +1000
Message-ID: <20100510022033.GB7165@dastard>
References: <1743435018.20100510013511@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1743435018.20100510013511@kaneda.iguw.tuwien.ac.at>
 <462402327.20100509210710@kaneda.iguw.tuwien.ac.at>
 <1816344475.20100509204800@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 09, 2010 at 08:48:00PM +0200, Rainer Fuegenstein wrote:
> 
> today in the morning some daemon processes terminated because of
> errors in the xfs file system on top of a software raid5, consisting
> of 4*1.5TB WD caviar green SATA disks.

Reminds me of a recent(-ish) md/dm readahead cancellation fix - that
would fit the symptoms of (btree corruption showing up under heavy IO
load but no corruption on disk. However, I can't seem to find any
references to it at the moment (can't remember the bug title), but
perhaps your distro doesn't have the fix in it?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
