From: raz ben jehuda <razb@bitband.com>
Subject: Re: RAID1: What happens when one half of a mirror fails?
Date: Sun, 03 Jul 2005 09:41:04 +0300
Message-ID: <1120372864.3368.1.camel@raz-laptop>
References: <200506301024.13126.eric@pretorious.net>
	 <42C44210.7010204@gw.unix-scripts.info>
	 <200506301215.39271.eric@pretorious.net>  <42C44DD6.5060901@weisshuhn.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42C44DD6.5060901@weisshuhn.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i had a "system hanging" when both swap and root file system were on the
raid. for that i added line in the kernel that removes the bad disk from
the operating system. 
On Thu, 2005-06-30 at 22:53, Frank Wittig wrote:
> Eric Pretorious wrote:
> > On Thursday 30 June 2005 12:03 pm, Laurent CARON wrote:
> > 
> >>is the swap partition on raid?
> > 
> > 
> > No. swap both swap partitions are formatted as standard swap partitions and mounted via /etc/fstab.
> > 
> 
> That's no good idea. If a disk fails which contains a swap partition to
> which data has been swapped the system will crash.
> Therefor it is important to use mirrored partitions for swap.
-- 
Raz
Long Live The Penguin

