From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-6: help wanted
Date: Mon, 25 Oct 2004 15:41:36 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16764.37392.910080.718564@cse.unsw.edu.au>
References: <cleqh6$ps4$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from H. Peter Anvin on Saturday October 23
To: "H. Peter Anvin" <hpa@zytor.com>, Jim Paris <jim@jtan.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday October 23, hpa@zytor.com wrote:
> Okay, it's well overdue to do this...
> 
> There is currently a data-corruption bug in the RAID-6 md layer
> (raid6main.c).  I have so far not been successful in locating it,
> although it is easily reproducible, thanks to a set of scripts by Jim
> Paris.  I suspect it is a race condition between raid6d and the rest
> of the kernel.


Does this fix the problem?
It is definitely wrong as it is.

NeilBrown



 ----------- Diffstat output ------------
 ./drivers/md/raid6main.c |    1 -
 1 files changed, 1 deletion(-)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-10-22 16:14:11.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-10-25 15:39:36.000000000 +1000
@@ -734,7 +734,6 @@ static void compute_parity(struct stripe
 	case READ_MODIFY_WRITE:
 		BUG();		/* READ_MODIFY_WRITE N/A for RAID-6 */
 	case RECONSTRUCT_WRITE:
-	case UPDATE_PARITY:	/* Is this right? */
 		for (i= disks; i-- ;)
 			if ( i != pd_idx && i != qd_idx && sh->dev[i].towrite ) {
 				chosen = sh->dev[i].towrite;
