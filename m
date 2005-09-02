From: Neil Brown <neilb@suse.de>
Subject: Re: MD or MDADM bug?
Date: Fri, 2 Sep 2005 19:34:22 +1000
Message-ID: <17176.7326.892297.381537@cse.unsw.edu.au>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
	<17176.2600.694418.472339@cse.unsw.edu.au>
	<018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH>
	<17176.4401.418417.56385@cse.unsw.edu.au>
	<019601c5af9b$23d8ce50$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David M. Strang on Friday September 2
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 2, dstrang@shellpower.net wrote:
> >
> > Can you run that with '-v' for me?
> 
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 2.
...

and just for completeness:

 mdadm -E /dev/sdm /dev/sdaa 

Thanks.

NeilBrown
