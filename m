From: Neil Brown <neilb@suse.de>
Subject: Re: Changing chunk size
Date: Fri, 16 Feb 2007 10:24:43 +1100
Message-ID: <17876.60347.983953.748979@notabene.brown>
References: <45D4955C.60008@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Thursday February 15
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday February 15, davidsen@tmr.com wrote:
> I have determined that a large array was created with an overly-large 
> chunk size. Best way to resize?

Dump and restore.

in-place reshapes (such as raid5 + 1 disk => raid6 or
change-chunk-size) are on my list of 'that might be interesting to
implement', but there are plenty of more interesting things.  And it
would be very slow.  It would need to copy some number of stripes to a
backup somewhere, then copy them back in the new layout, so every
block in the array would be written twice.

NeilBrown
