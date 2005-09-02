From: Neil Brown <neilb@suse.de>
Subject: Re: MD or MDADM bug?
Date: Fri, 2 Sep 2005 18:45:37 +1000
Message-ID: <17176.4401.418417.56385@cse.unsw.edu.au>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
	<17176.2600.694418.472339@cse.unsw.edu.au>
	<018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH>
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
> 
> > mdadm 2.0 had a fix for assembling version-1 arrays that would
> > particularly affect raid5.  Try using that instead of -devel-3.
> 
> No luck -- 
> 
> -(root@abyss)-(~)- # mdadm -A /dev/md0 /dev/sda /dev/sdb /dev/sdc /dev/sdd 
> /dev/sde /dev/sdf /dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl 
> /dev/sdm /dev/sdn /dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt 
> /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdy /dev/sdz /dev/sdaa /dev/sdab -f
> mdadm: /dev/md0 assembled from 26 drives - not enough to start the array.
> 
> Any other suggestions?
> 

Can you run that with '-v' for me?

NeilBrown
