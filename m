From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: MD or MDADM bug?
Date: Fri, 2 Sep 2005 18:15:36 +1000
Message-ID: <17176.2600.694418.472339@cse.unsw.edu.au>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David M. Strang on Thursday September 1
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 1, dstrang@shellpower.net wrote:
> This is somewhat of a crosspost from my thread yesterday; but I think it 
> deserves it's own thread atm. Some time ago, I had a device fail -- with the 
> help of Neil, Tyler & others on the mailing list; a few patches to mdadm --  
> I was able to recover. Using mdadm --remove & mdadm --add, I was able to 
> rebuild the bad disc in my array. Everything seemed fine; however -- when I 
> rebooted and re-assembled the raid; it wouldn't take the disk that was 
> re-added. I had to add it again; and let it rebuild. About 3 weeks ago, I 
> lost power -- the outage lasted longer than the UPS, and my system shutdown. 
> Upon startup, once again -- I had to re-add 'the disk' back to the array. 
> For some reason, if I remove a device and add it back -- when I stop and 
> re-assemble the array - it won't 'start' that disk.
....
> 
> I'm using mdadm 2.0-devel-3 on a Linux 2.6.11.12 kernel, with version-1 
> superblocks.

mdadm 2.0 had a fix for assembling version-1 arrays that would
particularly affect raid5.  Try using that instead of -devel-3.

NeilBrown
