From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: out of sync raid 5 + xfs = kernel startup problem
Date: Thu, 14 Apr 2005 12:29:27 +1000
Message-ID: <16989.54663.829943.302110@cse.unsw.edu.au>
References: <425C7D1E.30708@flaminglunchbox.net>
	<16988.39872.477594.821987@cse.unsw.edu.au>
	<425DD07F.8090802@flaminglunchbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robey Holderith on Wednesday April 13
Sender: linux-raid-owner@vger.kernel.org
To: Robey Holderith <robey@flaminglunchbox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday April 13, robey@flaminglunchbox.net wrote:
> >
> Thanks for the help.  I rebooted using a rescue partition and used the 
> two commands.  After about 2 hours of synching the array decided that 
> sdf had failed and ceased its synch.  I restarted and then tried to 
> assemble the array once again.  sdd2 and sdf2 are now both marked as 
> spares and the array had only 4/6 partitions... dead.  Can I force the 
> device numbers within the array?  I know that sdd2 was position 5 and 
> sdf2 was position 3.  I'd like to save what I can... most of the data on 
> the array can be reproduced... but it takes so much time.

Just do the "mdadm --assemble --force" again, but this time don't
--add any device that mdadm doesn't include.
This will leave you with a degraded array consisting of the "best"
drives that mdadm can find.

Then copy of the data you want.

Then seriously look at your hardware.  if sdd and sdf have appeared to
fail, there is a good chance that it is SCSI cabling rather than
drives that is giving the problem.

NeilBrown


> 
> If anyone is interested during my attempts to force the array to run I 
> got a segfault in mdadm.  I'll post a snippet here... ignore if it's old 
> news.
> 
> md: pers->run() failed ...
> Unable to handle kernel NULL pointer dereference at 0000000000000030 RIP:
> <ffffffff802c9350>{md_error+64}
> 
> Again... thanks for any and all help.
> 
> -Robey
