From: Neil Brown <neilb@suse.de>
Subject: Re: RAID0 with bitmap support in 2.6.15 kernel
Date: Mon, 17 Apr 2006 23:28:22 +1000
Message-ID: <17475.38902.177218.601247@cse.unsw.edu.au>
References: <200604170859.k3H8xkD1004413@mailserver.spsoftindia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yogesh Pahilwan on Monday April 17
Sender: linux-raid-owner@vger.kernel.org
To: Yogesh Pahilwan <pahilwan.yogesh@spsoftindia.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 17, pahilwan.yogesh@spsoftindia.com wrote:
> Hi Folks,
> 
> I am creating RAID0 with bitmap support in 2.6.15 kernel.
> 
> For that I have created 10GB partition each on 4 sata disks and try to
> created RAID0 over these 4 10 GB partitions and use one of the partitions on
> one of the disks for keeping the bitmap file. I have use following command
> for creating RAID0.
> 
> # mdadm -Cv /dev/md0 -bitmap=/root/mntbitmap/RAID0.bitmap -bitmap-chunk=2048
> -l0 -n4 /dev/sd{a1,b1,c1,d1}
> 
> But after this I am getting Segmentation fault and kernel oops as shown in
> dmesg.

Well, a Segmentation Fault certainly isn't good, and I will try to fix
it.
But bitmap support isn't available for raid0, because it is
meaningless.
The 'bitmap' records sections of the array which might be
inconsistent.  As raid0 have no redundancy, it cannot be
inconsistent.  So there is nothing to record.

What did you hope to gain by adding a bitmap to raid0??

NeilBrown
