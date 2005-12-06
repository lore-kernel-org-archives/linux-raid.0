From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 resync question
Date: Tue, 6 Dec 2005 11:32:09 +1100
Message-ID: <17300.56329.638969.509384@cse.unsw.edu.au>
References: <045901c5f9fa$8f2b7fa0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Tuesday December 6
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 6, djani22@dynamicweb.hu wrote:
> Hello, list,
> 
> 
> Is there a way to force the raid to skip this type of resync?

Why would you want to? 
The array is 'unclean', presumably due to a system crash.  The parity
isn't certain to be correct so your data isn't safe against a device
failure.  You *want* this resync.

If you are using 2.6.14 to later you can try turning on the
write-intent bitmap (mdadm --grow /dev/md0 --bitmap=internal).
That may impact write performance a bit (reports on how much would be
appreciated) but will make this resync-after-crash much faster.

NeilBrown

> 
> Every 2s: cat /proc/mdstat                              Tue Dec  6 01:28:55
> 2005
> 
> Personalities : [linear] [raid0] [raid1] [raid5] [multipath] [raid6]
> [raid10] [f
> aulty]
> md0 : active raid5 sdb1[4] sda1[10] hds1[5] hdq1[2] hdo1[3] hdm1[8] hdk1[6]
> hdi1
> [7] hde1[9] hdc1[1] hda1[0]
>       1953583360 blocks level 5, 32k chunk, algorithm 2 [11/11]
> [UUUUUUUUUUU]
>       [=>...................]  resync =  6.0% (11758724/195358336)
> finish=1216.8
> min speed=2512K/sec
