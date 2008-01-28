From: Neil Brown <neilb@suse.de>
Subject: Re: BUG: possible array corruption when adding a component to a degraded
 raid5 (possibly other levels too)
Date: Mon, 28 Jan 2008 22:34:49 +1100
Message-ID: <18333.48601.218262.452373@notabene.brown>
References: <479DA8E6.6040209@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Rabbitson on Monday January 28
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday January 28, rabbit+list@rabbit.us wrote:
> Hello,
> 
> It seems that mdadm/md do not perform proper sanity checks before adding a 
> component to a degraded array. If the size of the new component is just right, 
> the superblock information will overlap with the data area. This will happen 
> without any error indications in the syslog or otherwise.

I thought I fixed that.... What versions of Linux kernel and mdadm are
you using for your tests?

Thanks,
NeilBrown
