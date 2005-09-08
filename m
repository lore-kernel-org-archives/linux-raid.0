From: Neil Brown <neilb@suse.de>
Subject: Re: Drive fails & raid6 array is not self rebuild .
Date: Fri, 9 Sep 2005 07:09:40 +1000
Message-ID: <17184.43156.113155.811612@cse.unsw.edu.au>
References: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69F99@bsc.tt.umist.ac.uk>
	<Pine.LNX.4.63.0509081247060.29776@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mr. James W. Laferriere on Thursday September 8
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday September 8, babydr@baby-dragons.com wrote:
>  	Hello All ,  Is there a documented procedure to follow during
>  	creation or after that will get a raid6 array to self
>  	rebuild ?

I suspect a kernel upgrade would do the trick, though you don't say
what kernel you are running.
You could probably kick it along by removing and re-adding your spare:
  mdadm /dev/md_d0 --remove /dev/sdao
  mdadm /dev/md_d0 --add /dev/sdao

(And I assume you mean 'raid5' rather than 'raid6', not that it
matters..)

NeilBrown

> # cat /proc/mdstat
> ...snip...
> md_d0 : active raid5 sdc[0] sdao[40] sdan[34] sdam[33] sdal[32] 
> sdak[31] sdaj[30] sdah[29] sdag[28] sdaf[27] sdae[26] sdad[25] 
> sdac[24] sdab[23] sdaa[22] sdz[21] sdy[20] sdw[19] sdv[18] sdu[17] 
> sdt[16] sds[15] sdr[14] sdq[13] sdp[12] sdo[11] sdn[10] sdl[9] sdk[8] 
> sdj[7] sdi[6] sdh[5] sdg[4] sdf[3] sde[2](F) sdd[1]
>        1244826240 blocks level 5, 64k chunk, algorithm 2 [36/35] 
> [UU_UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU]
