From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: AW: Stupid Question?
Date: Tue, 25 May 2004 08:58:42 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16562.32290.124423.951804@cse.unsw.edu.au>
References: <16561.24317.771846.481608@cse.unsw.edu.au>
	<006401c4416e$db1215a0$1600a8c0@kessler.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from root@warpy.yomeganet.biz on Monday May 24
To: root@warpy.yomeganet.biz
Cc: jim@rubylane.com, AndyLiebman@aol.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 24, root@warpy.yomeganet.biz wrote:
> > >             You can't make a raid out of /dev/hda and 
> > /dev/hdb - whole 
> > > devices.
> > 
> > Why not?  I do it all the time.
> > 
> > You cannot get the kernel to auto-detect the raid if it is 
> > made from whole devices, but I don't care much about that.  
> > It works for me.
> 
> Whats the benefit of doing an Array over the whole devices? Are there
> any problems, for example that you maybe cannot boot from that array?
> 

No particular benefit.  But if I want to RAID together a number of
whole drives, there seems little point partitioning them first.  It
would certainly work either way.  I choose the way that makes most
sense in my situation.

I often RAID1 a pair of whole devices, partition them into
root/swap/rest and boot off them (this is using md partitioning code
which isn't in 2.4, but is in 2.6).  There is a problem here that lilo
thinks it knows all about md arrays.  However I figured out how to
trick it into not realising they are md arrays and it works fine (I
create a symlink from /dev/MD* -> /dev/md* and only tell lilo about
/dev/MD*).

NeilBrown

> Thanks,
> 
> Greetings,
> Stephan
