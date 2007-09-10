From: Iustin Pop <iusty@k1024.org>
Subject: Re: RAID1 and load-balancing during read
Date: Mon, 10 Sep 2007 21:35:30 +0200
Message-ID: <20070910193530.GB2597@teal.hq.k1024.org>
References: <200709102229.30655.jimis@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200709102229.30655.jimis@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 10, 2007 at 10:29:30PM +0300, Dimitrios Apostolou wrote:
> Hello list, 
> 
> I just created a RAID1 array consisting of two disks. After experiments with 
> processes *reading* from the device (badblocks, dd) and the iostat program, I 
> can see that only one disk is being utilised for reading. To be exact, every 
> time I execute the command one of the two disks is being randomly used, but 
> the other one has absolutely no activity. 
> 
> My question is: why isn't load balancing happening? Is there an option I'm 
> missing? Until now I though it was the default for all RAID1 implementations. 

Did you read the archives of this list? This question has been answered,
like, 4 times already in the last months.

And yes, the driver does do load balancing. Just not as RAID0 does,
since it's not RAID0.

regards,
iustin
