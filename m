From: rdc <denrdc@gmail.com>
Subject: Re: MD Raid5 rebuild problems - md: sde has invalid sb, not importing!
Date: Fri, 17 Aug 2007 21:35:53 +0200
Message-ID: <200708172135.53895.denrdc@gmail.com>
References: <200708162358.51671.denrdc@gmail.com> <18116.62462.616627.109914@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18116.62462.616627.109914@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 17 August 2007 03:03:58 you wrote:
>
> Very odd..
> Please report which kernel version and mdadm version you are using,
> and the exact sizes of each of the devices in the array (e.g. cat
> /proc/partitions).
>

I am using 2.6.22-gentoo-r3 (but within an hour i am going to try 2.6.22 
vanilla, to be sure), mdadm 2.6.2

The partition ( well, whole disks actually, i created a raid5 over the 
complete disks ) explains it all : 
   8    16  244198584 sdb
   8    32  244198584 sdc
   8    48  244198584 sdd
   8    64  244197527 sde
   8    80  244198584 sdf
   8    96  244198584 sdg

Seems the disk i am trying to add is slightly smaller. Strange thing is, these 
disks have been running in a raid5 array for over a year, and are all the 
same make model & firmware. How can it be that this disk "shrunk" a bit ?

Kind regards
den_RDC

