From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: 2.6.0-test{1,2,3} kernels + software raid 0 + xfs broken?
Date: Thu, 28 Aug 2003 09:28:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16205.16041.470921.352218@gargle.gargle.HOWL>
References: <200308231916.00588.ma1flfs@bath.ac.uk>
	<200308271321.44105.ma1flfs@bath.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Florian Schanda on Wednesday August 27
To: ma1flfs@bath.ac.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 27, ma1flfs@bath.ac.uk wrote:
> On Saturday 23 August 2003 19:16, Florian Schanda wrote:
> > I am running a 2.4.21 kernel + xfs + raid0 (software) on 2 scsi disks. It
> > works without flaws.
> >
> > Trying the same setup in 2.6.0-test{1,2,3} (haven't tested 4 yet) _will_
> > give data corruption if I write to the array.
> 
> Looking at: 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/must-fix/must-fix-6.txt
> 
> > o RAID0 dies on strangely aligned BIOs
> 
> Is that my problem? I'm not sure I fully undestand this -- what is strangely 
> aligned here?

This has been fixed, though possibly it was in test4.
In any case, if this were your problem you would be seeing raid0
related messages in your kernel logs.

NeilBrown
