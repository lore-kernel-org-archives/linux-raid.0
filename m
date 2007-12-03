From: Neil Brown <neilb@suse.de>
Subject: Re: problem with software raid1 on 2.6.22.10: check/rebuild hangs
Date: Mon, 3 Dec 2007 14:00:50 +1100
Message-ID: <18259.29026.622217.229830@notabene.brown>
References: <200712030305.50109.wolfgang.walter@studentenwerk.mhn.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wolfgang Walter on Monday December 3
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>
Cc: mingo@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 3, wolfgang.walter@studentenwerk.mhn.de wrote:
> Hello,
> 
> with kernel 2.6.22.10 checking a raid1 or rebuilding ist does not work on one 
> of our machines. After a short time the rebuild/check does not make progress 
> any more . Processes which then access the filesystems on those raids are 
> blocked.
> 
> Nothing gets logged. Access to other filesystems works fine.
> 
> If we boot 2.6.17.10 (the kernel we used befor upgrading to 2.6.22) the raids 
> the check/rebuild is done without any problems.
> 

Sounds like a driver problem.
Your symptoms are completely consistent with a request being submitted
to the underlying device, and that request never completing.

What controller runs your drives for you.  You should probably report
the problem to the relevant maintainer.

Do you compile your own kernels?  Would you be comfortable using "git
bisect" to narrow down exactly which change breaks things?  It should
take more than a dozen or so tests.

NeilBrown
