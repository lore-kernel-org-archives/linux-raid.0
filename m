From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: migrating raid-1 to different drive geometry ?
Date: Tue, 25 Jan 2005 09:47:24 +1100
Message-ID: <16885.31484.125772.316987@cse.unsw.edu.au>
References: <20050124145910.GC29766@kaneda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from rfu@kaneda.iguw.tuwien.ac.at on Monday January 24
Sender: linux-raid-owner@vger.kernel.org
To: rfu@kaneda.iguw.tuwien.ac.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Monday January 24, rfu@kaneda.iguw.tuwien.ac.at wrote:
> how can the existing raid setup be moved to the new disks 
> without data loss ?
> 
> I guess it must be something like this:
> 
> 1) physically remove first old drive
> 2) physically add first new drive
> 3) re-create partitions on new drive
> 4) run raidhotadd for each partition
> 5) wait until all partitions synced
> 6) repeat with second drive

Sounds good.
> 
> the big question is: since the drive geometry will definitely different
> between old 60GB and new 80GB drive(s), how do the new partitions 
> have to be created on the new drive ?
> - do they have to have exactly the same amount of blocks ?
No.
> - may they be bigger ?
Yes (they cannot be smaller).

However making the partitions bigger will not make the arrays bigger.

If you are using a recent 2.6 kernel and mdadm 1.8.0, you can grow the
array with
   mdadm --grow /dev/mdX --size=max

You will then need to convince the filesystem in the array to make use
of the extra space.  Many filesystems do support such growth.  Some
even support on-line growth.

NeilBrown
