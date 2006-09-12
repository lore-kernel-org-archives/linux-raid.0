From: Neil Brown <neilb@suse.de>
Subject: Re: Moving a raid5 array
Date: Wed, 13 Sep 2006 02:21:42 +1000
Message-ID: <17670.56982.310173.651209@cse.unsw.edu.au>
References: <200609121714.58541.clive@vacuumtube.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Clive Messer on Tuesday September 12
Sender: linux-raid-owner@vger.kernel.org
To: Clive Messer <clive@vacuumtube.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday September 12, clive@vacuumtube.org.uk wrote:
> 
> I currently have a 4 disk raid5 array which I wish to move to another machine. 
> In the current machine it is comprised of sda1/sdb1/sdc1/sdd1. When I move it 
> to the new machine the disks will all shift up by 2. ie. the partitions will 
> now be sdc1/sdd1/sde1/sdf1. If I 'mdadm --assemble' the array on the new 
> machine with the new partition names will md figure it all out or am I going 
> to trash my data?
> 
> For reference my current mdadm.conf ......
> 
> DEVICE /dev/sd*[0-9]
> ARRAY /dev/md0 level=raid5 num-devices=4 
> UUID=f1949e2c:bec621e4:de55ae15:4f336899

Providing you don't already have a /dev/md0 on the new machine, which
should work perfectly - no confusion.

NeilBrown
