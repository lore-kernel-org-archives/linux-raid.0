From: Neil Brown <neilb@suse.de>
Subject: Re: changing MD device names
Date: Sun, 2 Jul 2006 14:30:20 +1000
Message-ID: <17575.19420.943532.223775@cse.unsw.edu.au>
References: <Pine.LNX.4.61.0607012009220.2163@soloth.lewis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Lewis on Saturday July 1
Sender: linux-raid-owner@vger.kernel.org
To: Jon Lewis <jlewis@lewis.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 1, jlewis@lewis.org wrote:
> I have a system which was running several raid1 devices (md0 - md2) using 
> 2 physical drives (hde, and hdg).  I wanted to swap out these drives for 
> two different ones, so I did the following:
> 
> 1) swap out hdg for a new drive
> 2) create degraded raid1's (md3 and md4) using partitions on new hdg
> 3) format md3 and md4 and copy data from md0-2 to md3-4
> 4) install grub on new hdg
> 5) pull hde
> 
> Now, after a bit of fixing in the grub menu and fstab, I have a system 
> that boots up using just 1 of the new drives, but the md devices are md3 
> and md4.  What's the easiest way to change the prefered minor # and get 
> these to be md0 and md1?  Will just booting from a rescue or live CD and 
> assembling the new drives as md0 & md1 automatically update the prefered 
> minor in their superblocks?
> 
> The system is running Centos 4 (2.6.9-34.0.1.EL kernel).

You need to do a tiny bit more than assemble the new drives as md0 and
md1.  You also need to cause some write activity so that md bothers to
update the superblock.  Mounting and unmounting the filesystem should
do it.
Or you could assemble with --update=super-minor

NeilBrown
