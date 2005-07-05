From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm memory leak?
Date: Wed, 6 Jul 2005 07:08:53 +1000
Message-ID: <17098.63205.207499.40820@cse.unsw.edu.au>
References: <42CA0B7E.4040109@shlrm.org>
	<17098.4949.378512.822529@cse.unsw.edu.au>
	<Pine.LNX.4.63.0507050831130.15691@cerberus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eric Sandall on Tuesday July 5
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandall <eric@sandall.us>
Cc: David Kowis <dkowis@shlrm.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday July 5, eric@sandall.us wrote:
> On Tue, 5 Jul 2005, Neil Brown wrote:
> > On Monday July 4, dkowis@shlrm.org wrote:
> >> I'm not entirely sure if this is mdadm's fault, but I cannot find anything else that would cause the problem, since mdadm is the only new
> >> thing and I'm pretty sure it's not 2.6.11.12's fault. Anyways, on to my issue:
> >> I'm running samba, apache2, mysql, postgresql, and a few other things. I've got an Athlon-XP 1700+ with 768Mb RAM. Right after startup I've
> >> got about 600Mb of free memory, and as time progresses, and I use samba for things (playing an MP3,) my amount of free memory declines
> >> rather rapidly. It hovers around 8Mb of free ram, with no swap usage. The computer has bogged down bad enough that oom-killer has had to
> >> kill just about everything. ps and top don't show anything eating up all my memory. I'm very impressed with mdadm and I'd like to keep using
> >> it, but i'd also like to have a bit of free memory on my computer. I'm using an XFS file system on a 200Gb mirrored RAID array, two drives,
> >> on seperate IDE channels (seperate cables.)
> >> Thanks for your time,
> >
> > Hmmm.
> > There is an md related memory leak in 2.6.12, but I don't think it is
> > there in 2.6.11.anything.
> 
> I also have this problem, but am using 2.6.10-as7 (also reiserfs on
> the raid-1 array). This machine has 1Gb RAM, but has roughly 2-40Mb
> free at any time after running for a day (I can leave the machine up
> as long as I want, but all processes run slow as they now have to do a
> lot of swapping). The kernel was compiled with gcc 3.4.4 and glibc
> 2.3.5 with NPTL (if that matters).
> 
> > If 'ps' doesn't show anything, the next place to look is
> > /proc/slabinfo (which 'slabtop' might display for you).
> 
>   Active / Total Objects (% used)    : 12080357 / 12132001 (99.6%)
>   Active / Total Slabs (% used)      : 176776 / 176776 (100.0%)
>   Active / Total Caches (% used)     : 66 / 101 (65.3%)
>   Active / Total Size (% used)       : 668099.80K / 671784.20K (99.5%)
>   Minimum / Average / Maximum Object : 0.01K / 0.05K / 128.00K
> 
>    OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME 
> 6013634 6013300  99%    0.02K  26609      226    106436K biovec-1
> 6013306 6013297  99%    0.09K 146666       41    586664K bio

These two lines point to the problem - it is a leak of 'bio's.

This patch fixes it.

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-06-30 11:07:38.000000000 +1000
+++ ./drivers/md/md.c	2005-06-28 13:02:04.000000000 +1000
@@ -338,6 +338,7 @@ static int super_written(struct bio *bio
 
 	if (atomic_dec_and_test(&rdev->mddev->pending_writes))
 		wake_up(&rdev->mddev->sb_wait);
+	bio_put(bio);
 	return 0;
 }
 
