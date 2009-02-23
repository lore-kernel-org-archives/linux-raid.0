From: Harry Mangalam <harry.mangalam@uci.edu>
Subject: Re: rescue an alien md raid5
Date: Mon, 23 Feb 2009 11:59:34 -0800
Message-ID: <200902231159.34403.harry.mangalam@uci.edu>
References: <200902231013.46082.harry.mangalam@uci.edu> <49A2F1E8.6030901@scalableinformatics.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49A2F1E8.6030901@scalableinformatics.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: landman@scalableinformatics.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Joe,

Thanks for the reply and the hint, but the norecovery option fails due 
to the superblock not being found.  Neil's comment seems to indicate 
that there's a basic incompatibility in the way the NAS vendors 
implemented XFS.  We may be hosed on this one (not my NAS/files - I'm 
just trying to help some others in the group).  I will try the XFS 
group tho.

The mdadm part came thru like a champ tho - thanks!

Another reason to stay away from these kind of gadgets (I actually 
tried this device when it first came out and abandoned that approach 
as too futzy, not nearly flexible enough and not administratable 
enough).  As well, with all the big P3/p4 towers being given away for 
free now, I can build one of these in an hour or so with one of the 
SilImage cards and get a much more useful box for essentially the 
cost of raw disk.

Harry

On Monday 23 February 2009, Joe Landman wrote:
> Harry Mangalam wrote:
> > Here's an unusual (long) tale of woe.

> Hmmm... is it possible that the journal is external for the XFS
> filesystem in question?  Could you try
>
> 	mount -o norecovery,ro /dev/md1 /mountpoint
>
> Otherwise, could you dd the file system off there onto another
> (large) partition, before you try xfs_repair



-- 
Harry Mangalam - Research Computing, NACS, E2148, Engineering Gateway, 
UC Irvine 92697  949 824-0084(o), 949 285-4487(c)
---
Good judgment comes from experience; 
Experience comes from bad judgment. [F. Brooks.]
