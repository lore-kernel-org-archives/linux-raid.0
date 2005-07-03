From: raz ben jehuda <razb@bitband.com>
Subject: Re: RAID1: What happens when one half of a mirror fails?
Date: Sun, 03 Jul 2005 19:12:56 +0300
Message-ID: <1120407176.4647.14.camel@raz-laptop>
References: <200506301024.13126.eric@pretorious.net>
	 <42C44210.7010204@gw.unix-scripts.info>
	 <200506301215.39271.eric@pretorious.net>  <42C44DD6.5060901@weisshuhn.de>
	 <1120372864.3368.1.camel@raz-laptop>  <42C807B4.4080701@weisshuhn.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42C807B4.4080701@weisshuhn.de>
Sender: linux-raid-owner@vger.kernel.org
To: Frank Wittig <fw@weisshuhn.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

it means that your system will not crash. no data loss would happen 
The problem i had was that the system kept on bouncing io to the
defected disk and since both the root file system and the swap were on 
raid1 the system hanged after a short while.
I added a line that removed the defected ata port ( the disk ) from the
disks array in the kernel and by doing that i had prevented this io
bouncing.  


On Sun, 2005-07-03 at 18:43, Frank Wittig wrote:
> with current version 2.6 kernels there are no problems known to me not
> to have swap and system raid partitions built out of partitions of the
> same physical disks.
> i didn't catch what you mean by "the kernel that removes the bad disk
> from the operating system". if it means that it will trigger a swapoff
> for the partition on the failed disk it is near to useless since at that
> time already a irreversible data loss has happened which causes the
> system to crash.
> the only possibility to prevent a system crash during failure of a
> harddisk is swapping to raid partitions.
> 
> raz ben jehuda wrote:
> > i had a "system hanging" when both swap and root file system were on the
> > raid. for that i added line in the kernel that removes the bad disk from
> > the operating system. 
> > On Thu, 2005-06-30 at 22:53, Frank Wittig wrote:
> > 
> >>Eric Pretorious wrote:
> >>
> >>>On Thursday 30 June 2005 12:03 pm, Laurent CARON wrote:
> >>>
> >>>
> >>>>is the swap partition on raid?
> >>>
> >>>
> >>>No. swap both swap partitions are formatted as standard swap partitions and mounted via /etc/fstab.
> >>>
> >>
> >>That's no good idea. If a disk fails which contains a swap partition to
> >>which data has been swapped the system will crash.
> >>Therefor it is important to use mirrored partitions for swap.
-- 
Raz
Long Live The Penguin

