From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 Reshape Status + xfs_growfs = Success! (2.6.17.3)
Date: Tue, 18 Jul 2006 10:48:07 +1000
Message-ID: <17596.12231.468729.199881@cse.unsw.edu.au>
References: <Pine.LNX.4.64.0607111159470.12230@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751285AbWGRAsp@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Tuesday July 11
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

On Tuesday July 11, jpiszcz@lucidpixels.com wrote:
> Neil,
> 
> It worked, echo'ing the 600 > to the stripe width in /sys, however, how 
> come /dev/md3 says it is 0 MB when I type fdisk -l?
> 
> Is this normal?

Yes.  The 'cylinders' number is limited to 16bits.  For you 2.2TB
array, the number of 'cylinders' (given 2 heads and 4 sectors) would
be about 500,000 which doesn't fit into 16 bits.
> 
> Furthermore, the xfs_growfs worked beautifully!
> 

Excellent!

NeilBrown
