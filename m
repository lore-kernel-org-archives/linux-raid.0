From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: raid1: All my data completely vanished into the void
Date: Wed, 28 Dec 2005 00:30:51 -0500
Message-ID: <200512280030.51387.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 27 December 2005 11:50 pm,   
Ross Vandegrift wrote:

> Are you 100% sure that you didn't do:
>
> mdadm -Cv -n2 -l1 /dev/md0 /dev/sda /dev/sdb, etc, etc?
> (ie, note lack of subdevice for partition!!!)
> It sounds like you created md devices out of whole disks instead of
> partitions and overwrote the partition information.  I don't *think*
> this should be a problem, but I don't 100% know...
>
> Try this to see if it finds your array:
>
> mdadm --assemble /dev/md0 /dev/sda /dev/sdb

That works! In fact that does indeed find all the data! I then mount it as 
/home/big2 and the data is still there that I left before.

You are a genius!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

What an idiot I am. 

What does doing

mdadm -Cv -n2 -l1 /dev/md0 /dev/sda /dev/sdb

do to the partition tables??? 
(And why can I still access the data if I messed up the partitions??? very 
odd).
Can you point me at an explanation of the effects of what I did?

Every way a person can screw up,  it will happen...

Mitcehll
