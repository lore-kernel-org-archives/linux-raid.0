From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: bugs in md.c
Date: Fri, 12 Sep 2003 12:21:20 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16225.11680.795423.127348@notabene.cse.unsw.edu.au>
References: <pan.2003.09.08.21.01.07.571395@libero.it>
	<pan.2003.09.09.09.22.15.38454@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alessandro Bono on Tuesday September 9
To: Alessandro Bono <a.bono@libero.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 9, a.bono@libero.it wrote:
> After stoping /dev/md0 i tried to assemble updating summaries with mdadm
> 1.3 + patches but i receive a segmentation fault
> 
> mdadm compiled staticaly on a Debian stable (gcc 2.95) and unstable (gcc
> 3.3.2)
> 
...
> --- SIGSEGV (Segmentation fault) @ 0 (0) ---
> +++ killed by SIGSEGV +++

Oops. Silly typo:
Line 304 of Assembly.c is

				for (i=0; MD_SB_DISKS ; i++) 
but should be
				for (i=0; i < MD_SB_DISKS ; i++) 

I have updated the patch at:
  http://www.cse.unsw.edu.au/~neilb/source/mdadm/patch/applied/

NeilBrown
