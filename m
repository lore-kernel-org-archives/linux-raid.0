From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: bug report: mdadm-devel-2 , superblock version 1
Date: Mon, 25 Jul 2005 10:37:32 +1000
Message-ID: <17124.13388.640551.502519@cse.unsw.edu.au>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>
	<17114.54800.132155.142544@cse.unsw.edu.au>
	<00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>
	<17114.62108.319878.983091@cse.unsw.edu.au>
	<010701c58b32$ee423830$c200a8c0@NCNF5131FTH>
	<17115.149.130115.176372@cse.unsw.edu.au>
	<001601c58b37$620c69d0$c200a8c0@NCNF5131FTH>
	<17115.1749.370942.838069@cse.unsw.edu.au>
	<42DB0F41.7030806@dtbb.net>
	<42DB11B8.1090501@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tyler on Sunday July 17
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 17, pml@dtbb.net wrote:
> As a side note, do I need any kernel patches to use the version 1 
> superblocks Neil?  That may be what i'm missing.. as the kernel in use 
> currently is a vanilla 2.6.12.3.  I'm not trying to use bitmaps or 
> anything else at the moment.

version 1 superblock should work mostly in 2.6.12.3.  I'm not 100%
sure no related patches have gone in since 2.6.12 though...

NeilBrown
