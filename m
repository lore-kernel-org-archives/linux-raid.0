From: Gordon Henderson <gordon@drogon.net>
Subject: Re: How safe is software RAID compared to how safe hardware RAID
Date: Wed, 19 Nov 2003 22:28:05 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0311192224210.19690@unicorn.drogon.net>
References: <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
 <Pine.LNX.4.55.0311190935440.10628@umi.cfht.hawaii.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.55.0311190935440.10628@umi.cfht.hawaii.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 19 Nov 2003, Kanoa Withington wrote:

> In a software RAID 1 array, each of the sub-volumes can be used just
> like a normal partition+file system outside of the array and the whole
> domain of software RAID, which is very nice for fault recovery. With a
> hardware controller this usually cannot be done, the data on the disks
> is useless without the controller.

Just as an aside, I've recently had to build several near identical
machines with a mirrored disk set (ie. s/w RAID1) and I used this feature
to "clone" the other boxes... ie. build one with 2 disks, make sure the
mirrors are syncd up, then take one drive out and use it to build a 2nd,
and a 3rd, etc.  each time putting in a blank 2nd disk and partitioning it
as before then letting the mirror re-sync...

I'm sure there may be easier ways, but this worked for me!

Gordon
