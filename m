From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Software RAID Stopped Working With Aurora Kernel
Date: Mon, 27 May 2002 14:59:14 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15601.48418.82978.28645@notabene.cse.unsw.edu.au>
References: <15594.14625.624567.495812@notabene.cse.unsw.edu.au>
	<NDBBIAKEEKGGEIKCBKNAEENACPAA.kc130iseo@coastalnet.com>
	<15594.45618.113616.670740@notabene.cse.unsw.edu.au>
	<3CEAC664.8D738EC2@ec.rr.com>
	<15594.56731.169389.603464@notabene.cse.unsw.edu.au>
	<3CEB8862.E114F042@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Calvin D. Webster on Wednesday May 22
To: cwebster@ec.rr.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday May 22, cwebster@ec.rr.com wrote:
> 
> There were a few other minor inconsistencies that I thought you might be
> interested in between the output of "mdadm" and that of "lsraid" from
> the new raidtools.
> 
> 
> "mdadm --examine /dev/sda1" shows "State : dirty, no-errors". All other
> RAID drives show the same.
> 
> "lsraid -D -a /dev/md0" shows "state		= good". All other RAID devices
> show the same.

I have never looked at "lsraid".  My guess is that "good" is
equivalent to "no-errors" and that lsraid doesn't bother to report
"dirty".  This shouldn't relate to the filesystem superblock though...
 still, a fsck every few months is a good idea.

NeilBrown
